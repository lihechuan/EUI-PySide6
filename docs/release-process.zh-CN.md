# 本地与 GitHub 发布流程

简体中文 | [English](release-process.en.md) · [使用指南](guide.zh-CN.md)

版本号来自 `pyproject.toml` 的 `project.version`，与 `source.__version__` 保持一致。提交说明使用英文，同步维护中英文文档。Release 正文只保留简短编号列表，说明新增、修改或修复的功能。

| 目标 | 安装包 | 免安装包 |
| --- | --- | --- |
| Windows x64 | `*-windows-x64-setup.exe` | `*-windows-x64-portable.zip` |
| macOS Intel | `*-macos-x64.dmg` | `*-macos-x64-portable.zip` |
| macOS Apple Silicon | `*-macos-arm64.dmg` | `*-macos-arm64-portable.zip` |
| Python 组件库 | `eui_pyside6-*.whl` | `eui_pyside6-*.tar.gz`（源码） |

桌面包前缀为 `EUI-PySide6-Gallery-VERSION`，不提供 Windows x86。桌面包自带 Python、PySide6/Qt 和所需资源，wheel 的依赖通过 pip 安装。使用时保留完整免安装目录或 macOS app bundle。

## 本地构建

在对应操作系统和架构上使用 64 位 Python 3.12 构建。Windows 需要 Inno Setup 6（将 `ISCC` 加入 PATH 或设置 `ISCC_EXE`）；macOS 使用系统的 `codesign`、`ditto` 和 `hdiutil`。

```powershell
python -m venv build/package-venv
.\build\package-venv\Scripts\python.exe -m pip install -r packaging/requirements.txt
.\build\package-venv\Scripts\python.exe -m pip install --no-deps -e .
.\build\package-venv\Scripts\python.exe -m unittest discover -s tests -p "test_*.py"
.\build\package-venv\Scripts\python.exe tests/run_all.py --jobs 1
.\build\package-venv\Scripts\python.exe packaging/package.py
.\build\package-venv\Scripts\python.exe -m build
```

macOS 使用 `./build/package-venv/bin/python`。构建会重新生成资源、冻结 Gallery、检查隔离环境启动，并在 `dist/` 生成发行包、校验值和构建信息。macOS 使用临时签名，未使用 Developer ID 签名或公证；Windows 安装包未使用 Authenticode 签名。

## GitHub 发布

沿用 EUI 的发布顺序：推送 `master`，构建全部目标，汇总发行包和 `SHA256SUMS.txt`，创建草稿 Release，上传文件，重新下载每个文件并校验 SHA-256，再公开。`vVERSION` 标签和 Release 指向同一源码提交。

未公开版本会在后续 `master` 推送时重试，已公开版本保留原文件。PR 和手动运行只构建不发布，标签推送必须匹配项目版本。确认 Actions 日志、Release 公开状态、全部八个发行包和校验清单后，才能报告完成。

打包版 Gallery 更新使用对应平台的免安装包和校验清单，源码目录受到保护，不允许覆盖。后续版本应保留可执行文件与压缩包结构。
