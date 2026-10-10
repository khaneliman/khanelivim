"""Run with python3 -m unittest discover -s docs/scripts -p 'test_*.py'."""

import importlib.util
import unittest
from pathlib import Path

spec = importlib.util.spec_from_file_location(
    "render_keymaps", Path(__file__).with_name("render-keymaps.py")
)
renderer = importlib.util.module_from_spec(spec)
spec.loader.exec_module(renderer)


class KeymapTableTests(unittest.TestCase):
    def test_key_notation_and_table_delimiters(self):
        entries = [
            {"lhs": key, "modes": ["n"], "label": "Description", "scope": "global"}
            for key in ("|", "gd", "<C-w>", " f")
        ]
        rows = renderer.render_table(entries)[2:]
        keys = ["`\\|`", "`gd`", "`<C-w>`", "`<leader>f`"]
        for row, key in zip(rows, keys, strict=True):
            self.assertTrue(row.startswith(f"| {key} |"), row)
            self.assertEqual(row.replace("\\|", "").count("|"), 5, row)

    def test_descriptions_keep_literal_key_names(self):
        row = renderer.render_table(
            [
                {
                    "lhs": "<Tab>",
                    "modes": ["i"],
                    "label": "Jump <Tab> & <S-Tab> | fallback",
                    "scope": "global",
                }
            ]
        )[-1]
        self.assertIn("Jump &lt;Tab&gt; &amp; &lt;S-Tab&gt; \\| fallback", row)
