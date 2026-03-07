#!/usr/bin/env python3

import json
import sys

PROFILES = ["minimal", "basic", "standard", "full", "debug"]

SECTIONS = [
    (
        "Core",
        [
            ("Description", "description"),
            ("Treesitter whitelist", "treesitterWhitelist"),
            ("Optimize enable", "optimizeEnable"),
            ("Optimizer", "optimizer"),
            ("AI plugins", "aiPlugins"),
            ("Dashboard", "dashboard"),
            ("Docs viewers", "docsViewers"),
        ],
    ),
    (
        "Developer Workflow",
        [
            ("Debug adapters", "debugAdapters"),
            ("Debug UI", "debugUi"),
            ("Diff viewer", "diffViewer"),
            ("Git integrations", "gitIntegrations"),
            ("Picker", "picker"),
            ("File manager", "fileManager"),
            ("HTTP client", "httpClient"),
            ("Motion", "motion"),
            ("Rename", "rename"),
            ("Search", "search"),
            ("Text objects", "textObjects"),
        ],
    ),
    (
        "Text",
        [
            ("Comments", "comments"),
            ("Markdown rendering", "markdownRendering"),
            ("Patterns", "patterns"),
            ("Split/join", "splitJoin"),
            ("Whitespace", "whitespace"),
        ],
    ),
    (
        "UI",
        [
            ("Animations", "animations"),
            ("Bufferline", "bufferline"),
            ("Commandline", "commandline"),
            ("Indent guides", "indentGuides"),
            ("Keybinding help", "keybindingHelp"),
            ("Notifications", "notifications"),
            ("Rename popup", "renamePopup"),
            ("Signature help", "signatureHelp"),
            ("Status column", "statusColumn"),
            ("Statusline", "statusline"),
            ("Terminal", "terminal"),
        ],
    ),
    (
        "Utilities",
        [
            ("Clipboard", "clipboard"),
            ("Screenshots", "screenshots"),
            ("Sessions", "sessions"),
        ],
    ),
]


def format_scalar(value):
    if value is None:
        return "none"
    if isinstance(value, bool):
        return "`true`" if value else "`false`"
    if isinstance(value, str):
        return f"`{value}`"
    return f"`{value}`"


def format_value(value):
    if isinstance(value, list):
        if not value:
            return "none"
        return "<br>".join(f"`{item}`" for item in value)
    return format_scalar(value)


def render_table(rows, profile_matrix):
    header = "| Setting | " + " | ".join(PROFILES) + " |"
    divider = "|---|" + "|".join("---" for _ in PROFILES) + "|"
    body = [header, divider]

    for label, key in rows:
        cells = [label]
        for profile in PROFILES:
            cells.append(format_value(profile_matrix[profile][key]))
        body.append("| " + " | ".join(cells) + " |")

    return "\n".join(body)


def main():
    if len(sys.argv) != 3:
        print(
            "usage: render-profile-matrix.py <input.json> <output.md>", file=sys.stderr
        )
        sys.exit(1)

    input_path, output_path = sys.argv[1], sys.argv[2]

    with open(input_path, encoding="utf-8") as handle:
        payload = json.load(handle)

    profile_matrix = payload["profileMatrix"]

    lines = [
        "# Profile Matrix",
        "",
        "This page is generated from evaluated `khanelivim.profile` configs via `mkNixvimConfig`.",
        "",
        "`full` currently reflects the raw component defaults from the option modules.",
        "`debug` follows the full/default surface and adds debug-focused overrides.",
        "",
    ]

    for section_name, rows in SECTIONS:
        lines.append(f"## {section_name}")
        lines.append("")
        lines.append(render_table(rows, profile_matrix))
        lines.append("")

    with open(output_path, "w", encoding="utf-8") as handle:
        handle.write("\n".join(lines))


if __name__ == "__main__":
    main()
