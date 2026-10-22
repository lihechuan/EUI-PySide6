import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import tempfile
from pathlib import Path


def read_version(source):
    import tomllib
    value = tomllib.loads(source)["project"]["version"]
    if not re.fullmatch(r"\d+\.\d+\.\d+", value):
        raise ValueError("Expected a numeric X.Y.Z project version.")
    return value


def release_plan(root, event_name, ref, repository):
    version = read_version((root / 'pyproject.toml').read_text(encoding='utf-8'))
    publish = False
    if event_name == 'push' and ref == 'refs/heads/master':
        releases = api('repos/' + repository + '/releases?per_page=100', paginate=True)
        publish = not any(item['tag_name'] == 'v' + version and not item['draft']
                          for page in releases for item in page)
    elif event_name == 'push' and ref.startswith('refs/tags/v'):
        if ref != 'refs/tags/v' + version:
            raise ValueError('The tag must match the version in pyproject.toml.')
        publish = True
    return version, publish


def run(*arguments):
    return subprocess.check_output(arguments, encoding='utf-8').strip()


def api(path, data=None, paginate=False, method='PATCH'):
    arguments = ['gh', 'api', path]
    if paginate:
        arguments += ['--paginate', '--slurp']
    if data is not None:
        arguments += ['--method', method, '--input', '-']
    return json.loads(subprocess.check_output(
        arguments, input=json.dumps(data) if data is not None else None, encoding='utf-8'
    ))


def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def package_names(version):
    prefix = f'EUI-PySide6-Gallery-{version}-'
    return [prefix + suffix for suffix in (
        'windows-x64-setup.exe', 'windows-x64-portable.zip',
        'macos-x64.dmg', 'macos-x64-portable.zip',
        'macos-arm64.dmg', 'macos-arm64-portable.zip',
    )] + [f'eui_pyside6-{version}-py3-none-any.whl', f'eui_pyside6-{version}.tar.gz']


def collect_packages(root, version):
    destination = root / 'dist'
    expected = set(package_names(version))
    checksums = {}
    for manifest in sorted(destination.glob('*/SHA256SUMS.txt')):
        for line in manifest.read_text(encoding='ascii').splitlines():
            checksum, name = line.split('  ', 1)
            if name not in expected or name in checksums or not re.fullmatch(r'[0-9a-fA-F]{64}', checksum):
                raise ValueError('Invalid, unexpected, or duplicate package checksum.')
            source = manifest.parent / name
            if digest(source) != checksum.lower():
                raise ValueError('Package checksum mismatch: ' + name)
            checksums[name] = checksum.lower()
            shutil.copy2(source, destination / name)
    if set(checksums) != expected:
        raise ValueError('Missing packages: ' + ', '.join(sorted(expected - set(checksums))))
    (destination / 'SHA256SUMS.txt').write_text(
        ''.join(checksums[name] + '  ' + name + '\n' for name in sorted(checksums)), encoding='ascii')


def publish_release(root, version, repository, commit):
    if version != read_version((root / 'pyproject.toml').read_text(encoding='utf-8')):
        raise ValueError('Release version differs from the checked-out source.')
    tag = 'v' + version
    prefix = 'repos/' + repository
    releases = api(prefix + '/releases?per_page=100', paginate=True)
    release = next((item for page in releases for item in page if item['tag_name'] == tag), None)
    if release and not release['draft']:
        print(f'{tag} is already published; its files are preserved.')
        return

    reference = subprocess.run(
        ['git', 'rev-parse', '--verify', f'refs/tags/{tag}^{{commit}}'],
        cwd=root, capture_output=True, text=True
    )
    if reference.returncode == 0 and reference.stdout.strip() != commit:
        raise ValueError('The existing tag points to a different source commit.')
    if release and release['target_commitish'] != commit:
        raise ValueError('The existing draft belongs to a different source commit.')

    files = [root / 'dist' / name for name in package_names(version)]
    checksums = root / 'dist/SHA256SUMS.txt'
    expected = {}
    for line in checksums.read_text(encoding='ascii').splitlines():
        checksum, name = line.split('  ', 1)
        if name in expected or not re.fullmatch(r'[0-9a-fA-F]{64}', checksum):
            raise ValueError('Invalid or duplicate package checksum.')
        expected[name] = checksum.lower()
    if set(expected) != {path.name for path in files}:
        raise ValueError('Checksums must cover exactly the configured platform packages.')
    for path in files:
        if digest(path) != expected[path.name]:
            raise ValueError(f'Local package checksum mismatch: {path.name}')
    files.append(checksums)

    if not release:
        release = api(prefix + '/releases', {
            'tag_name': tag, 'target_commitish': commit, 'draft': True,
            'name': f'EUI-PySide6 {version}',
            'body': (root / 'packaging/release-notes.md').read_text(encoding='utf-8'),
        }, method='POST')

    assets = {asset['name']: asset for asset in release['assets']}
    with tempfile.TemporaryDirectory(prefix='eui-release-verify-') as directory:
        for path in files:
            if path.name not in assets:
                run('gh', 'release', 'upload', tag, str(path), '--repo', repository)
            run('gh', 'release', 'download', tag, '--repo', repository,
                '--pattern', path.name, '--dir', directory)
            if digest(Path(directory) / path.name) != digest(path):
                raise ValueError(f'Downloaded release checksum mismatch: {path.name}')
    published = api(prefix + f"/releases/{release['id']}", {'draft': False, 'make_latest': 'legacy'})
    if published['draft'] or not {path.name for path in files}.issubset(
        {asset['name'] for asset in published['assets']}
    ):
        raise ValueError('Release publication or asset verification failed.')
    print(published['html_url'])


def main():
    parser = argparse.ArgumentParser(description='Detect and publish EUI version releases.')
    parser.add_argument('command', choices=('plan', 'collect', 'publish'))
    arguments = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    if arguments.command == 'plan':
        version, publish = release_plan(root, os.environ['GITHUB_EVENT_NAME'], os.environ['GITHUB_REF'],
                                        os.environ['GITHUB_REPOSITORY'])
        with Path(os.environ['GITHUB_OUTPUT']).open('a', encoding='utf-8') as output:
            output.write(f'version={version}\npublish={str(publish).lower()}\n')
        print(f'Version: {version}; publish release: {publish}')
    elif arguments.command == 'collect':
        collect_packages(root, os.environ['EUI_RELEASE_VERSION'])
    else:
        publish_release(root, os.environ['EUI_RELEASE_VERSION'], os.environ['GITHUB_REPOSITORY'],
                        os.environ['GITHUB_SHA'])


if __name__ == '__main__':
    main()
