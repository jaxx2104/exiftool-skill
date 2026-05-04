# Phase 4 design: English-only sweep + description optimization

**Status:** Brainstormed 2026-05-04, ready for plan generation.

**Refines:** `2026-05-04-exiftool-skill-design.md` §10 (description optimization).
This document supersedes the bilingual assumptions of §10 — see "English-only
decision" below.

**Out of scope:**
- Phase 5 (marketplace registration, v0.1.0 GitHub release).
- Substantive content edits to `references/tasks/*.md` beyond removing
  Japanese input examples and headings (no rewording, no new patterns).

---

## 1. Goal

Two coordinated workstreams executed in order:

1. **English-only sweep.** Remove all Japanese-language input examples,
   headings, and trigger phrases from the skill so the public artifact is
   uniformly in English. Japanese-speaking users can still invoke the skill
   in Japanese — Claude understands Japanese prompts and matches them
   semantically against English skill content. Explicit Japanese trigger
   strings in the description are not necessary.
2. **Description optimization loop.** Run skill-creator's
   `scripts/run_loop.py` against a 20-query English trigger eval set to
   optimize the SKILL.md frontmatter `description:` field for trigger
   precision and recall. Apply the loop's `best_description` (selected by
   held-out test score) to SKILL.md.

Workstream 1 lands first because (a) the optimizer runs against a stable
artifact, and (b) the trigger eval set is English-only by design.

## 2. English-only decision

### Why
The user's stated policy ("公開リポジトリでは英語で記述する" → on public
repositories, write in English) is enforced inconsistently in the current
skill: SKILL.md description and `references/tasks/*.md` retain Japanese
input examples (e.g., `「撮った写真、撮影日で…」`, `「短く」`) for
bilingual coverage, but `evals/evals.json` was made English-only in PR #4.

The original rationale for keeping Japanese in the skill was trigger
recall against Japanese users. This rationale is dropped: Japanese users
type prompts in Japanese, and Claude matches Japanese prompts to English
skill content semantically without needing literal trigger strings. The
explicit Japanese examples in the skill add maintenance overhead without
discriminating value.

### Scope of removal
| File or directory | Action |
|-------------------|--------|
| `skills/exiftool/SKILL.md` (frontmatter `description:`) | Remove Japanese trigger phrases (`"撮影日時"`, `"sanitize"` mid-sentence Japanese asides) |
| `skills/exiftool/SKILL.md` (body, including reference map) | Replace Japanese row labels (`表示・抽出 (view metadata)`) with English-only equivalents |
| `skills/exiftool/references/tasks/*.md` × 8 | Remove Japanese `**Input**` examples (`「短く」 / "compact"` → `"compact"`); translate Japanese-only headings/captions to English |
| `skills/exiftool/references/safety.md` | Same pattern |
| `skills/exiftool/references/tag-cheatsheet.md` | Same pattern |
| `skills/exiftool/scripts/*.sh` | Likely no Japanese; verify with `grep -P '[\x{3000}-\x{9fff}]'` and clean if found |
| `skills/exiftool/references/upstream/*.md` | OUT of scope — generated from upstream; English already |
| `tests/fixtures/README.md`, `evals/evals.json`, `CHANGELOG.md`, `README.md` | Already English |
| `docs/superpowers/specs/*.md`, `docs/superpowers/plans/*.md` | Out of scope (these are project docs, not the shipped skill). The Phase 4 plan doc itself is in English. |

### What is NOT removed
- Japanese-language pitfall *content* that is itself instructional in
  English. (None currently exists; this is a forward note.)
- Japanese in test fixtures' EXIF (the upstream-sourced JPEGs may contain
  Japanese in `Comment` or `XPSubject` tags — those are user data inside
  binary fixtures, not skill content).

## 3. Trigger eval set

### File
`evals/trigger-eval.json` (new). 20 queries, English only.

### Schema (per skill-creator `run_loop.py`)
```json
{
  "queries": [
    {"query": "<text>", "should_trigger": true},
    {"query": "<text>", "should_trigger": false}
  ]
}
```

### Sourcing
Start from spec `2026-05-04-exiftool-skill-design.md` §10.1 drafts. Apply
the following adjustments:

1. **De-personalize paths.** Replace user-specific paths with generic
   relative paths:
   - `/Volumes/SD/DCIM` → `./photos/`
   - `~/Pictures/2026-04-tokyo` → `./trip-photos/`
   - `/Volumes/photo-library/` → `./library/`
2. **Translate the Japanese trigger sample** ("撮った写真、撮影日で年月
   日のフォルダに分けたい") into a paraphrased English equivalent. Aim
   for casual register to preserve sample diversity.
3. **Preserve register diversity.** The 10 should-trigger samples should
   span: terse one-liners, multi-clause narrative, technical spec-style,
   and casual chat-style. The current spec drafts already cover this —
   keep the spread.
4. **Hold the no-trigger 10 fixed.** They map cleanly to image
   processing / video transcoding / OCR territory and need no edits
   beyond the same de-personalization pass.

### Held-out split
`run_loop.py` defaults: `--holdout 0.4` → 8 queries test (4+4
stratified), 12 queries train (6+6 stratified). Use the default.

## 4. Description optimization loop

### Invocation
```sh
SC=~/.claude/plugins/cache/anthropic-agent-skills/example-skills/5128e1865d67/skills/skill-creator
WS=~/repos/github.com/jaxx2104/exiftool-skill-workspace/phase-4-description-loop

cd "$SC"
python -m scripts.run_loop \
  --eval-set ~/repos/github.com/jaxx2104/exiftool-skill/evals/trigger-eval.json \
  --skill-path ~/repos/github.com/jaxx2104/exiftool-skill/skills/exiftool \
  --model claude-opus-4-7 \
  --max-iterations 5 \
  --runs-per-query 3 \
  --holdout 0.4 \
  --results-dir "$WS" \
  --verbose
```

### Stop criterion
The loop terminates on whichever fires first:

- **Early stop:** test set pass rate = 100% AND train set pass rate ≥ 90%.
- **Iteration cap:** `max-iterations = 5` reached. The loop's internal
  best-by-test selection picks the winning description.

In both cases, `best_description` is read from the loop's results JSON
and applied to `skills/exiftool/SKILL.md` frontmatter `description:`
manually (no automated rewrite — the human approves the final string).

### Workspace
`~/repos/github.com/jaxx2104/exiftool-skill-workspace/phase-4-description-loop/`
(sibling of repo, already gitignored via `*-workspace/`).

## 5. Acceptance criteria

| Item | Threshold |
|------|-----------|
| All Japanese removed from in-scope files | `grep -P '[\x{3000}-\x{9fff}]' -r skills/exiftool/` returns no matches except in `references/upstream/` |
| `tests/lint.sh` | passes 8/8 (link integrity, frontmatter, etc.) |
| Trigger eval set | 20 queries, schema-valid for `run_loop.py` |
| Description optimization loop | runs to completion, produces `best_description` in workspace |
| Final SKILL.md description | held-out test pass rate ≥ baseline (best-of: pre-optimization vs post-optimization) |

## 6. PR structure

| PR | Contents | Branch |
|----|----------|--------|
| **PR-A** | This design doc + Phase 4 plan doc (from writing-plans) | `phase-4-plan` |
| **PR-B** | English-only sweep (SKILL.md + references/) + CHANGELOG entry | `phase-4-english-only` |
| **PR-C** | `evals/trigger-eval.json` + applied `best_description` in SKILL.md + CHANGELOG entry | `phase-4-description-opt` |

PR-B merges before PR-C is opened so the optimizer runs against a
stable English-only artifact.

## 7. Risks

- **Optimizer destabilizes carefully-curated description.** The current
  description is hand-tuned with care for both should-trigger and
  should-not-trigger semantics. Mitigation: the held-out test set acts
  as the brake; if the loop's "improvements" hurt held-out performance,
  the loop's best-by-test selection naturally falls back to the
  pre-optimization description.
- **Description optimization runs are slow / costly.** Each iteration is
  20 queries × 3 runs × 1 model call = ~60 calls per iteration, ×5
  iterations = ~300 calls. Bounded; not a runaway risk.
- **Removing Japanese trigger phrases reduces Japanese-prompt trigger
  recall in practice.** Empirically untested; the assumption is that
  Claude's semantic matching covers the gap. Mitigation: post-optimization,
  spot-check a handful of Japanese prompts manually against the new
  SKILL.md to confirm trigger behavior; if recall regresses, add a
  follow-up PR with a small bilingual hint. (This is post-Phase-4
  contingency, not a planned step.)

## 8. Self-review

- **Placeholder scan:** No "TBD" / "TODO" remain. The optional Japanese-
  recall regression mitigation in §7 is explicitly framed as
  contingency, not a planned step.
- **Internal consistency:** §1 (workstream order) matches §6 (PR
  order). §2's Japanese-removal scope matches §5's `grep` acceptance
  threshold.
- **Scope check:** Two workstreams in one design is acceptable because
  (a) they share a common motivation (English-only repo) and (b)
  workstream 2 cannot run cleanly until workstream 1 lands. Splitting
  into two design docs would force cross-references for negligible
  clarity gain.
- **Ambiguity check:** "best by held-out test" in §4 is the loop's
  internal selection — clarified explicitly. The "human approves the
  final string" gate is explicit (no auto-rewrite of SKILL.md).
