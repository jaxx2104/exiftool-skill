# Phase 5 design: v0.1.0 release

**Status:** Brainstormed 2026-05-04, ready for plan generation.

**Refines:** `2026-05-04-exiftool-skill-design.md` §11 (distribution) + §12 M6.

**Out of scope:**
- Phase 4 description optimization (already shipped via PR #7).
- Building and attaching a `.skill` file to the GitHub release — spec §11.3 lists `.skill` packaging as an optional install path (path 2 of 3). The marketplace install path (path 1) and manual-clone path (path 3) work without it. Building `.skill` is a future polish PR if user demand surfaces.
- End-to-end install verification (`/plugin marketplace add jaxx2104/exiftool-skill` → `/plugin install exiftool@jaxx2104`) — left to the user as a post-release manual smoke test.
- v2+ scope from §12.1 (TagName allowlist expansion, CLI wrapper).

---

## 1. Goal

Cut a v0.1.0 release: bump the plugin manifest version, polish the README to match the §11.4 structure, finalize the CHANGELOG, fix the `.claude/` housekeeping nit, and create the `v0.1.0` GitHub release tag so users can install via `/plugin marketplace add jaxx2104/exiftool-skill`.

## 2. Why "marketplace registration" is mostly already done

Claude Code's plugin marketplace mechanism reads `.claude-plugin/marketplace.json` directly from the repository URL — there is no separate global registry to publish to. The `marketplace.json` file already shipped in Phase 1 (current at `9b7e0f3` per `git log`). Phase 5 only needs:

1. The plugin manifest (`plugin.json`) to declare a real version (`0.1.0`, not `0.1.0-dev`).
2. README + CHANGELOG to be release-ready.
3. A GitHub release tag to anchor the version.

Nothing needs to be pushed to an external service.

## 3. Scope of changes

### 3.1 `.claude-plugin/plugin.json`
Single change: `"version": "0.1.0-dev"` → `"version": "0.1.0"`. The other fields (`name`, `description`, `author`, `license`, `homepage`, `skills`, `files`) are correct as-is.

### 3.2 `README.md`
Three edits:

1. **Remove the pre-release wart** in the `## Install` section. Currently:
   > Install
   >
   > (Available in Phase 5 — Plugin marketplace registration pending.)
   
   Replace with the three-path install block from spec §11.3 + §11.4 (marketplace / `.skill` package / manual clone).

2. **Add the wider Install section** (3 paths). Currently only the marketplace path is shown. The §11.3 paths to add:
   - **Plugin marketplace (recommended)**: `/plugin marketplace add jaxx2104/exiftool-skill` → `/plugin install exiftool@jaxx2104`
   - **`.skill` file**: package via skill-creator's `package_skill` then manually install (one-line note + link).
   - **Manual clone**: `git clone` + symlink `skills/exiftool/` into `~/.claude/skills/`.

3. **Remove the "Status: pre-release" block at the top.** Currently:
   > Status: pre-release (v0.1.0 in progress). Plugin marketplace registration happens in Phase 5.
   
   Drop entirely — by the time anyone reads this in main post-release, v0.1.0 is shipped.

The rest of README (Prerequisites, Safety model, Development, License, Acknowledgements) already matches §11.4. Touch nothing else.

### 3.3 `CHANGELOG.md`
Two edits:

1. **Convert `## [Unreleased]` → `## [0.1.0] - 2026-05-04`.** The existing subsections (Phase 1 Added, Phase 2 Added, Phase 3 Added/Changed, Phase 4 Changed/Added) all roll into this single release entry.

2. **Remove the `### Pending (later phases)` block.** Currently it lists "Plugin marketplace registration & v0.1.0 GitHub release (Phase 5)." With v0.1.0 shipping, that line is moot. Post-v0.1.0 work goes under a new `## [Unreleased]` section that we add empty above the v0.1.0 release entry, ready for future entries.

### 3.4 `.gitignore`
Add `.claude/` (one line under the existing `# OS` block or a new `# Claude Code session state` block). Caught during Phase 4 PR-C: `.claude/scheduled_tasks.lock` is created by the ScheduleWakeup feature and shouldn't be committed.

### 3.5 Lint
`tests/lint.sh` must continue to pass 8/8. The frontmatter check, link integrity, etc. are all unaffected by version-string and README edits.

## 4. Release procedure (post-PR-B merge)

After PR-B (the implementation PR) merges to main, the controller (this session) runs:

```sh
git checkout main
git pull --ff-only origin main
git tag -a v0.1.0 -m "exiftool-skill v0.1.0"
git push origin v0.1.0
gh release create v0.1.0 \
  --title "v0.1.0" \
  --notes-from-tag
```

The `--notes-from-tag` flag pulls the annotated tag message as release notes. Alternatively, `--notes-file` can pull a more detailed body from the v0.1.0 CHANGELOG entry; pick whichever produces a release page that reads cleanly.

The user pre-approved this controller-driven release step (option (a) from the brainstorming round).

## 5. PR structure

| PR | Contents | Branch |
|----|----------|--------|
| **PR-A** | This design doc + Phase 5 plan doc (from writing-plans) | `phase-5-plan` |
| **PR-B** | plugin.json bump + README rewrite + CHANGELOG cut + .gitignore + lint | `phase-5-release` |

GitHub release `v0.1.0` is created after PR-B merges, NOT inside any PR.

## 6. Acceptance criteria

| Item | Threshold |
|------|-----------|
| `plugin.json` version | `0.1.0` (no `-dev` suffix) |
| README Install section | All 3 paths from §11.3 documented; pre-release wart gone |
| README top | "Status: pre-release" block removed |
| CHANGELOG | `## [0.1.0] - 2026-05-04` heading; no `### Pending` block; new empty `## [Unreleased]` above |
| `.gitignore` | contains `.claude/` |
| `tests/lint.sh` | passes 8/8 |
| Git tag | `v0.1.0` exists on `origin` and points to the merged-PR-B HEAD on `main` |
| GitHub release | `v0.1.0` published with non-empty notes |

## 7. Risks

- **README's marketplace install incantation untested in this session.** The string `/plugin marketplace add jaxx2104/exiftool-skill` is taken from spec §11.3 verbatim. If Claude Code's actual marketplace command is `/plugin install` with different syntax, this README is wrong. Mitigation: copy spec syntax verbatim and trust the spec author (also the user); fix in a v0.1.1 docs PR if smoke test reveals an issue.
- **`v0.1.0` tag is destructive in the sense that it cannot be cleanly retracted from history once pushed.** Mitigation: PR-B is reviewed, lint is green, manifest is correct, and the user explicitly approved the controller running the release step (option (a)). Any post-tag fix ships as v0.1.1.
- **Empty `## [Unreleased]` section may look odd in main right after release.** Mitigation: it's the standard Keep-a-Changelog convention; readers expect it. Even better, the next change (chronologically v0.1.1 work) will populate it.

## 8. Self-review

- **Placeholder scan:** No "TBD" / "TODO" remain. The §11.3 install incantation and the `--notes-from-tag` choice are both committed decisions, not placeholders.
- **Internal consistency:** §3 (file-by-file edits) maps 1:1 to §6 (acceptance criteria). §4 (release procedure) follows §5 (PR structure) ordering. §2 (no external registry to register with) makes the "registration" framing in M6 unambiguous.
- **Scope check:** A single small spec for a release-cut PR is appropriate. The optional `.skill` packaging is explicitly excluded in the out-of-scope block.
- **Ambiguity check:** "marketplace registration" was the most ambiguous phrase from M6 — §2 makes it explicit (no external action needed). The release-procedure command in §4 is exact.
