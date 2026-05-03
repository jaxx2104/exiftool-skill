# exiftool-skill — Design Spec

- **Date**: 2026-05-04
- **Author**: jaxx2104
- **Status**: Draft (awaiting review)
- **Skill name**: `exiftool`
- **Distribution**: Claude Code Plugin via GitHub (`jaxx2104/exiftool-skill`)

---

## 1. Overview

A comprehensive Agent Skill that lets users operate on image, video, and audio
file metadata (EXIF / IPTC / XMP / GPS / MakerNote) through natural language in
Claude Code or Claude. The skill translates user intent into safe `exiftool`
invocations and abstracts away the two main pain points of the underlying CLI:

1. The option surface area (`-overwrite_original`, `-r`, `-ext`, `-tagsFromFile`,
   `-if`, `-d`, `-geotag`, ...) is large and easy to forget.
2. Tag naming is idiosyncratic (`EXIF:GPSLatitudeRef`, `XMP-dc:Subject`,
   `Composite:GPSPosition`, etc.) and requires distinguishing read-only derived
   tags from writable raw tags.

The skill targets parity with Anthropic's first-party skills (`pdf`, `pptx`,
`xlsx`) in terms of structure, progressive disclosure, safety, and triggering
quality.

### 1.1 Goals

- A single skill installable via `/plugin install` that covers eight core
  metadata task categories with the same density.
- Instructions and reference material derived from the upstream
  `exiftool/exiftool` documentation (Phil Harvey) so the skill remains
  authoritative and updatable.
- Strong default safety behavior for write/delete operations.
- Verifiable quality through an evals iteration loop and a description
  optimization loop.

### 1.2 Non-Goals

- Reimplementing `exiftool` (the value of upstream is 20+ years of MakerNote
  support; we do not throw that away).
- Bundling `exiftool` itself; users install via `brew`, `apt`, etc.
- Building a GUI or web frontend.
- Modifying upstream Perl code.
- Replacing image/video processing tools (ImageMagick, ffmpeg). The skill is
  metadata-only.

### 1.3 Target users

Claude Code or Claude users who handle photographs and video — developers,
photographers, content creators — who know `exiftool` exists but do not want
to keep its option grammar in working memory.

---

## 2. Architecture decisions

| Decision                                              | Choice                                       | Rationale |
|------------------------------------------------------|----------------------------------------------|-----------|
| Wrap CLI vs. write skill vs. rebuild                 | **Skill** (LLM as translator)                | Both pain points are fundamentally translation problems; rebuilding loses MakerNote knowledge; a wrapper CLI just relocates the memorization burden. |
| Skill scope                                          | **Comprehensive (A–H, equal density)**       | Stated goal: official-skill caliber, breadth over depth-of-favorites. |
| References model                                     | **Two-layer: hand-written `tasks/` + auto-generated `upstream/`** | Hand-written layer encodes natural-language → command translation patterns; upstream layer mirrors authoritative docs; they cannot pollute each other. |
| Repository layout                                    | **Separate repo (`jaxx2104/exiftool-skill`)** | Avoids merge conflicts with the upstream `exiftool` mirror; the skill repo can be optimized for skill distribution. |
| Upstream import mechanism                            | **Git submodule pinned to a tag**            | Reproducible regenerations; explicit version provenance per regeneration. |
| Distribution                                         | **Claude Code Plugin marketplace + optional `.skill` file** | First-class install UX (`/plugin install`); `.skill` available for manual flows. |
| Reference generation                                 | **Allowlist-driven script (`tools/regen-references.sh`)** | Avoids dumping all 156 TagName pages; keeps the skill lean. |
| Quality assurance                                    | **skill-creator eval loop + description optimization** | Mirrors Anthropic's own production skill workflow. |

---

## 3. Repository layout

```
exiftool-skill/
├── .claude-plugin/
│   ├── marketplace.json
│   └── plugin.json
├── README.md
├── LICENSE                       # Perl Artistic / GPL dual (upstream-inherited)
├── CHANGELOG.md
│
├── skills/
│   └── exiftool/
│       ├── SKILL.md
│       ├── references/
│       │   ├── tasks/            # hand-written, 8 files at equal density
│       │   │   ├── reading.md
│       │   │   ├── gps.md
│       │   │   ├── datetime.md
│       │   │   ├── copying.md
│       │   │   ├── renaming.md
│       │   │   ├── formats.md
│       │   │   ├── video.md
│       │   │   └── sanitize.md
│       │   ├── upstream/         # auto-generated from vendor/exiftool/html
│       │   │   ├── INDEX.md
│       │   │   ├── examples.md
│       │   │   ├── faq.md
│       │   │   ├── geotag.md
│       │   │   ├── filename.md
│       │   │   ├── metafiles.md
│       │   │   ├── geolocation.md
│       │   │   ├── cli-options.md
│       │   │   ├── common-mistakes.md
│       │   │   ├── idiosyncracies.md
│       │   │   ├── install.md
│       │   │   └── tag-names/
│       │   │       ├── exif.md
│       │   │       ├── composite.md
│       │   │       ├── xmp.md
│       │   │       ├── iptc.md
│       │   │       ├── gps.md
│       │   │       ├── quicktime.md
│       │   │       ├── jpeg.md
│       │   │       ├── png.md
│       │   │       ├── extra.md
│       │   │       ├── canon.md
│       │   │       ├── nikon.md
│       │   │       ├── sony.md
│       │   │       ├── fujifilm.md
│       │   │       ├── panasonic.md
│       │   │       ├── olympus.md
│       │   │       ├── pentax.md
│       │   │       ├── apple.md
│       │   │       ├── dji.md
│       │   │       └── gopro.md
│       │   ├── safety.md
│       │   └── tag-cheatsheet.md
│       └── scripts/
│           ├── plan-batch.sh
│           ├── strip-private.sh
│           ├── dry-rename.sh
│           └── extract-gpx.sh
│
├── vendor/
│   └── exiftool/                 # git submodule, pinned tag
│
├── tools/                        # development-only, excluded from distribution
│   ├── regen-references.sh
│   ├── html2md.py
│   ├── select-upstream.yaml
│   └── check-links.sh
│
├── tests/
│   └── fixtures/                 # license-clear sample media
│
├── evals/
│   ├── evals.json
│   └── trigger-eval.json
│
└── docs/
    └── superpowers/
        └── specs/
            └── 2026-05-04-exiftool-skill-design.md
```

### 3.1 Distribution scope

`tools/`, `vendor/`, `tests/`, `evals/`, `docs/`, and any `*-workspace/`
sibling directories are **excluded** from the installed plugin payload via
`.claude-plugin/plugin.json` `files` whitelist (or `.gitattributes
export-ignore`). End users receive `skills/exiftool/` only.

### 3.2 Licensing

Upstream `exiftool` is dual-licensed under the Perl Artistic License and the
GNU GPL. Files under `references/upstream/` are mechanical derivations of
upstream HTML and inherit those terms. The repository as a whole adopts the
same dual license to remain compatible.

---

## 4. SKILL.md design

### 4.1 Description (frontmatter)

```
Use this skill any time the user works with image, video, or audio file
metadata (EXIF, IPTC, XMP, GPS, MakerNote). This includes: viewing or
extracting metadata; reading or writing GPS coordinates; correcting
DateTimeOriginal or shifting timestamps across many files; renaming or
organizing files by capture date; copying tags between files or applying
sidecar XMP; exporting metadata to JSON/CSV; extracting GPS tracks from
GoPro/DJI videos; stripping private information (GPS, serials, comments)
before public sharing. Trigger when the user mentions metadata, EXIF,
GPS, geotag, "shot date", "撮影日時", sanitize, or references media
files (.jpg, .jpeg, .heic, .heif, .cr2, .cr3, .nef, .arw, .dng, .raw,
.tiff, .png, .mp4, .mov, .avi, .mkv, .mp3, .wav, .gpr, .360). Also
trigger when extracting structured data from media files for analysis.
Do NOT trigger for: image content (pixels, resizing, format conversion
of pixel data), video transcoding, audio waveform processing — those
need ffmpeg/ImageMagick, not exiftool.
```

This description will be the seed for the description-optimization loop
(see §10) and may be updated by it.

### 4.2 Body structure

`SKILL.md` stays under ~300 lines and contains:

1. One-paragraph purpose statement.
2. Prerequisite check (`exiftool -ver`).
3. **Reference map** — a table mapping user intent to the relevant
   `references/tasks/*.md` file. The LLM uses this to jump directly to
   the smallest relevant body of context.
4. **Critical safety rules** that must be in-context for every invocation
   (the three-step rule, `_original` handling, the four most common
   pitfalls). Detail lives in `references/safety.md`.
5. Pointer to `references/upstream/INDEX.md` for deep dives.

### 4.3 Reference map (excerpt)

| User intent                                  | Reference                          |
|----------------------------------------------|------------------------------------|
| 表示・抽出 (view metadata)                   | references/tasks/reading.md        |
| GPS の追加・削除・変換                        | references/tasks/gps.md            |
| 撮影日時の補正・タイムゾーン                  | references/tasks/datetime.md       |
| タグの一括コピー・sidecar XMP 適用            | references/tasks/copying.md        |
| 撮影日でリネーム・整理                        | references/tasks/renaming.md       |
| JSON / CSV / 表形式エクスポート               | references/tasks/formats.md        |
| 動画 (GoPro/DJI) のメタデータ                | references/tasks/video.md          |
| 個人情報除去 (公開前 sanitize)                | references/tasks/sanitize.md       |
| Need a tag name?                             | references/tag-cheatsheet.md       |
| Writing files? (REQUIRED before any write)   | references/safety.md               |
| Deep dive on upstream                        | references/upstream/INDEX.md       |

---

## 5. `references/tasks/` — hand-written translation patterns

### 5.1 Common template

Every task file uses the same skeleton so the LLM knows where to look:

```markdown
# <Task Name>

<2–3 sentence scope statement>

## When this applies
LLM should read this file when the user says things like:
- "..."
- "..."

## Pre-flight checks
What to verify before issuing commands (mandatory for destructive ops).

## Common patterns

### Pattern: <short name>
**Input** (user says): "..."
**Command**:
```sh
exiftool ...
```
**Why**: explanation of the command and what it does
**Notes**: caveats

### Pattern: <next>
...

## Pitfalls
Task-specific traps (tag confusion, write protection, TZ shifts, etc.).

## See also
- `references/upstream/<related>.md`
- `references/safety.md`
- `references/tag-cheatsheet.md`
```

The `Why` field is intentional: skill-creator's "explain why, not just what"
guidance lets the LLM generalize the pattern to variant requests instead of
mechanically replaying examples.

### 5.2 File coverage

| File           | Patterns covered (minimum 3 per file)                                                                 |
|----------------|--------------------------------------------------------------------------------------------------------|
| reading.md     | Show all tags; specific tags; group filters (`-EXIF:all`); short forms; batch + `-if`; JSON intro      |
| gps.md         | Show GPS; strip GPS; set coordinates manually; geotag from GPX                                         |
| datetime.md    | Show dates; bulk offset (`-AllDates+=`); restore from filename; TZ correction                          |
| copying.md     | File-to-file; selective (`-tagsFromFile src -gps:all dst`); sidecar XMP apply; image → XMP             |
| renaming.md    | `FileName<DateTimeOriginal`; `Directory<DateTimeOriginal`; collision counter `%%-c`; dry-run via `-TestName` |
| formats.md     | `-j`, `-j -G`; `-csv`; `-s/-s2/-s3`; `-struct`; piping to `jq`/`csvkit`                                |
| video.md       | Basic same as image; QuickTime:CreateDate (UTC); `-ee` for embedded GoPro GPS; `.SRT` for DJI; GPX out via `-p` |
| sanitize.md    | `-all=`; `-exif:all=`; SNS-publish preset (`-gps:all= -SerialNumber= -OwnerName= -Comment=`); `-overwrite_original` use |

### 5.3 Reference implementation: `gps.md`

The `gps.md` file is illustrated in full in §13.1 (Appendix) to lock the
density and tone for the rest of the task files. All eight task files target
that density.

---

## 6. `references/upstream/` — auto-generated mirror

### 6.1 Generation pipeline

```
vendor/exiftool/                       (git submodule, pinned tag)
  └── html/, html/TagNames/
              │
              ▼  tools/regen-references.sh
                  ├─ tools/select-upstream.yaml   (allowlist)
                  ├─ tools/html2md.py             (converter)
                  ▼
skills/exiftool/references/upstream/
  ├── INDEX.md (auto)
  ├── *.md
  └── tag-names/*.md
```

### 6.2 Allowlist (v1)

`tools/select-upstream.yaml` enumerates the source/output mappings.

**From `html/`** (10 files):
`examples.html`, `faq.html`, `geotag.html`, `filename.html`, `metafiles.html`,
`geolocation.html`, `exiftool_pod.html` (→ `cli-options.md`),
`mistakes.html` (→ `common-mistakes.md`), `idiosyncracies.html`,
`install.html`.

**From `html/TagNames/`** (~19 files for v1):
- Foundational: `EXIF`, `Composite`, `XMP`, `IPTC`, `GPS`, `QuickTime`,
  `JPEG`, `PNG`, `Extra`.
- MakerNote (major manufacturers): `Canon`, `Nikon`, `Sony`, `Fujifilm`,
  `Panasonic`, `Olympus`, `Pentax`, `Apple`.
- Action cameras / drones: `DJI`, `GoPro`.

The remaining ~130 TagName files are deferred to v2 by adding entries to the
YAML allowlist.

### 6.3 Converter (`tools/html2md.py`)

- Library: `markdownify` + `beautifulsoup4` (no external binaries like pandoc).
- Pre-processing: strip `<style>`, `<script>`; normalize tight tables;
  rewrite intra-doc links (`href="EXIF.html"` → `tag-names/exif.md`).
- Post-processing: insert TOC for large files (configured per-entry in YAML);
  write frontmatter (see §6.4).

### 6.4 Generated file frontmatter

```markdown
---
generated_from: vendor/exiftool/html/geotag.html
upstream_version: 13.57
upstream_commit: dae9b7a8
generated_at: 2026-05-04
do_not_edit: true
---

> **Auto-generated** from upstream exiftool documentation. Do not edit by
> hand — edits will be overwritten on next regeneration. To change wording,
> edit the corresponding file in `vendor/exiftool/html/` upstream or
> override behavior in `references/tasks/`.

# Geotagging
...
```

### 6.5 `INDEX.md`

Auto-generated index of every `upstream/` file, table form
(`File | Source | Purpose`), used as the LLM's entry point when consulting
the upstream layer.

### 6.6 Regeneration workflow (human)

```sh
# 1) Bump upstream
cd vendor/exiftool && git fetch --tags && git checkout 13.58 && cd ../..

# 2) Regenerate
./tools/regen-references.sh

# 3) Diff review
git diff skills/exiftool/references/upstream/

# 4) Link integrity
./tools/check-links.sh

# 5) Commit
git add vendor/exiftool skills/exiftool/references/upstream/
git commit -m "Bump upstream to 13.58, regenerate references"
```

---

## 7. `scripts/` — bundled helpers

These ship inside the skill and may be invoked by the LLM during execution.
Distinct from `tools/` (developer-only, not distributed).

| Script              | Purpose                                                            |
|---------------------|--------------------------------------------------------------------|
| `plan-batch.sh`     | Count files matched by an `-if` query; mandatory pre-step for batch destructive ops. |
| `strip-private.sh`  | Bundled sanitize preset for SNS-publish workflows.                  |
| `dry-rename.sh`     | `-TestName` wrapper for previewing rename outcomes.                 |
| `extract-gpx.sh`    | One-liner for GoPro/DJI embedded GPS → GPX.                         |

### Conventions

- `set -euo pipefail` at top.
- `--help` prints usage.
- `--dry-run` flag is uniform across scripts.
- All scripts call `exiftool` from `PATH`; no vendored binary.

Rationale: skill-creator notes that bundling helpers prevents repeated
re-invention across evals. These four are the patterns the LLM otherwise
tends to reconstruct ad hoc and get wrong (especially the
plan-batch / count-first pattern).

---

## 8. Safety and `references/safety.md`

### 8.1 The three-step rule

For any write or delete operation:

1. **Plan**: present what will change (which files, which tags, expected count).
2. **Confirm**: explicit user OK before execution.
3. **Execute**: run the write.

This rule is mirrored in `SKILL.md` body so the LLM cannot avoid seeing it.

### 8.2 `_original` backup behavior

| Flag                              | Behavior                                                  |
|-----------------------------------|-----------------------------------------------------------|
| (default)                         | Creates `<file>_original` next to the write              |
| `-overwrite_original`             | Deletes the backup (irreversible)                        |
| `-overwrite_original_in_place`    | Same content, preserves inode/atime; backup still removed |

A decision table in `safety.md` maps user intent ("save space" / "preserve
inode" / "be safe") to the right flag.

### 8.3 Pitfall catalog

Each pitfall is a numbered entry with **symptom, cause, avoidance, upstream
link**. v1 ships with at least the following:

- **P-001**: Write to `Composite:GPSPosition` silently no-ops.
- **P-002**: Forgetting `GPSLatitudeRef`/`GPSLongitudeRef` flips hemispheres.
- **P-003**: `-FileModifyDate` ≠ `-DateTimeOriginal`.
- **P-004**: `-AllDates` does not include `FileModifyDate`.
- **P-005**: `QuickTime:CreateDate` is in UTC; clients differ on TZ display.
- **P-006**: HEIC may store GPS in `XMP` not `EXIF`.
- **P-007**: `-overwrite_original` is irreversible.
- **P-008**: Wildcard expansion vs. `-r` recursion.
- **P-009**: Filename case (`%%le` lowercases extension; `%%e` preserves).
- **P-010**: PNG often lacks an EXIF segment; metadata may be in tEXt chunks.

Each entry references `references/upstream/common-mistakes.md` and
`references/upstream/idiosyncracies.md` (auto-generated from the upstream
files of the same name).

---

## 9. Evals strategy

### 9.1 Initial test cases (`evals/evals.json`)

Eight realistic prompts spanning the eight task categories:

| ID | Name                   | Prompt sketch                                                                                                |
|----|------------------------|--------------------------------------------------------------------------------------------------------------|
| 1  | view-gps-single        | "tests/fixtures/photo.jpg の GPS 座標教えて"                                                                  |
| 2  | strip-gps-batch        | "tests/fixtures/share/ にある写真を SNS に上げる前に GPS 全部消して"                                          |
| 3  | shift-datetime-tz      | "旅行写真、UTC+0 で撮ったやつだけ 9 時間戻して"                                                                |
| 4  | rename-by-date         | "Downloads の写真を撮影日で YYYY/MM/DD/ にリネームして"                                                       |
| 5  | geotag-from-gpx        | "track.gpx に合わせて photos/ 全部 geotag して"                                                               |
| 6  | video-gps-track        | "GoPro で撮った gopro.mp4 から GPS トラックを GPX で出して"                                                   |
| 7  | copy-tags-sidecar      | "現像した tiff に元 raw の Exif 全部コピーしたい"                                                              |
| 8  | csv-export-camera-info | "photos/ 配下全部の Make / Model / LensModel を CSV で"                                                       |

### 9.2 Assertion patterns

Programmatically checkable, descriptive assertions per eval:

- `output_contains_command_with("-tagsFromFile")` for eval 7
- `does_not_attempt_write_to("Composite:GPSPosition")` for eval 5
- `mentions_dry_run_or_count_first()` for evals 2, 3, 4
- `mentions_overwrite_original_implications()` for evals 2, 3
- `output_file_exists("*.gpx")` for eval 6

Subjective qualities (clarity of explanation, tone) remain qualitative for
human review.

### 9.3 Iteration loop

Standard skill-creator workflow:

1. Spawn with-skill and baseline subagents in parallel for all 8 evals into
   `iteration-1/`.
2. Capture `timing.json` per run from notification metadata.
3. Grade with `agents/grader.md` → `grading.json` per run.
4. Aggregate via `python -m scripts.aggregate_benchmark` →
   `benchmark.{json,md}`.
5. Open `eval-viewer/generate_review.py` for human review.
6. Read `feedback.json`, improve skill, re-run into `iteration-2/`.
7. Repeat until feedback is empty / improvements plateau.

### 9.4 Workspace layout

```
exiftool-skill-workspace/   # sibling of exiftool-skill/
├── iteration-1/
│   ├── eval-1-view-gps-single/
│   │   ├── with_skill/outputs/
│   │   ├── without_skill/outputs/
│   │   ├── eval_metadata.json
│   │   ├── grading.json
│   │   └── timing.json
│   ├── ...
│   ├── benchmark.json
│   └── benchmark.md
└── iteration-2/
    └── ...
```

---

## 10. Description optimization

After the eval loop stabilizes, run skill-creator's
`scripts/run_loop.py` to optimize triggering precision/recall.

### 10.1 Trigger eval set (20 queries)

Realistic, detailed, mixed-formality queries. **10 should-trigger** sample:

- "this heic from yesterday's hike, can you wipe the gps before i text it to my mom"
- "撮った写真、撮影日で年月日のフォルダに分けたい"
- "drone footage from last weekend — extract the gps log as gpx so I can plot it"
- "I have a CSV of camera serial numbers and need to find which jpg in the album was shot by which body"
- "before I post these to instagram could you strip the metadata"
- (5 more covering the remaining task categories)

**10 should-not-trigger** near-misses:

- "resize all my photos in ./album to 1920px wide" (ImageMagick territory)
- "convert this mov to mp4 with h.265" (ffmpeg)
- "my image looks too dark, can you brighten it" (image processing)
- "extract the audio from this video as a wav" (ffmpeg)
- "compress these jpgs to under 500kb each" (mozjpeg)
- "remove the watermark from this image" (pixel editing)
- "rotate this photo 90 degrees" (pixel rotation, not orientation tag)
- "I want to ocr the text in this scanned pdf" (PDF/OCR)
- "find duplicate photos in this directory" (perceptual hashing tools)
- "make a contact sheet of these photos" (ImageMagick)

### 10.2 Run

```sh
python -m scripts.run_loop \
  --eval-set evals/trigger-eval.json \
  --skill-path skills/exiftool \
  --model claude-opus-4-7 \
  --max-iterations 5 \
  --verbose
```

Resulting `best_description` (selected by held-out test score, not train) is
applied to `SKILL.md` frontmatter.

---

## 11. Distribution

### 11.1 `.claude-plugin/marketplace.json`

```json
{
  "name": "exiftool",
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

### 11.2 `.claude-plugin/plugin.json`

```json
{
  "name": "exiftool",
  "version": "0.1.0",
  "description": "Read/write EXIF, IPTC, XMP, GPS, MakerNote metadata via natural language.",
  "author": "jaxx2104",
  "license": "Artistic-1.0-Perl OR GPL-1.0-or-later",
  "skills": ["./skills/exiftool"],
  "homepage": "https://github.com/jaxx2104/exiftool-skill"
}
```

### 11.3 Install paths

1. **Plugin marketplace (recommended)**:
   `/plugin marketplace add jaxx2104/exiftool-skill` →
   `/plugin install exiftool@exiftool`
2. **`.skill` file**: `python -m scripts.package_skill skills/exiftool` →
   manual install of the resulting `.skill`.
3. **Manual clone**: `git clone` and symlink into `~/.claude/skills/`.

### 11.4 README structure

- Install (three paths above)
- What it does (8 task categories with one example each)
- Prerequisites (`brew install exiftool`, `apt install libimage-exiftool-perl`)
- Safety model (link to `safety.md`)
- Development (vendor/, tools/, regen process)
- License (dual)
- Acknowledgements (Phil Harvey)

---

## 12. Milestones

| M  | Content                                                                                                                  | Done when                                                                                            |
|----|--------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| M1 | Scaffolding                                                                                                              | New repo, `.claude-plugin/`, directory tree, `vendor/exiftool` submodule pinned, SKILL.md skeleton, README, LICENSE, CHANGELOG |
| M2 | Hand-written `tasks/` (8 files) + `safety.md`                                                                            | Each file matches common template; ≥3 patterns per file; ≥10 pitfalls in catalog; cross-links resolve |
| M3 | Upstream auto-generation                                                                                                 | `regen-references.sh`, `select-upstream.yaml` covers ~30 files, `html2md.py` operational, `INDEX.md` generated, output committed |
| M4 | Evals iteration                                                                                                          | `evals/evals.json` with 8 cases; `iteration-1/` complete; eval-viewer reviewed; feedback applied; `iteration-2/` stable |
| M5 | Description optimization                                                                                                 | `trigger-eval.json` (20 queries) reviewed; `run_loop.py` completes; `best_description` applied        |
| M6 | v1 release                                                                                                               | Plugin published to marketplace; README final; CHANGELOG entry; GitHub release tag `v0.1.0`           |

**Critical path**: M1 → (M2 ∥ M3) → M4 → M5 → M6

### 12.1 Post-v1 (out of scope for this spec)

- v2: TagName allowlist expanded from ~30 to 100+ files.
- v3 candidate: thin CLI wrapper (option 3 from initial brainstorming) sharing
  the same task pattern catalog.

---

## 13. Appendix

### 13.1 `references/tasks/gps.md` — full reference example

The reference density target for all eight task files:

````markdown
# GPS / Geolocation

This file covers reading, writing, deleting, and converting GPS coordinates
in image and video files using exiftool.

## When this applies
Read this file when the user says things like:
- 「GPS 消して」「ジオタグ削除」"strip GPS", "remove location"
- 「この写真どこで撮った？」"where was this taken"
- 「GPX から座標つけて」"geotag from GPX"
- 「この座標を入れて」"set GPS to lat,lon"

## Pre-flight checks
1. **Writing or deleting?** Read `references/safety.md` first.
2. **Batch operation?** Run a count first:
   `exiftool -if '$gpslatitude' -p '$filename' -r DIR | wc -l`
3. **Backup behavior**: by default exiftool creates `<file>_original`.
   Confirm with the user whether to keep or use `-overwrite_original`.

## Common patterns

### Pattern: Show GPS coordinates
**Input**: "この写真の GPS 教えて" / "where was photo.jpg taken"
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
**Input**: "GPS 消して" / "remove all location data before posting"
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
**Input**: "この写真に東京駅の座標入れて" / "geotag photo.jpg to 35.6812, 139.7671"
**Command**:
```sh
exiftool \
  -GPSLatitude=35.6812 -GPSLatitudeRef=N \
  -GPSLongitude=139.7671 -GPSLongitudeRef=E \
  photo.jpg
```
**Why**: GPS in EXIF is stored as positive magnitude + N/S/E/W ref.
Forgetting `Ref` results in coordinates being interpreted as the wrong
hemisphere — a common silent failure.

### Pattern: Geotag from a GPX track
**Input**: "track.gpx に合わせて全部 geotag して"
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
  Use `EXIF:GPSLatitude` / `EXIF:GPSLongitude` (with `Ref` tags).
- **Forgetting `Ref` tags.** Without `GPSLatitudeRef=N`, southern hemisphere
  coordinates flip sign in some viewers.
- **HEIC files**: GPS may live in `XMP:GPSLatitude` instead of `EXIF`. When
  in doubt, read both groups: `exiftool -GPS:all -XMP:GPS:all file.heic`.
- **Video GPS** (GoPro/DJI): see `references/tasks/video.md` — different
  storage location.

## See also
- `references/safety.md` — backup behavior, batch confirmation
- `references/upstream/geotag.md` — full geotag option reference
- `references/tag-cheatsheet.md` — GPS tag families across EXIF/XMP/Composite
- `references/tasks/video.md` — GPS in video files
````

---

## 14. Open questions / future work

- Whether to ship `tools/` inside the distributed plugin so users can run
  their own re-generations (deferred; for v1, `tools/` is dev-only).
- Whether the `.skill` packaging path should be a CI artifact attached to
  every release (probably yes, decide at M6).
- Geolocation reverse-lookup (`geolocation.html`) requires the optional
  `Geolocation.dat` data file; document install separately or bundle a
  download script (decide during M2 for `tasks/gps.md`).
