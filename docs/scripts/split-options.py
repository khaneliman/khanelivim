#!/usr/bin/env python3

from __future__ import annotations

import pathlib
import re
import shutil
import sys

ACRONYMS = {
    "ai",
    "api",
    "css",
    "dap",
    "git",
    "html",
    "http",
    "https",
    "json",
    "lsp",
    "nix",
    "sql",
    "ssh",
    "toml",
    "ui",
    "url",
    "xml",
    "yaml",
}


def titleize(value: str) -> str:
    parts = value.replace("-", " ").replace("_", " ").split()
    normalized = [
        part.upper() if part.lower() in ACRONYMS else part.capitalize()
        for part in parts
    ]
    return " ".join(normalized)


def display_option_name(option_name: str, group: str) -> str:
    prefix = f"khanelivim.{group}"
    return (
        option_name[len(prefix) + 1 :]
        if option_name.startswith(prefix + ".")
        else option_name
    )


def main() -> None:
    if len(sys.argv) != 5:
        print(
            "Usage: split-options.py <input_file> <output_dir> <start_marker> <end_marker>"
        )
        sys.exit(1)

    input_file = pathlib.Path(sys.argv[1])
    output_dir = pathlib.Path(sys.argv[2])
    start_marker = sys.argv[3]
    end_marker = sys.argv[4]
    root = pathlib.Path(".")

    text = input_file.read_text()
    heading_re = re.compile(r"(?m)^(#+)\s+.*khanelivim(?:\\\.[a-zA-Z0-9_-]+)+.*$")
    matches = list(heading_re.finditer(text))

    groups: dict[str, list[str]] = {}

    for idx, match in enumerate(matches):
        start = match.start()
        end = matches[idx + 1].start() if idx + 1 < len(matches) else len(text)
        section = text[start:end].strip()

        option_match = re.search(r"khanelivim(?:\\\.[a-zA-Z0-9_-]+)+", section)
        option_name = option_match.group(0).replace("\\.", ".") if option_match else ""

        if not option_name.startswith("khanelivim."):
            group = "other"
            display_name = option_name
        else:
            parts = option_name.split(".")
            group = parts[1] if len(parts) > 1 else "root"
            display_name = display_option_name(option_name, group)

        if option_name:
            lines = section.splitlines()
            if lines:
                escaped_option_name = option_name.replace(".", "\\.")
                lines[0] = re.sub(
                    re.escape(escaped_option_name),
                    display_name,
                    lines[0],
                    count=1,
                )
                section = "\n".join(lines)

        groups.setdefault(group, []).append(section + "\n")

    if not groups:
        groups["other"] = [text.strip() + "\n"]

    if output_dir.exists():
        shutil.rmtree(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    ordered_groups = sorted(groups)

    for group in ordered_groups:
        group_title = titleize(group)
        content = f"# {group_title}\n\n" + "\n".join(groups[group])
        (output_dir / f"{group}.md").write_text(content + "\n")

    index_lines = ["# Options Reference", ""]
    for group in ordered_groups:
        group_title = titleize(group)
        index_lines.append(f"- [{group_title}](./{group}.md)")
    (output_dir / "index.md").write_text("\n".join(index_lines) + "\n")

    summary_path = root / "SUMMARY.md"
    summary = summary_path.read_text()
    markers_re = re.compile(
        rf"(?ms)^(?P<indent>[ \t]*){re.escape(start_marker)}\s*$.*?^(?P=indent){re.escape(end_marker)}\s*$"
    )
    match = markers_re.search(summary)

    if not match:
        print(
            f"Warning: Summary markers {start_marker} / {end_marker} not found in SUMMARY.md"
        )
    else:
        indent = match.group("indent")
        lines = [f"{indent}{start_marker}"]
        for group in ordered_groups:
            group_title = titleize(group)
            lines.append(f"{indent}- [{group_title}](options/{group}.md)")
        lines.append(f"{indent}{end_marker}")
        summary = markers_re.sub("\n".join(lines), summary, count=1)

    summary_path.write_text(summary + "\n")


if __name__ == "__main__":
    main()
