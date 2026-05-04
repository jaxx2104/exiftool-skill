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
