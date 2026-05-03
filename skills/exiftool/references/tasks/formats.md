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
