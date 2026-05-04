#!/usr/bin/env bash
# lint.sh — Verification harness for exiftool-skill.
#
# Runs:
# 1. JSON parse for .claude-plugin/{plugin,marketplace}.json.
# 2. YAML frontmatter parse for skills/exiftool/SKILL.md.
# 3. bash -n for every skill script.
# 4. shellcheck for every skill script (if shellcheck is installed).
# 5. Markdown link integrity check across SKILL.md and references/.
#
# Exits non-zero on any failure.
#
# Usage:
#   tests/lint.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

PASS_COUNT=0
FAIL_COUNT=0

ok() {
    echo "  ✓ $1"
    PASS_COUNT=$((PASS_COUNT + 1))
}

fail() {
    echo "  ✗ $1" >&2
    FAIL_COUNT=$((FAIL_COUNT + 1))
}

heading() {
    echo
    echo "=== $1 ==="
}

# 1. Plugin / marketplace JSON
heading "plugin/marketplace JSON"
for f in .claude-plugin/plugin.json .claude-plugin/marketplace.json; do
    if python3 -c "import json; json.load(open('$f'))" 2>/dev/null; then
        ok "$f parses as JSON"
    else
        fail "$f does NOT parse as JSON"
    fi
done

# 2. SKILL.md frontmatter
heading "SKILL.md frontmatter"
SKILL_MD="skills/exiftool/SKILL.md"
if python3 - <<PY
import re, sys
t = open("$SKILL_MD").read()
m = re.match(r"^---\n(.*?)\n---", t, re.S)
if not m:
    print("no frontmatter")
    sys.exit(1)
fm = m.group(1)
if "name: exiftool" not in fm:
    print("missing 'name: exiftool'")
    sys.exit(1)
if "description:" not in fm:
    print("missing 'description:'")
    sys.exit(1)
PY
then
    ok "$SKILL_MD frontmatter has name + description"
else
    fail "$SKILL_MD frontmatter invalid"
fi

# 3. bash -n on scripts
heading "bash -n on scripts"
while IFS= read -r -d '' s; do
    if bash -n "$s" 2>/dev/null; then
        ok "$s parses"
    else
        fail "$s has bash syntax error"
    fi
done < <(find skills/exiftool/scripts -type f -name '*.sh' -print0)

# 4. shellcheck (optional)
heading "shellcheck (optional)"
if command -v shellcheck >/dev/null 2>&1 && shellcheck --version >/dev/null 2>&1; then
    while IFS= read -r -d '' s; do
        if shellcheck -S error "$s" 2>/dev/null; then
            ok "shellcheck $s"
        else
            fail "shellcheck $s reported errors"
        fi
    done < <(find skills/exiftool/scripts -type f -name '*.sh' -print0)
else
    echo "  · shellcheck not installed — skipping"
fi

# 5. Markdown link integrity (intra-repo references only)
heading "markdown link integrity"
LINK_FAIL=0
while IFS= read -r -d '' md; do
    # Extract markdown links of form [text](path) where path is relative.
    # Filter out external (http, mailto), anchors-only, and absolute.
    (grep -oE '\]\([^)]+\)' "$md" || true) | sed 's/^](//;s/)$//' | while IFS= read -r link; do
        # Strip anchor.
        link_path="${link%%#*}"
        # Skip empty, external, absolute.
        case "$link_path" in
            "" )                   continue ;;
            http://*|https://* )   continue ;;
            mailto:* )             continue ;;
            /* )                   continue ;;
        esac
        # Resolve relative to the directory of the markdown file.
        md_dir="$(dirname "$md")"
        target="$md_dir/$link_path"
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
        if [[ ! -e "$target" ]]; then
            echo "  ✗ broken link in $md: $link_path → $target" >&2
            LINK_FAIL=1
        fi
    done
done < <(find skills/exiftool -name '*.md' -print0)

if [[ "$LINK_FAIL" -eq 0 ]]; then
    ok "all relative markdown links resolve"
else
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi

# Summary
heading "summary"
echo "  passed: $PASS_COUNT"
echo "  failed: $FAIL_COUNT"

if [[ "$FAIL_COUNT" -gt 0 ]]; then
    exit 1
fi
