# Renaming and folder organization

This file covers renaming files based on metadata (typically capture
date), reorganizing into date-based folder hierarchies, and previewing
renames safely before committing.

## When this applies
Read this file when the user says things like:
- "rename by capture date"
- "organize into year/month/day folders"
- "what about duplicate filenames"
- "preview before running"

## Pre-flight checks
1. Rename is a write to `FileName` and `Directory` (filesystem ops, not
   metadata). Read `references/safety.md`.
2. **Always preview with `-TestName` before `-FileName` on bulk runs.**
3. By default, exiftool refuses to overwrite an existing file. Use
   collision-counter formats (`%%-c`) or `-overwrite_original` only with
   explicit confirmation.

## Common patterns

### Pattern: Rename one file by capture date
**Input**: "rename photo.jpg by date"
**Command**:
```sh
exiftool '-FileName<DateTimeOriginal' \
         -d '%Y%m%d_%H%M%S.%%le' photo.jpg
```
**Why**: `<` reads the value from a tag (`DateTimeOriginal`), `-d`
applies a date format, `%%le` lowercases the original extension (P-009).
Result: `photo.jpg` → `20240315_103022.jpg`.

### Pattern: Preview a bulk rename without renaming
**Input**: "show me what would happen first"
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
**Input**: "rename all by capture date"
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
**Input**: "split into year/month/day folders"
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
**Input**: "two shots in the same second"
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
**Input**: "name files like Make_Model_DateTime"
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
