"""Run with python3 -m unittest discover -s flake/dev -p 'test_*.py'."""

import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

GENERATOR = Path(__file__).with_name("new-plugin.py").resolve()


class PluginGeneratorTests(unittest.TestCase):
    def setUp(self):
        cache = Path(os.environ.get("XDG_CACHE_HOME", Path.cwd() / ".planning"))
        cache.mkdir(parents=True, exist_ok=True)
        self.temp = tempfile.TemporaryDirectory(dir=cache)
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        self.plugins = self.base / "modules/nixvim/plugins"
        self.plugins.mkdir(parents=True)

    def generate(self, name, template="custom"):
        return subprocess.run(
            [
                sys.executable,
                str(GENERATOR),
                name,
                template,
                "--base-path",
                str(self.base),
            ],
            capture_output=True,
            text=True,
            check=False,
        )

    def test_templates_create_parseable_modules_without_overwrite(self):
        for template in ("custom", "custom-lazy", "nixvim"):
            with self.subTest(template=template):
                self.assertEqual(self.generate(template, template).returncode, 0)
                output = self.plugins / template / "default.nix"
                original = output.read_bytes()
                subprocess.run(
                    ["nix-instantiate", "--parse", str(output)],
                    capture_output=True,
                    check=True,
                )
                self.assertNotEqual(self.generate(template).returncode, 0)
                self.assertEqual(output.read_bytes(), original)

    def test_invalid_names_do_not_escape_plugin_directory(self):
        for name in (
            "",
            ".",
            "..",
            "../escape",
            "nested/name",
            "/absolute",
            "trailing/",
        ):
            with self.subTest(name=name):
                self.assertNotEqual(self.generate(name).returncode, 0)
                self.assertEqual(list(self.plugins.iterdir()), [])

    def test_existing_symlinks_are_not_followed(self):
        plugin = self.plugins / "sample"
        plugin.mkdir()
        target = self.base / "target"
        target.write_bytes(b"preserve\x00\xff")
        output = plugin / "default.nix"
        output.symlink_to(target)
        self.assertNotEqual(self.generate("sample").returncode, 0)
        self.assertEqual(target.read_bytes(), b"preserve\x00\xff")
        output.unlink()
        output.symlink_to(self.base / "absent")
        self.assertNotEqual(self.generate("sample").returncode, 0)
        self.assertFalse((self.base / "absent").exists())
