---
generated_from: vendor/exiftool/html/metafiles.html
upstream_version: 13.59
upstream_commit: 2200871d
generated_at: 2026-06-01
do_not_edit: true
---

> **Auto-generated** from upstream exiftool documentation. Do not
> edit by hand — edits will be overwritten on next regeneration.
> To change wording, edit the corresponding file in
> `vendor/exiftool/html/` upstream or override behavior in
> `references/tasks/`.
Metadata Sidecar Files

[XMP Sidecar Files](#xmp)
  
[ExifTool XML Files](#xml)
  
[EXIF Files](#exif)
  
[MIE Files](#mie)
  
[EXV Files](#exv)

# Metadata Sidecar Files

Metadata for images and other file types may be stored in a separate metadata
file. These are the only files that exiftool can create from scratch. A common
example of this is the XMP "sidecar" file (which is discussed in the next
section in some detail). Other supported metadata file types are EXIF, MIE,
EXV, ICC and VRD. As well, ExifTool supports XML-format output, which can also
be used to generate metadata sidecar files.

---

### XMP Sidecar Files

There are a number of different ways to generate an XMP sidecar file with
exiftool, and the method you choose depends on your circumstances and
preferences. Below are a number of example commands which write an output XMP
file from information in a source file of any type.

1. Copy same-named tags from all information types to preferred locations in XMP:

(`SRC.EXT` is the source file name and
extension, and `DST` is the destination file name)

```
exiftool -tagsfromfile SRC.EXT DST.xmp
```

2. Rewrite source file to destination XMP file:

(same effect as above, but the command will exit with an error if the output XMP file already exists)

```
exiftool SRC.EXT -o DST.xmp
```

3. Copy XMP, preserving original locations:

(ie. copies XMP tags only to the same namespaces in the destination file)

```
exiftool -tagsfromfile SRC.EXT -all:all DST.xmp
```

Advanced: Notice that `-all:all` is used above instead of
`-xmp:all` even though only XMP tags will be copied (since the destination
is an XMP file). This is because `-all:all` preserves the family 1 group
(ie. XMP namespace) while `-xmp:all` would copy tags to the preferred XMP
namespace, which may be different for XMP tags that exist in multiple namespaces.
To get the best of both worlds, `"-all:all<xmp:all"` may be used to
avoid the inefficiencies of assigning tags which aren't copied, while still
preserving the family 1 group.

4. Rewrite source to XMP file, preserving locations:

(same effect as above, but the command will fail if the XMP file already exists)

```
exiftool SRC.EXT -o DST.xmp -all:all
```

5. Generate XMP from EXIF and IPTC using standard tag name mappings:

(the `.args` files are available in the full ExifTool distribution)

```
exiftool -tagsfromfile SRC.EXT -@ exif2xmp.args -@ iptc2xmp.args DST.xmp
```

6. Copy XMP as a block to an XMP file:

(writing as a block is the only way to transfer unknown or non-writable XMP tags)

```
exiftool -tagsfromfile SRC.EXT -xmp DST.xmp
```

Note that this will not deal with extended XMP segments in JPEG
images if they exist.

7. Extract XMP as a block and write to output XMP file: (same effect as above)

```
exiftool -xmp -b SRC.EXT > DST.xmp
```

As with the previous command, this command will not copy extended XMP
segments in JPEG images, but in this case the `-a` option may be
added to also extract extended XMP blocks. However, the result would be a
non-standard XMP file that ExifTool could read but other utilities may not.

8. Extract XMP as a block to an output text file with .xmp extension:

(same effect as above, but the destination file name will be the same
as the source file, and this command will fail if the XMP file exists while the
previous command will overwrite an existing file)

```
exiftool -xmp -b -w xmp SRC.EXT
```

The advantage of this command is that it may be applied to multiple
source files or entire directories.

9. Restore all XMP tags from an XMP sidecar file to XMP in a JPG image:

```
exiftool -tagsfromfile SRC.xmp -all:all DST.jpg
```

10. Restore XMP as a block from an XMP sidecar file to a JPG image:

(same effect as above except that any non-writable XMP tags would be
copied by this command, and the 2 kB of padding recommended by the XMP
specification is not added when copying as a block)

```
exiftool -tagsfromfile SRC.xmp -xmp DST.jpg
```

or equivalently

```
exiftool "-xmp<=SRC.xmp" DST.jpg
```

#### Batch Processing

Multiple files may be processed in a single command by specifying multiple
file and/or directory names on the command line. The examples below demonstrate
how to process all files with a specific extension in an entire directory tree.

11. Create XMP sidecar files for all files with extension EXT in a
directory tree:

(when batch-generating sidecar files from many images, the `-o`
form of the command is easier to use, but can not be used to modify
existing XMP files)

```
exiftool -ext EXT -o %d%f.xmp -r DIR
```

where `DIR` is the name of the directory containing
the images. The `-r` option causes sub-directories to be recursively
processed. Multiple `-ext` options may be used to process different
file types in a single command. With this command, same-named tags from any type
of metadata will be written to the preferred XMP namespace in the output XMP
file. To copy only XMP tags, `-xmp:all` may be added to the command.
(See example 14 for more about this.)

12. Copy tags to sidecar files that already exist:

(same as above, but copies only to existing XMP files)

```
exiftool -ext xmp -tagsfromfile %d%f.EXT -r DIR
```

This command will add tags from the source files to information that
already exists in the XMP files, but note that this command searches for the XMP
files instead of the image files, so it will not generate new XMP sidecar files
if some images don't have them. For this, the advanced (ie. tricky and
confusing to use) `-srcfile` option comes in handy:

13. Copy tags to sidecar files, generating new files if necessary:

(same as above, but also creates new XMP files if they don't exist)

```
exiftool -ext EXT -tagsfromfile @ -srcfile %d%f.xmp -r DIR
```

Note that as with the previous two commands, this command will
commute metadata from other groups to the preferred location in XMP.

14. Copy only XMP tags to the same namespace in sidecar files:

(same as above, but copies only XMP and preserves specific tag locations)

```
exiftool -ext EXT -tagsfromfile @ "-all:all<xmp:all" -srcfile %d%f.xmp -r DIR
```

In this command, if "`-xmp:all`" was used instead of
`"-all:all<xmp:all"`, then all XMP tags would have been copied to
their preferred namespaces in the sidecar file. But by writing to the
destination group of "`all`", the specific location (ie. XMP
namespace) of each tag is preserved.

15. Copy XMP from sidecar files back to the same locations in the source files:

(the inverse of the previous command)

```
exiftool -ext EXT -tagsfromfile %d%f.xmp -all:all -r DIR
```

Here,
`-all:all` copies all metadata (in this case only XMP, since the
sidecar XMP file contains no other types) to the same specific locations in the
target files (extension `EXT`).

16. Write a tag to XMP sidecar if it exists, or the original file otherwise:

```
exiftool -ext EXT -artist="Phil" -srcfile %d%f.xmp -srcfile @ DIR
```

When multiple `-srcfile` options are used, the first
existing file is processed. If none of the specified source files exists, then
the first one in the list is created (however, this won't happen with this
example since one of the specified source files is "`@`", which
represents the original file name).

17. Create XMP sidecar file in another directory:

```
exiftool -ext EXT -o DSTDIR/%f.xmp -r SRCDIR
```

By specifying a directory name instead of `%d`, this
command writes XMP files to `DSTDIR` instead of the original
source directory. The same technique may be used in any of the above commands to
write XMP to a sidecar file in a different directory.

#### Via the API

By specifying different tags in the
[SetNewValuesFromFile](https://exiftool.org/ExifTool.html#SetNewValuesFromFile)
call, the above examples numbered 1-6 are programmed like this:

> |  |
> | --- |
> | ``` $exifTool->SetNewValuesFromFile('SRC.EXT', @tags_to_copy); $exifTool->WriteInfo(undef, 'DST.xmp'); ``` |

and examples 7 and 8 use this general technique:

> |  |
> | --- |
> | ``` my $info = ImageInfo('SRC.EXT', 'xmp'); die "No XMP" unless $$info{XMP}; open FILE, '>DST.xmp'; print FILE ${$$info{XMP}}; close FILE; ``` |

---

### ExifTool XML Files

Closely related to the XMP sidecar file is the XML file written using the
exiftool `-X` option. This file is RDF/XML format like XMP, but uses
exiftool-specific namespaces to give an exact mapping for all exiftool tag
names. This type of file is better suited to general information
storage/recovery since it facilitates copying of more original metadata than an
XMP file, but it doesn't have the portability of an XMP file or the ability to
store native-format data like a MIE or EXV file, and ExifTool can not be used to
edit XML files as it can with other metadata files. Below are example commands
demonstrating the use of exiftool XML files.

Create an exiftool XML sidecar file:

```
exiftool -X a.jpg > a.xml
```

Restore original meta information from exiftool XML file:

```
exiftool -tagsfromfile a.xml -all:all a.jpg
```

The `-X` option also supports extracting binary data when
`-b` is added. For example, the above command may be modified to
also store the binary MakerNotes block like this:

```
exiftool -X -b -makernotes -all a.jpg > a.xml
```

Note that we needed to add `-makernotes` because it isn't
extracted as a block unless requested, and since we specified a tag to extract
we also needed to add `-all` to continue extracting other tags as
well. Restoring the original metadata from this file is the same as in the
previous example.

#### Via the API

There is no way to automatically produce a sidecar exiftool XML file via the
API since this function is accomplished with an output formatting option of the
exiftool application. However, the API may be used to read and copy tags
from an exiftool XML file just like any other file format. When reading
ExifTool XML files, all tags except those in the `ExifTool`,
`File` and `Composite` groups are extracted with their
original family 1 groups to facilitate copying of these tags back into their
original locations in an image.

---

### EXIF Files

EXIF files store EXIF information in the same TIFF-based format as the EXIF
APP1 segment of a JPEG image, but without the "Exif\0\0" header. The three
commands below illustrate techniques for copying the entire EXIF block from a
source image (`SRCFILE`) to an output EXIF file
(`out.exif`):

```
exiftool -exif -b SRCFILE > out.exif

exiftool -tagsfromfile SRCFILE -exif out.exif

exiftool -o out.exif -exif SRCFILE
```

The [Extra](tag-names/extra.md) EXIF tag used in each of the
above commands (the "`-exif`" argument) represents the EXIF metadata
in the form of a binary data block. JPEG, PNG, JP2, MIE and MIFF files all
support storage of EXIF data blocks in this format, although exiftool does not
currently write MIFF images.

Tags may also be copied individually to and from an EXIF file, but remember
that this will not copy "unsafe" tags unless they are specified explicitly. The
following command creates an EXIF file from the metadata in a source file:

```
exiftool -o out.exif -all -unsafe SRCFILE
```

This technique works for any type of source file, provided the file contains
at least one tag with the same name as an EXIF tag. Below is an example of how
to apply this to all files in a directory:

```
exiftool -o %d%f.exif -all -unsafe DIR
```

---

### MIE Files

The [MIE file format](MIE1.1-20070121.pdf) allows storage of
native binary meta information, and is the best option for saving metadata from
a file in its original format. Here are two examples that copy all individual
tags plus the ICC Profile to a MIE sidecar file:

```
exiftool -tagsfromfile a.jpg -all:all -icc_profile a.mie
```

```
exiftool -o a.mie -all:all -icc_profile a.jpg
```

And the following command performs the inverse operation, restoring metadata
in a JPG image from a MIE file:

```
exiftool -tagsfromfile a.mie -all:all -icc_profile a.jpg
```

Information can also be copied in block form to a MIE file. This allows
preservation of the original data structure as well as unknown and non-writable
tags. The command below copies the full EXIF segment as a block from a JPEG
image,

```
exiftool -tagsfromfile a.jpg -exif a.mie
```

which is functionally different from copying all writable EXIF tags
individually with a command more like this

```
exiftool -tagsfromfile a.jpg -exif:all a.mie
```

Block-writable tags are listed in the
[Extra Tags documentation](tag-names/extra.md).

MIE files also have the ability to store information in compressed format with
the `-z` option (provided Compress::Zlib is installed on your system),
which may be useful if disk space is at a premium.

---

### EXV Files

EXV files are used by [Exiv2](http://exiv2.org/), and are
basically a JPEG file without the image data, so they may be used as a metadata
file to contain any information supported by the JPEG format (EXIF, XMP, IPTC,
etc.). ExifTool has full read, write and create support for this format.

---

*Created Nov 12, 2008*  
*Last revised July 31, 2019*

[<-- Back to ExifTool home page](https://exiftool.org/index.html)
