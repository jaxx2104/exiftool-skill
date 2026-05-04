---
generated_from: vendor/exiftool/html/filename.html
upstream_version: 13.57
upstream_commit: dae9b7a8
generated_at: 2026-05-04
do_not_edit: true
---

> **Auto-generated** from upstream exiftool documentation. Do not
> edit by hand — edits will be overwritten on next regeneration.
> To change wording, edit the corresponding file in
> `vendor/exiftool/html/` upstream or override behavior in
> `references/tasks/`.
FileName and Directory tags

## Writing "FileName" and "Directory" tags

By writing the **FileName** and/or **Directory** pseudo tags, ExifTool
can be used to rename and/or move images into directories according to any
information contained in the image. This is a powerful feature when combined
with the `-tagsFromFile` ability to copy the values from other tags.
The most common use of this feature is to organize images by date/time, but any
other tag value may also be used.

Writing the **Directory** tag moves a file to a specified directory. The
directory is created if it doesn't already exist.

Writing the **FileName** tag renames a file. If the new **FileName**
has a directory specification (ie. contains a '`/`' character), then
the file is also moved to the specified directory (see
[example 6](#ex6) below), and the directory is created if necessary.
Existing files will not be overwritten (but see "Warning" below).

The write-only **TestName** tag provides a mechanism for dry-run testing
of the rename feature. Writing **TestName** displays the old and new names
without making any changes to the files. (Note that there is no corresponding
test tag for **Directory**, but **TestName** supports a full path name
just like **FileName**, so the directory may be tested as well.)

When writing the **FileName**, **Directory** or **TestName** tag,
`%d`, `%f` and `%e` may be used to represent
the directory, name and extension of the original file (in a similar way to the
`-o`, `-w` and `-tagsFromFile` options). Also,
`%c` may be used to add a copy number to the output file name to
avoid collisions with existing file names. Note that these codes must be escaped
with an extra `%` if used within a date format string. Modifiers may
also be used to change the default behaviour of these format codes. See the
`-w` option in the [application
documentation](https://exiftool.org/exiftool_pod.html) for details.

When organizing files by date/time, the `-d` (date format) option
is essential for specifying a format for the date/time tag(s) used to generate
the new file and/or directory name. The examples below demonstrate the use of
this feature. Also, a list of of [common date format codes](#codes)
is provided for reference.

> **Advanced feature:** The write-only
> **HardLink** tag may be written using a technique similar to **FileName**.
> Instead of renaming or moving the file, writing **HardLink** creates a hard
> link with the specified name. This feature allows files to be organized without
> affecting the originals. See the [Extra Tags
> documentation](tag-names/extra.md) for more information.

### Notes:

Writing the **FileName** and/or **Directory** tags alone causes the
file to be renamed or moved, not copied. However, if any "real" tags are
written at the same time, then the file is rewritten to the new destination and
the original file is left unchanged. (Only writable system tags may be set
without causing the file to be rewritten.) If desired, the
`-overwrite_original` option may be used to remove the original copy
when the file is rewritten.

Conversely, the `-o` option may be used to force exiftool to
always create a copy of the file, even if no meta-information tags are written.
This is true even if the `-o` option is superseded by writing the
**Directory** tag, or through a **FileName** which includes a directory
specification. (See [example 5](#ex5) below. Also see
[example 11](#ex11) for the directory precedence rules.)

If the `-d` option is used, the unformatted date/time value must
be valid (ie. in the form "`YYYY:mm:dd HH:MM:SS`"), otherwise the
date formatting will fail and the file will not be renamed or moved (but this may
be changed via the [API StrictDate option](https://exiftool.org/ExifTool.html#StrictDate)).

Also note that the `-d` formatting applies to date/time tags used
in `-if` conditions unless the print conversion is disabled by adding
a `#` suffix to the tag name.

In a Windows batch file, all `%` characters must be escaped as
`%%`. This can result in extreme format codes like
`%%%%f` when using the `-d` option.

> **Warning:**
> Writing **illegal file names** in Windows can have unpredictable results and
> may result in **data loss**. Illegal characters in Windows file names are:
>
> ```
>     / \ ? * : | " < >
> ```
>
> Any tag used in generating a file name which may contain these characters must
> first be filtered to remove or translate these characters. A special feature
> allows these characters to be removed from a tag value by adding a semicolon
> inside the braces after a tag name. For example:
>
> ```
>     exiftool "-filename<${model;}.%e" c:\images
> ```
>
> This advanced formatting feature may also be used to do arbitrary reformatting
> of any tag value used in a format string. See the `-p` option in the
> [application documentation](https://exiftool.org/exiftool_pod.html) for more details.

## Examples

|  |  |
| --- | --- |
| 0. | `exiftool -d %Y%m%d_%H%M%%-c.%%e "-testname<CreateDate" DIR` |

> The **TestName** tag is used for dry-run testing of the file renaming
> feature. The above command is identical to that of the next example except that
> **TestName** is written instead of **FileName**. So instead of renaming
> the files, this command prints the old and new file names without actually
> changing anything. For example:
> > ```
> > > exiftool -d %Y%m%d_%H%M%%-c.%%e "-testname<CreateDate" tmp
> > 'tmp/a.jpg' --> 'tmp/20031031_1544.jpg'
> > 'tmp/b.jpg' --> 'tmp/20010519_1836.jpg'
> >     1 directories scanned
> >     0 image files updated
> >     2 image files unchanged
> > ```

|  |  |
| --- | --- |
| 1. | `exiftool -d %Y%m%d_%H%M%%-c.%%e "-filename<CreateDate" DIR` |

> Rename all images in directory '`DIR`' to names like
> '`20060327_1058-2.jpg`', with individual file names derived from the
> value of the CreateDate (plus a copy number with a leading '`-`' if a
> file with the same name already exists), and with the same extension as the
> original image. *[Note that copying tag values with '`<`' implies
> '`-tagsfromfile @`' unless otherwise specified. See the
> `-tagsFromFile` description in the
> [application documentation](https://exiftool.org/exiftool_pod.html) for details.]*
>
> **FAQ:** *"Why doesn't this command rename my files?"*
>
> There are 2 common reasons for this:
>
> a) When a directory name is specified, this command will only rename "writable"
> files in the directory. Use '`exiftool -listwf`' to list the
> extensions of currently writable file types. The `-ext` option may
> be used to rename other file types (eg. '`-ext avi`').
>
> b) For this command to work, the CreateDate tag must exist in the source
> file. Use '`exiftool -createdate FILE`' to see if a file contains
> this information. If it doesn't, you may need to use another date/time tag such
> as DateTimeOriginal or FileModifyDate. To see all available date/time tags in a
> file (and their locations), use '`exiftool -a -G1 -s -time:all FILE`'.

|  |  |
| --- | --- |
| 2. | `exiftool -d %Y-%m-%d "-directory<datetimeoriginal" image.jpg` |

> Move '`image.jpg`' into a directory with a name given by
> DateTimeOriginal, in the form '`2006-03-27`'.

|  |  |
| --- | --- |
| 3. | `exiftool '-filename<%f_$imagesize.%e' dir` |

> This example uses an expression to add the image size to the name of all images
> in directory '`dir`'. For example, this would rename a 640x480 image
> called '`image.jpg`' to '`image_640x480.jpg`'. (Note that
> the single quotes are necessary in Unix shells due to the '`$`'
> symbol, but double quotes must be used instead when running in a Windows cmd shell.)

|  |  |
| --- | --- |
| 4. | `exiftool -r -directory=%e_images/%d pics` |

> Recursively move all images based in directory '`pics`' to
> separate directory trees organized by file extension. For instance, in this
> example the file '`pics/toys/new_car.jpg`' is moved to
> '`jpg_images/pics/toys/new_car.jpg`'.

|  |  |
| --- | --- |
| 5. | `exiftool -r -o %e_images/%d pics  exiftool -r -o . -directory=%e_images/%d pics` |

> Both of these commands have the same effect as example 4 above except that
> images are copied instead of moved since the `-o` option was used.
> The output directory specified by the `-o` option is overridden in
> the second example by writing the Directory tag. This technique of using
> `-o` with a dummy directory name is necessary when you want the files
> to be copied instead of moved and the directory name is derived from the value
> of other tags (eg. '`-directory<createDate`'). (Because the
> values of other tags may not be used with the `-o` option.)

|  |  |
| --- | --- |
| 6. | `exiftool -r -d %Y/%m/%d/image_%H%M%S.%%e "-filename<filemodifydate" DIR` |

> Recursively rename all images in '`DIR`' and any contained
> subdirectories to the form '`image_HHMMSS.EXT`' (where
> '`ext`' is the original file extension), and move them into a new
> directory hierarchy based on date of file modification, with path names like
> '`2006/03/27/image_105859.jpg`'.

The following examples demonstrate the interaction of this feature with
other ExifTool options:

|  |  |
| --- | --- |
| 7. | `exiftool -filename=new.jpg dir/image.jpg` |

> Rename '`dir/image.jpg`' to '`dir/new.jpg`'.

|  |  |
| --- | --- |
| 8. | `exiftool -filename=new.jpg -comment=xxx dir/image.jpg` |

> Copy '`dir/image.jpg`', add a new comment, and write output to
> '`dir/new.jpg`'. The original file '`dir/image.jpg`' is
> not changed.

|  |  |
| --- | --- |
| 9. | `exiftool -filename=new.jpg -comment=xxx -overwrite_original dir/image.jpg` |

> Rewrite '`dir/image.jpg`', adding a new comment and writing output to
> '`dir/new.jpg`'. The original file '`dir/image.jpg`' is
> removed.

|  |  |
| --- | --- |
| 10. | `exiftool -o tmp/ -filename=new.jpg image.jpg  exiftool -o tmp/xxx.jpg -filename=new.jpg image.jpg  exiftool -o tmp/new.jpg image.jpg` |

> A file name or directory specified via the **FileName** or **Directory**
> tag takes precedence over that specified by the `-o` option, so these
> three commands all have the same effect: '`tmp/new.jpg`' is created
> without changing '`image.jpg`'. Note that in the first command, the
> trailing '`/`' on '`tmp/`' is necessary if the
> '`tmp`' directory doesn't already exist, otherwise '`tmp`'
> would be taken as a file name and '`new.jpg`' would be created in the
> current directory. As illustrated in example 4 above, the file is rewritten
> instead of simply being renamed when the '`-o`' option is used.

|  |  |
| --- | --- |
| 11. | `exiftool -directory=dir1 -filename=dir2/out.jpg -o dir3/ dir4/image.jpg` |

> This example demonstrates the priorities of directory names specified using
> different techniques. The output directory is taken from the first directory
> specified from the following list: 1) the **Directory** tag, 2) the
> directory part of the **FileName** tag, 3) the directory part of the
> `-o` option, or 4) the source directory, in that order. The order of
> the arguments on the command line is not significant. In this example, the
> target file is copied (not moved, because the `-o` option was used)
> to '`dir1/image.jpg`'.

> Note that both the **FileName** tag and the `-o`
> option may be used without a directory specification, in which case the
> directory with the next highest priority is used. Also note that if
> `-o` specifies a directory, then the directory name must end with a
> '`/`' or the directory must already exist, otherwise ExifTool will
> interpret the last part as a file name. (eg. '`-o images/test`'
> specifies the '`images`' directory unless the
> '`images/test`' directory already exists, while '`-o
> images/test/`' unambiguously specifies the '`images/test`'
> directory.)

|  |  |
| --- | --- |
| 12. | `exiftool -d %Y/%m "-directory<filemodifydate" "-directory<createdate" "-directory<datetimeoriginal" .` |

> Move image files from the current directory (`.`) into a
> directory hierarchy based on year/month. In this command the Directory tag is
> set from multiple other date/time tags. ExifTool evaluates the command-line
> arguments left to right, and latter assignments to the same tag override earlier
> ones, so the Directory for each image is ultimately set by the rightmost copy
> argument that is valid for that image. Specifically, Directory is set from
> DateTimeOriginal if it exists, otherwise CreateDate if it exists, and finally
> FileModifyDate (which always exists) is used as a fallback.

|  |  |
| --- | --- |
| 13. | `exiftool -d %Y '-filename<$createdate/${model;}/${createdate#;DateFmt("%Y-%m-%d_%H%M%S")}.%e' pics` |

> Multiple date/time formatting codes become necessary when other
> tags are place between date/time fields. The `DateFmt` helper
> function is provided for this reason, and is applied to the unformatted tag
> value (ie. tag name ending with '`#`') to achieve a different
> date/time formatting in the same string. (Note that the single quotes are
> necessary in Unix shells due to the '`$`' symbol, but double quotes
> must be used instead when running in a Windows cmd shell.)

## Common Date Format Codes

Date format codes are used in the argument to the `-d` option to
represent components of the date/time string. The codes listed below are common
to most systems, but additional codes may be available on your specific system
-- see your *strftime* man page for details. The default EXIF date/time
formatting is equivalent to '`%Y:%m:%d %H:%M:%S`'.

> |  |  |
> | --- | --- |
> | %a | - abbreviated locale weekday name |
> | %A | - full locale weekday name |
> | %b | - abbreviated locale month name |
> | %B | - full locale month name |
> | %c | - preferred locale date/time representation |
> | %d | - day of month (01-31) |
> | %f | - fractional seconds (see note 1 below) |
> | %H | - hour on a 24-hour clock (00-23) |
> | %I | - hour on a 12-hour clock (01-12) |
> | %j | - day of year (001-366) |
> | %m | - month number (01-12) |
> | %M | - minute (00-59) |
> | %p | - 'AM' or 'PM' |
> | %s | - number of seconds since the Epoch, UTC (see note 2 below) |
> | %S | - seconds (00-59) |
> | %w | - weekday number (0-6) |
> | %W | - week number of the year (00-53) |
> | %x | - preferred locale date representation |
> | %X | - preferred locale time representation |
> | %y | - 2-digit year (00-99) |
> | %Y | - 4-digit year (eg. 2006) |
> | %z | - time zone in the form +/-hhmm (see note 2 below) |
> | %Z | - system time zone name (see note 3 below) |
> | %% | - a literal '%' character |

ExifTool file name format codes may be used inside a date format
string when a date/time tag is used to set the value of the **FileName** or
**Directory** tags via the command-line interface. In this case, an extra
'`%`' must be added to pass the format code through the date/time
parser:

> |  |  |
> | --- | --- |
> | %%d | - original file directory (including trailing "/" if necessary) |
> | %%f | - original file name (without the extension) |
> | %%e | - original file extension (not including the ".") |
> | %%c | - copy number (output files only) |

See the `-w` option in the [exiftool
application documentation](https://exiftool.org/exiftool_pod.html) for details about special features available
with these name format codes.

**Notes:**

1. The `%f` format code is an ExifTool-specific enhancement and
   supports an optional number of digits after the decimal point. For example,
   `%3f` gives fractional seconds with 3 digits (eg. ".123").
   `%f` alone returns an empty string if the date/time contains no
   subseconds. A "`-`" may be added to drop the decimal (eg.
   `%-3f` would give "123"). The value is rounded to the specified
   number of digits, and the date/time value is incremented by one second if the
   rounding would overflow to the next second, even if the number of decimal digits
   is zero (ie. `%0f`). Without `%f`, the fractional seconds
   are simply discarded and no rounding is performed.
2. The `%s` and `%z` format codes use the time zone
   specified by the date/time value. If the date/time value does not include a
   time zone specification, then it is interpreted as a local time in the system
   time zone. `%z` returns the time zone in the format "-0500", and
   adding a colon to the format specifier (ie. `%:z`) adds a colon to
   the returned time zone (eg. "-05:00"). These format codes are parsed by
   ExifTool, so they should work on all systems.
3. The `%Z` format code ignores any time zone specified in the
   date/time value, and returns the system time-zone name for the given date/time
   interpreted as a local system time.

---

[<-- Back to ExifTool home page](https://exiftool.org/index.html)
