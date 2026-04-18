#!/usr/bin/env python3

from __future__ import annotations

import json
import pathlib
import re
import shutil
import sys
from collections import defaultdict

CATEGORY_ORDER = [
    ("essential-navigation", "Essential Navigation"),
    ("windows-buffers", "Windows & Buffers"),
    ("search-picking", "Search & Picking"),
    ("file-management", "File Management"),
    ("git", "Git"),
    ("lsp-navigation", "LSP & Navigation"),
    ("diagnostics-debugging", "Diagnostics & Debugging"),
    ("language-workflows", "Language Workflows"),
    ("toggles", "Toggles"),
    ("editing-text", "Editing & Text"),
    ("misc", "Miscellaneous"),
]

MODE_ORDER = ["n", "v", "x", "s", "o", "i", "t", "c"]


def normalize_lhs(lhs: str) -> str:
    if lhs.startswith(" "):
        return "<leader>" + lhs[1:]
    return lhs


def fallback_label(lhs: str, rhs: str | None) -> str | None:
    normalized_lhs = normalize_lhs(lhs).lower()
    normalized_rhs = (rhs or "").lower()

    if normalized_lhs == "<space>":
        return "Leader noop"
    if normalized_lhs == "<esc>" and "noh" in normalized_rhs:
        return "Clear search highlight"
    if lhs == "Y" and normalized_rhs == "y$":
        return "Yank to end of line"
    if normalized_lhs == "<c-c>" and "b#" in normalized_rhs:
        return "Switch to alternate buffer"
    if lhs == "j":
        return "Move cursor down"
    if lhs == "k":
        return "Move cursor up"
    if lhs == "K":
        return "Hover documentation"
    if lhs == "gd":
        return "Go to definition"
    if lhs == "grr":
        return "Find references"
    if lhs == "gri":
        return "Go to implementation"
    if lhs == "gy":
        return "Go to type definition"
    if lhs == "gx":
        return "Open document link"
    if lhs == "s":
        return "Flash jump"
    if lhs == "S":
        return "Flash treesitter"
    if lhs == "]q":
        return "Next quickfix item"
    if lhs == "[q":
        return "Previous quickfix item"
    if lhs == "|":
        return "Vertical split"
    if lhs == "-":
        return "Horizontal split"
    if lhs == "<tab>":
        return "Next buffer"
    if lhs == "<s-tab>":
        return "Previous buffer"
    if "vsplit" in normalized_rhs:
        return "Vertical split"
    if re.search(r"(^|[^v])split", normalized_rhs):
        return "Horizontal split"
    if "bnext" in normalized_rhs:
        return "Next buffer"
    if "bprevious" in normalized_rhs:
        return "Previous buffer"

    return None


def display_context(entry: dict[str, object]) -> str:
    if entry["scope"] == "global":
        return "global"
    filetype = entry.get("filetype")
    if filetype:
        return f"`{filetype}` buffer"
    return "buffer"


def classify(entry: dict[str, object], label: str) -> str:
    lhs = normalize_lhs(str(entry["lhs"])).lower()
    desc = label.lower()
    filetype = str(entry.get("filetype") or "")

    if lhs.startswith("<leader>z") or (
        entry["scope"] == "buffer"
        and filetype
        and any(
            term in desc
            for term in [
                "imports",
                "tsserver",
                "runnables",
                "cargo",
                "venv",
                "test",
                "watch",
                "source definition",
                "file references",
                "outdated",
            ]
        )
    ):
        return "language-workflows"

    if lhs.startswith("<leader>u") or "toggle" in desc:
        return "toggles"

    if lhs.startswith("<leader>d") or any(
        term in desc
        for term in [
            "debug",
            "breakpoint",
            "repl",
            "session",
            "terminate",
            "step ",
            "run code lens",
            "diagnostic",
            "errors list",
            "diagnostics list",
        ]
    ):
        return "diagnostics-debugging"

    if (
        lhs.startswith("<leader>l")
        or lhs in {"gd", "grr", "gri"}
        or any(
            term in desc
            for term in [
                "hover",
                "definition",
                "references",
                "implementation",
                "rename",
                "type definition",
                "document link",
                "tooling info",
                "code action",
                "format",
            ]
        )
    ):
        if any(
            term in desc for term in ["diagnostic", "errors list", "diagnostics list"]
        ):
            return "diagnostics-debugging"
        return "lsp-navigation"

    if lhs.startswith("<leader>g") or any(
        term in desc
        for term in [
            "git",
            "diff",
            "hunk",
            "blame",
            "lazygit",
            "bookmark",
            "rebase",
            "squash",
            "fetch",
            "push",
            "open pr",
            "history picker",
            "status picker",
        ]
    ):
        return "git"

    if lhs.startswith("<leader>f") or any(
        term in desc
        for term in [
            "find ",
            "search",
            "picker",
            "grep",
            "recent files",
            "help",
            "symbols",
            "marks",
            "todo",
            "command history",
        ]
    ):
        return "search-picking"

    if lhs.startswith("<leader>e") or any(
        term in desc for term in ["file explorer", "mini files", "yazi", "neo-tree"]
    ):
        return "file-management"

    if (
        lhs.startswith("<leader>b")
        or lhs
        in {
            "<tab>",
            "<s-tab>",
            "|",
            "-",
            "<c-c>",
            "<c-n>",
            "<leader>w",
            "<leader>q",
            "<leader>w",
            "<leader>q",
        }
        or any(
            term in desc
            for term in ["buffer", "window", "split", "save", "quit", "new file"]
        )
    ):
        return "windows-buffers"

    if any(
        term in desc
        for term in [
            "comment",
            "indent",
            "unindent",
            "paste",
            "yank",
            "surround",
            "whitespace",
        ]
    ):
        return "editing-text"

    if lhs in {"<space>", "<esc>", "j", "k", "y", "s"} or any(
        term in desc for term in ["move cursor", "leader noop", "clear search", "jump"]
    ):
        return "essential-navigation"

    return "misc"


def mode_key(mode: str) -> int:
    try:
        return MODE_ORDER.index(mode)
    except ValueError:
        return len(MODE_ORDER)


def sort_key(entry: dict[str, object]) -> tuple[object, ...]:
    return (
        0 if entry["scope"] == "global" else 1,
        str(entry.get("filetype") or ""),
        str(entry["lhs"]).lower(),
        str(entry["label"]).lower(),
    )


def render_table(entries: list[dict[str, object]]) -> list[str]:
    lines = [
        "| Key | Modes | Description | Context |",
        "|---|---|---|---|",
    ]

    for entry in entries:
        modes = " ".join(f"`{mode}`" for mode in sorted(entry["modes"], key=mode_key))
        lines.append(
            "| {key} | {modes} | {desc} | {context} |".format(
                key=f"`{normalize_lhs(str(entry['lhs']))}`",
                modes=modes,
                desc=entry["label"].replace("|", "\\|"),
                context=display_context(entry),
            )
        )

    return lines


def main() -> None:
    if len(sys.argv) != 6:
        print(
            "usage: render-keymaps.py <input.json> <output_dir> <summary.md> <start_marker> <end_marker>",
            file=sys.stderr,
        )
        sys.exit(1)

    input_path = pathlib.Path(sys.argv[1])
    output_dir = pathlib.Path(sys.argv[2])
    summary_path = pathlib.Path(sys.argv[3])
    start_marker = sys.argv[4]
    end_marker = sys.argv[5]

    payload = json.loads(input_path.read_text(encoding="utf-8"))

    by_group: dict[str, dict[tuple[object, ...], dict[str, object]]] = defaultdict(dict)

    for item in payload["maps"]:
        lhs = item.get("lhs")
        if not lhs:
            continue

        rhs = item.get("rhs")
        label = item.get("desc") or fallback_label(lhs, rhs)
        if not label:
            continue

        category = classify(item, label)
        dedupe_key = (
            item["scope"],
            item.get("filetype"),
            lhs,
            label,
        )

        existing = by_group[category].get(dedupe_key)
        if existing is None:
            by_group[category][dedupe_key] = {
                "scope": item["scope"],
                "filetype": item.get("filetype"),
                "lhs": lhs,
                "label": label,
                "modes": {item["mode"]},
            }
        else:
            existing["modes"].add(item["mode"])

    if output_dir.exists():
        shutil.rmtree(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    generated_categories = []

    sample_filetypes = ", ".join(f"`{ft}`" for ft in payload.get("sampleFiletypes", []))

    index_lines = [
        "# Keymaps",
        "",
        "This section is generated from a headless run of the evaluated `standard` profile.",
        "It includes startup maps plus buffer-local maps discovered after opening representative sample files.",
        "",
        f"Representative filetypes: {sample_filetypes or 'none'}",
        "",
        "Only mappings with an explicit description or a small generated fallback label are shown.",
        "",
    ]

    for slug, title in CATEGORY_ORDER:
        entries = sorted(by_group.get(slug, {}).values(), key=sort_key)
        if not entries:
            continue

        generated_categories.append((slug, title))
        index_lines.append(f"- [{title}](./{slug}.md) ({len(entries)} maps)")

        page_lines = [
            f"# {title}",
            "",
            "This page is generated from runtime keymap state.",
            "",
        ]
        page_lines.extend(render_table(entries))
        page_lines.append("")

        (output_dir / f"{slug}.md").write_text("\n".join(page_lines), encoding="utf-8")

    if not generated_categories:
        index_lines.append("No keymaps were generated.")

    (output_dir / "index.md").write_text(
        "\n".join(index_lines) + "\n", encoding="utf-8"
    )

    summary = summary_path.read_text(encoding="utf-8")
    markers_re = re.compile(
        rf"(?ms)^(?P<indent>[ \t]*){re.escape(start_marker)}\s*$.*?^(?P=indent){re.escape(end_marker)}\s*$"
    )
    match = markers_re.search(summary)

    if not match:
        print(
            f"Warning: Summary markers {start_marker} / {end_marker} not found in {summary_path}",
            file=sys.stderr,
        )
    else:
        indent = match.group("indent")
        lines = [f"{indent}{start_marker}"]
        for slug, title in generated_categories:
            lines.append(f"{indent}- [{title}](keymaps/{slug}.md)")
        lines.append(f"{indent}{end_marker}")
        summary = markers_re.sub("\n".join(lines), summary, count=1)
        summary_path.write_text(summary.rstrip() + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
