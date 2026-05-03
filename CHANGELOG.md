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
