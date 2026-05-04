# Changelog

All notable changes to exiftool-skill are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

### Added (Phase 2 — upstream auto-generation)
- `tools/select-upstream.yaml` allowlist (29 files: 10 html/ + 19 TagNames/).
- `tools/html2md.py` HTML → Markdown converter (markdownify + bs4) with
  link rewriting that points non-allowlisted references to upstream URLs.
- `tools/regen-references.sh` driver and `tools/check-links.sh`
  standalone link integrity checker.
- `tools/requirements.txt` Python deps.
- Generated `skills/exiftool/references/upstream/` content: 10 root
  pages, 19 TagNames pages, plus auto-generated `INDEX.md`.
- `.github/workflows/weekly-upstream-bump.yml` — weekly cron + manual
  dispatch, opens auto-PR on new upstream tag.
- `tests/lint.sh` — Phase 1 `references/upstream/` exemption removed;
  link checker now ignores non-`.md` link targets.

### Added (Phase 3 — evals iteration)
- `evals/evals.json` — 8 realistic English prompts spanning the 8 task
  categories (read GPS, batch GPS strip, datetime TZ shift, rename by
  date, geotag from GPX, video GPS extraction, tag copy via
  `-tagsFromFile`, CSV camera-info export).
- `tests/fixtures/` — license-clear sample media copied from
  `vendor/exiftool/t/images/` (inherits Artistic / GPL), a synthetic
  CC0 minimal `track.gpx`, and a QuickTime stand-in for the missing
  GoPro mp4. `tests/fixtures/README.md` records provenance and the
  GoPro caveat.
- Two iterations against the eval set (with-skill vs baseline executor
  subagents, grader subagents, `aggregate_benchmark` summary). Iter-1
  with-skill 23/24 (96%) vs baseline 21/24 (88%); iter-2 with-skill
  reached 24/24 (100%) and plateau on the existing assertion set.

### Changed (Phase 3 — skill content edits driven by eval feedback)
- `references/tasks/datetime.md` — new pitfall: when the metadata that
  would identify a target subset (`OffsetTimeOriginal`, GPS) is absent,
  ASK the user instead of guessing heuristically. Driven by eval 3
  iteration-1 with-skill silently picking a file by year.
- `references/tasks/formats.md` — CSV pattern now states explicitly
  that for a directory target `-r` should be included even on a flat
  directory, rather than enumerating files by hand. Driven by eval 8
  iteration-1 with-skill missing `-r`.

### Pending (later phases)
- Description optimization (Phase 4).
- Plugin marketplace registration & v0.1.0 GitHub release (Phase 5).
