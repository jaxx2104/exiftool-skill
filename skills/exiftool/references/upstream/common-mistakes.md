---
generated_from: vendor/exiftool/html/mistakes.html
upstream_version: 13.58
upstream_commit: 38bdbace
generated_at: 2026-05-11
do_not_edit: true
---

> **Auto-generated** from upstream exiftool documentation. Do not
> edit by hand — edits will be overwritten on next regeneration.
> To change wording, edit the corresponding file in
> `vendor/exiftool/html/` upstream or override behavior in
> `references/tasks/`.
Common ExifTool Mistakes

1. [Missing Duplicate Tags](#M1)
2. [Over-use of \*.\*](#M2)
3. [Over-scripting](#M3)
4. [Writing Multiple Tags](#M4)
5. [Redirecting Tags](#M5)

# Common Mistakes when using ExifTool

### 1. Missing Duplicate Tags

> By default, ExifTool will suppress duplicate tags in the output.
> Often this is desirable but sometimes one can be fooled into thinking
> that information doesn't exist when it is just hidden by another tag
> with the same name. For instance, the following command won't necessarily
> return all of the EXIF tags:
>
> ```
> exiftool -exif:all image.jpg
> ```
>
> To avoid this problem, use the `-a` option.

### 2. Over-use of Wildcards in File Names (eg. "`*.*`")

> It is often preferable to specify a directory name (eg. "`.`") instead
> of using wildcards (eg. "`*.*`") for a number of reasons:
>
> 1. "`*.*`" will process any file with a "." in the name. This includes files
>    that ExifTool should not normally process (like the "\_original" backup files for
>    example). By specifying a directory name instead, ExifTool will process only
>    supported file types. Or the `-ext` option may be used to process
>    specific file types.
> 2. "`*.*`" will process any **sub-directories** which contain "."
>    in the name. This may be unexpected.
> 3. The `-r` option (to recursively process sub-directories) is only
>    effective when a directory name is specified, so it doesn't work when
>    "`*.*`" is specified (unless the first-level directories have a "."
>    in the name, as mentioned in point b above).
> 4. Arguments like "`*.jpg`" are a problem on systems with
>    case-sensitive file names (like OS X and Linux) because JPG images with
>    uppercase extensions will be missed. It is better to avoid this problem and use
>    "`-ext jpg .`" to process all JPG images in the current directory
>    because this technique is case-insensitive.
> 5. This can be a security problem on systems where the shell automatically
>    expands wildcards (eg. Mac and Linux) because a malicious arrangement of file
>    names could potentially have unwanted effects since they may be interpreted as
>    ExifTool options (see [Security Issues](https://exiftool.org/index.html#security)).
> 6. There are problems using wildcards to match files with Unicode characters in
>    their names on Windows systems.

### 3. Over-scripting

> Often users write shell scripts to do some specific batch processing
> when the exiftool application already has the ability to do this either without
> scripting or with a greatly simplified script. This includes the ability to
> recursively scan sub-directories for a specific file extension (case insensitive),
> rename files from metadata values, and move files to different directories.

> For example, this Unix script (from
> [here](https://web.archive.org/web/20171223023104/http://www.tuxradar.com/answers/433)):
>
> ```
> find -name '*.jpg' | while read PIC; do
> DATE=$(exiftool -p '$DateTimeOriginal' $PIC |
> sed 's/[: ]//g')
> touch -t $(echo $DATE | sed 's/\(..$\)/\.\1/') $PIC
> mv -i $PIC $(dirname $PIC)/$DATE.jpg
> done
> ```
>
> may be replaced with this single command:
>
> ```
> exiftool -d %Y%m%d "-filename<datetimeoriginal" "-filemodifydate<datetimeoriginal#" -ext jpg -r .
> ```
>
> Running as a single command is much faster because the startup time of loading
> ExifTool is significant.

### 4. Writing/Copying Multiple Tags

> Any number of tags may be specified on a single command line, but
> often people execute a separate command to write or copy each tag, which is very
> inefficient. Combining all of the tag assignments into a single command avoids
> the significant overhead of launching exiftool for the subsequent commands. For
> example:
>
> ```
> exiftool -artist=phil -modifydate=now -tagsfromfile %d%f.xmp -xmp:title -xmp:description -ext jpg c:\images
> ```
>
> The `-@` option may be used to read command-line arguments from a
> file, and may be useful in situations where there are a large number of
> arguments.

### 5. Errors and Inefficiencies when Redirecting Tags

> The syntax to redirect tags when copying is `"-DSTTAG<SRCTAG"`,
> but the syntax also allows a string containing tag names (prefixed by `$`)
> to be used in place of `SRCTAG`. Three **common mistakes** when using this
> syntax are:
>
> 1. Adding a leading "`-`" before the `SRCTAG`. (eg.
>    `"-EXIF:Artist<-XMP:Creator"`) This is **wrong**, and the tag will
>    not be copied. (It should be `"-EXIF:Artist<XMP:Creator"`.)
> 2. Adding a leading "`$`" when copying a simple tag. (eg.
>    `"-comment<$filename"`). This is usually not necessary *(see
>    exception below)* and it is less efficient for ExifTool to process the source
>    string than it is to copy the tag directly. Also, values of list-type and
>    shortcut tags are concatenated in the string rather than being copied
>    individually, and wildcards are not allowed. Another difference is that a minor
>    warning is generated if a tag doesn't exist when interpolating its value in a
>    string (with "`$`"), but isn't when copying the tag directly.
> 3. Using "`=`" instead of "`<`" to copy a tag, or
>    using "`<`" instead of "`=`" to assign a value.
>
>    |  |
>    | --- |
>    | "`<`" is used for copying, in which case the source (right-hand-side) operand is interpreted as either 1. a tag name (if the operand does not contain a "`$`" symbol), or 2. a string containing tag names prefixed by "`$`" symbols (if the operand contains a "`$`" symbol)."`=`" is used to assign a simple tag value, and the source operand is a string that is written directly to the destination tag.  (And the combination "`<=`" is used to assign a tag value from the contents of a file.) |
>
> An exception to rule "b" above occurs when trying to copy the value of one tag
> to a group of different tags, for example:
>
> ```
> exiftool "-time:all<datetimeoriginal" FILE  (WRONG!)
> ```
>
> The above command doesn't work because the destination tag name of "All" writes
> to the tag with the same name as the source (ie. only "DateTimeOriginal"). However,
> when interpolated in a string the identity of the source tag is lost, so the
> following command will write to all tags in the Time group:
>
> ```
> exiftool "-time:all<$datetimeoriginal" FILE
> ```
>
> (Note that single quotes would be necessary in the above command under Mac/Linux.)

---

*Last revised Mar 11, 2021*

[<-- Back to ExifTool home page](https://exiftool.org/index.html)
