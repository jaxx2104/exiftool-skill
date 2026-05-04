# Phase 4 Implementation Plan: English-only sweep + description optimization

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Strip Japanese from the shipped skill (SKILL.md + 8 task files), then run skill-creator's `run_loop.py` against a 20-query English trigger eval set and apply the held-out best `description` to SKILL.md frontmatter.

**Architecture:** Two workstreams executed in series.
W1 (PR-B): mechanical sweep of 9 files (SKILL.md + `references/tasks/*.md` × 8), each replacing Japanese `**Input**: 「...」 / "..."` patterns with English-only `**Input**: "..."`, and stripping Japanese trigger phrases from SKILL.md frontmatter `description:`. W2 (PR-C): create a 20-query English `evals/trigger-eval.json`, invoke `skill-creator/run_loop.py` against it, and apply the loop's `best_description` to SKILL.md frontmatter.

**Tech Stack:**
- bash + grep + sed for the sweep
- skill-creator (`~/.claude/plugins/cache/anthropic-agent-skills/example-skills/5128e1865d67/skills/skill-creator/`) for `run_loop.py`
- Python 3.12 (mise: `/Users/jaxx/.local/share/mise/installs/python/3.12.13/bin/python3`) — system `python3` is 3.9 and crashes on `dict | None` annotations in skill-creator
- `claude -p` headless mode (used internally by run_loop.py)

**Reference spec:** `docs/superpowers/specs/2026-05-04-phase-4-design.md`.

**Working directory:** `~/repos/github.com/jaxx2104/exiftool-skill/` on a fresh branch per PR (each PR off `origin/main`).

**This plan does NOT cover:**
- Phase 5 (marketplace registration / v0.1.0 release).
- Substantive content edits beyond Japanese removal.
- Editing `docs/superpowers/specs/*.md` or `docs/superpowers/plans/*.md` (project docs, not the shipped skill — Japanese in plan/spec docs is fine).

---

## File Structure

| Path | Responsibility | Touched in |
|------|----------------|-----------|
| `skills/exiftool/SKILL.md` | Skill entry point. Frontmatter `description:` and body reference map | T2 |
| `skills/exiftool/references/tasks/{reading,gps,datetime,copying,renaming,formats,video,sanitize}.md` | Task-specific reference files. Each contains `**Input**: 「...」 / "..."` pairs and a few Japanese headings/captions | T3 |
| `skills/exiftool/references/safety.md` | Already clean (verified) — no edit | T4 (verify) |
| `skills/exiftool/references/tag-cheatsheet.md` | Already clean (verified) — no edit | T4 (verify) |
| `skills/exiftool/scripts/*.sh` | Already clean (verified) — no edit | T4 (verify) |
| `CHANGELOG.md` | Phase 4 entries (one per merged PR) | T6, T11 |
| `evals/trigger-eval.json` | New 20-query English trigger eval set | T8 |

---

## Conventions

- One commit per task that touches the repo (unless a task is verification only).
- Public-repo policy: all commit messages, doc text, and skill content in English.
- Phase 4 is **3 PRs** (PR-A spec+plan; PR-B sweep; PR-C optimization). PR-A is the branch this plan is being written on (`phase-4-plan`); PR-B and PR-C use fresh branches off `origin/main` after the prior PR merges.
- Subagent dispatches: see `superpowers:subagent-driven-development`. The controller drives those.

---

## Workstream 1 — English-only sweep (PR-B)

### Task 1: Branch, audit Japanese inventory (no commit)

**Files:** none yet.

- [ ] **Step 1: Fetch + branch off origin/main**

```bash
cd ~/repos/github.com/jaxx2104/exiftool-skill
git fetch -p origin
git checkout -b phase-4-english-only origin/main
```

- [ ] **Step 2: Inventory Japanese in skill — record counts**

```bash
grep -rc --include="*.md" --include="*.sh" -P '[\x{3000}-\x{9fff}]' skills/exiftool/ \
    | grep -v ':0$' | sort
```

Expected output (these are the files in scope; counts may have drifted slightly since plan time):

```
skills/exiftool/SKILL.md:9
skills/exiftool/references/tasks/copying.md:10
skills/exiftool/references/tasks/datetime.md:9
skills/exiftool/references/tasks/formats.md:11
skills/exiftool/references/tasks/gps.md:8
skills/exiftool/references/tasks/reading.md:11
skills/exiftool/references/tasks/renaming.md:10
skills/exiftool/references/tasks/sanitize.md:10
skills/exiftool/references/tasks/video.md:10
```

If any other file appears, surface it before continuing.

- [ ] **Step 3: Confirm out-of-scope files are clean**

```bash
grep -P '[\x{3000}-\x{9fff}]' skills/exiftool/references/safety.md skills/exiftool/references/tag-cheatsheet.md 2>&1
grep -rP '[\x{3000}-\x{9fff}]' skills/exiftool/references/upstream/ 2>&1 | head
grep -rP '[\x{3000}-\x{9fff}]' skills/exiftool/scripts/ 2>&1
```

Expected: all empty (no matches).

### Task 2: Sweep `skills/exiftool/SKILL.md`

**Files:**
- Modify: `skills/exiftool/SKILL.md`

The Japanese in SKILL.md falls into two patterns:

1. **Frontmatter `description:` field** — contains explicit Japanese trigger phrases like `"撮影日時"` embedded in an English sentence. Remove the Japanese tokens; leave the surrounding English intact.
2. **Reference map table** — Japanese row labels like `表示・抽出 (view metadata)`, `GPS の追加・削除・変換`, etc. Replace with English-only labels.

- [ ] **Step 1: Read the file once to understand the structure**

```bash
sed -n '1,50p' skills/exiftool/SKILL.md
```

The frontmatter is at the top. The reference map table is around the `## Reference map` heading.

- [ ] **Step 2: Edit frontmatter description**

Locate the `description:` line in the frontmatter (line 3 in current HEAD). The Japanese tokens inside are trigger phrases inserted between English; remove them and leave the English sentence flowing naturally. Example:

Before (excerpt):
```
… "shot date", "撮影日時", sanitize, …
```

After:
```
… "shot date", sanitize, …
```

Strip every Japanese token in the description string. Read the whole description before editing — preserve sentence structure so the resulting English reads naturally.

- [ ] **Step 3: Edit reference map labels**

The reference map is a markdown table. Each row's first cell contains a Japanese label followed sometimes by an English parenthetical. Replace each cell with the English-only label.

Example transformation:
| 表示・抽出 (view metadata) | → | View / extract metadata |
| GPS の追加・削除・変換 | → | Add / remove / convert GPS |
| 撮影日時の補正・タイムゾーン | → | Date / timezone correction |
| タグの一括コピー・sidecar XMP 適用 | → | Bulk tag copy / sidecar XMP |
| 撮影日でリネーム・整理 | → | Rename / organize by capture date |
| JSON / CSV / 表形式エクスポート | → | JSON / CSV / table export |
| 動画 (GoPro/DJI) のメタデータ | → | Video (GoPro/DJI) metadata |
| 個人情報除去 (公開前 sanitize) | → | Sanitize before publishing |

Apply each as a separate `Edit` (unique `old_string` per row).

- [ ] **Step 4: Verify SKILL.md is now Japanese-free**

```bash
grep -cP '[\x{3000}-\x{9fff}]' skills/exiftool/SKILL.md
```

Expected: `0`.

- [ ] **Step 5: Lint passes**

```bash
tests/lint.sh
```

Expected: `passed: 8` / `failed: 0`. (Frontmatter parse + link integrity should still hold; no link targets changed.)

- [ ] **Step 6: Commit**

```bash
git add skills/exiftool/SKILL.md
git commit -m "$(cat <<'EOF'
chore(skill): remove Japanese from SKILL.md (frontmatter + reference map)

Public-repo English-only policy. The skill's description and reference
map now read uniformly in English; Japanese-prompt users still trigger
the skill via Claude's semantic matching against the English content.

Per Phase 4 design.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task 3: Sweep `skills/exiftool/references/tasks/*.md` (8 files)

**Files:**
- Modify: `skills/exiftool/references/tasks/{reading,gps,datetime,copying,renaming,formats,video,sanitize}.md` (8 files)

The dominant Japanese pattern in these files is the `**Input**:` header on each pattern block:

```
**Input**: 「<JP example>」 / "<EN example>"
```

The `「...」` quotes contain a Japanese sample user input alongside an English sample. The fix is to delete `「<JP>」 / ` so the line becomes `**Input**: "<EN example>"`.

Other Japanese in these files (rare but possible):
- A handful of section headings like `## いつ使うか` paired with English. Replace with English-only.
- Inline Japanese commentary in `**Why**:` blocks. Replace with English (preserve technical meaning).

Approach: for each of the 8 files, do one read-and-edit pass, then a single commit at the end of the task with all 8 files staged.

- [ ] **Step 1: Process `reading.md`**

```bash
grep -nP '[\x{3000}-\x{9fff}]' skills/exiftool/references/tasks/reading.md
```

For each match, apply `Edit` to remove the Japanese (most lines: drop the `「...」 / ` prefix; for headings / prose, replace with the English equivalent). Then verify:

```bash
grep -cP '[\x{3000}-\x{9fff}]' skills/exiftool/references/tasks/reading.md
```

Expected: `0`.

- [ ] **Step 2: Process `gps.md`**

Same procedure as Step 1.

- [ ] **Step 3: Process `datetime.md`**

Same procedure.

- [ ] **Step 4: Process `copying.md`**

Same procedure.

- [ ] **Step 5: Process `renaming.md`**

Same procedure.

- [ ] **Step 6: Process `formats.md`**

Same procedure.

- [ ] **Step 7: Process `video.md`**

Same procedure.

- [ ] **Step 8: Process `sanitize.md`**

Same procedure.

- [ ] **Step 9: Verify all 8 task files are Japanese-free**

```bash
grep -rcP '[\x{3000}-\x{9fff}]' skills/exiftool/references/tasks/ | grep -v ':0$'
```

Expected: empty (no output).

- [ ] **Step 10: Lint**

```bash
tests/lint.sh
```

Expected: `passed: 8` / `failed: 0`.

- [ ] **Step 11: Commit**

```bash
git add skills/exiftool/references/tasks/
git commit -m "$(cat <<'EOF'
chore(skill): remove Japanese input examples from references/tasks/*

Each pattern block's '**Input**: 「JP」 / "EN"' becomes '**Input**:
"EN"'. A few Japanese section headings and prose are translated to
English. No technical content changes.

Per Phase 4 design.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task 4: Verify out-of-scope files stayed clean

**Files:** none modified.

- [ ] **Step 1: Re-run the audit**

```bash
grep -rcP '[\x{3000}-\x{9fff}]' skills/exiftool/ | grep -v ':0$' | grep -v references/upstream/
```

Expected: empty (no output). The `references/upstream/` exclusion is because those files are auto-generated mirrors of upstream documentation and are out of scope; they are English already but might pick up the occasional Japanese exception in upstream content.

If any in-scope file shows a count > 0, return to Task 2 or Task 3.

### Task 5: CHANGELOG entry, push, open PR-B

**Files:**
- Modify: `CHANGELOG.md`

- [ ] **Step 1: Insert Phase 4 sweep entry**

Open `CHANGELOG.md`, find the `## [Unreleased]` section (and any existing Phase 3 subsections under it). Add a new subsection AFTER the existing `### Changed (Phase 3 …)` block:

```markdown
### Changed (Phase 4 — English-only sweep)
- `SKILL.md` frontmatter `description:` and body reference map: removed
  Japanese trigger phrases and labels; the public skill is uniformly in
  English. Japanese-prompt users still trigger the skill via semantic
  matching.
- `references/tasks/*.md` (8 files): replaced `**Input**: 「JP」 / "EN"`
  pairs with `**Input**: "EN"`; translated remaining Japanese headings
  and prose to English.
```

- [ ] **Step 2: Commit**

```bash
git add CHANGELOG.md
git commit -m "$(cat <<'EOF'
docs: record Phase 4 English-only sweep in CHANGELOG

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

- [ ] **Step 3: Push branch**

```bash
git push -u origin phase-4-english-only
```

- [ ] **Step 4: Open PR-B**

```bash
gh pr create --title "Phase 4: English-only sweep (SKILL.md + references/tasks/)" --body "$(cat <<'EOF'
## Summary

- Strip Japanese trigger phrases and labels from `SKILL.md` (frontmatter `description:` + body reference map).
- Strip Japanese input examples and headings from `references/tasks/*.md` (8 files), keeping the English equivalents intact.
- `references/safety.md`, `references/tag-cheatsheet.md`, `scripts/*.sh`, `references/upstream/` were already English — no change.

Per `docs/superpowers/specs/2026-05-04-phase-4-design.md` §2.

## Test plan

- [x] `tests/lint.sh` passes 8/8 (frontmatter parse, link integrity, etc.)
- [x] `grep -rcP '[\x{3000}-\x{9fff}]' skills/exiftool/ | grep -v references/upstream/ | grep -v ':0$'` returns empty
- [x] No technical content edits — only Japanese-to-English text replacement

## Out of scope

- Phase 5 marketplace registration / release
- `docs/superpowers/{specs,plans}/*.md` (project docs, not the shipped skill)
EOF
)"
```

Wait for human merge before starting Workstream 2.

---

## Workstream 2 — Description optimization (PR-C)

### Task 6: Branch, write `evals/trigger-eval.json`

**Files:**
- Create: `evals/trigger-eval.json`

- [ ] **Step 1: Branch off the merged main**

```bash
cd ~/repos/github.com/jaxx2104/exiftool-skill
git fetch -p origin
git checkout -b phase-4-description-opt origin/main
```

- [ ] **Step 2: Write the eval set**

`evals/trigger-eval.json` schema:

```json
{
  "queries": [
    {"query": "<text>", "should_trigger": true},
    ...
  ]
}
```

Write the file with these 20 queries:

```json
{
  "queries": [
    {"query": "this heic from yesterday's hike, can you wipe the gps before i text it to my mom", "should_trigger": true},
    {"query": "I want to organize my photos into year/month/day folders by capture date", "should_trigger": true},
    {"query": "drone footage from last weekend — extract the gps log as gpx so I can plot it", "should_trigger": true},
    {"query": "I have a CSV of camera serial numbers and need to find which jpg in the album was shot by which body", "should_trigger": true},
    {"query": "before I post these to instagram could you strip the metadata", "should_trigger": true},
    {"query": "took these in tokyo with the camera clock still on PST, can you bump DateTimeOriginal +17h on everything in ./trip-photos/", "should_trigger": true},
    {"query": "got a gpx from my watch, can you geotag the photos under ./trip-photos/ using it (geosync if needed, my camera was 30 sec ahead)", "should_trigger": true},
    {"query": "I converted these CR3s to TIFF in lightroom but the exif got stripped — can you copy the exif from each cr3 to the matching tiff next to it", "should_trigger": true},
    {"query": "give me a csv of every jpg under ./library/ with Make, Model, LensModel, FocalLength, ISO so I can pivot in numbers", "should_trigger": true},
    {"query": "extract the embedded gps log from this gopro mp4 as a .gpx so I can drop it into google earth", "should_trigger": true},

    {"query": "resize all my photos in ./album to 1920px wide", "should_trigger": false},
    {"query": "convert this mov to mp4 with h.265", "should_trigger": false},
    {"query": "my image looks too dark, can you brighten it", "should_trigger": false},
    {"query": "extract the audio from this video as a wav", "should_trigger": false},
    {"query": "compress these jpgs to under 500kb each", "should_trigger": false},
    {"query": "remove the watermark from this image", "should_trigger": false},
    {"query": "rotate this photo 90 degrees", "should_trigger": false},
    {"query": "I want to ocr the text in this scanned pdf", "should_trigger": false},
    {"query": "find duplicate photos in this directory", "should_trigger": false},
    {"query": "make a contact sheet of these photos", "should_trigger": false}
  ]
}
```

Notes:
- Personal paths (`/Volumes/SD/DCIM`, `~/Pictures/2026-04-tokyo`, `/Volumes/photo-library/`) from the spec drafts have been replaced with generic `./photos/`, `./trip-photos/`, `./library/`.
- The original spec §10.1 had one Japanese sample (`"撮った写真、撮影日で年月日のフォルダに分けたい"`); it has been replaced with the English paraphrase `"I want to organize my photos into year/month/day folders by capture date"`.
- All other spec drafts pass through verbatim except the path swap.

- [ ] **Step 3: Verify JSON parses and counts**

```bash
python3 -c "import json; d=json.load(open('evals/trigger-eval.json')); q=d['queries']; print(len(q), sum(1 for x in q if x['should_trigger']), sum(1 for x in q if not x['should_trigger']))"
```

Expected: `20 10 10`.

- [ ] **Step 4: Commit**

```bash
git add evals/trigger-eval.json
git commit -m "$(cat <<'EOF'
test(trigger-eval): 20-query English trigger eval set

10 should-trigger samples across the 8 task categories with realistic
register diversity (terse / multi-clause / casual / spec-style); 10
should-not-trigger near-misses in image-resize / video-transcode / OCR
/ pixel-edit territory. Personal paths from spec drafts replaced with
generic ./photos/ / ./trip-photos/ / ./library/.

Per Phase 4 design §3.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task 7: Run `run_loop.py`

**Files:** none modified in repo. Output lands in workspace.

- [ ] **Step 1: Set up workspace dir**

```bash
WS=~/repos/github.com/jaxx2104/exiftool-skill-workspace/phase-4-description-loop
mkdir -p "$WS"
```

- [ ] **Step 2: Capture the current SKILL.md description as baseline**

```bash
python3 - <<'PY'
import re, pathlib
fm = re.search(r'^---\n(.*?)\n---', pathlib.Path("skills/exiftool/SKILL.md").read_text(), re.S).group(1)
desc = re.search(r'description:\s*(.*?)(?=\n[a-z_]+:|\Z)', fm, re.S).group(1).strip()
print(desc)
PY
```

Save the output (paste into `$WS/baseline-description.txt` for reference).

- [ ] **Step 3: Run the loop**

```bash
PY=/Users/jaxx/.local/share/mise/installs/python/3.12.13/bin/python3
SC=~/.claude/plugins/cache/anthropic-agent-skills/example-skills/5128e1865d67/skills/skill-creator
WS=~/repos/github.com/jaxx2104/exiftool-skill-workspace/phase-4-description-loop

cd "$SC"
"$PY" -m scripts.run_loop \
  --eval-set ~/repos/github.com/jaxx2104/exiftool-skill/evals/trigger-eval.json \
  --skill-path ~/repos/github.com/jaxx2104/exiftool-skill/skills/exiftool \
  --model claude-opus-4-7 \
  --max-iterations 5 \
  --runs-per-query 3 \
  --holdout 0.4 \
  --results-dir "$WS" \
  --verbose 2>&1 | tee "$WS/run.log"
```

Expected: a timestamped subdirectory inside `$WS/` containing `results.json`, `report.html`, and `log.txt`. Final stderr line shows the chosen `best_description` and held-out test pass rate.

- [ ] **Step 4: Locate `best_description`**

```bash
WS=~/repos/github.com/jaxx2104/exiftool-skill-workspace/phase-4-description-loop
RESULTS=$(ls -td "$WS"/*/ | head -1)results.json
"$PY" -c "import json; d=json.load(open('$RESULTS')); print(d.get('best_description', d))"
```

Save the printed string — this is the candidate to apply to SKILL.md.

### Task 8: Apply `best_description` to SKILL.md

**Files:**
- Modify: `skills/exiftool/SKILL.md` (frontmatter `description:` only)

- [ ] **Step 1: Read the current SKILL.md frontmatter**

```bash
sed -n '1,5p' skills/exiftool/SKILL.md
```

- [ ] **Step 2: Replace the `description:` line**

Use `Edit` to swap the current frontmatter `description:` value for the captured `best_description`. Preserve the leading `description: ` prefix and YAML quoting style. The rest of the frontmatter (`name: exiftool`) and body must not change.

- [ ] **Step 3: Verify frontmatter still parses**

```bash
tests/lint.sh 2>&1 | grep frontmatter
```

Expected: `✓ skills/exiftool/SKILL.md frontmatter has name + description`.

- [ ] **Step 4: Verify still no Japanese**

```bash
grep -cP '[\x{3000}-\x{9fff}]' skills/exiftool/SKILL.md
```

Expected: `0`.

- [ ] **Step 5: Commit**

Embed the held-out test pass rate from Task 7 into the commit message.

```bash
git add skills/exiftool/SKILL.md
git commit -m "$(cat <<'EOF'
feat(skill): apply optimized description from Phase 4 run_loop

run_loop.py against evals/trigger-eval.json (20 English queries, 10
trigger / 10 no-trigger, 40% held-out) selected the description below
as best by held-out test pass rate.

Held-out test pass rate: <RATE>%
(replace <RATE> with the actual number from the loop's report)

Per Phase 4 design §4.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task 9: CHANGELOG entry, push, open PR-C

**Files:**
- Modify: `CHANGELOG.md`

- [ ] **Step 1: Insert Phase 4 description-optimization entry**

Find the `## [Unreleased]` section. After the `### Changed (Phase 4 — English-only sweep)` block (added by PR-B), add:

```markdown
### Added (Phase 4 — description optimization)
- `evals/trigger-eval.json` — 20-query English trigger eval set (10
  should-trigger across the 8 task categories with realistic register
  diversity, 10 should-not-trigger near-misses in image-resize /
  video-transcode / OCR / pixel-edit territory).
- Optimized `SKILL.md` `description:` via skill-creator's
  `run_loop.py` against the trigger eval set; held-out test pass
  rate <RATE>% (best-by-test selection from <N> iterations).
```

Replace `<RATE>` and `<N>` with the actual values from Task 7.

- [ ] **Step 2: Commit**

```bash
git add CHANGELOG.md
git commit -m "$(cat <<'EOF'
docs: record Phase 4 description optimization in CHANGELOG

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

- [ ] **Step 3: Push branch**

```bash
git push -u origin phase-4-description-opt
```

- [ ] **Step 4: Open PR-C**

```bash
gh pr create --title "Phase 4: description optimization (held-out test <RATE>%)" --body "$(cat <<'EOF'
## Summary

- Add `evals/trigger-eval.json` — 20-query English trigger eval set (10 should-trigger / 10 should-not-trigger).
- Run skill-creator's `run_loop.py` against it for up to 5 iterations with 40% held-out test split.
- Apply the `best_description` (selected by held-out test pass rate) to `SKILL.md` frontmatter.

Per `docs/superpowers/specs/2026-05-04-phase-4-design.md` §3 + §4.

## Results

- Held-out test pass rate: <RATE>%
- Iterations to plateau: <N>
- Eval workspace (gitignored): `~/repos/github.com/jaxx2104/exiftool-skill-workspace/phase-4-description-loop/`

## Test plan

- [x] `tests/lint.sh` passes 8/8
- [x] `python3 -c "import json; json.load(open('evals/trigger-eval.json'))"` parses
- [x] Frontmatter `description:` still satisfies SKILL.md frontmatter check

## Out of scope

- Phase 5 marketplace registration / release
EOF
)"
```

Wait for human merge.

---

## Self-Review

**Spec coverage:**

| Spec section | Plan task |
|--------------|-----------|
| §1 (two workstreams in order) | T1–T5 (W1) → T6–T9 (W2) |
| §2 (English-only removal scope table) | T1 audit + T2 SKILL.md + T3 8 task files + T4 verify out-of-scope |
| §3 (trigger eval set: schema, sourcing, holdout) | T6 (file write with 20 queries, de-personalized paths, JP→EN translation) |
| §4 (run_loop invocation + stop criterion) | T7 (full invocation) + T7 step 4 (locate best) |
| §5 (acceptance criteria) | T2 step 4 / T3 step 9 / T4 step 1 cover the grep zero; T2 step 5 + T8 step 3 cover lint; T6 step 3 covers schema; T7 step 3 covers loop completion; T8 covers held-out ≥ baseline (the loop's internal selection enforces this) |
| §6 (3 PRs) | PR-A is the branch this plan is on; T5 opens PR-B; T9 opens PR-C |
| §7 (risks) | Mitigations are inline (held-out test brake + cost is bounded). No task — the design's "post-Phase 4 contingency" remains contingent. |

**Out of scope (intentional):**
- Editing the master spec `2026-05-04-exiftool-skill-design.md` §10.
- Adding bilingual hint back if Japanese-prompt recall regresses (deferred per design §7 contingency).
- Phase 5.

**Placeholder scan:** `<RATE>` and `<N>` are intentional fill-ins from runtime data (Task 7 results). They are not "TBD" — they are values the executor reads from a specific output and substitutes in two specific commit messages and the PR-C body. Every other step has complete code or commands.

**Type / signature consistency:** All file paths and commands are literal absolute paths or rooted at the repo. The `WS`, `SC`, `PY` shell variables are defined fresh in each task that uses them.

**Granularity check:** Tasks 2 and 3 have 5–11 small steps each (read, edit, verify, lint, commit). Tasks 6, 8, 9 are 4–5 steps each. Task 7 is 4 steps but step 3 is the long-running loop invocation — single command, no decomposition possible.

**Human checkpoints (cannot be automated):**
- Between Task 5 and Task 6 (wait for PR-B merge).
- Between Task 9 and any further work (wait for PR-C merge).
