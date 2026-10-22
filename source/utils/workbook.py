import io
import math
import re
import zipfile
import xml.etree.ElementTree as ET
from pathlib import Path

from PySide6.QtCore import QIODevice, QSaveFile

NS = "http://schemas.openxmlformats.org/spreadsheetml/2006/main"


def column_name(index):
    name = ""
    while index >= 0:
        name = chr(65 + index % 26) + name
        index = index // 26 - 1
    return name


def write_workbook(path, matrix):
    if not path or len(matrix) > 1048576:
        raise ValueError("Invalid workbook path or row count")
    worksheet = ET.Element("worksheet", xmlns=NS)
    data = ET.SubElement(worksheet, "sheetData")
    for index, values in enumerate(matrix, 1):
        if len(values) > 16384:
            raise ValueError("The worksheet exceeds 16384 columns")
        row = ET.SubElement(data, "row", r=str(index))
        for col, value in enumerate(values):
            cell = ET.SubElement(row, "c", r=f"{column_name(col)}{index}")
            if isinstance(value, bool):
                cell.set("t", "b")
                ET.SubElement(cell, "v").text = "1" if value else "0"
            elif isinstance(value, (int, float)) and math.isfinite(value):
                ET.SubElement(cell, "v").text = str(value)
            else:
                cell.set("t", "inlineStr")
                text = ET.SubElement(ET.SubElement(cell, "is"), "t")
                text.set("{http://www.w3.org/XML/1998/namespace}space", "preserve")
                text.text = "" if value is None else str(value)
    buffer = io.BytesIO()
    with zipfile.ZipFile(buffer, "w", zipfile.ZIP_DEFLATED) as archive:
        archive.writestr("[Content_Types].xml", '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/><Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/></Types>')
        archive.writestr("_rels/.rels", '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/></Relationships>')
        archive.writestr("xl/workbook.xml", f'<workbook xmlns="{NS}" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><sheets><sheet name="Table" sheetId="1" r:id="rId1"/></sheets></workbook>')
        archive.writestr("xl/_rels/workbook.xml.rels", '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/></Relationships>')
        archive.writestr("xl/worksheets/sheet1.xml", ET.tostring(worksheet, encoding="utf-8", xml_declaration=True))
    output = QSaveFile(path)
    if not output.open(QIODevice.WriteOnly):
        raise OSError(output.errorString())
    data = buffer.getvalue()
    if output.write(data) != len(data) or not output.commit():
        raise OSError(output.errorString())
    return dict(ok=True)


def read_workbook(path):
    if not path or Path(path).stat().st_size > 64 * 1024 * 1024:
        raise ValueError("Invalid path or workbook exceeds 64 MiB")
    try:
        archive = zipfile.ZipFile(path)
    except zipfile.BadZipFile as error:
        raise ValueError("Invalid XLSX archive") from error
    with archive:
        if sum(item.file_size for item in archive.infolist()) > 128 * 1024 * 1024:
            raise ValueError("Expanded workbook exceeds 128 MiB")
        def xml(name):
            content = archive.read(name)
            if b"<!DOCTYPE" in content or b"<!ENTITY" in content:
                raise ValueError("XML entity declarations are not supported")
            try:
                return ET.fromstring(content)
            except ET.ParseError as error:
                raise ValueError("Invalid workbook XML") from error
        strings = []
        if "xl/sharedStrings.xml" in archive.namelist():
            strings = ["".join(node.itertext()) for node in xml("xl/sharedStrings.xml")]
        book = xml("xl/workbook.xml")
        sheets = book.find(f"{{{NS}}}sheets")
        if sheets is None or not len(sheets):
            raise ValueError("The workbook has no worksheets")
        rid = sheets[0].get("{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id")
        relation = next((r for r in xml("xl/_rels/workbook.xml.rels") if r.get("Id") == rid), None)
        if relation is None or relation.get("TargetMode") == "External":
            raise ValueError("Invalid worksheet relationship")
        target = relation.get("Target", "")
        if ".." in target.split("/") or "\\" in target or ":" in target:
            raise ValueError("Invalid worksheet path")
        target = target.lstrip("/") if target.startswith("/") else "xl/" + target
        matrix = []
        for row in xml(target).iter(f"{{{NS}}}row"):
            number = int(row.get("r", len(matrix) + 1))
            if not len(matrix) < number <= 1048576:
                raise ValueError("Invalid worksheet row index")
            matrix.extend([] for _ in range(number - len(matrix) - 1))
            values = []
            for cell in row:
                match = re.fullmatch(r"([A-Z]+)[0-9]+", cell.get("r", ""))
                if not match:
                    raise ValueError("Invalid cell reference")
                column = 0
                for char in match[1]:
                    column = column * 26 + ord(char) - 64
                if not 1 <= column <= 16384:
                    raise ValueError("Invalid worksheet column index")
                values.extend("" for _ in range(column - len(values)))
                kind = cell.get("t")
                text = cell.findtext(f"{{{NS}}}v", "")
                if kind == "inlineStr":
                    value = "".join(node.text or "" for node in cell.iter(f"{{{NS}}}t"))
                elif kind == "s":
                    index = int(text)
                    if not 0 <= index < len(strings):
                        raise ValueError("Invalid shared string index")
                    value = strings[index]
                elif kind == "b":
                    value = text == "1"
                elif kind in ("str", "e") or not text:
                    value = text
                else:
                    value = float(text)
                    if not math.isfinite(value):
                        raise ValueError("Non-finite numeric cell")
                values[column - 1] = value
            matrix.append(values)
    return dict(ok=True, matrix=matrix)
