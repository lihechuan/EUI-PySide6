import hashlib
import importlib.util
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

spec = importlib.util.spec_from_file_location("github_release", Path(__file__).resolve().parents[1] / "packaging/github_release.py")
release = importlib.util.module_from_spec(spec)
spec.loader.exec_module(release)


class ReleaseTests(unittest.TestCase):
    def test_version_and_package_matrix(self):
        self.assertEqual(release.read_version('[project]\nversion="1.3.2"'), "1.3.2")
        for version in ("1.2", "v1.2.3", "1.2.3-beta", "../1.2.3"):
            with self.assertRaises(ValueError):
                release.read_version('[project]\nversion="' + version + '"')
        names = release.package_names("1.3.2")
        self.assertEqual(len(names), 8)
        self.assertEqual(len(set(names)), 8)
        self.assertFalse(any("x86-" in name for name in names))

    def test_master_retries_unpublished_version_but_preserves_published_release(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "pyproject.toml").write_text('[project]\nversion="1.3.2"')
            for draft in (True, False):
                with patch.object(release, "api", return_value=[[dict(tag_name="v1.3.2", draft=draft)]]):
                    self.assertEqual(release.release_plan(root, "push", "refs/heads/master", "owner/repo"), ("1.3.2", draft))
            with patch.object(release, "api") as api:
                self.assertFalse(release.release_plan(root, "workflow_dispatch", "refs/heads/master", "owner/repo")[1])
                self.assertFalse(release.release_plan(root, "pull_request", "refs/pull/1/merge", "owner/repo")[1])
                api.assert_not_called()
            with self.assertRaises(ValueError):
                release.release_plan(root, "push", "refs/tags/v1.0.0", "owner/repo")

    def packages(self, root):
        artifact = root / "dist/platform"
        artifact.mkdir(parents=True)
        records = []
        for name in release.package_names("1.3.2"):
            data = name.encode()
            (artifact / name).write_bytes(data)
            records.append(hashlib.sha256(data).hexdigest() + "  " + name)
        (artifact / "SHA256SUMS.txt").write_text("\n".join(records) + "\n", encoding="ascii")
        return artifact

    def test_collect_verifies_every_package_before_publication(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            self.packages(root)
            release.collect_packages(root, "1.3.2")
            manifest = (root / "dist/SHA256SUMS.txt").read_text().splitlines()
            self.assertEqual(len(manifest), 8)
            for name in release.package_names("1.3.2"):
                self.assertTrue((root / "dist" / name).is_file())

    def test_missing_corrupt_duplicate_and_unexpected_packages_are_rejected(self):
        for failure in ("missing", "corrupt", "duplicate", "unsafe"):
            with self.subTest(failure=failure), tempfile.TemporaryDirectory() as directory:
                root = Path(directory)
                artifact = self.packages(root)
                manifest = artifact / "SHA256SUMS.txt"
                lines = manifest.read_text().splitlines()
                if failure == "missing":
                    lines.pop()
                elif failure == "corrupt":
                    (artifact / release.package_names("1.3.2")[0]).write_bytes(b"tampered")
                elif failure == "duplicate":
                    lines.append(lines[0])
                else:
                    lines[0] = "0" * 64 + "  ../outside.zip"
                manifest.write_text("\n".join(lines) + "\n")
                with self.assertRaises(ValueError):
                    release.collect_packages(root, "1.3.2")
