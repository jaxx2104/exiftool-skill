#!/usr/bin/env python3
"""Convert one upstream exiftool HTML page to a Markdown file with
frontmatter. Invoked per-file by tools/regen-references.sh.

Usage:
    html2md.py --source PATH --output PATH \
               [--toc] [--upstream-version VER] [--upstream-commit SHA] \
               [--upstream-source-rel REL_PATH]
"""
from __future__ import annotations

import argparse
import datetime as dt
import re
import sys
from pathlib import Path

from bs4 import BeautifulSoup
from markdownify import markdownify


def strip_noise(soup: BeautifulSoup) -> None:
    """Remove style/script/nav cruft that does not survive Markdown."""
    for tag in soup(["style", "script"]):
        tag.decompose()
    # Upstream pages have a "back to top" anchor block at the end.
    for a in soup.find_all("a", attrs={"href": "#top"}):
        a.decompose()


def rewrite_intra_links(soup: BeautifulSoup, *, in_tag_names: bool) -> None:
    """Rewrite href="EXIF.html" to relative skill-internal Markdown links.

    For pages under upstream/tag-names/ (in_tag_names=True), references
    to other TagNames pages stay sibling-relative (e.g. "exif.md").
    For pages under upstream/ root, references to TagNames/EXIF.html
    become "tag-names/exif.md".
    """
    for a in soup.find_all("a", href=True):
        href = a["href"]
        # Anchor-only, mailto, external — leave alone.
        if href.startswith(("#", "mailto:", "http://", "https://")):
            continue
        # TagNames/<Name>.html (cross-section reference)
        m = re.match(r"^TagNames/([A-Za-z0-9_]+)\.html(#.*)?$", href)
        if m:
            target = f"tag-names/{m.group(1).lower()}.md"
            if in_tag_names:
                target = f"{m.group(1).lower()}.md"
            a["href"] = target + (m.group(2) or "")
            continue
        # ../html/<page>.html or ../<page>.html — flatten to upstream/<page>.md
        m = re.match(r"^\.\./(?:html/)?([A-Za-z0-9_]+)\.html(#.*)?$", href)
        if m:
            target = f"../{m.group(1).lower()}.md"
            a["href"] = target + (m.group(2) or "")
            continue
        # Sibling .html within the same dir.
        m = re.match(r"^([A-Za-z0-9_]+)\.html(#.*)?$", href)
        if m:
            target = f"{m.group(1).lower()}.md"
            a["href"] = target + (m.group(2) or "")
            continue


def insert_toc(md: str) -> str:
    """Insert a table of contents at the top of the Markdown body.

    Collects every H2/H3 heading and emits a bulleted list with
    GitHub-style anchor slugs.
    """
    headings = []
    for line in md.splitlines():
        if line.startswith("## "):
            headings.append((2, line[3:].strip()))
        elif line.startswith("### "):
            headings.append((3, line[4:].strip()))
    if not headings:
        return md
    lines = ["## Contents", ""]
    for level, text in headings:
        slug = re.sub(r"[^a-z0-9\- ]", "", text.lower()).strip()
        slug = re.sub(r"\s+", "-", slug)
        indent = "  " * (level - 2)
        lines.append(f"{indent}- [{text}](#{slug})")
    lines.append("")
    toc = "\n".join(lines)
    # Insert before the first H1, or at the very top if no H1.
    if "\n# " in md or md.startswith("# "):
        # Find the H1 line and insert TOC immediately after it.
        out_lines = []
        inserted = False
        for line in md.splitlines():
            out_lines.append(line)
            if not inserted and line.startswith("# "):
                out_lines.append("")
                out_lines.append(toc)
                inserted = True
        return "\n".join(out_lines)
    return toc + "\n" + md


def convert(
    source: Path,
    output: Path,
    *,
    toc: bool,
    upstream_version: str,
    upstream_commit: str,
    upstream_source_rel: str,
) -> None:
    raw = source.read_text(encoding="utf-8", errors="replace")
    soup = BeautifulSoup(raw, "html.parser")
    strip_noise(soup)
    in_tag_names = "tag-names" in str(output).replace("\\", "/")
    rewrite_intra_links(soup, in_tag_names=in_tag_names)

    md_body = markdownify(
        str(soup),
        heading_style="ATX",
        bullets="-",
        strip=["script", "style"],
    ).strip()

    # Collapse runs of >2 blank lines.
    md_body = re.sub(r"\n{3,}", "\n\n", md_body)

    if toc:
        md_body = insert_toc(md_body)

    today = dt.date.today().isoformat()
    frontmatter = "\n".join(
        [
            "---",
            f"generated_from: {upstream_source_rel}",
            f"upstream_version: {upstream_version}",
            f"upstream_commit: {upstream_commit}",
            f"generated_at: {today}",
            "do_not_edit: true",
            "---",
            "",
            "> **Auto-generated** from upstream exiftool documentation. Do not",
            "> edit by hand — edits will be overwritten on next regeneration.",
            "> To change wording, edit the corresponding file in",
            "> `vendor/exiftool/html/` upstream or override behavior in",
            "> `references/tasks/`.",
            "",
        ]
    )

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(frontmatter + md_body + "\n", encoding="utf-8")


def main() -> int:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--source", required=True, type=Path)
    p.add_argument("--output", required=True, type=Path)
    p.add_argument("--toc", action="store_true")
    p.add_argument("--upstream-version", required=True)
    p.add_argument("--upstream-commit", required=True)
    p.add_argument("--upstream-source-rel", required=True,
                   help="Path inside repo, e.g. vendor/exiftool/html/geotag.html")
    args = p.parse_args()

    if not args.source.is_file():
        print(f"error: source not found: {args.source}", file=sys.stderr)
        return 2

    convert(
        args.source,
        args.output,
        toc=args.toc,
        upstream_version=args.upstream_version,
        upstream_commit=args.upstream_commit,
        upstream_source_rel=args.upstream_source_rel,
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
