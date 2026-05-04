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

### Pending (later phases)
- `references/upstream/` auto-generation (Phase 2).
- `.github/workflows/weekly-upstream-bump.yml` (Phase 2).
- Evals iteration loop (Phase 3).
- Description optimization (Phase 4).
- Plugin marketplace registration & v0.1.0 GitHub release (Phase 5).
