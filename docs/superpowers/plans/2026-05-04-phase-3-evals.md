# exiftool-skill Phase 3: Evals Iteration Implementation Plan

**Goal:** Set up the skill-creator-style evaluation loop (8 realistic test prompts, parallel with-skill / baseline runs, eval-viewer human review, iterate until stable) per spec §9.

**Architecture:** `evals/evals.json` declares the test cases. `tests/fixtures/` provides license-clear sample media (sourced from upstream `vendor/exiftool/t/images/`, which is dual-licensed identically to the skill). For each iteration, dispatch one with-skill subagent and one baseline (no-skill) subagent per eval into `exiftool-skill-workspace/iteration-N/eval-<id>/<config>/outputs/`. Capture timing from notification metadata. Grade with a grader subagent. Aggregate via `python -m scripts.aggregate_benchmark`. Open `eval-viewer/generate_review.py` for human review. Read `feedback.json`, improve, iterate.

**Tech Stack:**
- Python (skill-creator's `aggregate_benchmark`, `generate_review.py`, packaged with the `example-skills:skill-creator` skill)
- `exiftool` CLI (must be on PATH on the runner)
- Subagents (general-purpose) for parallel execution
- A web browser for the eval-viewer (manual step; this is the human-in-the-loop)

**Reference spec:** `docs/superpowers/specs/2026-05-04-exiftool-skill-design.md` §9.

**Working directory:** `~/repos/github.com/jaxx2104/exiftool-skill/` on a new branch (e.g., `phase-3-evals`).

**This plan does NOT cover:**
- Description optimization (Phase 4) — runs after evals stabilize.
- Marketplace registration / release (Phase 5).
- Modifications to the skill content itself, except in response to eval feedback (T6 loop).

---

## Why this phase needs a human in the loop

Unlike Phase 1 and Phase 2, Phase 3 is interactive: the eval-viewer opens a browser and waits for the user to click through each test case, leave feedback, and submit. The plan below is structured so that the human-action gates are explicit (T4 step 4, T6 step 1).

---

## File Structure

| Path | Responsibility | Created in |
|------|----------------|-----------|
| `evals/evals.json` | 8 test prompts spanning the eight task categories | T1 |
| `tests/fixtures/photo.jpg`, `share/*.jpg`, `track.gpx`, etc. | License-clear sample inputs | T2 |
| `exiftool-skill-workspace/iteration-1/eval-<id>/<cfg>/outputs/` | Per-run outputs | T3 |
| `exiftool-skill-workspace/iteration-1/eval-<id>/{eval_metadata,grading,timing}.json` | Per-eval metadata + grading + timing | T3, T5 |
| `exiftool-skill-workspace/iteration-1/benchmark.{json,md}` | Aggregated results | T5 |
| (subsequent) `exiftool-skill-workspace/iteration-2/...` | After feedback applied | T6 |

The `exiftool-skill-workspace/` directory is **a sibling of the repo**, not committed (already in `.gitignore` via `*-workspace/`).

---

## Conventions

- One commit per task that touches files inside the repo. The workspace directory and its contents are not committed.
- Subagent dispatches: see `superpowers:subagent-driven-development` for the exact pattern. The plan below assumes the controller (the running session) drives those dispatches.

---

## Task 1: `evals/evals.json` — initial 8 test cases

**Files:**
- Create: `evals/evals.json`

- [ ] **Step 1: Write the file**

```json
{
  "skill_name": "exiftool",
  "evals": [
    {
      "id": 1,
      "name": "view-gps-single",
      "prompt": "tests/fixtures/photo.jpg の GPS 座標教えて",
      "expected_output": "lat/lon が答えに含まれる、書き込みは行わない",
      "files": ["tests/fixtures/photo.jpg"]
    },
    {
      "id": 2,
      "name": "strip-gps-batch",
      "prompt": "tests/fixtures/share/ にある写真を SNS に上げる前に GPS 全部消して",
      "expected_output": "件数を先に提示、確認後にバッチ削除、_original の扱いを明示",
      "files": ["tests/fixtures/share/"]
    },
    {
      "id": 3,
      "name": "shift-datetime-tz",
      "prompt": "旅行で撮った写真、カメラの時計が日本時間のままで撮った分があるんだけど、UTC+0 の場所で撮影したやつだけ 9 時間戻して。対象は tests/fixtures/trip/ 以下。",
      "expected_output": "対象絞り込みを -if で行う、AllDates または DateTimeOriginal の更新",
      "files": ["tests/fixtures/trip/"]
    },
    {
      "id": 4,
      "name": "rename-by-date",
      "prompt": "tests/fixtures/downloads/ の写真を撮影日で YYYY/MM/DD/ のフォルダに分けてリネームして",
      "expected_output": "-Directory<DateTimeOriginal -d, dry-run 提案",
      "files": ["tests/fixtures/downloads/"]
    },
    {
      "id": 5,
      "name": "geotag-from-gpx",
      "prompt": "tests/fixtures/track.gpx に合わせて tests/fixtures/photos/ 全部 geotag して",
      "expected_output": "-geotag 使用、時刻ズレ可能性に言及",
      "files": ["tests/fixtures/track.gpx", "tests/fixtures/photos/"]
    },
    {
      "id": 6,
      "name": "video-gps-track",
      "prompt": "GoPro で撮った tests/fixtures/gopro.mp4 から GPS トラックを GPX で出して",
      "expected_output": "-ee の使用、または .fmt の言及",
      "files": ["tests/fixtures/gopro.mp4"]
    },
    {
      "id": 7,
      "name": "copy-tags-sidecar",
      "prompt": "現像した tests/fixtures/develop.tiff に、元 raw (tests/fixtures/source.cr3) の Exif 全部コピーしたい",
      "expected_output": "-tagsFromFile の使用",
      "files": ["tests/fixtures/develop.tiff", "tests/fixtures/source.cr3"]
    },
    {
      "id": 8,
      "name": "csv-export-camera-info",
      "prompt": "tests/fixtures/photos/ 配下全部の Make / Model / LensModel を CSV で出して",
      "expected_output": "-csv -Make -Model -LensModel -r",
      "files": ["tests/fixtures/photos/"]
    }
  ]
}
```

- [ ] **Step 2: Verify JSON parses**

```bash
python3 -c "import json; d = json.load(open('evals/evals.json')); print(len(d['evals']))"
```
Expected: `8`

- [ ] **Step 3: Commit**

```bash
git add evals/evals.json
git commit -m "$(cat <<'EOF'
test(evals): initial 8 test prompts spanning the 8 task categories

Realistic prompts in Japanese (jaxx's primary working language) that
exercise reading, sanitize, datetime shift, rename-by-date, geotag from
GPX, video GPS extraction, tag copying, and CSV export. Each eval
declares the input fixture paths.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 2: `tests/fixtures/` — sample media

**Files:**
- Create: `tests/fixtures/<various>` (copied from `vendor/exiftool/t/images/`)
- Create: `tests/fixtures/README.md` — provenance and license note

- [ ] **Step 1: Inventory what each eval needs**

| Eval | Required fixtures | Source from upstream (vendor/exiftool/t/images/) |
|------|-------------------|---------------------------------------------------|
| 1 view-gps-single | `photo.jpg` (must contain GPS) | `Apple.jpg` (HEIC GPS variant in upstream — fall back to any jpg with GPS) |
| 2 strip-gps-batch | `share/*.jpg` (≥3 files, some with GPS) | mix of `Canon.jpg`, `Nikon.jpg`, `Sony.jpg` |
| 3 shift-datetime-tz | `trip/*.jpg` (with DateTimeOriginal) | `Canon.jpg`, `Nikon.jpg`, `Pentax.jpg` |
| 4 rename-by-date | `downloads/*.jpg` (≥3 files) | as above |
| 5 geotag-from-gpx | `track.gpx`, `photos/*.jpg` (without GPS) | upstream lacks a sample GPX — generate one (see step 3 below); `photos/*` from images that lack GPS |
| 6 video-gps-track | `gopro.mp4` (with embedded GPS) | upstream may not ship one — fall back to mocking with `vendor/exiftool/t/images/QuickTime.mov` and noting the eval may be SKIP if no embedded GPS |
| 7 copy-tags-sidecar | `develop.tiff`, `source.cr3` | `CanonRaw.cr3` + `TIFF.tif` |
| 8 csv-export-camera-info | `photos/*.jpg` | reuse the eval-5 photos/ |

- [ ] **Step 2: Copy upstream fixtures**

For each fixture, prefer copying (not symlinking) from `vendor/exiftool/t/images/` so the eval is self-contained even if `vendor/` rotates. Sample copies:

```bash
cd ~/repos/github.com/jaxx2104/exiftool-skill
mkdir -p tests/fixtures/share tests/fixtures/trip tests/fixtures/downloads tests/fixtures/photos
cp vendor/exiftool/t/images/Apple.jpg tests/fixtures/photo.jpg
for f in Canon.jpg Nikon.jpg Sony.jpg; do
    cp vendor/exiftool/t/images/$f tests/fixtures/share/
    cp vendor/exiftool/t/images/$f tests/fixtures/trip/
    cp vendor/exiftool/t/images/$f tests/fixtures/downloads/
    cp vendor/exiftool/t/images/$f tests/fixtures/photos/
done
cp vendor/exiftool/t/images/CanonRaw.cr3 tests/fixtures/source.cr3
cp vendor/exiftool/t/images/TIFF.tif tests/fixtures/develop.tiff
```

- [ ] **Step 3: Generate `track.gpx`**

A minimal valid GPX trace covering the timestamps of `tests/fixtures/photos/`:

```bash
cat > tests/fixtures/track.gpx <<'GPX'
<?xml version="1.0" encoding="UTF-8"?>
<gpx version="1.1" creator="exiftool-skill evals" xmlns="http://www.topografix.com/GPX/1/1">
  <trk>
    <name>Eval test track</name>
    <trkseg>
      <trkpt lat="35.6812" lon="139.7671"><time>2010-01-01T00:00:00Z</time></trkpt>
      <trkpt lat="35.6800" lon="139.7700"><time>2030-12-31T23:59:59Z</time></trkpt>
    </trkseg>
  </trk>
</gpx>
GPX
```

- [ ] **Step 4: Address the GoPro fixture (eval 6)**

Upstream `vendor/exiftool/t/images/` does not ship a GoPro MP4 with embedded GPS5. Options:
- (a) Drop eval 6 from iteration-1 and add it back when a fixture is available.
- (b) Use any QuickTime fixture as a stand-in and let the eval pass condition include "report that no GPS stream was found".
- (c) Source a tiny synthetic GoPro sample from a public-domain source (e.g., a 1-second clip generated on a real GoPro and explicitly licensed CC0).

Recommendation: **(b) for iteration-1**, with a note in `tests/fixtures/README.md` that a real GoPro fixture is wanted. Update the eval's `expected_output` accordingly.

- [ ] **Step 5: Write `tests/fixtures/README.md`**

```markdown
# tests/fixtures/

Sample media for the `evals/` iteration loop.

Most files are copied from `vendor/exiftool/t/images/` and inherit
the upstream `exiftool` dual-license (Artistic / GPL).

`track.gpx` is a synthetic minimal GPX file generated for these
evals; it is dedicated to the public domain.

GoPro / DJI fixtures: upstream does not ship video with embedded
telemetry. Until a public-domain sample is available, eval 6 uses
a generic QuickTime stand-in.
```

- [ ] **Step 6: Commit**

```bash
git add tests/fixtures/
git commit -m "$(cat <<'EOF'
test(fixtures): sample media for evals (sourced from upstream)

Fixtures copied from vendor/exiftool/t/images/ (dual-license
inherited). track.gpx is a synthetic minimal GPX. GoPro fixture
TODO documented in tests/fixtures/README.md.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 3: Iteration 1 — dispatch all runs

(This task is interactive: it dispatches subagents and waits for results. It does not produce a commit by itself.)

- [ ] **Step 1: Set up workspace**

```bash
WS=~/repos/github.com/jaxx2104/exiftool-skill-workspace
mkdir -p "$WS/iteration-1"
```

- [ ] **Step 2: For each eval, dispatch with-skill and baseline subagents in parallel**

For eval N (e.g., eval 1: view-gps-single):

```
Task tool (general-purpose, no skill bound):
  description: "Eval 1 baseline (no skill)"
  prompt: |
    Execute this task: tests/fixtures/photo.jpg の GPS 座標教えて
    Save the final output and any artifacts to:
      $WS/iteration-1/eval-1-view-gps-single/without_skill/outputs/
    Save a transcript (your reasoning + commands run + final answer) to:
      $WS/iteration-1/eval-1-view-gps-single/without_skill/outputs/transcript.md
```

```
Task tool (general-purpose, with skill manually loaded):
  description: "Eval 1 with-skill"
  prompt: |
    Read skill: ~/repos/github.com/jaxx2104/exiftool-skill/skills/exiftool/SKILL.md
    Then execute: tests/fixtures/photo.jpg の GPS 座標教えて
    Save final output + transcript to:
      $WS/iteration-1/eval-1-view-gps-single/with_skill/outputs/
```

Repeat for evals 2..8, dispatching all 16 (8 × 2) subagents in the same controller turn so they run roughly in parallel.

- [ ] **Step 3: Capture timing from each notification**

For each subagent completion notification, write to that run's `timing.json`:

```json
{"total_tokens": <int>, "duration_ms": <int>, "total_duration_seconds": <float>}
```

- [ ] **Step 4: Write `eval_metadata.json` per eval**

```json
{
  "eval_id": 1,
  "eval_name": "view-gps-single",
  "prompt": "tests/fixtures/photo.jpg の GPS 座標教えて",
  "assertions": [
    {"text": "Output contains lat and lon values from photo.jpg"},
    {"text": "No write commands attempted (no '=' in any exiftool invocation)"},
    {"text": "Mentions Composite:GPSPosition is read-only OR uses raw GPSLatitude/GPSLongitude tags"}
  ]
}
```

(Repeat for evals 2..8 with task-appropriate assertions; see spec §9.2 for the assertion patterns matrix.)

---

## Task 4: Grade and aggregate

- [ ] **Step 1: Dispatch grader**

```
Task tool (general-purpose):
  description: "Grade iteration-1"
  prompt: |
    Read: ~/.claude/plugins/cache/superpowers-marketplace/superpowers/5.0.7/skills/requesting-code-review/agents/grader.md
    For each $WS/iteration-1/eval-<id>/<cfg>/ pair, evaluate the assertions
    in eval_metadata.json against the outputs/ directory.
    Write grading.json per run with the schema:
      {"expectations": [{"text": ..., "passed": bool, "evidence": "..."}, ...]}
```

- [ ] **Step 2: Aggregate**

```bash
SC=~/.claude/plugins/cache/anthropic-agent-skills/example-skills/d230a6dd6eb1/skills/skill-creator
cd "$SC"
python -m scripts.aggregate_benchmark "$WS/iteration-1" --skill-name exiftool
```

Produces `$WS/iteration-1/benchmark.{json,md}`.

- [ ] **Step 3: Open the eval viewer**

```bash
nohup python "$SC/eval-viewer/generate_review.py" "$WS/iteration-1" \
  --skill-name "exiftool" \
  --benchmark "$WS/iteration-1/benchmark.json" \
  > /dev/null 2>&1 &
```

- [ ] **Step 4: Tell the user**

> "I've opened the iteration-1 results in your browser. There are two tabs — Outputs lets you click through each test case and leave feedback, Benchmark shows the quantitative comparison. When you're done, come back here and let me know."

**This is the human-in-the-loop checkpoint.** Wait for the user to confirm.

---

## Task 5: Read feedback

- [ ] **Step 1: Read `$WS/iteration-1/feedback.json`**

```json
{
  "reviews": [
    {"run_id": "eval-1-with_skill", "feedback": "...", "timestamp": "..."},
    ...
  ]
}
```

- [ ] **Step 2: Categorize feedback**

For each review, decide:
- **Empty feedback**: user is satisfied; no change needed for this eval.
- **Specific complaint**: actionable; surfaces a gap in `references/tasks/<file>.md` or `safety.md` or a bundled helper.
- **Cross-cutting concern**: affects multiple evals; may indicate a SKILL.md body update.

---

## Task 6: Apply improvements and run iteration-2

- [ ] **Step 1: Edit skill content per feedback**

Each user complaint should map to one of:
- A `references/tasks/<file>.md` clarification or new `### Pattern:` block.
- A `references/safety.md` pitfall addition.
- A `scripts/<file>.sh` adjustment.
- A `SKILL.md` reference-map or critical-rule edit.

Commit each change separately with a message that cites the eval feedback.

- [ ] **Step 2: Re-run iteration-2**

Repeat T3 + T4 against `$WS/iteration-2/` (with-skill subagents only — baseline does not need re-running).

When opening the viewer, pass `--previous-workspace "$WS/iteration-1"` so the user sees previous-iteration outputs and feedback inline.

- [ ] **Step 3: Loop until plateau**

Keep iterating until:
- All feedback is empty in a given iteration, OR
- Improvements stop landing (token / pass-rate plateau across 2 consecutive iterations), OR
- The user says "good enough."

---

## Task 7: Commit final state + open Phase 3 PR

- [ ] **Step 1: Verify lint still passes**

```bash
tests/lint.sh
```

- [ ] **Step 2: Update CHANGELOG**

Add a "Phase 3 — evals iteration" section recording:
- The 8 evals that ran.
- Number of iterations to plateau.
- Summary of skill changes made in response to feedback (one bullet per
  eval that produced a change).

- [ ] **Step 3: Commit + push + PR**

```bash
git add CHANGELOG.md
git commit -m "docs: record Phase 3 evals iteration outcome"
git push -u origin phase-3-evals
gh pr create --title "Phase 3: Evals iteration" --body "..."
gh pr merge --squash --delete-branch
```

---

## Self-Review

**Spec coverage (§9):**

| Spec section | Plan task |
|--------------|-----------|
| §9.1 Initial 8 test cases | T1 |
| §9.2 Assertion patterns (per-eval) | T3 step 4 |
| §9.3 Iteration loop | T3, T4, T5, T6 |
| §9.4 Workspace layout | T3 step 1 |

**Out of scope (intentional):**
- Description optimization (Phase 4) is explicitly deferred.
- Marketplace registration (Phase 5) is explicitly deferred.

**Human-in-the-loop checkpoints (cannot be automated):**
- T4 step 4 (eval-viewer review)
- T5 step 2 (feedback interpretation occasionally needs the user)

**Placeholder scan:** no "TBD" / "TODO" remain. The GoPro fixture caveat in T2 step 4 is an explicit unresolved choice with three documented alternatives — the controller picks (b) for iteration-1.
