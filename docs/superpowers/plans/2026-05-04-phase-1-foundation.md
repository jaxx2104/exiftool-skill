# exiftool-skill Phase 1: Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bring up a working, installable Claude Code Plugin that ships a `exiftool` skill with the eight hand-written task references and a safety guide — the minimum viable "official-caliber" skill.

**Architecture:** A new GitHub-public repository `jaxx2104/exiftool-skill` packaged as a Claude Code Plugin. Skill content lives under `skills/exiftool/` with `SKILL.md` as the entry point and `references/{tasks,upstream}/` plus `references/safety.md` and `references/tag-cheatsheet.md` as progressive disclosure. Bundled bash helpers under `scripts/`. Upstream `exiftool/exiftool` is included as a git submodule pinned to tag `13.57` so future phases can auto-generate `references/upstream/`. This phase covers M1 (scaffolding) and M2 (hand-written task references + safety) from the design spec; the `references/upstream/` layer is created as an empty placeholder and filled by Phase 2.

**Tech Stack:**
- Claude Code Plugin (`.claude-plugin/{marketplace,plugin}.json`)
- Markdown skill content (`SKILL.md`, `references/**/*.md`)
- Bash 4+ helper scripts (`#!/usr/bin/env bash`, `set -euo pipefail`)
- Git submodule for `vendor/exiftool` (upstream Phil Harvey repo)
- macOS / Linux (skill targets exiftool installed via `brew` / `apt`)
- Verification: `shellcheck`, `bash -n`, `python3 -c 'import yaml; ...'` for plugin.json sanity, manual link integrity grep

**Reference spec:** `docs/superpowers/specs/2026-05-04-exiftool-skill-design.md`

**Working directory:** `~/repos/github.com/jaxx2104/exiftool-skill/` (already initialized as a local git repo on branch `main`, no remote yet — the only existing commits are the design spec at `docs/superpowers/specs/2026-05-04-exiftool-skill-design.md`).

**Out of scope for this phase:**
- `references/upstream/*` content (Phase 2)
- `tools/regen-references.sh`, `tools/html2md.py`, `tools/select-upstream.yaml`, `tools/check-links.sh` (Phase 2)
- `.github/workflows/weekly-upstream-bump.yml` (Phase 2)
- `evals/` (Phase 3)
- Description optimization (Phase 4)
- Plugin marketplace registration / GitHub release (Phase 5)

---

## File Structure

| Path | Responsibility | Created in |
|------|----------------|-----------|
| `.gitignore` | Exclude OS noise, editor temp, Python bytecode | T1 |
| `.gitattributes` | `export-ignore` for `tools/`, `vendor/`, `tests/`, `evals/`, `docs/`, `.github/` (supplementary to plugin.json `files`) | T2 |
| `LICENSE` | Perl Artistic + GPL dual license text (upstream-inherited) | T3 |
| `README.md` | Installation, what the skill does, prerequisites, dev workflow | T4 |
| `CHANGELOG.md` | Keep-a-changelog formatted; `[Unreleased]` only at this phase | T5 |
| `vendor/exiftool/` | Git submodule pinned to upstream tag `13.57` | T6 |
| `.gitmodules` | Submodule declaration (auto-created by `git submodule add`) | T6 |
| `.claude-plugin/marketplace.json` | Marketplace manifest (`name: jaxx2104`, plugin: exiftool) | T7 |
| `.claude-plugin/plugin.json` | Plugin metadata + `files` whitelist (distribution scope) | T8 |
| `skills/exiftool/SKILL.md` | Entry point: description frontmatter, prerequisite, reference map, critical safety rules | T9 (skeleton), T22 (final) |
| `skills/exiftool/references/safety.md` | Three-step rule, `_original` decision table, ≥10-entry pitfall catalog | T10 |
| `skills/exiftool/references/tag-cheatsheet.md` | Frequent-tag lookup grouped by EXIF/XMP/IPTC/Composite/MakerNote | T11 |
| `skills/exiftool/references/tasks/reading.md` | View/extract patterns | T12 |
| `skills/exiftool/references/tasks/gps.md` | Read/strip/set/geotag GPS (full template, copied from spec §13.1) | T13 |
| `skills/exiftool/references/tasks/datetime.md` | Show/shift/restore dates, TZ correction | T14 |
| `skills/exiftool/references/tasks/copying.md` | File-to-file, sidecar XMP, selective copy | T15 |
| `skills/exiftool/references/tasks/renaming.md` | `FileName<` / `Directory<` patterns, `-TestName` dry-run | T16 |
| `skills/exiftool/references/tasks/formats.md` | `-j`, `-csv`, short forms, piping | T17 |
| `skills/exiftool/references/tasks/video.md` | QuickTime, GoPro `-ee`, DJI SRT, GPX out | T18 |
| `skills/exiftool/references/tasks/sanitize.md` | `-all=`, SNS-publish preset, `-overwrite_original` use | T19 |
| `skills/exiftool/references/upstream/.gitkeep` | Empty placeholder; filled by Phase 2 | T9 |
| `skills/exiftool/scripts/plan-batch.sh` | Count files matched by `-if` query | T20 |
| `skills/exiftool/scripts/strip-private.sh` | SNS-publish sanitize preset | T21 |
| `skills/exiftool/scripts/dry-rename.sh` | `-TestName` rename preview | T22a |
| `skills/exiftool/scripts/extract-gpx.sh` | GoPro/DJI embedded GPS → GPX | T22b |
| `tests/lint.sh` | Verification harness: shellcheck, JSON parse, link grep | T23 |

(Existing) `docs/superpowers/specs/2026-05-04-exiftool-skill-design.md` is preserved; new `docs/superpowers/plans/2026-05-04-phase-1-foundation.md` is this file.

---

## Conventions

- **Commits**: one commit per task. Conventional Commits prefix:
  - `chore:` for repo plumbing (gitignore, license, submodule)
  - `feat:` for skill content additions (SKILL.md, references/, scripts/)
  - `docs:` for README / CHANGELOG / plan / spec edits
  - `test:` for `tests/lint.sh`
- All commit messages end with the standard footer:
  ```
  Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
  ```
- All shell scripts begin with `#!/usr/bin/env bash` and `set -euo pipefail`.
- All Markdown files end with a single trailing newline.
- "Verification" steps are run with the working directory set to the repo root unless otherwise noted.
- The repo has **no remote** during Phase 1; do not run `git push`. A remote is added in Phase 5.

---

## Task 1: Add `.gitignore`

**Files:**
- Create: `.gitignore`

- [ ] **Step 1: Write the file**

```
# OS
.DS_Store
Thumbs.db

# Editor
.vscode/
.idea/
*.swp
*.swo
*~

# Python (used by tools/ in later phases)
__pycache__/
*.pyc
.venv/
venv/

# Build / packaging artifacts (Phase 5)
*.skill
dist/

# Workspace siblings (skill-creator eval workspaces, kept outside the repo,
# but sometimes accidentally created inside)
*-workspace/

# Temporary
*.tmp
*.log
```

- [ ] **Step 2: Verify the file is well-formed**

Run: `wc -l .gitignore`
Expected: a positive integer (no errors).

- [ ] **Step 3: Commit**

```bash
git add .gitignore
git commit -m "$(cat <<'EOF'
chore: add .gitignore

Cover OS noise, editor scratch, Python bytecode (used by tools/ in
later phases), packaging artifacts, and accidental skill-creator
workspace siblings.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 2: Add `.gitattributes` for export-ignore

**Files:**
- Create: `.gitattributes`

- [ ] **Step 1: Write the file**

```
# Supplementary to .claude-plugin/plugin.json `files` whitelist.
# Only effective for git-archive based fetch paths.
tools/                  export-ignore
vendor/                 export-ignore
tests/                  export-ignore
evals/                  export-ignore
docs/                   export-ignore
.github/                export-ignore
.gitattributes          export-ignore
.gitmodules             export-ignore
*-workspace/            export-ignore
```

- [ ] **Step 2: Verify**

Run: `cat .gitattributes | grep -c export-ignore`
Expected: `9`

- [ ] **Step 3: Commit**

```bash
git add .gitattributes
git commit -m "$(cat <<'EOF'
chore: add .gitattributes export-ignore for non-distribution paths

Supplementary to plugin.json files whitelist; covers git-archive
fetch paths.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 3: Add LICENSE (Perl Artistic + GPL dual)

**Files:**
- Create: `LICENSE`

- [ ] **Step 1: Fetch the upstream LICENSE text**

The upstream `exiftool/exiftool` repo bundles its license inside its `Changes` and module headers but ships a top-level `LICENSE` file. Copy it from the upstream local mirror to keep dual-license alignment.

Run:
```bash
cp /Users/jaxx/repos/github.com/jaxx2104/exiftool/Changes /tmp/_upstream_changes.txt
ls -la /Users/jaxx/repos/github.com/jaxx2104/exiftool/ | grep -iE 'license|copying'
```

If a `README` is the only license-bearing file in the upstream, the dual-license declaration is the lines starting with "This program is free software". Use the canonical Perl Artistic License + GPL combination.

- [ ] **Step 2: Write the LICENSE file**

Write `LICENSE` containing the dual-license declaration:

```
exiftool-skill is licensed under the same terms as the upstream
exiftool project: you may redistribute and/or modify it under either
the GNU General Public License (any version) or the Artistic License,
the same terms as the standard Perl distribution.

The contents of `references/upstream/` are mechanical derivations of
documentation in https://github.com/exiftool/exiftool and inherit those
terms automatically.

----------------------------------------------------------------------

The Artistic License

Preamble

  The intent of this document is to state the conditions under which a
  Package may be copied, such that the Copyright Holder maintains some
  semblance of artistic control over the development of the package,
  while giving the users of the package the right to use and distribute
  the Package in a more-or-less customary fashion, plus the right to
  make reasonable modifications.

[Full text of Artistic License 1.0 — fetch from
https://opensource.org/licenses/Artistic-1.0 if not available locally,
and paste verbatim.]

----------------------------------------------------------------------

GNU GENERAL PUBLIC LICENSE
Version 1, February 1989

[Full text of GPLv1 — fetch from
https://www.gnu.org/licenses/old-licenses/gpl-1.0.txt and paste
verbatim, OR use GPLv2 since the upstream uses "any version".]
```

If the engineer cannot fetch full license texts in their environment, write the dual-license preamble (first paragraph above) plus an SPDX header `SPDX-License-Identifier: Artistic-1.0-Perl OR GPL-1.0-or-later` and add a TODO in the next task to attach full text before publication. **For Phase 1, the SPDX-only short form is acceptable** since the repo is not yet public; full text must be in place before Phase 5 release.

Minimum acceptable Phase 1 file:

```
SPDX-License-Identifier: Artistic-1.0-Perl OR GPL-1.0-or-later

exiftool-skill is licensed under the same terms as the upstream
exiftool project: the Artistic License (Perl) or the GNU General
Public License, at the recipient's option. Full license texts will
be inlined before the v0.1.0 release.

The contents of `references/upstream/` are mechanical derivations of
documentation in https://github.com/exiftool/exiftool and inherit
those terms automatically.
```

- [ ] **Step 3: Verify**

Run: `head -1 LICENSE`
Expected: `SPDX-License-Identifier: Artistic-1.0-Perl OR GPL-1.0-or-later`

- [ ] **Step 4: Commit**

```bash
git add LICENSE
git commit -m "$(cat <<'EOF'
chore: add LICENSE (Artistic-1.0-Perl OR GPL-1.0-or-later)

Dual license matching upstream exiftool. Full license texts to be
inlined before v0.1.0 release; SPDX header sufficient for pre-release.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 4: Initial README.md

**Files:**
- Create: `README.md`

- [ ] **Step 1: Write the file**

```markdown
# exiftool-skill

A comprehensive Claude Code skill for image, video, and audio metadata
operations via [exiftool](https://exiftool.org/) (Phil Harvey).

> Status: pre-release (v0.1.0 in progress). Plugin marketplace registration
> happens in Phase 5.

## What it does

Translates natural-language requests into safe `exiftool` invocations across
eight task categories:

1. View / extract metadata
2. GPS / geolocation read, write, strip
3. Capture date / time correction and TZ shifting
4. Tag copying and sidecar XMP application
5. Renaming and folder organization by capture date
6. JSON / CSV / structured export
7. Video metadata (GoPro, DJI, generic QuickTime)
8. Sanitize / strip private metadata before publication

## Prerequisites

`exiftool` must be installed on `PATH`:

- macOS: `brew install exiftool`
- Debian / Ubuntu: `sudo apt install libimage-exiftool-perl`
- Other: see <https://exiftool.org/install.html>

Verify with: `exiftool -ver`

## Install

(Available in Phase 5 — Plugin marketplace registration pending.)

Once registered, install via Claude Code:

```
/plugin marketplace add jaxx2104/exiftool-skill
/plugin install exiftool@jaxx2104
```

## Safety model

Write and delete operations are gated by a three-step rule (plan → confirm
→ execute) and explicit `_original` backup handling. See
`skills/exiftool/references/safety.md`.

## Development

- Skill content: `skills/exiftool/`
- Hand-written task references: `skills/exiftool/references/tasks/`
- Auto-generated upstream docs: `skills/exiftool/references/upstream/` (Phase 2)
- Bundled helpers: `skills/exiftool/scripts/`
- Upstream submodule: `vendor/exiftool/` (pinned to tag `13.57`)

## License

Dual-licensed under the Artistic License (Perl) or the GNU GPL — same terms
as upstream exiftool. See `LICENSE`.

## Acknowledgements

All authoritative metadata knowledge in this skill derives from
[exiftool by Phil Harvey](https://exiftool.org/) and his decades of
maker-note reverse engineering. This skill is a translation layer; he is
the source.
```

- [ ] **Step 2: Verify**

Run: `head -1 README.md`
Expected: `# exiftool-skill`

Run: `grep -c "^## " README.md`
Expected: `7` (What it does, Prerequisites, Install, Safety model, Development, License, Acknowledgements)

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "$(cat <<'EOF'
docs: initial README

Cover purpose, eight task categories, prerequisites, install
placeholder (Phase 5), safety model, development layout, license,
and acknowledgement of Phil Harvey's upstream work.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 5: Initial CHANGELOG.md

**Files:**
- Create: `CHANGELOG.md`

- [ ] **Step 1: Write the file**

```markdown
# Changelog

All notable changes to exiftool-skill are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial repository scaffolding (`.claude-plugin/`, `LICENSE`,
  `README.md`, `vendor/exiftool` submodule pinned to tag `13.57`).
- Hand-written task references for 8 categories under
  `skills/exiftool/references/tasks/`.
- `skills/exiftool/references/safety.md` with three-step rule,
  `_original` decision table, and 10-entry pitfall catalog.
- `skills/exiftool/references/tag-cheatsheet.md`.
- Bundled bash helpers under `skills/exiftool/scripts/`:
  `plan-batch.sh`, `strip-private.sh`, `dry-rename.sh`,
  `extract-gpx.sh`.
- `tests/lint.sh` verification harness.

### Pending (later phases)
- `references/upstream/` auto-generation (Phase 2).
- `.github/workflows/weekly-upstream-bump.yml` (Phase 2).
- Evals iteration loop (Phase 3).
- Description optimization (Phase 4).
- Plugin marketplace registration & v0.1.0 GitHub release (Phase 5).
```

- [ ] **Step 2: Verify**

Run: `grep -c "^## " CHANGELOG.md`
Expected: `1` (just `[Unreleased]`)

- [ ] **Step 3: Commit**

```bash
git add CHANGELOG.md
git commit -m "$(cat <<'EOF'
docs: initial CHANGELOG

Keep-a-changelog format. [Unreleased] section seeded with Phase 1
deliverables; later-phase items listed as Pending.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 6: Add `vendor/exiftool` submodule pinned to tag `13.57`

**Files:**
- Create: `vendor/exiftool/` (submodule)
- Create: `.gitmodules` (auto)

- [ ] **Step 1: Add submodule**

Run:
```bash
git submodule add https://github.com/exiftool/exiftool.git vendor/exiftool
```

Expected: `Cloning into 'vendor/exiftool'...` and the clone completes.

- [ ] **Step 2: Pin to tag `13.57`**

Run:
```bash
cd vendor/exiftool
git fetch --tags
git checkout 13.57
cd ../..
```

Expected: `HEAD is now at <sha> Update to 13.57` (or the equivalent commit message).

- [ ] **Step 3: Verify pin**

Run:
```bash
git -C vendor/exiftool describe --tags
```
Expected: `13.57`

Run:
```bash
cat .gitmodules
```
Expected output (one block):
```
[submodule "vendor/exiftool"]
	path = vendor/exiftool
	url = https://github.com/exiftool/exiftool.git
```

- [ ] **Step 4: Commit**

```bash
git add .gitmodules vendor/exiftool
git commit -m "$(cat <<'EOF'
chore: vendor upstream exiftool as submodule pinned to 13.57

Source for Phase 2 reference auto-generation. Pinned tag is bumped
by the future weekly-upstream-bump workflow.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 7: `.claude-plugin/marketplace.json`

**Files:**
- Create: `.claude-plugin/marketplace.json`

- [ ] **Step 1: Write the file**

```json
{
  "name": "jaxx2104",
  "owner": {
    "name": "jaxx2104",
    "url": "https://github.com/jaxx2104"
  },
  "plugins": [
    {
      "name": "exiftool",
      "source": ".",
      "description": "Comprehensive ExifTool skill: view, edit, strip, geotag, rename, and sanitize image/video/audio metadata via natural language."
    }
  ]
}
```

- [ ] **Step 2: Verify JSON parses**

Run:
```bash
python3 -c "import json; json.load(open('.claude-plugin/marketplace.json'))"
```
Expected: no output, exit 0.

- [ ] **Step 3: Commit**

```bash
git add .claude-plugin/marketplace.json
git commit -m "$(cat <<'EOF'
feat: add .claude-plugin/marketplace.json

Marketplace name 'jaxx2104' so plugin install reads as
exiftool@jaxx2104 (avoids the awkward exiftool@exiftool form).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 8: `.claude-plugin/plugin.json`

**Files:**
- Create: `.claude-plugin/plugin.json`

- [ ] **Step 1: Write the file**

```json
{
  "name": "exiftool",
  "version": "0.1.0-dev",
  "description": "Read/write EXIF, IPTC, XMP, GPS, MakerNote metadata via natural language.",
  "author": "jaxx2104",
  "license": "Artistic-1.0-Perl OR GPL-1.0-or-later",
  "homepage": "https://github.com/jaxx2104/exiftool-skill",
  "skills": ["./skills/exiftool"],
  "files": [
    ".claude-plugin/**",
    "skills/exiftool/**",
    "README.md",
    "LICENSE",
    "CHANGELOG.md"
  ]
}
```

The `files` whitelist authoritatively declares the distribution payload
(per spec §3.1) — `tools/`, `vendor/`, `tests/`, `evals/`, `docs/`,
`.github/`, and any `*-workspace/` directories are *not* included.

The version is `0.1.0-dev` until Phase 5 cuts the release.

- [ ] **Step 2: Verify JSON parses**

Run:
```bash
python3 -c "import json; d = json.load(open('.claude-plugin/plugin.json')); print(d['name'], d['version'])"
```
Expected: `exiftool 0.1.0-dev`

- [ ] **Step 3: Commit**

```bash
git add .claude-plugin/plugin.json
git commit -m "$(cat <<'EOF'
feat: add .claude-plugin/plugin.json

Plugin metadata, dual-license SPDX, and the files whitelist that
defines distribution scope. Version is 0.1.0-dev until Phase 5
cuts the release.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 9: `SKILL.md` skeleton + `references/upstream/.gitkeep`

**Files:**
- Create: `skills/exiftool/SKILL.md` (skeleton; final form in T22)
- Create: `skills/exiftool/references/upstream/.gitkeep`

- [ ] **Step 1: Write the SKILL.md skeleton**

```markdown
---
name: exiftool
description: Use this skill any time the user works with image, video, or audio file metadata (EXIF, IPTC, XMP, GPS, MakerNote). This includes viewing or extracting metadata; reading or writing GPS coordinates; correcting DateTimeOriginal or shifting timestamps across many files; renaming or organizing files by capture date; copying tags between files or applying sidecar XMP; exporting metadata to JSON/CSV; extracting GPS tracks from GoPro/DJI videos; stripping private information (GPS, serials, comments) before public sharing. Trigger when the user mentions metadata, EXIF, GPS, geotag, "shot date", "撮影日時", sanitize, or references media files (.jpg, .jpeg, .heic, .heif, .cr2, .cr3, .nef, .arw, .dng, .raw, .tiff, .png, .mp4, .mov, .avi, .mkv, .mp3, .wav, .gpr, .360). Also trigger when extracting structured data from media files for analysis. Do NOT trigger for image content (pixels, resizing, format conversion of pixel data), video transcoding, or audio waveform processing — those need ffmpeg/ImageMagick, not exiftool.
---

# ExifTool Skill

Read, write, and manage metadata in image, video, and audio files using the
`exiftool` CLI. This skill provides task-oriented translations from
natural-language requests into safe `exiftool` invocations.

## Prerequisite

`exiftool` must be on PATH. Verify with `exiftool -ver`. If absent:

- macOS: `brew install exiftool`
- Debian/Ubuntu: `sudo apt install libimage-exiftool-perl`
- Other: <https://exiftool.org/install.html>

## Reference map

(Filled in T22. References listed below are stubs only.)

- View / extract: `references/tasks/reading.md`
- GPS: `references/tasks/gps.md`
- Date/time: `references/tasks/datetime.md`
- Tag copy / sidecar: `references/tasks/copying.md`
- Renaming: `references/tasks/renaming.md`
- Formats: `references/tasks/formats.md`
- Video: `references/tasks/video.md`
- Sanitize: `references/tasks/sanitize.md`
- Tag cheatsheet: `references/tag-cheatsheet.md`
- Safety (REQUIRED before any write): `references/safety.md`

## Critical safety rules

(Filled in T22.)
```

- [ ] **Step 2: Create the upstream placeholder**

Run:
```bash
mkdir -p skills/exiftool/references/upstream
touch skills/exiftool/references/upstream/.gitkeep
```

- [ ] **Step 3: Verify**

Run: `head -1 skills/exiftool/SKILL.md`
Expected: `---`

Run: `python3 -c "import re; t=open('skills/exiftool/SKILL.md').read(); m=re.match(r'^---\n(.+?)\n---', t, re.S); assert m, 'no frontmatter'; assert 'name: exiftool' in m.group(1); assert 'description:' in m.group(1); print('OK')"`
Expected: `OK`

Run: `test -f skills/exiftool/references/upstream/.gitkeep && echo OK`
Expected: `OK`

- [ ] **Step 4: Commit**

```bash
git add skills/exiftool/SKILL.md skills/exiftool/references/upstream/.gitkeep
git commit -m "$(cat <<'EOF'
feat: SKILL.md skeleton + upstream/ placeholder

Frontmatter description is the design-spec verbatim seed for Phase 4
description optimization. Reference map and safety rules are stubs;
finalized in T22 once all referenced files exist.

upstream/.gitkeep reserves the directory for Phase 2 auto-generation.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 10: `references/safety.md`

**Files:**
- Create: `skills/exiftool/references/safety.md`

- [ ] **Step 1: Write the file**

```markdown
# Safety rules for write operations

Read this file **before issuing any write or delete** with `exiftool`.
Reading-only operations (no `=`, no `<`, no `-overwrite_*`) do not require
this gate.

## The three-step rule

1. **Plan**: state what will change — which files, which tags, expected
   count — and surface this to the user.
2. **Confirm**: get explicit user approval. Do not infer consent from
   ambiguous phrasing.
3. **Execute**: run the write only after confirmation.

For batch operations, the Plan step **must** include a count produced by
the matching `-if` query (or `scripts/plan-batch.sh`).

## `_original` backup behavior

By default, exiftool writes the modified file in place and leaves the
unmodified original next to it as `<file>_original`.

| Flag | Behavior | Use when |
|------|----------|----------|
| (none) | Creates `<file>_original` | Default. Safe. |
| `-overwrite_original` | Deletes the backup after success | The user explicitly accepts that the original cannot be restored. |
| `-overwrite_original_in_place` | Same content as above, but preserves inode and atime | The file is referenced by hard links or apps that watch inode identity, and the user accepts loss of the backup. |

When in doubt, **do not** pass `-overwrite_original` — exiftool's default
is the safe choice.

## Tag-family writability

| Group | Read | Write | Notes |
|-------|------|-------|-------|
| `EXIF` | yes | yes | Primary writable group for most cameras. |
| `XMP` | yes | yes | Sidecar-friendly; broader Unicode support than IPTC. |
| `IPTC` | yes | yes | Legacy news/photo tags. |
| `Composite` | yes | **no** | Derived/computed tags. Writing silently no-ops. |
| `MakerNote` | yes | rarely | Manufacturer-proprietary; partial write support per camera. |
| `File` (e.g., `FileName`, `FileModifyDate`) | yes | yes | These are filesystem operations, not metadata writes. |

## Pitfall catalog

Each entry: **symptom → cause → avoidance**. Numbered for easy reference
in conversations.

### P-001: Writing to `Composite:GPSPosition` does nothing

- **Symptom**: command succeeds, no error, but coordinates are unchanged.
- **Cause**: `Composite:GPSPosition` is a derived (read-only) tag combining
  `EXIF:GPSLatitude`, `GPSLongitude`, and the `Ref` tags into one string.
- **Avoidance**: write the four underlying tags
  (`EXIF:GPSLatitude`, `GPSLatitudeRef`, `GPSLongitude`, `GPSLongitudeRef`).

### P-002: Forgetting `Ref` tags flips hemispheres

- **Symptom**: a Tokyo photo (35.68°N) reads as 35.68°S in some viewers.
- **Cause**: EXIF stores GPS as positive magnitude + N/S/E/W ref. Without
  the ref, the consuming app applies an arbitrary default.
- **Avoidance**: when writing latitude/longitude manually, always include
  `GPSLatitudeRef=N|S` and `GPSLongitudeRef=E|W`.

### P-003: `-FileModifyDate` ≠ `-DateTimeOriginal`

- **Symptom**: the user asks to "fix the date" and the photo metadata is
  unchanged; only the filesystem mtime moved.
- **Cause**: `FileModifyDate` is a filesystem property; `DateTimeOriginal`
  is the EXIF capture date. Most users mean the latter.
- **Avoidance**: clarify intent. Default to `-DateTimeOriginal`
  (or `-AllDates`).

### P-004: `-AllDates` is not "every date"

- **Symptom**: bulk shift leaves `FileModifyDate` (or other unexpected
  fields) at the old value.
- **Cause**: `-AllDates` is a shortcut for the three EXIF date tags
  (`DateTimeOriginal`, `CreateDate`, `ModifyDate`). It does **not** include
  filesystem dates, GPS times, or QuickTime times.
- **Avoidance**: enumerate explicitly when needed:
  `-DateTimeOriginal -CreateDate -ModifyDate -GPSDateTime -QuickTime:CreateDate`.

### P-005: `QuickTime:CreateDate` is in UTC

- **Symptom**: a video shows a 9-hour offset between EXIF and QuickTime
  date values for the same recording.
- **Cause**: QuickTime/MP4 atoms store creation times in UTC by spec; EXIF
  stores wall-clock with optional `OffsetTime`.
- **Avoidance**: when shifting video dates, treat QuickTime fields as UTC
  and apply or strip the offset accordingly.

### P-006: HEIC stores GPS in XMP, not always EXIF

- **Symptom**: `exiftool -GPS:all heic_file.heic` returns nothing for a
  photo that clearly has location.
- **Cause**: Apple devices often write GPS into the XMP block of HEIC
  containers in addition to (or instead of) the EXIF block.
- **Avoidance**: read both groups:
  `exiftool -GPS:all -XMP:GPS:all file.heic`. For deletion, use
  `-gps:all=` (lowercase, all groups).

### P-007: `-overwrite_original` cannot be undone

- **Symptom**: user wants to recover a pre-edit copy after running with
  `-overwrite_original`; there is no `_original` file.
- **Cause**: the flag deletes the backup synchronously after the write.
- **Avoidance**: never add `-overwrite_original` to a write command on the
  user's behalf without explicit confirmation. Consider
  `-overwrite_original_in_place` only when inode preservation is required.

### P-008: Wildcards vs. `-r`

- **Symptom**: `exiftool ./photos/*.jpg` skips `./photos/sub/IMG.jpg`.
- **Cause**: shell glob expansion is non-recursive; `-r` is exiftool's
  own recursion flag.
- **Avoidance**: prefer `exiftool -r -ext jpg ./photos` for recursive
  walks. The shell glob and `-r` serve different purposes.

### P-009: Filename case from `%%le` vs. `%%e`

- **Symptom**: a renamed file ends up with `.JPG` instead of `.jpg`
  (or vice versa), breaking downstream tooling that case-discriminates.
- **Cause**: in `-d`/`-FileName<` formats, `%%e` preserves the original
  extension's case; `%%le` lowercases it.
- **Avoidance**: pick the appropriate form. For mixed-case sources where
  consistent lowercase is desired, use `%%le`.

### P-010: PNG metadata may be in tEXt, not EXIF

- **Symptom**: stripping EXIF from a PNG leaves visible "metadata" intact
  in viewers.
- **Cause**: PNG historically stores metadata in `tEXt`, `iTXt`, `zTXt`
  chunks. Newer files may carry EXIF in an `eXIf` chunk; both can coexist.
- **Avoidance**: for full sanitization of PNGs, use `-all=` rather than
  `-exif:all=`.

## See also

- `references/upstream/common-mistakes.md` (Phase 2; auto-generated from
  upstream `mistakes.html`)
- `references/upstream/idiosyncracies.md` (Phase 2; auto-generated from
  upstream `idiosyncracies.html`)
- `references/tag-cheatsheet.md` for tag-name lookup
```

- [ ] **Step 2: Verify**

Run: `grep -c "^### P-" skills/exiftool/references/safety.md`
Expected: `10`

Run: `grep -c "^## " skills/exiftool/references/safety.md`
Expected: `5` (three-step rule, _original backup, Tag-family writability, Pitfall catalog, See also)

- [ ] **Step 3: Commit**

```bash
git add skills/exiftool/references/safety.md
git commit -m "$(cat <<'EOF'
feat(skill): references/safety.md with 10-entry pitfall catalog

Three-step rule (plan/confirm/execute), _original decision table,
tag-family writability matrix, and pitfalls P-001..P-010 covering
Composite write, Ref omission, FileModifyDate confusion, AllDates
scope, QuickTime UTC, HEIC XMP-GPS, overwrite irreversibility,
wildcard vs -r, filename case, PNG tEXt chunks.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 11: `references/tag-cheatsheet.md`

**Files:**
- Create: `skills/exiftool/references/tag-cheatsheet.md`

- [ ] **Step 1: Write the file**

```markdown
# Tag cheatsheet

Frequent-use tag names grouped by metadata family. Use this as a quick
lookup when composing `exiftool` commands. For exhaustive listings, see
`references/upstream/tag-names/` (Phase 2).

## How tag references work

`exiftool` tag names are case-insensitive but conventionally PascalCase.
Tags can be qualified by group:

- `EXIF:GPSLatitude` (specific)
- `GPSLatitude` (all groups; ambiguous if multiple groups carry it)
- `-GPS:all` (all tags in the GPS sub-group)
- `-EXIF:all` (all EXIF tags)
- `-Composite:all` (all derived tags — read-only)

## EXIF — capture metadata

| Tag | Notes |
|-----|-------|
| `DateTimeOriginal` | Capture moment. Wall-clock; pair with `OffsetTimeOriginal` for TZ. |
| `CreateDate` | Often equal to `DateTimeOriginal`. |
| `ModifyDate` | Last-edited timestamp (in EXIF, not filesystem). |
| `OffsetTime` / `OffsetTimeOriginal` / `OffsetTimeDigitized` | TZ offsets like `+09:00`. |
| `Make`, `Model`, `LensModel` | Camera/lens identification. |
| `ISO`, `FNumber`, `ExposureTime`, `FocalLength` | Exposure settings. |
| `Orientation` | 1..8 (rotation/flip flag, NOT pixel rotation). |
| `Software` | Often the editor or firmware version. |
| `SerialNumber`, `LensSerialNumber` | Personally identifying — consider stripping for public sharing. |

## EXIF GPS sub-group

| Tag | Notes |
|-----|-------|
| `GPSLatitude` / `GPSLatitudeRef` | Magnitude + `N`/`S`. |
| `GPSLongitude` / `GPSLongitudeRef` | Magnitude + `E`/`W`. |
| `GPSAltitude` / `GPSAltitudeRef` | `0` = above sea level, `1` = below. |
| `GPSDateStamp` / `GPSTimeStamp` | UTC, separate from EXIF dates. |
| `GPSProcessingMethod` | e.g., `GPS`, `CELLID`, `MANUAL`. |

## XMP — broader, Unicode-friendly

| Tag | Notes |
|-----|-------|
| `XMP-dc:Title`, `XMP-dc:Subject`, `XMP-dc:Description` | Dublin Core; widely supported. |
| `XMP-dc:Creator`, `XMP-dc:Rights` | Authorship. |
| `XMP-photoshop:DateCreated` | Often used by Lightroom/Photoshop. |
| `XMP-iptcExt:LocationShown*` | Structured location info. |
| `XMP-GPS:GPSLatitude` / `GPSLongitude` | XMP-stored GPS (HEIC, some Android). |

## IPTC — legacy news/photo tags

| Tag | Notes |
|-----|-------|
| `IPTC:Caption-Abstract` | Caption / description. Historical name kept by spec. |
| `IPTC:Keywords` | Multi-value keywords. |
| `IPTC:By-line` / `IPTC:By-lineTitle` | Author. |
| `IPTC:City`, `IPTC:Country-PrimaryLocationName` | Location. |

## Composite — derived, read-only

| Tag | Composed from |
|-----|---------------|
| `Composite:GPSPosition` | `GPSLatitude` + `GPSLatitudeRef` + `GPSLongitude` + `GPSLongitudeRef`, formatted. |
| `Composite:GPSDateTime` | `GPSDateStamp` + `GPSTimeStamp`. |
| `Composite:ImageSize` | `ImageWidth` + `ImageHeight`. |
| `Composite:Aperture`, `Composite:ShutterSpeed`, `Composite:FOV` | Computed from raw EXIF values. |

**Composite tags cannot be written.** See pitfall P-001 in `safety.md`.

## QuickTime / MP4 — video

| Tag | Notes |
|-----|-------|
| `QuickTime:CreateDate` / `QuickTime:ModifyDate` | UTC by spec (P-005). |
| `QuickTime:Duration` | Seconds. |
| `QuickTime:VideoFrameRate`, `VideoCodec` | Stream characteristics. |
| `QuickTime:GPSCoordinates` | Single-string lat,lon,alt for whole-clip location. |

## MakerNote — manufacturer-specific

Read-only in most cases. See `references/upstream/tag-names/<vendor>.md`
(Phase 2) for full enumeration. Common groups encountered:

- `Canon:`, `Nikon:`, `Sony:`, `Fujifilm:`, `Panasonic:`, `Olympus:`,
  `Pentax:`, `Apple:` (HEIC iPhone metadata), `DJI:` (drones),
  `GoPro:` (action cameras).

## File group — filesystem operations

| Tag | Notes |
|-----|-------|
| `FileName` | Used with `-FileName<...` to rename. |
| `Directory` | Used with `-Directory<...` to move. |
| `FileModifyDate` | Filesystem mtime — not a metadata write (P-003). |

## See also

- `references/safety.md` for write-safety rules.
- `references/tasks/<topic>.md` for command patterns by use case.
- `references/upstream/tag-names/` (Phase 2) for exhaustive listings.
```

- [ ] **Step 2: Verify**

Run: `grep -c "^## " skills/exiftool/references/tag-cheatsheet.md`
Expected: `10` (How tag references work, EXIF, EXIF GPS, XMP, IPTC, Composite, QuickTime, MakerNote, File group, See also)

- [ ] **Step 3: Commit**

```bash
git add skills/exiftool/references/tag-cheatsheet.md
git commit -m "$(cat <<'EOF'
feat(skill): references/tag-cheatsheet.md

Frequent-use tag names grouped by metadata family (EXIF, GPS sub-
group, XMP, IPTC, Composite, QuickTime, MakerNote, File group) with
notes pointing to safety pitfalls.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 12: `references/tasks/reading.md`

**Files:**
- Create: `skills/exiftool/references/tasks/reading.md`

- [ ] **Step 1: Write the file**

```markdown
# Reading and extracting metadata

This file covers viewing metadata, filtering by tag or group, batch
reads, and producing parseable output. Reading is non-destructive — no
safety gate required.

## When this applies
Read this file when the user says things like:
- 「この写真の Exif 見せて」「メタデータ全部出して」 / "show all exif"
- 「GPS だけ抽出して」 / "just the GPS"
- 「Make / Model だけ」 / "what camera shot this"
- 「ディレクトリ全体の DateTimeOriginal を一覧」 / "list capture dates"

## Pre-flight checks
1. Reading is read-only; no backup or confirmation needed.
2. For batch reads, decide the output shape early (terminal-readable
   table vs. JSON for downstream parsing). See
   `references/tasks/formats.md` for export forms.

## Common patterns

### Pattern: Show all metadata for one file
**Input**: 「このファイルのメタデータ全部見せて」 / "what's in photo.jpg"
**Command**:
```sh
exiftool photo.jpg
```
**Why**: default output groups tags by family with human-readable values.
For large outputs add `-G` to prefix every tag with its group, which
makes the source family unambiguous (`[EXIF]` vs `[XMP]` vs
`[Composite]`):
```sh
exiftool -G photo.jpg
```

### Pattern: Show specific tags only
**Input**: 「GPS と DateTimeOriginal だけ」 / "just GPS and capture date"
**Command**:
```sh
exiftool -GPSPosition -DateTimeOriginal photo.jpg
```
**Why**: tag flags filter the output. Use the cheatsheet
(`references/tag-cheatsheet.md`) to pick the right tag name. For
machine consumption prefer the underlying writable tags:
```sh
exiftool -GPSLatitude -GPSLongitude -DateTimeOriginal photo.jpg
```

### Pattern: Show all tags in a group
**Input**: 「EXIF だけ全部」 / "all EXIF tags"
**Command**:
```sh
exiftool -EXIF:all photo.jpg
# Other groups:
exiftool -XMP:all photo.jpg
exiftool -GPS:all photo.jpg
exiftool -Composite:all photo.jpg
```
**Why**: `<Group>:all` prints every tag in that family. Useful for
confirming what would be touched by a `<Group>:all=` deletion.

### Pattern: Short forms for compact output
**Input**: 「短く」 / "compact output"
**Command**:
```sh
exiftool -s photo.jpg     # tag names instead of descriptions
exiftool -s2 photo.jpg    # short form, single column
exiftool -s3 photo.jpg    # values only, no tag names
```
**Why**: `-s3` is ideal for piping a single value into another command:
```sh
DATE=$(exiftool -s3 -DateTimeOriginal photo.jpg)
```

### Pattern: Batch read across a directory
**Input**: 「フォルダ全部の撮影日を一覧」 / "list all capture dates in DIR"
**Command**:
```sh
exiftool -r -ext jpg -ext heic -DateTimeOriginal -FileName ./photos
```
**Why**: `-r` recurses; `-ext` (repeatable) restricts to specific
extensions (case-insensitive). Without `-ext`, exiftool processes every
file it can read. For just the count of photos with a given tag:
```sh
exiftool -if '$DateTimeOriginal' -p '$FileName' -r ./photos | wc -l
```

### Pattern: Conditional filtering with `-if`
**Input**: 「GPS が入ってるやつだけ」 / "only files that have GPS"
**Command**:
```sh
exiftool -if '$gpslatitude' -p '$FileName' -r ./photos
```
**Why**: `-if` evaluates a Perl expression against each file's tag
values. `$gpslatitude` is truthy when present. Combine for stricter
filters: `-if '$gpslatitude and $make eq "Apple"'`.

### Pattern: Export as JSON for downstream parsing
**Input**: 「JSON で取って後で処理したい」 / "give me JSON"
**Command**:
```sh
exiftool -j -G photo.jpg
exiftool -j -G -DateTimeOriginal -GPSLatitude -GPSLongitude -r ./photos
```
**Why**: `-j` produces a JSON array (one object per file). `-G` adds
group prefixes to every key (e.g., `EXIF:DateTimeOriginal`), which
disambiguates same-named tags from different groups. See
`references/tasks/formats.md` for CSV and other shapes.

## Pitfalls

- **Empty output for an expected tag**: the file may not contain it.
  Check the group: `exiftool -G photo.jpg | grep -i <name>`.
- **Wildcard non-recursion**: `exiftool ./photos/*.jpg` skips
  subdirectories. Use `-r -ext jpg ./photos`. (Pitfall P-008.)
- **JSON values are strings by default**: numeric tags (ISO, FNumber)
  appear as strings. Add `-n` to disable PrintConv for raw numeric
  values when feeding scripts.

## See also

- `references/tasks/formats.md` for full JSON/CSV/structured export.
- `references/tag-cheatsheet.md` for choosing tag names.
- `references/upstream/cli-options.md` (Phase 2) for the full option list.
```

- [ ] **Step 2: Verify**

Run: `grep -c "^### Pattern:" skills/exiftool/references/tasks/reading.md`
Expected: `7`

- [ ] **Step 3: Commit**

```bash
git add skills/exiftool/references/tasks/reading.md
git commit -m "$(cat <<'EOF'
feat(skill): references/tasks/reading.md

Patterns: show all, show specific, group-all, short forms, batch
recursion, -if filter, JSON export. Pre-flight notes that reads
require no safety gate. Pitfalls cover empty output, glob
non-recursion (P-008), JSON value typing.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 13: `references/tasks/gps.md` (full reference example)

**Files:**
- Create: `skills/exiftool/references/tasks/gps.md`

This task's content is taken verbatim from spec §13.1 (Appendix), which is
the density target for all task files.

- [ ] **Step 1: Write the file**

```markdown
# GPS / Geolocation

This file covers reading, writing, deleting, and converting GPS coordinates
in image and video files using exiftool.

## When this applies
Read this file when the user says things like:
- 「GPS 消して」「ジオタグ削除」/ "strip GPS", "remove location"
- 「この写真どこで撮った？」/ "where was this taken"
- 「GPX から座標つけて」/ "geotag from GPX"
- 「この座標を入れて」/ "set GPS to lat,lon"

## Pre-flight checks
1. **Writing or deleting?** Read `references/safety.md` first.
2. **Batch operation?** Run a count first:
   `exiftool -if '$gpslatitude' -p '$filename' -r DIR | wc -l`
3. **Backup behavior**: by default exiftool creates `<file>_original`.
   Confirm with the user whether to keep or use `-overwrite_original`.

## Common patterns

### Pattern: Show GPS coordinates
**Input**: 「この写真の GPS 教えて」 / "where was photo.jpg taken"
**Command**:
```sh
exiftool -GPSPosition -GPSAltitude photo.jpg
# Or for parsing:
exiftool -j -GPSLatitude -GPSLongitude photo.jpg
```
**Why**: `Composite:GPSPosition` is a derived (read-only) tag combining
lat/lon/refs into a human-friendly string. For programmatic use, prefer
the raw `EXIF:GPSLatitude` / `GPSLongitude`.

### Pattern: Strip GPS from one or many files
**Input**: 「GPS 消して」 / "remove all location data before posting"
**Command (single file, dry-run first recommended)**:
```sh
# Confirm what will be removed:
exiftool -gps:all photo.jpg
# Then remove:
exiftool -gps:all= photo.jpg
```
**Command (batch)**:
```sh
# 1) Count first:
exiftool -if '$gpslatitude' -p '$filename' -r ./photos | wc -l
# 2) Strip:
exiftool -gps:all= -r ./photos
```
**Why**: `-gps:all=` deletes the entire GPS group in EXIF and XMP at once,
which is what users typically mean by "remove GPS". Setting individual tags
can leave residue (e.g., `GPSAltitude` lingering).

### Pattern: Set GPS coordinates manually
**Input**: 「この写真に東京駅の座標入れて」 / "geotag photo.jpg to 35.6812, 139.7671"
**Command**:
```sh
exiftool \
  -GPSLatitude=35.6812 -GPSLatitudeRef=N \
  -GPSLongitude=139.7671 -GPSLongitudeRef=E \
  photo.jpg
```
**Why**: GPS in EXIF is stored as positive magnitude + N/S/E/W ref.
Forgetting `Ref` results in coordinates being interpreted as the wrong
hemisphere — a common silent failure. (Pitfall P-002.)

### Pattern: Geotag from a GPX track
**Input**: 「track.gpx に合わせて全部 geotag して」
**Command**:
```sh
exiftool -geotag track.gpx -r ./photos
# If photo time is offset from GPX time:
exiftool -geotag track.gpx -geosync=+1:00:00 -r ./photos
```
**Why**: exiftool matches by `DateTimeOriginal`. If the camera clock is off,
use `-geosync` to apply an offset.

## Pitfalls
- **`Composite:GPSPosition` is read-only.** Writing to it silently fails.
  Use `EXIF:GPSLatitude` / `EXIF:GPSLongitude` (with `Ref` tags). (P-001)
- **Forgetting `Ref` tags.** Without `GPSLatitudeRef=N`, southern hemisphere
  coordinates flip sign in some viewers. (P-002)
- **HEIC files**: GPS may live in `XMP:GPSLatitude` instead of `EXIF`. When
  in doubt, read both groups: `exiftool -GPS:all -XMP:GPS:all file.heic`. (P-006)
- **Video GPS** (GoPro/DJI): see `references/tasks/video.md` — different
  storage location.

## See also
- `references/safety.md` — backup behavior, batch confirmation
- `references/upstream/geotag.md` — full geotag option reference (Phase 2)
- `references/tag-cheatsheet.md` — GPS tag families across EXIF/XMP/Composite
- `references/tasks/video.md` — GPS in video files
```

- [ ] **Step 2: Verify**

Run: `grep -c "^### Pattern:" skills/exiftool/references/tasks/gps.md`
Expected: `4`

Run: `grep -c "P-00" skills/exiftool/references/tasks/gps.md`
Expected: at least `3` (links to P-001, P-002, P-006)

- [ ] **Step 3: Commit**

```bash
git add skills/exiftool/references/tasks/gps.md
git commit -m "$(cat <<'EOF'
feat(skill): references/tasks/gps.md

Density-target reference (per spec §13.1) for all task files.
Patterns: show GPS, strip (single + batch), set manually, geotag from
GPX. Pitfalls cross-link safety.md P-001 (Composite write), P-002
(Ref omission), P-006 (HEIC XMP-GPS).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 14: `references/tasks/datetime.md`

**Files:**
- Create: `skills/exiftool/references/tasks/datetime.md`

- [ ] **Step 1: Write the file**

```markdown
# Date and time correction

This file covers viewing capture dates, shifting timestamps in bulk,
restoring dates from filenames, and timezone correction.

## When this applies
Read this file when the user says things like:
- 「撮影日時直して」「全部 2 時間ずらして」 / "shift all dates by +2h"
- 「カメラの時計が UTC のままだった」 / "camera clock was on UTC"
- 「ファイル名から DateTimeOriginal を入れて」 / "set capture date from filename"
- 「TZ オフセット入ってない」 / "no offset time stored"

## Pre-flight checks
1. Date writes are destructive. Read `references/safety.md`.
2. Confirm which tag the user means: `DateTimeOriginal` (EXIF capture
   moment), `CreateDate` (often equal), `FileModifyDate` (filesystem
   mtime — usually NOT what users want; pitfall P-003).
3. For batch shifts, count first:
   `exiftool -if '$DateTimeOriginal' -p '$FileName' -r DIR | wc -l`.

## Common patterns

### Pattern: Show capture dates
**Input**: 「この写真いつ撮った？」 / "when was this taken"
**Command**:
```sh
exiftool -DateTimeOriginal -CreateDate -OffsetTimeOriginal photo.jpg
# For directory:
exiftool -DateTimeOriginal -r ./photos
```
**Why**: `DateTimeOriginal` is the canonical capture moment. Showing
`OffsetTimeOriginal` alongside reveals whether the camera recorded TZ
context (many older cameras do not).

### Pattern: Shift all dates by an offset
**Input**: 「全部 2 時間進めて」 / "add 2 hours to all dates"
**Command**:
```sh
# Single file:
exiftool -AllDates+="0:0:0 2:0:0" photo.jpg
# Batch:
exiftool -AllDates+="0:0:0 2:0:0" -r ./photos
# Subtract:
exiftool -AllDates-="0:0:0 2:0:0" -r ./photos
# Days, hours, minutes, seconds:
exiftool -AllDates+="0:0:0 0:30:0" photo.jpg   # +30 minutes
exiftool -AllDates+="0:0:1 0:0:0" photo.jpg    # +1 day
```
**Why**: `-AllDates` is a shortcut for `DateTimeOriginal`, `CreateDate`,
`ModifyDate` simultaneously. Format is
`Y:M:D h:m:s`. **Note**: this does NOT include `FileModifyDate`,
`GPSDateTime`, or `QuickTime:CreateDate` (P-004).

### Pattern: Restore date from filename
**Input**: 「ファイル名 IMG_20240315_103022.jpg から撮影日入れて」 /
"recover DateTimeOriginal from filename"
**Command**:
```sh
exiftool '-DateTimeOriginal<filename' photo.jpg
# Verify what would be set first (dry-run via no-op test):
exiftool -p '$filename -> $DateTimeOriginal' '-DateTimeOriginal<filename' photo.jpg
```
**Why**: `<` reads the value from another tag. exiftool tries to match
common date patterns inside `$filename`. For unusual patterns, use a
custom format string per the upstream filename docs (Phase 2).

### Pattern: Apply or fix timezone offset
**Input**: 「写真は日本で撮ったのに TZ が UTC になってる」 /
"set OffsetTimeOriginal to +09:00"
**Command**:
```sh
# Set the offset annotation (does NOT shift dates):
exiftool -OffsetTimeOriginal=+09:00 -OffsetTime=+09:00 \
        -OffsetTimeDigitized=+09:00 photo.jpg
# To both shift dates by 9 hours AND record the offset:
exiftool -AllDates+="0:0:0 9:0:0" \
        -OffsetTimeOriginal=+09:00 -OffsetTime=+09:00 \
        -OffsetTimeDigitized=+09:00 photo.jpg
```
**Why**: `OffsetTime*` tags are EXIF 2.31+ TZ annotations. They do not
re-interpret existing wall-clock dates; they label them. For video,
`QuickTime:CreateDate` is UTC by spec (P-005) — handle separately.

### Pattern: Conditional shift (only files matching a criterion)
**Input**: 「Apple iPhone のやつだけ +9h して」
**Command**:
```sh
exiftool -if '$Make eq "Apple"' \
        -AllDates+="0:0:0 9:0:0" \
        -r ./photos
```
**Why**: `-if` filters before applying the write. The Plan step in the
three-step rule should run the same `-if` with `-p '$FileName' | wc -l`
first to display the count.

## Pitfalls

- **`-AllDates` is not "every date".** Filesystem mtime, GPSDateTime,
  and QuickTime atoms are not included (P-004). Enumerate explicitly
  when needed.
- **`-FileModifyDate` is filesystem-only** (P-003). The user almost
  always means `DateTimeOriginal`.
- **Video dates are UTC** (`QuickTime:CreateDate`, P-005). Shifting the
  same way as image dates can introduce a double-offset.
- **Date format gotcha**: the offset string is `Y:M:D h:m:s`, not
  `D:H:M:S`. `0:0:0 25:0:0` is valid (25 hours = +1d 1h).

## See also
- `references/safety.md` (especially P-003, P-004, P-005)
- `references/tasks/video.md` for QuickTime date handling
- `references/upstream/cli-options.md` (Phase 2) for `-tagsFromFile` and
  date-format extras
```

- [ ] **Step 2: Verify**

Run: `grep -c "^### Pattern:" skills/exiftool/references/tasks/datetime.md`
Expected: `5`

- [ ] **Step 3: Commit**

```bash
git add skills/exiftool/references/tasks/datetime.md
git commit -m "$(cat <<'EOF'
feat(skill): references/tasks/datetime.md

Patterns: show dates, bulk shift via -AllDates+=, restore from
filename, apply TZ offset (annotate vs. shift+annotate),
conditional shift via -if. Pitfalls cross-link P-003 (FileModifyDate
confusion), P-004 (AllDates scope), P-005 (QuickTime UTC).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 15: `references/tasks/copying.md`

**Files:**
- Create: `skills/exiftool/references/tasks/copying.md`

- [ ] **Step 1: Write the file**

```markdown
# Tag copying and sidecar XMP

This file covers copying metadata between files (image-to-image,
image-to-XMP, XMP-to-image), selective tag copies, and bulk sidecar
application.

## When this applies
Read this file when the user says things like:
- 「a.jpg のメタデータを b.jpg にコピー」 / "copy exif from a to b"
- 「現像した tiff に元 raw の Exif つけたい」 / "preserve raw exif in the converted tiff"
- 「XMP サイドカーから一括適用」 / "apply XMP sidecars to images"
- 「画像の exif を XMP として書き出して」 / "extract exif as sidecar"

## Pre-flight checks
1. Tag copies are writes. Read `references/safety.md`.
2. By default, only writable tags are copied (Composite, etc., are
   skipped automatically).
3. For batch sidecar application, confirm the naming convention
   (`photo.jpg` ↔ `photo.xmp` vs `photo.jpg.xmp`).

## Common patterns

### Pattern: Copy all metadata between two files
**Input**: 「a.jpg のメタデータを b.jpg にコピー」 / "copy a.jpg metadata to b.jpg"
**Command**:
```sh
exiftool -tagsFromFile a.jpg b.jpg
```
**Why**: `-tagsFromFile <source>` reads from the source and writes the
named tags (default: all writable tags) to the file(s) listed
afterwards. The destination file is modified in place; an `_original`
backup is created.

### Pattern: Copy a subset (e.g., only GPS or only EXIF)
**Input**: 「GPS だけコピー」 / "copy only GPS from a.jpg to b.jpg"
**Command**:
```sh
exiftool -tagsFromFile a.jpg -gps:all b.jpg
# Multiple selections (additive):
exiftool -tagsFromFile a.jpg -gps:all -DateTimeOriginal -Make -Model b.jpg
# Whole group:
exiftool -tagsFromFile a.jpg -EXIF:all b.jpg
```
**Why**: tag flags after `-tagsFromFile` restrict what is copied. Use
group:all for a clean sweep of one family.

### Pattern: Apply sidecar XMP to an image
**Input**: 「photo.xmp の内容を photo.jpg に適用」 / "apply photo.xmp to photo.jpg"
**Command**:
```sh
exiftool -tagsFromFile photo.xmp -all:all photo.jpg
```
**Why**: `-all:all` after `-tagsFromFile` from an XMP source pulls every
tag the sidecar contains into the image. For only structured XMP fields:
`-XMP:all` instead of `-all:all`.

### Pattern: Bulk sidecar application across a directory
**Input**: 「photos/ の各 .jpg に同名 .xmp を当てて」 / "apply each XMP sidecar to its image"
**Command**:
```sh
exiftool -tagsFromFile %d%f.xmp -all:all -ext jpg ./photos
```
**Why**: `%d` = directory of the destination, `%f` = base filename. So
for `./photos/IMG_001.jpg`, exiftool reads `./photos/IMG_001.xmp`. Add
`-r` for recursion.

### Pattern: Extract image metadata as a sidecar
**Input**: 「photo.jpg の exif を photo.xmp として書き出して」 /
"export photo.jpg metadata as XMP sidecar"
**Command**:
```sh
exiftool -o photo.xmp photo.jpg
# Or for batch:
exiftool -o %d%f.xmp -r -ext jpg ./photos
```
**Why**: `-o <output>` writes a new file rather than modifying the
source. When the output ends in `.xmp`, exiftool produces a valid
XMP sidecar containing the source's metadata.

### Pattern: Copy from a different tag (rename a tag)
**Input**: 「IPTC:Caption-Abstract を XMP-dc:Description にコピー」
**Command**:
```sh
exiftool '-XMP-dc:Description<IPTC:Caption-Abstract' photo.jpg
```
**Why**: `<` copies one tag's value into another. This is the
fundamental mechanism behind `-FileName<DateTimeOriginal` (renaming) and
similar tag-to-tag rewrites.

## Pitfalls

- **`-tagsFromFile` and the source argument**: the tag flags after
  `-tagsFromFile <source>` apply to that source until the next
  `-tagsFromFile` or until the end of options. Order matters.
- **Naming-convention mismatch for sidecars**: `photo.xmp` vs.
  `photo.jpg.xmp` are both used in the wild. The `%d%f.xmp` recipe
  assumes the former.
- **Composite tags are skipped silently** when copying — that is correct
  behavior but can confuse users who expect `Composite:GPSPosition` to
  carry over. The underlying writable tags (`GPSLatitude` etc.) do
  copy; the composite re-derives in the destination.
- **XMP sidecars created via `-o` overwrite if existing**. Confirm
  before running on a tree where sidecars may already be present.

## See also
- `references/safety.md`
- `references/upstream/metafiles.md` (Phase 2) for sidecar formats and
  related tags
- `references/tag-cheatsheet.md` for picking selective tags
```

- [ ] **Step 2: Verify**

Run: `grep -c "^### Pattern:" skills/exiftool/references/tasks/copying.md`
Expected: `6`

- [ ] **Step 3: Commit**

```bash
git add skills/exiftool/references/tasks/copying.md
git commit -m "$(cat <<'EOF'
feat(skill): references/tasks/copying.md

Patterns: -tagsFromFile (all + selective), sidecar XMP apply (single
+ bulk via %d%f.xmp), extract image as XMP sidecar via -o, tag-to-tag
copy via <. Pitfalls cover tag-flag scoping, naming conventions,
Composite skip, sidecar overwrite.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 16: `references/tasks/renaming.md`

**Files:**
- Create: `skills/exiftool/references/tasks/renaming.md`

- [ ] **Step 1: Write the file**

```markdown
# Renaming and folder organization

This file covers renaming files based on metadata (typically capture
date), reorganizing into date-based folder hierarchies, and previewing
renames safely before committing.

## When this applies
Read this file when the user says things like:
- 「撮影日でリネーム」 / "rename by capture date"
- 「YYYY/MM/DD/ のフォルダに分けて」 / "organize into year/month/day folders"
- 「ファイル名衝突したらどうなる？」 / "what about duplicate filenames"
- 「実際に動かす前に名前確認したい」 / "preview before running"

## Pre-flight checks
1. Rename is a write to `FileName` and `Directory` (filesystem ops, not
   metadata). Read `references/safety.md`.
2. **Always preview with `-TestName` before `-FileName` on bulk runs.**
3. By default, exiftool refuses to overwrite an existing file. Use
   collision-counter formats (`%%-c`) or `-overwrite_original` only with
   explicit confirmation.

## Common patterns

### Pattern: Rename one file by capture date
**Input**: 「photo.jpg を撮影日で rename」 / "rename photo.jpg by date"
**Command**:
```sh
exiftool '-FileName<DateTimeOriginal' \
         -d '%Y%m%d_%H%M%S.%%le' photo.jpg
```
**Why**: `<` reads the value from a tag (`DateTimeOriginal`), `-d`
applies a date format, `%%le` lowercases the original extension (P-009).
Result: `photo.jpg` → `20240315_103022.jpg`.

### Pattern: Preview a bulk rename without renaming
**Input**: 「実際に動かす前に確認」 / "show me what would happen first"
**Command**:
```sh
exiftool '-TestName<DateTimeOriginal' \
         -d '%Y%m%d_%H%M%S.%%le' \
         -r -ext jpg -ext heic ./photos
```
**Why**: `-TestName` produces the proposed `Old → New` mapping without
touching the filesystem. This is the dry-run idiom for renames.
`scripts/dry-rename.sh` wraps this pattern.

### Pattern: Bulk rename by capture date
**Input**: 「全部 撮影日で rename」 / "rename all by capture date"
**Command**:
```sh
# 1) Preview first:
exiftool '-TestName<DateTimeOriginal' \
         -d '%Y%m%d_%H%M%S.%%le' \
         -r -ext jpg -ext heic ./photos
# 2) Apply:
exiftool '-FileName<DateTimeOriginal' \
         -d '%Y%m%d_%H%M%S.%%le' \
         -r -ext jpg -ext heic ./photos
```
**Why**: matching the preview command except for `TestName` vs
`FileName` keeps the two commands obviously identical except for the
single safe/destructive switch.

### Pattern: Organize into date-based folders
**Input**: 「YYYY/MM/DD/ にフォルダ分けして」 / "split into year/month/day folders"
**Command**:
```sh
# Preview:
exiftool '-TestName<DateTimeOriginal' \
         -d '%Y/%m/%d/%Y%m%d_%H%M%S.%%le' \
         -r -ext jpg ./photos
# Apply:
exiftool '-FileName<DateTimeOriginal' \
         -d '%Y/%m/%d/%Y%m%d_%H%M%S.%%le' \
         -r -ext jpg ./photos
```
**Why**: forward slashes in `-d` create subdirectories. The same
expression handles both filename and folder placement at once. exiftool
creates intermediate directories as needed.

### Pattern: Handle filename collisions
**Input**: 「同じ秒に撮ったやつがある」 / "two shots in the same second"
**Command**:
```sh
exiftool '-FileName<DateTimeOriginal' \
         -d '%Y%m%d_%H%M%S%%-c.%%le' \
         -r -ext jpg ./photos
```
**Why**: `%%-c` is a copy-counter that exiftool inserts only when needed
to avoid collision, formatted as `_1`, `_2`, ... (the `-` makes the
underscore-separator explicit). Without a counter, exiftool refuses
the second write.

### Pattern: Use a tag other than capture date
**Input**: 「Make_Model_DateTime みたいな名前にしたい」
**Command**:
```sh
exiftool '-FileName<${Make}_${Model}_${DateTimeOriginal}.%le' \
         -d '%Y%m%d-%H%M%S' \
         -r -ext jpg ./photos
```
**Why**: `${Tag}` interpolation lets you compose arbitrary names. Note
the `.%le` here uses single `%` because it is outside a `-d` format
string interpreted by exiftool (the rule: `%%le` inside `-d`, `%le`
outside).

## Pitfalls

- **Forgetting `-TestName` first**. Bulk renames without preview can
  reorganize hundreds of files in ways the user did not intend.
- **Extension case** (P-009): `%%le` lowercases, `%%e` preserves source
  case.
- **Files without `DateTimeOriginal`** are skipped by `<DateTimeOriginal`
  rules — confirm coverage before assuming all files were renamed:
  `exiftool -if 'not $DateTimeOriginal' -p '$FileName' -r ./photos | wc -l`.
- **Cross-filesystem moves**: `-FileName<...` with a path component will
  attempt to move across filesystems. exiftool handles this but the
  operation is no longer atomic (a copy + delete). For very large trees,
  prefer organizing within the same volume.

## See also
- `references/safety.md`
- `references/upstream/filename.md` (Phase 2) for full `-d` format spec
- `skills/exiftool/scripts/dry-rename.sh` for the preview wrapper
```

- [ ] **Step 2: Verify**

Run: `grep -c "^### Pattern:" skills/exiftool/references/tasks/renaming.md`
Expected: `6`

- [ ] **Step 3: Commit**

```bash
git add skills/exiftool/references/tasks/renaming.md
git commit -m "$(cat <<'EOF'
feat(skill): references/tasks/renaming.md

Patterns: rename one file, preview via -TestName, bulk rename, folder
hierarchy, collision counter %%-c, custom tag composition. Pitfalls
cover skipping preview, extension case (P-009), missing
DateTimeOriginal, cross-filesystem moves.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 17: `references/tasks/formats.md`

**Files:**
- Create: `skills/exiftool/references/tasks/formats.md`

- [ ] **Step 1: Write the file**

```markdown
# Output formats: JSON, CSV, structured

This file covers producing parseable output for downstream tools (jq,
csvkit, spreadsheets, scripts).

## When this applies
Read this file when the user says things like:
- 「JSON で出して」 / "give me JSON"
- 「CSV にして spreadsheet で開きたい」 / "csv for excel/numbers"
- 「Make / Model / LensModel の表」 / "table of camera info"
- 「pipe して jq で処理」 / "pipe to jq"

## Pre-flight checks
1. Output formatting is read-only.
2. Decide upfront whether the consumer needs raw numeric values
   (`-n`) or human-readable strings (default `PrintConv`).

## Common patterns

### Pattern: JSON output
**Input**: 「JSON で出して」 / "json please"
**Command**:
```sh
exiftool -j photo.jpg                              # one file → JSON array of one
exiftool -j -G photo.jpg                           # group prefix on every key
exiftool -j -GPSLatitude -GPSLongitude photo.jpg   # subset
exiftool -j -G -r ./photos                         # batch
```
**Why**: `-j` produces a JSON array. `-G` adds group prefixes
(`EXIF:Make` instead of `Make`), which is essential when batching
across files where same-named tags from different groups would collide.

### Pattern: JSON with raw numeric values
**Input**: 「ISO とか数値で取りたい」 / "I need ISO as a number for sorting"
**Command**:
```sh
exiftool -j -n -ISO -FNumber -ExposureTime photo.jpg
```
**Why**: `-n` disables PrintConv, returning raw numeric/binary values
instead of formatted strings. Required when piping to numeric
processors. Example: without `-n`, `ISO` may be `100` (string);
`ExposureTime` may be `1/200` (string). With `-n`: `100` (numeric),
`0.005` (numeric).

### Pattern: CSV output
**Input**: 「CSV で」 / "csv please"
**Command**:
```sh
exiftool -csv photo.jpg                            # single file
exiftool -csv -r ./photos                          # batch (all tags, can be huge)
exiftool -csv -Make -Model -LensModel -DateTimeOriginal -r ./photos > out.csv
```
**Why**: `-csv` produces RFC-4180-style CSV with a header row containing
SourceFile + tag names. **Always restrict tags** when batching across
many files to keep the column count manageable.

### Pattern: Short forms for compact output
**Input**: 「短く」 / "compact"
**Command**:
```sh
exiftool -s photo.jpg     # tag names instead of long descriptions
exiftool -s2 photo.jpg    # tag names, single-column
exiftool -s3 photo.jpg    # values only, no tag names
```
**Why**: `-s3` is the right tool for grabbing one value into a shell
variable:
```sh
LAT=$(exiftool -s3 -GPSLatitude photo.jpg)
```

### Pattern: Structured XMP / nested tags
**Input**: 「XMP の構造そのまま JSON で」 / "preserve XMP structure"
**Command**:
```sh
exiftool -j -struct -XMP:all photo.jpg
```
**Why**: `-struct` preserves the structured form of XMP nested fields
(arrays, structs) instead of flattening them into separate keys with
indices.

### Pattern: Pipeline to jq for filtering
**Input**: 「Apple の写真だけ撮影日と GPS を JSON で」
**Command**:
```sh
exiftool -j -G -if '$Make eq "Apple"' \
         -DateTimeOriginal -GPSLatitude -GPSLongitude \
         -r ./photos | jq '.[] | {file: .SourceFile, date: ."EXIF:DateTimeOriginal"}'
```
**Why**: combining `-if` for filtering, `-j -G` for unambiguous JSON,
and `jq` for projection produces a clean pipeline. Note quoting:
the EXIF group prefix in jq must use `."EXIF:DateTimeOriginal"`.

### Pattern: Custom format string
**Input**: 「自分で format 指定」 / "custom output format"
**Command**:
```sh
exiftool -p '$FileName  $DateTimeOriginal  $GPSPosition' -r ./photos
# Or via a .fmt file (multi-line):
exiftool -p format.fmt -r ./photos
```
**Why**: `-p '<template>'` renders each file using the template, with
`$Tag` interpolation. For multi-line or complex templates, use a `.fmt`
file (see `references/upstream/cli-options.md` in Phase 2).

## Pitfalls

- **CSV header explosion**: `-csv -r DIR` without tag restriction can
  produce thousands of columns. Always specify tags.
- **JSON values are strings without `-n`**: `"ISO":"100"` not
  `"ISO":100`. Add `-n` for numeric consumers.
- **Quoting `$` in shells**: in `-p '$Tag'`, single quotes prevent
  shell expansion. With double quotes, escape as `\$Tag`.
- **`-csv` and missing tags**: rows with absent tags get empty cells,
  which jq/csvkit usually handle. Some downstream tools don't — confirm
  with the consumer.

## See also
- `references/tasks/reading.md` for the basics
- `references/upstream/cli-options.md` (Phase 2) for `-p` and `-fmt`
- `references/tag-cheatsheet.md` for picking subsets
```

- [ ] **Step 2: Verify**

Run: `grep -c "^### Pattern:" skills/exiftool/references/tasks/formats.md`
Expected: `7`

- [ ] **Step 3: Commit**

```bash
git add skills/exiftool/references/tasks/formats.md
git commit -m "$(cat <<'EOF'
feat(skill): references/tasks/formats.md

Patterns: JSON (default + -n), CSV, short forms -s/-s2/-s3, -struct
for XMP, jq pipeline, custom -p template. Pitfalls cover CSV column
explosion, JSON string typing, shell quoting, missing-tag rows.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 18: `references/tasks/video.md`

**Files:**
- Create: `skills/exiftool/references/tasks/video.md`

- [ ] **Step 1: Write the file**

```markdown
# Video metadata: GoPro, DJI, generic QuickTime

This file covers reading and editing metadata in MP4 / MOV / 360 video
containers, extracting embedded GPS tracks (GoPro), reading DJI sidecar
SRT files, and the QuickTime UTC convention.

## When this applies
Read this file when the user says things like:
- 「GoPro の GPS を GPX で出して」 / "extract GoPro GPS as GPX"
- 「動画の撮影日変えたい」 / "fix video capture date"
- 「DJI の SRT に GPS 入ってる」 / "DJI flight log"
- 「mov の Exif 見せて」 / "show video metadata"

## Pre-flight checks
1. Read-only operations: no safety gate.
2. Write operations on video: read `references/safety.md`. Note
   `QuickTime:CreateDate` is UTC by spec (P-005).
3. For GoPro embedded GPS streams, decide the output format up front
   (GPX, KML, JSON, raw `$GPS5` records).

## Common patterns

### Pattern: Show video metadata
**Input**: 「video.mp4 のメタデータ見せて」 / "what's in video.mp4"
**Command**:
```sh
exiftool video.mp4
# Group prefixes (clarifies QuickTime vs. EXIF vs. embedded streams):
exiftool -G video.mp4
# Just the dates:
exiftool -QuickTime:CreateDate -QuickTime:ModifyDate \
         -DateTimeOriginal video.mp4
```
**Why**: same `exiftool <file>` works for video; the displayed groups
will include `QuickTime`, `Track1`, `Audio`, `Video`, etc.
`QuickTime:CreateDate` is the spec-mandated container creation time
(UTC).

### Pattern: Shift video capture date
**Input**: 「動画の日時 9 時間ずらして」 / "shift video dates by +9h"
**Command**:
```sh
# QuickTime fields (UTC):
exiftool -QuickTime:CreateDate+="0:0:0 9:0:0" \
         -QuickTime:ModifyDate+="0:0:0 9:0:0" \
         video.mp4
# If the user also wants EXIF dates (some cameras embed both):
exiftool -AllDates+="0:0:0 9:0:0" \
         -QuickTime:CreateDate+="0:0:0 9:0:0" \
         -QuickTime:ModifyDate+="0:0:0 9:0:0" \
         video.mp4
```
**Why**: `-AllDates` covers the EXIF triplet but **not** QuickTime atoms
(P-004). The QuickTime fields must be enumerated explicitly. Treat the
QuickTime values as UTC (P-005) — confirm with the user whether they
want the wall-clock or the UTC value shifted.

### Pattern: Extract embedded GoPro GPS as GPX
**Input**: 「GoPro の GPS を GPX で出して」 / "extract GoPro GPS as GPX"
**Command**:
```sh
exiftool -ee -p ${HOME}/.config/exiftool/fmt/gpx.fmt gopro.mp4 > track.gpx
# Or, if no .fmt file is set up, point to one in vendor/exiftool:
exiftool -ee -p vendor/exiftool/fmt_files/gpx.fmt gopro.mp4 > track.gpx
```
**Why**: `-ee` enables ExtractEmbedded mode, which surfaces the per-
frame GPS samples GoPro stores in a private MP4 stream
(`Track:GPSLatitude`, `Track:GPSLongitude`, `Track:GPSDateTime`). The
`gpx.fmt` template (shipped under `vendor/exiftool/fmt_files/`)
formats them into a valid GPX 1.1 document.

The `scripts/extract-gpx.sh` helper wraps this pattern.

### Pattern: Read DJI SRT sidecar GPS
**Input**: 「DJI の SRT 読んで GPS 出して」 / "DJI flight log GPS"
**Command**:
```sh
exiftool drone.SRT
# Or batch:
exiftool -GPSLatitude -GPSLongitude -GPSAltitude -r ./flight
```
**Why**: DJI drones write a `.SRT` subtitle file alongside the video
that contains telemetry (GPS, altitude, gimbal, IMU). exiftool parses
SRT files natively and exposes the per-frame GPS fields as standard
GPS tags.

### Pattern: Set GPS on a whole video clip
**Input**: 「動画にこの座標入れて」 / "geotag this video"
**Command**:
```sh
exiftool \
  -QuickTime:GPSCoordinates="35.6812,139.7671,40" \
  video.mp4
# Some clients prefer EXIF/XMP-style tags inside MP4:
exiftool \
  -GPSLatitude=35.6812 -GPSLatitudeRef=N \
  -GPSLongitude=139.7671 -GPSLongitudeRef=E \
  video.mp4
```
**Why**: `QuickTime:GPSCoordinates` is the ISO 6709 single-string form
(`lat,lon,alt`) recognized by Photos.app and many media players. The
EXIF-style tags are recognized by some players but not all; test with
the consumer app.

### Pattern: Strip metadata from a video before sharing
**Input**: 「動画から個人情報全部消して」 / "sanitize video"
**Command**:
```sh
exiftool -all= video.mp4
# Confirm what would remain readable:
exiftool video.mp4
```
**Why**: `-all=` removes every writable tag across all groups. Some
video metadata lives in non-writable container fields (codec,
duration) which exiftool cannot remove — those are not personally
identifying.

## Pitfalls

- **`QuickTime:CreateDate` is UTC** (P-005). Treating it as wall-clock
  introduces a timezone-sized error.
- **`-AllDates` does not cover QuickTime** (P-004). Enumerate the
  QuickTime fields explicitly when shifting video dates.
- **GoPro `-ee` output volume**: a 30-minute clip can produce thousands
  of GPS samples. For visualization/plotting, downsample or filter.
- **DJI `.SRT` files are sometimes regenerated by the DJI app on
  import**, which can desync them from the original `.MP4`. Confirm
  filename pairing before processing.
- **Video write support is sparser than image write support**. Some
  tags read fine but cannot be modified. Test on a single file before
  batching.

## See also
- `references/safety.md` (P-004, P-005)
- `references/tasks/gps.md` for the read/write patterns shared with
  images
- `references/tasks/datetime.md` for the date offset notation
- `references/upstream/tag-names/quicktime.md` (Phase 2)
- `skills/exiftool/scripts/extract-gpx.sh`
```

- [ ] **Step 2: Verify**

Run: `grep -c "^### Pattern:" skills/exiftool/references/tasks/video.md`
Expected: `6`

- [ ] **Step 3: Commit**

```bash
git add skills/exiftool/references/tasks/video.md
git commit -m "$(cat <<'EOF'
feat(skill): references/tasks/video.md

Patterns: show video metadata, shift video dates (with explicit
QuickTime fields), extract GoPro embedded GPS via -ee + gpx.fmt,
DJI SRT GPS read, set GPS on whole clip, sanitize. Pitfalls cover
QuickTime UTC (P-005), -AllDates not covering QuickTime (P-004),
GoPro sample volume, DJI SRT pairing, sparser video write support.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 19: `references/tasks/sanitize.md`

**Files:**
- Create: `skills/exiftool/references/tasks/sanitize.md`

- [ ] **Step 1: Write the file**

```markdown
# Sanitize: strip private metadata before sharing

This file covers removing personally identifying information (GPS,
serial numbers, owner names, comments, embedded thumbnails) from media
files before public posting.

## When this applies
Read this file when the user says things like:
- 「SNS にあげる前に個人情報消して」 / "strip metadata before posting"
- 「シリアル番号と GPS 削って」 / "remove serial and GPS"
- 「全 metadata 消して」 / "wipe everything"
- 「カメラの所有者情報残ってない？」 / "is my owner name in there"

## Pre-flight checks
1. **All sanitization is destructive.** Read `references/safety.md`.
2. Default exiftool behavior creates `<file>_original` backups; confirm
   with the user whether to keep them or use `-overwrite_original`.
3. For batch operations, run a count first:
   `find ./photos -type f \\( -iname '*.jpg' -o -iname '*.heic' \\) | wc -l`

## Common patterns

### Pattern: Strip everything
**Input**: 「全部消して」 / "remove all metadata"
**Command**:
```sh
# Single file:
exiftool -all= photo.jpg
# Batch:
exiftool -all= -r -ext jpg -ext heic ./photos
```
**Why**: `-all=` removes every writable tag in every group at once. Some
tags exiftool cannot remove (file format intrinsics) remain — those are
not personally identifying.

### Pattern: SNS-publish preset
**Input**: 「SNS 用に sanitize」 / "ready this for instagram"
**Command**:
```sh
exiftool \
  -gps:all= \
  -SerialNumber= \
  -InternalSerialNumber= \
  -CameraSerialNumber= \
  -OwnerName= \
  -CameraOwnerName= \
  -ImageDescription= \
  -UserComment= \
  -Comment= \
  -Software= \
  -HostComputer= \
  -RawFileName= \
  photo.jpg
```
**Why**: this preset removes the most common identifying fields while
preserving generally useful metadata (Make, Model, LensModel, capture
date, exposure settings). The `scripts/strip-private.sh` helper wraps
this exact list and accepts a file or directory.

### Pattern: Remove only one group
**Input**: 「EXIF だけ消して XMP は残す」 / "strip EXIF but keep XMP"
**Command**:
```sh
exiftool -EXIF:all= photo.jpg
# Or only GPS:
exiftool -gps:all= photo.jpg
```
**Why**: `<Group>:all=` deletes every tag in one family. Useful when
the user wants to keep edits stored in XMP (e.g., Lightroom catalog
metadata) but blank out hardware-identifying EXIF.

### Pattern: Strip and clean up _original backups
**Input**: 「全部消して、バックアップも要らない」 / "no backups please"
**Command**:
```sh
# After confirmation that the user accepts irreversibility:
exiftool -all= -overwrite_original -r -ext jpg ./photos
```
**Why**: `-overwrite_original` removes the `_original` files exiftool
creates by default. Per pitfall P-007, this is irreversible — use only
with explicit user consent. Alternative: leave `_original` files in
place and clean them later:
```sh
find ./photos -name '*_original' -delete
```

### Pattern: Verify sanitization succeeded
**Input**: 「ちゃんと消えてるか確認」 / "verify what's left"
**Command**:
```sh
exiftool -G photo.jpg
# Or check for specific concerning tags:
exiftool -G -gps:all -SerialNumber -OwnerName -Software photo.jpg
```
**Why**: post-sanitization read confirms what remains. If the output is
empty for the queried tags, the sanitization succeeded.

### Pattern: PNG-specific (note tEXt chunks)
**Input**: 「PNG の sanitize」 / "sanitize PNG"
**Command**:
```sh
exiftool -all= image.png
```
**Why**: PNGs may carry metadata in `tEXt`/`iTXt`/`zTXt` chunks
(separate from EXIF). `-all=` removes them. Using `-EXIF:all=` alone
is insufficient (P-010).

## Pitfalls

- **Composite tags re-derive after deletion**: `Composite:GPSPosition`
  may "reappear" in subsequent reads if the underlying GPS tags were
  not all removed. `-gps:all=` covers this.
- **Embedded thumbnails carry GPS too**: some cameras embed a thumbnail
  with its own EXIF block. `-all=` strips it; `-EXIF:all=` may leave
  thumbnail EXIF behind. Verify by reading after sanitize.
- **`_original` files are irreversible after `-overwrite_original`**
  (P-007). Default behavior is safe; only delete backups with explicit
  consent.
- **PNG `tEXt` chunks** (P-010): use `-all=`, not `-EXIF:all=`.
- **Some MakerNote tags may carry latent identification** (lens-mount
  serial, internal counters) that are not in the SNS-publish preset
  above. For maximum sanitization, use `-all=`.

## See also
- `references/safety.md` (P-007, P-010)
- `references/tag-cheatsheet.md` for the identifying tag families
- `skills/exiftool/scripts/strip-private.sh`
```

- [ ] **Step 2: Verify**

Run: `grep -c "^### Pattern:" skills/exiftool/references/tasks/sanitize.md`
Expected: `6`

- [ ] **Step 3: Commit**

```bash
git add skills/exiftool/references/tasks/sanitize.md
git commit -m "$(cat <<'EOF'
feat(skill): references/tasks/sanitize.md

Patterns: strip everything, SNS-publish preset (matches
strip-private.sh), per-group removal, cleanup _original, verify
sanitization, PNG note. Pitfalls cover Composite re-derivation,
embedded thumbnail EXIF, _original irreversibility (P-007), PNG
tEXt chunks (P-010), MakerNote latent IDs.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 20: `scripts/plan-batch.sh`

**Files:**
- Create: `skills/exiftool/scripts/plan-batch.sh`

- [ ] **Step 1: Write the file**

```bash
#!/usr/bin/env bash
# plan-batch.sh — Count files matched by an exiftool -if query.
#
# This is the mandatory pre-step for batch destructive operations: print
# the count (and optionally the list) before any write so the user can
# confirm scope.
#
# Usage:
#   plan-batch.sh [-l|--list] [-e|--ext EXT]... DIR EXIFTOOL_IF_EXPR
#
# Examples:
#   plan-batch.sh ./photos '$gpslatitude'
#   plan-batch.sh -e jpg -e heic ./photos '$DateTimeOriginal'
#   plan-batch.sh --list ./photos '$Make eq "Apple"'
#
# Options:
#   -l, --list       Print matching filenames in addition to the count.
#   -e, --ext EXT    Restrict to extension EXT (repeatable).
#   -h, --help       Print this help.

set -euo pipefail

print_help() {
    sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
}

LIST=0
EXTS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -l|--list)   LIST=1; shift ;;
        -e|--ext)    EXTS+=("$2"); shift 2 ;;
        -h|--help)   print_help; exit 0 ;;
        --)          shift; break ;;
        -*)          echo "unknown option: $1" >&2; print_help >&2; exit 2 ;;
        *)           break ;;
    esac
done

if [[ $# -ne 2 ]]; then
    echo "error: expected DIR and EXIFTOOL_IF_EXPR" >&2
    print_help >&2
    exit 2
fi

DIR="$1"
EXPR="$2"

if [[ ! -d "$DIR" ]]; then
    echo "error: not a directory: $DIR" >&2
    exit 2
fi

EXT_ARGS=()
for e in "${EXTS[@]}"; do
    EXT_ARGS+=(-ext "$e")
done

if [[ "$LIST" -eq 1 ]]; then
    exiftool -r "${EXT_ARGS[@]}" -if "$EXPR" -p '$FileName' "$DIR"
    COUNT=$(exiftool -r "${EXT_ARGS[@]}" -if "$EXPR" -p '$FileName' "$DIR" | wc -l)
else
    COUNT=$(exiftool -r "${EXT_ARGS[@]}" -if "$EXPR" -p '$FileName' "$DIR" | wc -l)
fi

# Strip leading whitespace from wc output for clean display.
COUNT="${COUNT// /}"

echo "matched: $COUNT file(s)"
```

- [ ] **Step 2: Make executable and verify**

Run:
```bash
chmod +x skills/exiftool/scripts/plan-batch.sh
bash -n skills/exiftool/scripts/plan-batch.sh
skills/exiftool/scripts/plan-batch.sh --help | head -5
```

Expected: no syntax errors; `--help` prints the usage block.

If `shellcheck` is available, also run:
```bash
shellcheck skills/exiftool/scripts/plan-batch.sh
```
Expected: no errors. Warnings about `EXT_ARGS=()` initialization
(SC2207-style) are acceptable.

- [ ] **Step 3: Commit**

```bash
git add skills/exiftool/scripts/plan-batch.sh
git commit -m "$(cat <<'EOF'
feat(skill): scripts/plan-batch.sh

Count files matched by an exiftool -if expression. Mandatory pre-step
for batch destructive operations per safety.md three-step rule.
Supports --list for filename enumeration and --ext for extension
filtering.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 21: `scripts/strip-private.sh`

**Files:**
- Create: `skills/exiftool/scripts/strip-private.sh`

- [ ] **Step 1: Write the file**

```bash
#!/usr/bin/env bash
# strip-private.sh — Remove the most common identifying metadata from
# image files in preparation for public sharing.
#
# Removes: GPS, SerialNumber (and variants), OwnerName, ImageDescription,
# UserComment, Software, HostComputer, RawFileName.
#
# Preserves: Make, Model, LensModel, capture date, exposure settings.
#
# Usage:
#   strip-private.sh [--dry-run] [--no-backup] [-e|--ext EXT]... PATH
#
# Examples:
#   strip-private.sh photo.jpg
#   strip-private.sh --dry-run ./photos
#   strip-private.sh --no-backup -e jpg -e heic ./photos
#
# Options:
#   --dry-run       Show what would be removed; do not modify files.
#   --no-backup     Pass -overwrite_original to exiftool. IRREVERSIBLE.
#   -e, --ext EXT   Restrict to extension EXT (repeatable).
#   -h, --help      Print this help.

set -euo pipefail

print_help() {
    sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
}

DRY_RUN=0
NO_BACKUP=0
EXTS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)    DRY_RUN=1; shift ;;
        --no-backup)  NO_BACKUP=1; shift ;;
        -e|--ext)     EXTS+=("$2"); shift 2 ;;
        -h|--help)    print_help; exit 0 ;;
        --)           shift; break ;;
        -*)           echo "unknown option: $1" >&2; print_help >&2; exit 2 ;;
        *)            break ;;
    esac
done

if [[ $# -ne 1 ]]; then
    echo "error: expected PATH" >&2
    print_help >&2
    exit 2
fi

TARGET="$1"

if [[ ! -e "$TARGET" ]]; then
    echo "error: not found: $TARGET" >&2
    exit 2
fi

EXT_ARGS=()
for e in "${EXTS[@]}"; do
    EXT_ARGS+=(-ext "$e")
done

# Tags to remove. Order matches references/tasks/sanitize.md SNS preset.
STRIP_TAGS=(
    -gps:all=
    -SerialNumber=
    -InternalSerialNumber=
    -CameraSerialNumber=
    -OwnerName=
    -CameraOwnerName=
    -ImageDescription=
    -UserComment=
    -Comment=
    -Software=
    -HostComputer=
    -RawFileName=
)

EXTRA_ARGS=()
if [[ "$NO_BACKUP" -eq 1 ]]; then
    EXTRA_ARGS+=(-overwrite_original)
fi

if [[ -d "$TARGET" ]]; then
    EXTRA_ARGS+=(-r)
fi

if [[ "$DRY_RUN" -eq 1 ]]; then
    # Dry-run: show readings of the tags that WOULD be removed.
    READ_TAGS=()
    for t in "${STRIP_TAGS[@]}"; do
        READ_TAGS+=("${t%=}")
    done
    echo "# dry-run: tags currently present that would be removed"
    if [[ -d "$TARGET" ]]; then
        exiftool -G "${EXT_ARGS[@]}" -r "${READ_TAGS[@]}" "$TARGET"
    else
        exiftool -G "${READ_TAGS[@]}" "$TARGET"
    fi
    exit 0
fi

exiftool "${EXTRA_ARGS[@]}" "${EXT_ARGS[@]}" "${STRIP_TAGS[@]}" "$TARGET"
```

- [ ] **Step 2: Make executable and verify**

Run:
```bash
chmod +x skills/exiftool/scripts/strip-private.sh
bash -n skills/exiftool/scripts/strip-private.sh
skills/exiftool/scripts/strip-private.sh --help | head -5
```

Expected: no syntax errors; `--help` prints the usage block.

- [ ] **Step 3: Commit**

```bash
git add skills/exiftool/scripts/strip-private.sh
git commit -m "$(cat <<'EOF'
feat(skill): scripts/strip-private.sh

SNS-publish sanitize preset matching tasks/sanitize.md. Removes
GPS, serial numbers, owner name, descriptions/comments, software,
host computer, raw file name; preserves Make/Model/LensModel and
exposure data. --dry-run reads the same tags to show what would
be removed; --no-backup adds -overwrite_original (P-007).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 22a: `scripts/dry-rename.sh`

**Files:**
- Create: `skills/exiftool/scripts/dry-rename.sh`

- [ ] **Step 1: Write the file**

```bash
#!/usr/bin/env bash
# dry-rename.sh — Preview a -FileName< rename without modifying files.
#
# Wraps `exiftool -TestName<<TAG> -d <FORMAT>` so the user sees the
# proposed Old → New mapping before committing to the rename.
#
# Usage:
#   dry-rename.sh [-t|--tag TAG] [-d|--date-format FMT] [-e|--ext EXT]... PATH
#
# Defaults:
#   --tag           DateTimeOriginal
#   --date-format   %Y%m%d_%H%M%S.%%le
#
# Examples:
#   dry-rename.sh ./photos
#   dry-rename.sh -d '%Y/%m/%d/%Y%m%d_%H%M%S.%%le' ./photos
#   dry-rename.sh -t CreateDate -e jpg -e heic ./photos
#
# Options:
#   -t, --tag TAG          Source tag (default: DateTimeOriginal).
#   -d, --date-format FMT  -d format string (default: %Y%m%d_%H%M%S.%%le).
#   -e, --ext EXT          Restrict to extension EXT (repeatable).
#   -h, --help             Print this help.

set -euo pipefail

print_help() {
    sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
}

TAG="DateTimeOriginal"
FORMAT='%Y%m%d_%H%M%S.%%le'
EXTS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--tag)          TAG="$2"; shift 2 ;;
        -d|--date-format)  FORMAT="$2"; shift 2 ;;
        -e|--ext)          EXTS+=("$2"); shift 2 ;;
        -h|--help)         print_help; exit 0 ;;
        --)                shift; break ;;
        -*)                echo "unknown option: $1" >&2; print_help >&2; exit 2 ;;
        *)                 break ;;
    esac
done

if [[ $# -ne 1 ]]; then
    echo "error: expected PATH" >&2
    print_help >&2
    exit 2
fi

TARGET="$1"

if [[ ! -e "$TARGET" ]]; then
    echo "error: not found: $TARGET" >&2
    exit 2
fi

EXT_ARGS=()
for e in "${EXTS[@]}"; do
    EXT_ARGS+=(-ext "$e")
done

R_ARG=()
if [[ -d "$TARGET" ]]; then
    R_ARG+=(-r)
fi

exiftool "${R_ARG[@]}" "${EXT_ARGS[@]}" \
    "-TestName<${TAG}" \
    -d "$FORMAT" \
    "$TARGET"
```

- [ ] **Step 2: Make executable and verify**

Run:
```bash
chmod +x skills/exiftool/scripts/dry-rename.sh
bash -n skills/exiftool/scripts/dry-rename.sh
skills/exiftool/scripts/dry-rename.sh --help | head -5
```

Expected: no syntax errors; `--help` prints the usage block.

- [ ] **Step 3: Commit**

```bash
git add skills/exiftool/scripts/dry-rename.sh
git commit -m "$(cat <<'EOF'
feat(skill): scripts/dry-rename.sh

-TestName wrapper for previewing rename outcomes per
tasks/renaming.md. Defaults match the canonical recipe
(DateTimeOriginal, %Y%m%d_%H%M%S.%%le with lowercased extension).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 22b: `scripts/extract-gpx.sh`

**Files:**
- Create: `skills/exiftool/scripts/extract-gpx.sh`

- [ ] **Step 1: Write the file**

```bash
#!/usr/bin/env bash
# extract-gpx.sh — Extract embedded GPS track from a GoPro/DJI video as GPX.
#
# Uses exiftool -ee (ExtractEmbedded) plus the gpx.fmt template shipped
# with upstream exiftool.
#
# Usage:
#   extract-gpx.sh [-o|--output FILE] [-f|--fmt PATH] VIDEO
#
# Defaults:
#   --output  <video>.gpx (alongside the source)
#   --fmt     auto-detected; searches:
#               $EXIFTOOL_GPX_FMT
#               $XDG_CONFIG_HOME/exiftool/fmt/gpx.fmt
#               $HOME/.config/exiftool/fmt/gpx.fmt
#               <repo>/vendor/exiftool/fmt_files/gpx.fmt (when run from
#               inside the exiftool-skill repo)
#
# Examples:
#   extract-gpx.sh gopro.mp4
#   extract-gpx.sh -o track.gpx gopro.mp4
#   extract-gpx.sh -f /path/to/gpx.fmt drone.mov
#
# Options:
#   -o, --output FILE   Output GPX path.
#   -f, --fmt PATH      Path to gpx.fmt template.
#   -h, --help          Print this help.

set -euo pipefail

print_help() {
    sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
}

OUT=""
FMT=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -o|--output)  OUT="$2"; shift 2 ;;
        -f|--fmt)     FMT="$2"; shift 2 ;;
        -h|--help)    print_help; exit 0 ;;
        --)           shift; break ;;
        -*)           echo "unknown option: $1" >&2; print_help >&2; exit 2 ;;
        *)            break ;;
    esac
done

if [[ $# -ne 1 ]]; then
    echo "error: expected VIDEO" >&2
    print_help >&2
    exit 2
fi

VIDEO="$1"

if [[ ! -f "$VIDEO" ]]; then
    echo "error: not a file: $VIDEO" >&2
    exit 2
fi

if [[ -z "$OUT" ]]; then
    OUT="${VIDEO%.*}.gpx"
fi

if [[ -z "$FMT" ]]; then
    CANDIDATES=(
        "${EXIFTOOL_GPX_FMT:-}"
        "${XDG_CONFIG_HOME:-$HOME/.config}/exiftool/fmt/gpx.fmt"
        "$HOME/.config/exiftool/fmt/gpx.fmt"
    )
    # When running from inside the exiftool-skill repo, vendor/ has it.
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    REPO_ROOT="$SCRIPT_DIR/../../.."
    CANDIDATES+=("$REPO_ROOT/vendor/exiftool/fmt_files/gpx.fmt")

    for c in "${CANDIDATES[@]}"; do
        if [[ -n "$c" && -f "$c" ]]; then
            FMT="$c"
            break
        fi
    done
fi

if [[ -z "$FMT" || ! -f "$FMT" ]]; then
    cat >&2 <<EOF
error: gpx.fmt not found

Provide one with --fmt PATH, or place the template in one of:
  \$EXIFTOOL_GPX_FMT
  \$XDG_CONFIG_HOME/exiftool/fmt/gpx.fmt
  \$HOME/.config/exiftool/fmt/gpx.fmt

The upstream exiftool source ships gpx.fmt under fmt_files/.
EOF
    exit 2
fi

exiftool -ee -p "$FMT" "$VIDEO" > "$OUT"
echo "wrote: $OUT"
```

- [ ] **Step 2: Make executable and verify**

Run:
```bash
chmod +x skills/exiftool/scripts/extract-gpx.sh
bash -n skills/exiftool/scripts/extract-gpx.sh
skills/exiftool/scripts/extract-gpx.sh --help | head -5
```

Expected: no syntax errors; `--help` prints the usage block.

- [ ] **Step 3: Commit**

```bash
git add skills/exiftool/scripts/extract-gpx.sh
git commit -m "$(cat <<'EOF'
feat(skill): scripts/extract-gpx.sh

GoPro/DJI embedded GPS → GPX one-liner using -ee and the upstream
gpx.fmt template. Auto-detects the template from $EXIFTOOL_GPX_FMT,
XDG/HOME config paths, or vendor/exiftool/fmt_files/.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 23: `tests/lint.sh` — verification harness

**Files:**
- Create: `tests/lint.sh`

- [ ] **Step 1: Write the file**

```bash
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
if command -v shellcheck >/dev/null 2>&1; then
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
    grep -oE '\]\([^)]+\)' "$md" | sed 's/^](//;s/)$//' | while IFS= read -r link; do
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
```

- [ ] **Step 2: Make executable and run**

Run:
```bash
chmod +x tests/lint.sh
tests/lint.sh
```

Expected: all checks pass (or shellcheck-skipped if not installed).
Note: at this point in the plan, `tasks/*.md` files reference
`references/upstream/*.md` paths that DO NOT YET EXIST. The link
integrity check **WILL produce failures** for those references.

That is intentional and correct: the upstream files are created in
Phase 2. To allow Phase 1 lint to pass, we exempt `references/upstream/`
references from the integrity check by adding a special-case skip rule.

Update the lint script's link-integrity loop to skip targets under
`references/upstream/` if the directory is empty (only `.gitkeep`):

Replace the `# Resolve relative to the directory of the markdown file.`
block in the script with:

```bash
        md_dir="$(dirname "$md")"
        target="$md_dir/$link_path"
        # Phase 1: references/upstream/ is populated by Phase 2.
        # Skip integrity check for paths inside it while it is empty
        # (only .gitkeep present).
        case "$target" in
            *references/upstream/*)
                # Allow as long as the upstream dir exists.
                if [[ -d skills/exiftool/references/upstream ]]; then
                    continue
                fi
                ;;
        esac
        if [[ ! -e "$target" ]]; then
            echo "  ✗ broken link in $md: $link_path → $target" >&2
            LINK_FAIL=1
        fi
```

Re-run `tests/lint.sh` and confirm it now exits 0.

- [ ] **Step 3: Commit**

```bash
git add tests/lint.sh
git commit -m "$(cat <<'EOF'
test: tests/lint.sh verification harness

Validates plugin JSON, SKILL.md frontmatter, bash -n on every skill
script, shellcheck (when installed), and markdown link integrity.
Phase 2 will fill references/upstream/ — until then, the link check
exempts that subtree.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 24: Finalize SKILL.md (full reference map + safety rules)

**Files:**
- Modify: `skills/exiftool/SKILL.md`

- [ ] **Step 1: Read current state**

Run: `cat skills/exiftool/SKILL.md`

Confirm the skeleton from T9 is present.

- [ ] **Step 2: Replace the body (keep frontmatter)**

Overwrite `skills/exiftool/SKILL.md` with:

```markdown
---
name: exiftool
description: Use this skill any time the user works with image, video, or audio file metadata (EXIF, IPTC, XMP, GPS, MakerNote). This includes viewing or extracting metadata; reading or writing GPS coordinates; correcting DateTimeOriginal or shifting timestamps across many files; renaming or organizing files by capture date; copying tags between files or applying sidecar XMP; exporting metadata to JSON/CSV; extracting GPS tracks from GoPro/DJI videos; stripping private information (GPS, serials, comments) before public sharing. Trigger when the user mentions metadata, EXIF, GPS, geotag, "shot date", "撮影日時", sanitize, or references media files (.jpg, .jpeg, .heic, .heif, .cr2, .cr3, .nef, .arw, .dng, .raw, .tiff, .png, .mp4, .mov, .avi, .mkv, .mp3, .wav, .gpr, .360). Also trigger when extracting structured data from media files for analysis. Do NOT trigger for image content (pixels, resizing, format conversion of pixel data), video transcoding, or audio waveform processing — those need ffmpeg/ImageMagick, not exiftool.
---

# ExifTool Skill

Read, write, and manage metadata in image, video, and audio files using the
`exiftool` CLI. This skill provides task-oriented translations from
natural-language requests into safe `exiftool` invocations.

## Prerequisite

`exiftool` must be on PATH. Verify with `exiftool -ver`. If absent:

- macOS: `brew install exiftool`
- Debian / Ubuntu: `sudo apt install libimage-exiftool-perl`
- Other: <https://exiftool.org/install.html>

## Reference map (READ-FIRST when relevant)

Look up the user's intent in this table and read the corresponding
reference before composing commands. Most requests need exactly one
task file; writes additionally require `references/safety.md`.

| User intent                                  | Reference                          |
|----------------------------------------------|------------------------------------|
| 表示・抽出 (view metadata)                   | `references/tasks/reading.md`      |
| GPS の追加・削除・変換                        | `references/tasks/gps.md`          |
| 撮影日時の補正・タイムゾーン                  | `references/tasks/datetime.md`     |
| タグの一括コピー・sidecar XMP 適用            | `references/tasks/copying.md`      |
| 撮影日でリネーム・整理                        | `references/tasks/renaming.md`     |
| JSON / CSV / 表形式エクスポート               | `references/tasks/formats.md`      |
| 動画 (GoPro/DJI) のメタデータ                | `references/tasks/video.md`        |
| 個人情報除去 (公開前 sanitize)                | `references/tasks/sanitize.md`     |
| Need a tag name?                             | `references/tag-cheatsheet.md`     |
| Writing files? (REQUIRED before any write)   | `references/safety.md`             |
| Deep dive on upstream                        | `references/upstream/INDEX.md` *(populated in Phase 2)* |

## Critical safety rules

These four rules apply universally and must be honored even when the
relevant task file is not yet read:

1. **Three-step rule for writes**: any operation that modifies a file
   (commands containing `=`, `<`, or `-overwrite_*`) follows
   plan → confirm → execute. State what will change, get user OK, then
   run. Detail in `references/safety.md`.
2. **Batch operations require a count first**: before any destructive
   recursive command, run an `-if` query (or `scripts/plan-batch.sh`)
   to display the matching file count.
3. **`Composite:GPSPosition` is read-only.** Write to
   `EXIF:GPSLatitude/GPSLongitude` plus their `Ref` tags. (Pitfall P-001.)
4. **`-FileModifyDate` is filesystem mtime, not capture date.** When
   the user says "fix the date", default to `-DateTimeOriginal`.
   (Pitfall P-003.)

For the full pitfall catalog (P-001 through P-010), see
`references/safety.md`.

## Bundled helpers

`scripts/` ships shell wrappers for common multi-step patterns. Use them
when the LLM would otherwise reconstruct the same recipe ad hoc:

| Script | Use case |
|--------|----------|
| `scripts/plan-batch.sh` | Mandatory pre-step for batch destructive ops. |
| `scripts/strip-private.sh` | SNS-publish sanitize preset. |
| `scripts/dry-rename.sh` | Preview a `-FileName<` rename. |
| `scripts/extract-gpx.sh` | GoPro/DJI embedded GPS → GPX. |

All scripts accept `--help` for usage.

## When to consult `references/upstream/`

When the relevant `references/tasks/*.md` does not cover the user's
request, or when the user asks about an option the task file does not
mention, consult `references/upstream/INDEX.md` (populated in Phase 2)
to find the upstream documentation excerpt.
```

- [ ] **Step 3: Verify**

Run: `grep -c "references/tasks/" skills/exiftool/SKILL.md`
Expected: at least `8` (one per task file in the reference map)

Run: `head -1 skills/exiftool/SKILL.md`
Expected: `---`

Run: `tests/lint.sh`
Expected: all checks pass (Phase 2 placeholder allowance for
`references/upstream/` still applies).

- [ ] **Step 4: Commit**

```bash
git add skills/exiftool/SKILL.md
git commit -m "$(cat <<'EOF'
feat(skill): finalize SKILL.md with full reference map and safety rules

Replace the T9 skeleton with the complete entry point: full reference
map (8 task files + cheatsheet + safety + upstream pointer), four
critical safety rules embedded in the body so they remain in-context
even when references are not loaded, and a bundled-helpers table.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 25: Phase 1 final integration check

**Files:**
- Modify: `CHANGELOG.md` (move Phase 1 items to a stable section header)

- [ ] **Step 1: Run the lint harness**

Run: `tests/lint.sh`
Expected: all checks pass with `failed: 0`.

- [ ] **Step 2: Manual smoke check of repo state**

Run:
```bash
ls .claude-plugin
ls skills/exiftool
ls skills/exiftool/references
ls skills/exiftool/references/tasks
ls skills/exiftool/scripts
git submodule status
git log --oneline | head -30
```

Expected:
- `.claude-plugin` contains `marketplace.json`, `plugin.json`.
- `skills/exiftool` contains `SKILL.md`, `references/`, `scripts/`.
- `references/` contains `safety.md`, `tag-cheatsheet.md`, `tasks/`, `upstream/`.
- `references/tasks/` contains 8 files (reading, gps, datetime, copying,
  renaming, formats, video, sanitize).
- `references/upstream/` contains only `.gitkeep`.
- `scripts/` contains 4 `.sh` files, all executable.
- `git submodule status` shows `vendor/exiftool` at `13.57`.
- `git log` shows ~25 commits, one per task.

- [ ] **Step 3: Update CHANGELOG with Phase 1 completion note**

Modify `CHANGELOG.md`. Replace the `## [Unreleased]` block with:

```markdown
## [Unreleased]

### Added (Phase 1 — foundation)
- Repository scaffolding: `.gitignore`, `.gitattributes`, `LICENSE`
  (Artistic-1.0-Perl OR GPL-1.0-or-later), `README.md`,
  `CHANGELOG.md`, `vendor/exiftool` submodule pinned to tag `13.57`.
- Plugin manifests: `.claude-plugin/marketplace.json` (marketplace name
  `jaxx2104`), `.claude-plugin/plugin.json` (version `0.1.0-dev` with
  files whitelist).
- Skill entry point `skills/exiftool/SKILL.md` with description,
  reference map, and four embedded critical safety rules.
- Hand-written task references (8 files at equal density) under
  `skills/exiftool/references/tasks/`: `reading.md`, `gps.md`,
  `datetime.md`, `copying.md`, `renaming.md`, `formats.md`, `video.md`,
  `sanitize.md`.
- `skills/exiftool/references/safety.md` with three-step rule,
  `_original` decision table, tag-family writability matrix, and
  pitfall catalog P-001..P-010.
- `skills/exiftool/references/tag-cheatsheet.md`.
- Bundled helpers under `skills/exiftool/scripts/`: `plan-batch.sh`,
  `strip-private.sh`, `dry-rename.sh`, `extract-gpx.sh`.
- `tests/lint.sh` verification harness (JSON parse, frontmatter,
  bash -n, shellcheck if available, markdown link integrity).

### Pending (later phases)
- `references/upstream/` auto-generation (Phase 2).
- `.github/workflows/weekly-upstream-bump.yml` (Phase 2).
- Evals iteration loop (Phase 3).
- Description optimization (Phase 4).
- Plugin marketplace registration & v0.1.0 GitHub release (Phase 5).
```

- [ ] **Step 4: Commit**

```bash
git add CHANGELOG.md
git commit -m "$(cat <<'EOF'
docs: record Phase 1 deliverables in CHANGELOG

Foundation milestone (M1 + M2) complete: scaffolding, plugin
manifests, SKILL.md, 8 task references at equal density, safety.md
with 10 pitfalls, tag cheatsheet, 4 bundled helpers, lint harness.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

- [ ] **Step 5: Final verification**

Run:
```bash
tests/lint.sh
git log --oneline | wc -l
git status
```

Expected:
- lint: `failed: 0`
- commit count: ≥ `25`
- `git status`: clean working tree.

Phase 1 is complete. Proceed to Phase 2 (upstream auto-generation +
GitHub Actions) by running the brainstorming/writing-plans flow with the
existing spec, scoped to spec §6 and §6.7.

---

## Self-Review

Performed against `docs/superpowers/specs/2026-05-04-exiftool-skill-design.md`:

**Spec coverage (M1 + M2 only):**

| Spec section | Plan task |
|--------------|-----------|
| §3 Repository layout (top-level + skills/exiftool/) | T1–T9, T10–T22b |
| §3.1 Distribution scope (`files` whitelist) | T8 |
| §3.2 Licensing | T3 |
| §4 SKILL.md design (frontmatter, body, reference map, safety rules) | T9 (skeleton) + T24 (final) |
| §5.1 Common template | encoded into each task file (T12–T19) |
| §5.2 File coverage (8 task files, 3+ patterns each) | T12–T19 |
| §5.3 Reference implementation (gps.md verbatim from §13.1) | T13 |
| §7 scripts/ (4 helpers, conventions) | T20, T21, T22a, T22b |
| §8.1 Three-step rule | T10, T24 |
| §8.2 `_original` decision table | T10 |
| §8.3 Pitfall catalog (≥10) | T10 |
| §13.1 Appendix verbatim | T13 |
| `vendor/exiftool` submodule pinned to 13.57 | T6 |
| Plugin marketplace + plugin manifests | T7, T8 |
| `references/upstream/` placeholder | T9 (`.gitkeep`); contents are Phase 2 |

**Scope deferred to later phases (correctly out of scope here):**
- §6 (upstream auto-generation pipeline) → Phase 2
- §6.7 (GitHub Actions weekly bump) → Phase 2
- §9 (evals iteration) → Phase 3
- §10 (description optimization) → Phase 4
- §11 marketplace registration & §12 M6 v0.1.0 release → Phase 5

**Placeholder scan:** No "TBD" / "TODO" / "implement later" steps.
Every command and file body is concrete. The known concession is the
LICENSE in T3 which permits SPDX-only short form during Phase 1, with
the full text required before Phase 5 release — that gate is documented
in CHANGELOG and explicitly noted in T3 step 2.

**Type / signature consistency:**
- Script names: `plan-batch.sh`, `strip-private.sh`, `dry-rename.sh`,
  `extract-gpx.sh` consistent across §3 file structure, T20–T22b
  individual tasks, T24 SKILL.md helpers table, and T25 verification.
- Pitfall identifiers (P-001..P-010) used consistently across
  `safety.md` (T10), `gps.md` (T13), `datetime.md` (T14),
  `renaming.md` (T16), `video.md` (T18), `sanitize.md` (T19), and
  `SKILL.md` (T24).
- Tag-family writability matrix (T10) consistent with cheatsheet (T11)
  and pattern files (T12–T19).
- Plugin name `exiftool` and marketplace name `jaxx2104` consistent
  between T7 (marketplace.json), T8 (plugin.json), T24 (SKILL.md
  description), README (T4), and CHANGELOG (T25).

No issues found. Plan is ready for execution.
