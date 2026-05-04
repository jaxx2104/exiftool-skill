# exiftool-skill Phase 2: Upstream Reference Generation Implementation Plan

**Goal:** Populate `skills/exiftool/references/upstream/` by mechanically converting selected upstream `vendor/exiftool/html/*.html` and `html/TagNames/*.html` to Markdown, and automate the recurring upstream bump via a weekly GitHub Actions workflow that opens a PR.

**Architecture:** Python converter (`tools/html2md.py`) using `markdownify` + `beautifulsoup4`. A YAML-driven allowlist (`tools/select-upstream.yaml`) declares which upstream HTML files are converted and where the output lands. A shell driver (`tools/regen-references.sh`) wires it together; a link checker (`tools/check-links.sh`) validates relative links across SKILL.md and references after generation. A GitHub Actions workflow (`.github/workflows/weekly-upstream-bump.yml`) runs weekly, detects new upstream tags, bumps the submodule, regenerates references, and opens a PR.

**Tech Stack:**
- Python 3.11+ (mise-managed; `markdownify`, `beautifulsoup4`)
- Bash 4+ for the driver and link checker
- PyYAML for reading the allowlist
- GitHub Actions (Linux runner, `actions/checkout@v4`, `actions/setup-python@v5`, `gh` CLI)

**Reference spec:** `docs/superpowers/specs/2026-05-04-exiftool-skill-design.md` §6 and §6.7.

**Working directory:** `~/repos/github.com/jaxx2104/exiftool-skill/` on branch `phase-2-upstream-generation` (split from `origin/main` after Phase 1 merged as PR #1).

**Out of scope:**
- Evals iteration loop (Phase 3)
- Description optimization (Phase 4)
- Marketplace registration / v0.1.0 release (Phase 5)
- Removing the Phase 1 SKILL.md note "(populated in Phase 2)" — this plan finalizes that wording.

---

## File Structure

| Path | Responsibility | Created in |
|------|----------------|-----------|
| `tools/select-upstream.yaml` | Allowlist of upstream HTML → Markdown mappings (29 files) | T1 |
| `tools/html2md.py` | Convert one HTML file to Markdown with frontmatter | T2 |
| `tools/regen-references.sh` | Driver: read YAML, call converter, write `INDEX.md` | T3 |
| `tools/check-links.sh` | Standalone relative-link integrity checker | T4 |
| `tools/requirements.txt` | Python deps (`markdownify`, `beautifulsoup4`, `pyyaml`) | T1 |
| `skills/exiftool/references/upstream/INDEX.md` | Auto-generated index of all upstream/* files | T5 (run regen) |
| `skills/exiftool/references/upstream/*.md` | 29 generated reference files | T5 |
| `tests/lint.sh` | Remove the Phase 1 `references/upstream/` link-check exemption | T6 |
| `skills/exiftool/SKILL.md` | Update "(populated in Phase 2)" → final wording | T7 |
| `.github/workflows/weekly-upstream-bump.yml` | Weekly cron + workflow_dispatch + auto-PR | T8 |
| `CHANGELOG.md` | Record Phase 2 deliverables | T9 |

---

## Conventions

- One commit per task. Conventional Commits prefixes: `chore:`, `feat:`, `docs:`, `test:`, `ci:` (for the workflow).
- Commit footer: `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>`.
- All Python: `python3` shebang, type hints where useful, no third-party deps beyond `tools/requirements.txt`.
- All shell: `#!/usr/bin/env bash`, `set -euo pipefail`.
- The 29 generated `references/upstream/*.md` files are committed with a single squashed commit (T5 step 4) — not 29 separate commits.

---

## Task 1: Allowlist + Python deps

**Files:**
- Create: `tools/select-upstream.yaml`
- Create: `tools/requirements.txt`

- [ ] **Step 1: Write `tools/select-upstream.yaml`**

```yaml
# Allowlist of upstream exiftool HTML files to convert into
# skills/exiftool/references/upstream/. tools/regen-references.sh reads
# this and tools/html2md.py converts each entry. Add entries to expand
# the corpus in future phases.

html_root:
  - source: html/examples.html
    output: examples.md
  - source: html/faq.html
    output: faq.md
  - source: html/geotag.html
    output: geotag.md
  - source: html/filename.html
    output: filename.md
  - source: html/metafiles.html
    output: metafiles.md
  - source: html/geolocation.html
    output: geolocation.md
  - source: html/exiftool_pod.html
    output: cli-options.md
    options:
      toc: true
  - source: html/mistakes.html
    output: common-mistakes.md
  - source: html/idiosyncracies.html
    output: idiosyncracies.md
  - source: html/install.html
    output: install.md

tag_names:
  - source: html/TagNames/EXIF.html
    output: tag-names/exif.md
    options:
      toc: true
  - source: html/TagNames/Composite.html
    output: tag-names/composite.md
  - source: html/TagNames/XMP.html
    output: tag-names/xmp.md
    options:
      toc: true
  - source: html/TagNames/IPTC.html
    output: tag-names/iptc.md
  - source: html/TagNames/GPS.html
    output: tag-names/gps.md
  - source: html/TagNames/QuickTime.html
    output: tag-names/quicktime.md
    options:
      toc: true
  - source: html/TagNames/JPEG.html
    output: tag-names/jpeg.md
  - source: html/TagNames/PNG.html
    output: tag-names/png.md
  - source: html/TagNames/Extra.html
    output: tag-names/extra.md
  - source: html/TagNames/Canon.html
    output: tag-names/canon.md
    options:
      toc: true
  - source: html/TagNames/Nikon.html
    output: tag-names/nikon.md
    options:
      toc: true
  - source: html/TagNames/Sony.html
    output: tag-names/sony.md
    options:
      toc: true
  - source: html/TagNames/FujiFilm.html
    output: tag-names/fujifilm.md
  - source: html/TagNames/Panasonic.html
    output: tag-names/panasonic.md
  - source: html/TagNames/Olympus.html
    output: tag-names/olympus.md
  - source: html/TagNames/Pentax.html
    output: tag-names/pentax.md
  - source: html/TagNames/Apple.html
    output: tag-names/apple.md
  - source: html/TagNames/DJI.html
    output: tag-names/dji.md
  - source: html/TagNames/GoPro.html
    output: tag-names/gopro.md
```

(Note: upstream's filename for FujiFilm is `FujiFilm.html` with a capital F in "Film", and Pentax may live under different vendor names in some upstream snapshots. T2 step 5 verifies these resolve.)

- [ ] **Step 2: Write `tools/requirements.txt`**

```
markdownify>=0.13
beautifulsoup4>=4.12
pyyaml>=6.0
```

- [ ] **Step 3: Verify YAML parses**

```bash
python3 -c "import yaml; d = yaml.safe_load(open('tools/select-upstream.yaml')); print(len(d['html_root']), len(d['tag_names']))"
```
Expected: `10 19`

- [ ] **Step 4: Commit**

```bash
git add tools/select-upstream.yaml tools/requirements.txt
git commit -m "$(cat <<'EOF'
chore(tools): allowlist (29 files) and Python deps for upstream regen

YAML-driven enumeration of upstream HTML → Markdown mappings.
Allowlist covers 10 root html/ docs and 19 TagNames/ files (foundational
+ major MakerNote vendors + action cameras). Per-entry options.toc
flags large files for TOC injection.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 2: HTML → Markdown converter (`tools/html2md.py`)

**Files:**
- Create: `tools/html2md.py`

- [ ] **Step 1: Write the converter**

The converter reads one HTML file, applies pre-processing, runs
`markdownify`, applies post-processing, and writes a Markdown file with
frontmatter. It is invoked once per allowlist entry by the driver
(T3); it does not read the YAML itself.

```python
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
                # We are inside upstream/tag-names/, so the link is sibling.
                target = f"{m.group(1).lower()}.md"
            a["href"] = target + (m.group(2) or "")
            continue
        # Sibling .html within the same dir.
        m = re.match(r"^([A-Za-z0-9_]+)\.html(#.*)?$", href)
        if m:
            target = f"{m.group(1).lower()}.md"
            # If we are in tag-names/ and the link points to a non-TagName
            # page (rare), it would land outside the directory; emit a
            # parent-relative link.
            if in_tag_names:
                # The upstream TagName pages mostly cross-link only to
                # other TagName pages; a non-TagName sibling would be a
                # bug. Leave the link bare for the link checker to flag.
                pass
            a["href"] = target + (m.group(2) or "")
            continue
        # ../html/<page>.html — flatten to upstream/<page>.md
        m = re.match(r"^\.\./html/([A-Za-z0-9_]+)\.html(#.*)?$", href)
        if m:
            target = f"../{m.group(1).lower()}.md"
            a["href"] = target + (m.group(2) or "")


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
    parts = md.split("\n# ", 1)
    if len(parts) == 2:
        return parts[0] + "\n# " + parts[1].split("\n", 1)[0] + "\n\n" + toc + "\n" + (parts[1].split("\n", 1)[1] if "\n" in parts[1] else "")
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
```

- [ ] **Step 2: Smoke-test on one file**

Install deps in a venv (or system pip) and run a quick smoke test:

```bash
cd ~/repos/github.com/jaxx2104/exiftool-skill
python3 -m venv .venv
.venv/bin/pip install -r tools/requirements.txt
.venv/bin/python3 tools/html2md.py \
    --source vendor/exiftool/html/install.html \
    --output /tmp/install.md \
    --upstream-version 13.57 \
    --upstream-commit dae9b7a8 \
    --upstream-source-rel vendor/exiftool/html/install.html
head -20 /tmp/install.md
```

Expected: a Markdown file beginning with the auto-generated frontmatter, followed by the body of the install page rendered as Markdown.

- [ ] **Step 3: Add `.venv/` to `.gitignore` if not already covered**

`.gitignore` already covers `.venv/` and `venv/` from Phase 1. No edit needed; verify with `grep -E '^\.?venv/' .gitignore` (expect 2 matches).

- [ ] **Step 4: Commit**

```bash
git add tools/html2md.py
git commit -m "$(cat <<'EOF'
feat(tools): html2md.py — upstream HTML to Markdown converter

Per-file converter using markdownify + beautifulsoup4. Strips
style/script/back-to-top noise, rewrites intra-doc links to
skill-internal Markdown paths, optionally inserts a TOC for large
pages, and emits frontmatter recording upstream version/commit/source.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 3: Driver script (`tools/regen-references.sh`)

**Files:**
- Create: `tools/regen-references.sh`

- [ ] **Step 1: Write the driver**

```bash
#!/usr/bin/env bash
# regen-references.sh — Regenerate skills/exiftool/references/upstream/
# from vendor/exiftool/html/ via tools/html2md.py.
#
# Reads tools/select-upstream.yaml for the source/output mapping and
# the optional per-entry `options.toc` flag.
#
# Usage:
#   tools/regen-references.sh
#
# Requires:
#   - vendor/exiftool submodule populated and at the desired tag.
#   - python3 with deps from tools/requirements.txt.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

VENDOR="$ROOT/vendor/exiftool"
OUT_DIR="$ROOT/skills/exiftool/references/upstream"
YAML="$ROOT/tools/select-upstream.yaml"
CONVERTER="$ROOT/tools/html2md.py"

if [[ ! -d "$VENDOR/html" ]]; then
    echo "error: vendor/exiftool/html not found. Did you init the submodule?" >&2
    exit 2
fi

PYTHON="${PYTHON:-python3}"
if [[ -x "$ROOT/.venv/bin/python3" ]]; then
    PYTHON="$ROOT/.venv/bin/python3"
fi

UPSTREAM_VERSION=$(git -C "$VENDOR" describe --tags --exact-match 2>/dev/null \
                   || git -C "$VENDOR" describe --tags)
UPSTREAM_COMMIT=$(git -C "$VENDOR" rev-parse --short HEAD)

echo "regenerating upstream/ references"
echo "  upstream version: $UPSTREAM_VERSION"
echo "  upstream commit:  $UPSTREAM_COMMIT"

# Wipe and recreate the output dir, preserving .gitkeep.
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR/tag-names"
touch "$OUT_DIR/.gitkeep"

# Iterate the YAML allowlist via Python (avoids needing yq).
"$PYTHON" - <<PY
import yaml, subprocess, sys
from pathlib import Path

ROOT = Path("$ROOT")
VENDOR = Path("$VENDOR")
OUT = Path("$OUT_DIR")
CONVERTER = "$CONVERTER"
PY_BIN = "$PYTHON"
UV = "$UPSTREAM_VERSION"
UC = "$UPSTREAM_COMMIT"

with open("$YAML") as f:
    data = yaml.safe_load(f)

for section_key in ("html_root", "tag_names"):
    for entry in data.get(section_key, []):
        src = VENDOR / entry["source"]
        dst = OUT / entry["output"]
        if not src.is_file():
            print(f"  [skip] missing upstream: {src.relative_to(ROOT)}", file=sys.stderr)
            continue
        opts = entry.get("options") or {}
        cmd = [
            PY_BIN, CONVERTER,
            "--source", str(src),
            "--output", str(dst),
            "--upstream-version", UV,
            "--upstream-commit", UC,
            "--upstream-source-rel", str(src.relative_to(ROOT)),
        ]
        if opts.get("toc"):
            cmd.append("--toc")
        subprocess.run(cmd, check=True)
        print(f"  [ok] {entry['source']} -> {entry['output']}")
PY

# Emit INDEX.md.
INDEX="$OUT_DIR/INDEX.md"
{
    echo "# Upstream reference index (auto-generated)"
    echo
    echo "Generated from \`vendor/exiftool/\` at version \`$UPSTREAM_VERSION\` (commit \`$UPSTREAM_COMMIT\`)."
    echo
    echo "| File | Source |"
    echo "|------|--------|"
    while IFS= read -r f; do
        rel="${f#"$OUT_DIR/"}"
        # Read frontmatter source.
        src=$(awk '/^generated_from:/ {print $2; exit}' "$f")
        echo "| [\`$rel\`]($rel) | \`$src\` |"
    done < <(find "$OUT_DIR" -type f -name '*.md' ! -name 'INDEX.md' | sort)
} > "$INDEX"

echo "wrote $INDEX"
```

- [ ] **Step 2: Make executable and run**

```bash
chmod +x tools/regen-references.sh
tools/regen-references.sh
ls skills/exiftool/references/upstream/
ls skills/exiftool/references/upstream/tag-names/
wc -l skills/exiftool/references/upstream/INDEX.md
```

Expected:
- 10 `.md` files at the upstream/ root + `INDEX.md` + `.gitkeep`
- 19 `.md` files in upstream/tag-names/
- INDEX.md has a row for every generated file

- [ ] **Step 3: Commit (driver only — generated files come in T5)**

```bash
git add tools/regen-references.sh
git commit -m "$(cat <<'EOF'
feat(tools): regen-references.sh driver

Reads tools/select-upstream.yaml, calls tools/html2md.py for each
entry, and emits an auto-generated INDEX.md that references every
upstream/* file with its source path. Reads upstream version/commit
from vendor/exiftool submodule HEAD.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 4: Link integrity checker (`tools/check-links.sh`)

**Files:**
- Create: `tools/check-links.sh`

- [ ] **Step 1: Write the file**

```bash
#!/usr/bin/env bash
# check-links.sh — Verify every relative Markdown link under skills/
# resolves to an existing path. Used as a post-regen sanity check
# (also embedded in tests/lint.sh, but this one is standalone for
# the GitHub Action).
#
# Usage:
#   tools/check-links.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

FAIL=0

while IFS= read -r -d '' md; do
    (grep -oE '\]\([^)]+\)' "$md" || true) | sed 's/^](//;s/)$//' \
    | while IFS= read -r link; do
        link_path="${link%%#*}"
        case "$link_path" in
            "" )                   continue ;;
            http://*|https://* )   continue ;;
            mailto:* )             continue ;;
            /* )                   continue ;;
        esac
        md_dir="$(dirname "$md")"
        target="$md_dir/$link_path"
        if [[ ! -e "$target" ]]; then
            echo "broken link in $md: $link_path -> $target" >&2
            FAIL=1
        fi
    done
done < <(find skills/exiftool -name '*.md' -print0)

if [[ "$FAIL" -ne 0 ]]; then
    exit 1
fi
echo "all relative markdown links resolve"
```

- [ ] **Step 2: Make executable and run (after T5)**

For now, the script will be exercised in T5 step 3. Just create and commit:

```bash
chmod +x tools/check-links.sh
bash -n tools/check-links.sh
```

- [ ] **Step 3: Commit**

```bash
git add tools/check-links.sh
git commit -m "$(cat <<'EOF'
feat(tools): check-links.sh standalone link integrity checker

Same logic as the link-integrity stage in tests/lint.sh, factored
into a standalone tool for direct use in the
weekly-upstream-bump GitHub workflow.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 5: Run regen and commit generated upstream/

**Files:**
- Generate then commit: `skills/exiftool/references/upstream/**/*.md`

- [ ] **Step 1: Run regen**

```bash
tools/regen-references.sh
```

Expected: per-file `[ok]` lines and a final `wrote .../INDEX.md`. If any file is logged `[skip] missing upstream`, the allowlist references a path that does not exist in the pinned upstream tag — investigate (filename casing, version drift) before committing.

- [ ] **Step 2: Inspect a few generated files**

```bash
head -30 skills/exiftool/references/upstream/geotag.md
head -30 skills/exiftool/references/upstream/tag-names/exif.md
cat skills/exiftool/references/upstream/INDEX.md
```

Each generated file should start with the frontmatter block, then the
body. INDEX.md should have one row per generated `.md` file.

- [ ] **Step 3: Run link checker**

```bash
tools/check-links.sh
```

Expected: `all relative markdown links resolve`. If broken links are
reported, they are most likely:
- Cross-references from `tasks/*.md` to `references/upstream/<name>.md`
  files that the allowlist does not produce. Add the missing entry to
  `tools/select-upstream.yaml` and re-run T5 step 1.
- Intra-upstream links that the converter's `rewrite_intra_links` did
  not catch. Fix the converter (T2), commit the fix as a separate task,
  re-run T5 step 1.

- [ ] **Step 4: Commit the generated files**

```bash
git add skills/exiftool/references/upstream/
git commit -m "$(cat <<'EOF'
feat(skill): generate references/upstream/ from upstream 13.57

Auto-generated from vendor/exiftool/html via tools/regen-references.sh.
Covers 10 root html/ pages and 19 TagNames/ pages (foundational +
major MakerNote vendors + action cameras). INDEX.md provides a single
entry point. Frontmatter on each file records the source path and
upstream version/commit for provenance.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 6: Drop the Phase 1 lint exemption

**Files:**
- Modify: `tests/lint.sh`

- [ ] **Step 1: Read and edit**

Remove the `case "$target" in *references/upstream/* )` exemption block introduced in Phase 1, since `references/upstream/` is now populated and the link checker should treat it as any other path.

The block to remove (within the link-integrity loop):

```bash
        # Phase 1: references/upstream/ is populated by Phase 2.
        # Skip integrity check for paths inside it while it is empty
        # (only .gitkeep present).
        case "$target" in
            *references/upstream/*)
                if [[ -d skills/exiftool/references/upstream ]]; then
                    continue
                fi
                ;;
        esac
```

- [ ] **Step 2: Run lint**

```bash
tests/lint.sh
```

Expected: all checks pass; the link-integrity stage now covers
`references/upstream/` references and they resolve.

- [ ] **Step 3: Commit**

```bash
git add tests/lint.sh
git commit -m "$(cat <<'EOF'
test: drop Phase 1 references/upstream/ link-check exemption

upstream/ is now populated by tools/regen-references.sh, so lint can
treat it as any other path.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 7: Finalize SKILL.md upstream pointer

**Files:**
- Modify: `skills/exiftool/SKILL.md`

- [ ] **Step 1: Update the reference map row**

Replace the line containing `*(populated in Phase 2)*` so the upstream entry reads as live content. The row goes from:

```
| Deep dive on upstream                        | `references/upstream/INDEX.md` *(populated in Phase 2)* |
```

to:

```
| Deep dive on upstream                        | `references/upstream/INDEX.md` |
```

Also update the closing section "When to consult `references/upstream/`":

```markdown
## When to consult `references/upstream/`

When the relevant `references/tasks/*.md` does not cover the user's
request, or when the user asks about an option the task file does not
mention, consult `references/upstream/INDEX.md` to find the upstream
documentation excerpt. Each upstream file's frontmatter records which
upstream HTML page it derives from and the upstream version pinned in
`vendor/exiftool/`.
```

- [ ] **Step 2: Run lint**

```bash
tests/lint.sh
```

Expected: all checks pass.

- [ ] **Step 3: Commit**

```bash
git add skills/exiftool/SKILL.md
git commit -m "$(cat <<'EOF'
docs(skill): SKILL.md — finalize upstream/ pointer

upstream/ is populated; remove the Phase 1 placeholder note and
clarify that frontmatter records source provenance.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 8: Weekly upstream-bump GitHub Actions workflow

**Files:**
- Create: `.github/workflows/weekly-upstream-bump.yml`

- [ ] **Step 1: Write the workflow**

```yaml
name: Weekly upstream bump

on:
  schedule:
    - cron: '0 6 * * 1'   # Mondays 06:00 UTC
  workflow_dispatch: {}

permissions:
  contents: write
  pull-requests: write

jobs:
  bump:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout (with submodules)
        uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 0

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - name: Install Python deps
        run: |
          pip install -r tools/requirements.txt

      - name: Determine current and latest upstream tag
        id: tags
        run: |
          set -euo pipefail
          cd vendor/exiftool
          git fetch --tags --quiet
          CURRENT=$(git describe --tags --exact-match 2>/dev/null || git describe --tags)
          LATEST=$(git tag -l '13.*' | sort -V | tail -1)
          echo "current=$CURRENT" >> "$GITHUB_OUTPUT"
          echo "latest=$LATEST" >> "$GITHUB_OUTPUT"
          if [[ "$CURRENT" == "$LATEST" ]]; then
            echo "already at latest ($CURRENT) — no work to do"
            echo "needs_bump=false" >> "$GITHUB_OUTPUT"
          else
            echo "current=$CURRENT, latest=$LATEST"
            echo "needs_bump=true" >> "$GITHUB_OUTPUT"
          fi

      - name: Skip duplicate auto-PR
        if: steps.tags.outputs.needs_bump == 'true'
        id: dup
        run: |
          set -euo pipefail
          BRANCH="auto/upstream-${{ steps.tags.outputs.latest }}"
          if git ls-remote --exit-code --heads origin "$BRANCH" >/dev/null 2>&1; then
            echo "branch $BRANCH already exists on remote — skipping"
            echo "skip=true" >> "$GITHUB_OUTPUT"
          else
            echo "branch=$BRANCH" >> "$GITHUB_OUTPUT"
            echo "skip=false" >> "$GITHUB_OUTPUT"
          fi

      - name: Bump submodule and regenerate
        if: steps.tags.outputs.needs_bump == 'true' && steps.dup.outputs.skip == 'false'
        run: |
          set -euo pipefail
          cd vendor/exiftool
          git checkout "${{ steps.tags.outputs.latest }}"
          cd ../..
          ./tools/regen-references.sh

      - name: Verify links
        if: steps.tags.outputs.needs_bump == 'true' && steps.dup.outputs.skip == 'false'
        id: links
        run: |
          set -euo pipefail
          if ./tools/check-links.sh; then
            echo "links_ok=true" >> "$GITHUB_OUTPUT"
          else
            echo "links_ok=false" >> "$GITHUB_OUTPUT"
          fi

      - name: Commit and push
        if: steps.tags.outputs.needs_bump == 'true' && steps.dup.outputs.skip == 'false'
        run: |
          set -euo pipefail
          git config user.name "github-actions[bot]"
          git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
          git checkout -b "${{ steps.dup.outputs.branch }}"
          git add vendor/exiftool skills/exiftool/references/upstream/
          git commit -m "Bump upstream to ${{ steps.tags.outputs.latest }}, regenerate references"
          git push -u origin "${{ steps.dup.outputs.branch }}"

      - name: Open pull request
        if: steps.tags.outputs.needs_bump == 'true' && steps.dup.outputs.skip == 'false'
        env:
          GH_TOKEN: ${{ github.token }}
        run: |
          set -euo pipefail
          BODY="Auto-generated PR from weekly-upstream-bump workflow."
          BODY+=$'\n\n'"Bumps \`vendor/exiftool\` from \`${{ steps.tags.outputs.current }}\` to \`${{ steps.tags.outputs.latest }}\` and regenerates \`skills/exiftool/references/upstream/\`."
          BODY+=$'\n\n'"Upstream changelog: https://github.com/exiftool/exiftool/blob/${{ steps.tags.outputs.latest }}/Changes"
          LABELS=("auto-upstream")
          if [[ "${{ steps.links.outputs.links_ok }}" != "true" ]]; then
            LABELS+=("needs-attention")
            DRAFT="--draft"
            BODY+=$'\n\n'"⚠️ \`tools/check-links.sh\` reported broken links — see workflow logs."
          else
            DRAFT=""
          fi
          LABEL_ARGS=()
          for l in "${LABELS[@]}"; do
            LABEL_ARGS+=(--label "$l")
          done
          gh pr create $DRAFT \
            --title "Bump upstream to ${{ steps.tags.outputs.latest }}" \
            --body "$BODY" \
            --base main \
            --head "${{ steps.dup.outputs.branch }}" \
            "${LABEL_ARGS[@]}" \
            --reviewer jaxx2104 || true
```

- [ ] **Step 2: Validate YAML**

```bash
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/weekly-upstream-bump.yml'))" && echo OK
```

Expected: `OK`.

- [ ] **Step 3: Commit**

```bash
mkdir -p .github/workflows
git add .github/workflows/weekly-upstream-bump.yml
git commit -m "$(cat <<'EOF'
ci: weekly upstream-bump workflow

Mondays 06:00 UTC + workflow_dispatch. Detects new upstream tag, bumps
vendor/exiftool submodule, regenerates references/upstream/ via
tools/regen-references.sh, runs tools/check-links.sh, opens PR
auto/upstream-<tag>. Marks PR as draft + needs-attention if link
check fails. Skips silently when already at latest or when the same
auto branch already exists.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 9: CHANGELOG + Phase 2 final integration

**Files:**
- Modify: `CHANGELOG.md`

- [ ] **Step 1: Update**

Replace the `## [Unreleased]` block to record Phase 2 deliverables:

```markdown
## [Unreleased]

### Added (Phase 1 — foundation)
- Repository scaffolding: `.gitignore`, `.gitattributes`, `LICENSE`
  (Artistic-1.0-Perl OR GPL-1.0-or-later), `README.md`, `CHANGELOG.md`,
  `vendor/exiftool` submodule pinned to tag `13.57`.
- Plugin manifests: `.claude-plugin/marketplace.json` (marketplace name
  `jaxx2104`), `.claude-plugin/plugin.json` (version `0.1.0-dev` with
  files whitelist).
- Skill entry point `skills/exiftool/SKILL.md` with description,
  reference map, and four embedded critical safety rules.
- Hand-written task references (8 files at equal density) under
  `skills/exiftool/references/tasks/`.
- `skills/exiftool/references/safety.md` with three-step rule,
  `_original` decision table, and pitfall catalog P-001..P-010.
- `skills/exiftool/references/tag-cheatsheet.md`.
- Bundled bash helpers under `skills/exiftool/scripts/`.
- `tests/lint.sh` verification harness.

### Added (Phase 2 — upstream auto-generation)
- `tools/select-upstream.yaml` allowlist (29 files: 10 html/ + 19 TagNames/).
- `tools/html2md.py` HTML → Markdown converter (markdownify + bs4).
- `tools/regen-references.sh` driver and `tools/check-links.sh`
  standalone link integrity checker.
- `tools/requirements.txt` Python deps.
- Generated `skills/exiftool/references/upstream/` content: 10 root
  pages, 19 TagNames pages, plus auto-generated `INDEX.md`.
- `.github/workflows/weekly-upstream-bump.yml` — weekly cron + manual
  dispatch, opens auto-PR on new upstream tag.
- `tests/lint.sh` — Phase 1 `references/upstream/` exemption removed.

### Pending (later phases)
- Evals iteration loop (Phase 3).
- Description optimization (Phase 4).
- Plugin marketplace registration & v0.1.0 GitHub release (Phase 5).
```

- [ ] **Step 2: Final lint pass**

```bash
tests/lint.sh
```

Expected: all checks pass.

- [ ] **Step 3: Smoke check**

```bash
ls .github/workflows
ls tools
ls skills/exiftool/references/upstream | head -15
ls skills/exiftool/references/upstream/tag-names | head -15
git log --oneline | head -15
git status
```

Expected:
- `.github/workflows/weekly-upstream-bump.yml` present
- `tools/` contains html2md.py, regen-references.sh, check-links.sh, select-upstream.yaml, requirements.txt
- upstream/ has 10+ files at the root and 19 in tag-names/
- working tree clean

- [ ] **Step 4: Commit and open PR**

```bash
git add CHANGELOG.md
git commit -m "$(cat <<'EOF'
docs: record Phase 2 deliverables in CHANGELOG

Upstream auto-generation pipeline, generated references/upstream/
content, and the weekly-upstream-bump workflow.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"

git push -u origin phase-2-upstream-generation

gh pr create --title "Phase 2: Upstream reference generation + weekly auto-bump" \
  --body "Implements design spec §6 and §6.7. See docs/superpowers/plans/2026-05-04-phase-2-upstream-generation.md for the per-task breakdown."
```

- [ ] **Step 5: Merge**

```bash
gh pr merge --squash --delete-branch
git checkout main
git pull --ff-only
```

Phase 2 is complete when the PR is merged to `main` and `origin` is
synced.

---

## Self-Review

**Spec coverage (§6 + §6.7):**

| Spec section | Plan task |
|--------------|-----------|
| §6.1 Generation pipeline diagram | T2 + T3 (converter + driver) |
| §6.2 Allowlist (10 + 19 = 29) | T1 |
| §6.3 Converter implementation | T2 |
| §6.4 Generated frontmatter | T2 (frontmatter block in `convert()`) |
| §6.5 INDEX.md | T3 (driver appends INDEX.md generation) |
| §6.6 Manual regeneration | T3 (the driver itself; same script humans run) |
| §6.7 Automated workflow | T8 |

**Placeholder scan:** No "TBD"/"TODO" left. The Pentax allowlist note in T1 is a known caveat handled by T5 step 1's `[skip] missing upstream` log — but the upstream `13.57` ships `Pentax.html`, so the entry should resolve. If it doesn't on actual run, it's a clear actionable failure (caught in T5), not a plan placeholder.

**Type / signature consistency:**
- `tools/html2md.py` CLI flags (`--source`, `--output`, `--toc`, `--upstream-version`, `--upstream-commit`, `--upstream-source-rel`) match the call in `tools/regen-references.sh`.
- YAML keys (`html_root`, `tag_names`, `source`, `output`, `options.toc`) consistent between T1 (writer) and T3 (reader).
- Branch naming `auto/upstream-<tag>` consistent in T8.

No issues found.
