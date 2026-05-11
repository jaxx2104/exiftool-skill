---
generated_from: vendor/exiftool/html/faq.html
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
ExifTool FAQ

1. [Discussion forum](#Q1)
2. [Determining tag names](#Q2)
3. [ExifTool doesn't read/write properly](#Q3)
4. [Aperture and shutter speed](#Q4)
5. [Date and time formats](#Q5)
6. ["Can't convert TAG" errors](#Q6)
7. [Deleting all EXIF from a TIFF](#Q7)
8. [Writing Make, Model & MakerNotes](#Q8)
9. [Tag locations when copying](#Q9)
10. [Coded character sets](#Q10)
11. [User-defined tags](#Q11)
12. [Export to database](#Q12)
13. [Output file size and image quality](#Q13)
14. [GPS coordinate format](#Q14)
15. [MakerNote errors](#Q15)
16. [Some files not renamed](#Q16)
17. [List-type tags](#Q17)
18. [Windows character encoding](#Q18)
19. [Formatting tag values](#Q19)
20. [Write errors (repair corrupted EXIF)](#Q20)
21. [Newlines in values](#Q21)
22. [Order of operations](#Q22)
23. ["0 image files updated"](#Q23)
24. [Date/time gets reset to today](#Q24)
25. [Image validation](#Q25)
26. [Import from database](#Q26)
27. [Windows .BAT file problems](#Q27)
28. [Copying a shifted date/time](#Q28)
29. [ARGFILE options](#Q29)
30. [Extracting all metadata](#Q30)
31. [Rewriting the entire file](#Q31)
32. [Safely removing all metadata](#Q32)
33. [No writable tags set from <file>](#Q33)

# ExifTool FAQ

1. **"Is there a forum for discussing ExifTool issues?"**

> ExifTool issues can be discussed on the ExifTool forum at
> <https://exiftool.org/forum/>

2. **"How do I determine the tag name for some information?"**

> When you run exiftool, by default it prints descriptions, not tag
> names, for the information it extracts. These descriptions are in English
> unless the `-lang` option is used to select another language. Note
> that descriptions often contain spaces between words, but tag names never do.
> Also, tag names are always English, regardless of the `-lang`
> setting. To print the tag names instead instead of descriptions, use the
> `-s` option when extracting information. eg)
>
> ```
> exiftool -s image.jpg
> ```
>
> Valid characters in tag names are `A-Z`, `a-z`,
> `0-9`, `_` and `-`. See the
> [tag name documentation](https://exiftool.org/TagNames/index.html) for a complete list of
> available tag names.

> Tag names may be optionally prefixed by a group name to specify a
> particular information type or location. Use the `-g0`,
> `-g1`, etc (or `-G0`, `-G1`, etc) options when
> extracting information to see the corresponding group names. See the [Tag Groups](https://exiftool.org/index.html#groups) section of the ExifTool home page for
> more information.

3a. **"ExifTool reports the wrong value or doesn't extract a tag"**,
  
3b. **"ExifTool doesn't write a tag properly"**, or
  
3c. **"Other software can't read information written by ExifTool"**

> *[Also see [FAQ number 23](#Q23) for reasons why
> ExifTool may not write some tags to certain file types.]*

> First, if ExifTool says "image files updated", then some information
> was written. Make sure you are looking at the right information. Use ExifTool
> with a command like this to extract all information from the file, along with
> the location it was written:
>
> ```
> exiftool -a -G1 -s c:\images\test.jpg
> ```
>
> In this command, `-a` allows duplicate tags to be extracted,
> `-G1` shows the family 1 group name (ie. the location) of each tag,
> and `-s` shows the tag names instead of their descriptions.
> (Substitute the path name of your file in place of
> "`c:\images\test.jpg`".)

> When duplicate tags exist, only one is extracted unless the
> `-a` option is used. Beware that options like `-EXIF:all`
> select all EXIF tags from the extracted tags, so EXIF tags hidden by duplicate
> tags in other locations will not appear in the output for
> `-EXIF:all`. For example, the command
>
> ```
> exiftool -gps:all image.jpg
> ```
>
> will NOT necessarily extract all EXIF GPS tags because some may have been
> suppressed by same-named tags in other groups. To be sure all EXIF GPS tags are
> extracted, the `-a` option must be used:
>
> ```
> exiftool -a -gps:all image.jpg
> ```
>
> *[But note that GPS information may be stored in metadata formats
> other than just EXIF, so restricting the command to the EXIF "GPS" group may
> miss GPS information in other formats. The following command is better suited
> to extract all GPS from a wide variety of file formats:]*
>
> ```
> exiftool -a "-gps*" -ee video.mp4
> ```
>
> If you are having problems with other software reading information written by
> ExifTool, if possible try first writing the information from the other software,
> then use ExifTool (with the `-a` and `-G1` options) to
> determine where the information was written. Once you know where it should go,
> you can use ExifTool to write to this location. You can read or write
> information in a specific location by prefixing the tag name on the command line
> with the desired group name. eg.) "`-ExifIFD:DateTimeOriginal`"

> This problem may also occur if contradictory information exists in
> different meta information formats within the same file. For example, often XMP
> will be ignored if IPTC exists and the Photoshop:IPTCDigest does not agree with
> the IPTC content. The
> [Metadata Working Group](https://web.archive.org/web/20181006115950/http://www.metadataworkinggroup.org/specs/)
> recommends techniques to keep the EXIF, IPTC and XMP metadata synchronized.
> These recommendations are implemented by the ExifTool
> [MWG tags](https://exiftool.org/TagNames/MWG.html). For maximum compatibility with the
> widest range of applications, it is suggested that these MWG tags be used
> whenever possible.

> One final note: When writing, the `-v2` option may be
> useful because it provides details about what ExifTool is writing, and where.

4. **"ExifTool reports more than one shutter speed or aperture value, and
they are slightly different"**

> There are a number of different ways that aperture and shutter speed information
> are stored in many images. The standard EXIF values (EXIF:FNumber and
> EXIF:ExposureTime) should correspond to the values displayed by your camera, but
> these values may have been rounded off by the camera and/or ExifTool. (You can
> use the `-n` option to avoid rounding by ExifTool and show the full
> value in decimal form.) The corresponding EXIF APEX values (EXIF:ApertureValue
> and EXIF:ShutterSpeedValue) may be different due to their own round-off errors.
> If available, the MakerNotes values may be the most accurate because they
> haven't been rounded off to nice even values for display, so with these you may
> see odd values like 1/102 instead of 1/100, etc.

5. **"How do I format date and time information for writing?"**

> All information (including date/time information) is written in the
> same format as it is read out. When reading, ExifTool converts all date and
> time information to standard EXIF format, so this is also the way it is
> specified when writing. The standard EXIF date/time format is
> "`YYYY:mm:dd HH:MM:SS`", and some meta information formats such as
> XMP also allow sub-seconds and a timezone to be specified. The timezone format
> is "`+HH:MM`", "`-HH:MM`" or "`Z`". For
> example:
>
> ```
> exiftool -xmp:dateTimeOriginal="2005:10:23 20:06:34.33-05:00" a.jpg
> ```
>
> When writing XMP or other information types which allow incomplete date/time
> values, the following input formats are also accepted:
>
> ```
> YYYY
> YYYY:mm
> YYYY:mm:dd
> YYYY:mm:dd HH:MM
> ```
>
> Having said this, ExifTool is very flexible about the actual format of input
> date/time values when writing, and will attempt to reformat any values into the
> standard format unless the `-n` option is used. Any separators may
> be used (or in fact, none at all). The first 4 consecutive digits found in the
> value are interpreted as the year, then next 2 digits are the month, and so on.
> *[The year must be 4 digits. Other fields are expected to be 2
> digits, but a single digit is allowed if the subsequent character is a
> non-digit.]* For EXIF date/time values, all 6 date/time fields must exist
> ("`YYYYmmddHHMMSS`"), but XMP date/time values require only the year
> ("`YYYY`"). This feature facilitates useful operations such as
> setting date/time tags from a date embedded in the file name. For example, the
> command
>
> ```
> exiftool "-alldates<filename" c:\images
> ```
>
> will set the common date/time tags from the file name for all images in the
> directory "`c:\images`". This will work for any file name which
> matches the above criteria (eg. "IMG\_20110927\_103000.jpg").
> *[AllDates is a shortcut for 3 tag names: DateTimeOriginal,
> CreateDate and ModifyDate. See the [Shortcuts
> Tags documentation](https://exiftool.org/TagNames/Shortcuts.html) for more information.]*

> The `-d` option provides additional flexibility in
> parsing strings when writing date/time tags with ExifTool 10.32 or later if
> POSIX::strptime or Time::Piece is installed (use "`exiftool -ver -v`"
> to check the installed packages). The format of the `-d` argument is
> the same for reading and writing.

> The `-n` option may be used to disable all of the
> date/time reformatting when reading and writing which will allow otherwise
> invalid date/time values to be written (eg. partial EXIF dates). The
> reformatting may be disabled on a per-tag basis by adding "`#`"
> to the tag name instead of using `-n`

> **Special feature**: A value of "`now`" may be used to
> represent the current time when writing any date/time tag. For example:
>
> ```
> exiftool -xmp:dateTimeOriginal=now a.jpg
> ```
>
> *[There is also a [Now tag](tag-names/extra.md) which may
> be used for a similar purpose by copying its value to another tag, but copying
> tags adds an extra read stage to the processing which is best avoided if
> performance is an issue.]*

6. **"I get '`Can't convert TAG (not in PrintConv)`' errors when
writing a tag"**

> By default, ExifTool applies a print conversion (PrintConv) to extracted
> information to make the output more human-readable. Some conversions involve
> lookup tables which are documented in the **Values** column of the
> [tag name documentation](https://exiftool.org/TagNames/index.html). For example, the
> GPSAltitudeRef tag defines the following conversions:
>
> ```
> 0 = Above Sea Level
> 1 = Below Sea Level
> ```
>
> For this tag, a value of '0' is printed as 'Above Sea Level', and '1' is printed
> as 'Below Sea Level'. Reading and writing with ExifTool is symmetrical *[with
> the possible exception of list-type tags -- see [FAQ number 17](#Q17)
> below]*, so a value that is printed as 'Above Sea Level' must also be written in
> that form. (In other words, the inverse print conversion is applied when writing
> values.) For example, to write GPSAltitudeRef you can type:
>
> ```
> exiftool -gpsaltituderef="Above Sea Level" image.jpg
> ```
>
> or any unambiguous short form may be used and ExifTool will know what you mean, eg)
>
> ```
> exiftool -gpsaltituderef=above image.jpg
> ```
>
> Alternatively, the print conversion can be disabled for all tags with the
> `-n` option, or for individual tags by suffixing the tag name with a
> '`#`' character. In either case the printed value of GPSAltitudeRef
> will be '0' or '1' when extracting information, and the value is written in the
> same way. So following two commands have exactly the same effect as above:
>
> ```
> exiftool -gpsaltituderef=0 -n image.jpg
> exiftool -gpsaltituderef#=0 image.jpg
> ```
>
> Integer values may also be specified in hexadecimal (with a leading '0x'). For
> example, the following commands are all equivalent:
>
> ```
> exiftool -flash=1 -n image.jpg
> exiftool -flash=0x1 -n image.jpg
> exiftool -flash#=1 image.jpg
> exiftool -flash#=0x1 image.jpg
> exiftool -flash=fired image.jpg
> ```

> **Programmers**: These techniques look like this when calling Image::ExifTool
> functions from a Perl script:
>
> ```
> $exifTool->SetNewValue(flash => 1, Type => 'ValueConv');
> $exifTool->SetNewValue(flash => 0x1, Type => 'ValueConv');
> $exifTool->SetNewValue('flash#' => 1);
> $exifTool->SetNewValue('flash#' => 0x1);
> $exifTool->SetNewValue(flash => 'fired');
> ```

7. **"I can't delete all EXIF information from a TIFF file using
'`exiftool -exif:all= img.tif`'"**

> This is because of the way a TIFF file is structured. With a JPEG
> image, this command removes IFD0 (the main Image File Directory) as well as any
> subdirectories, thus removing all EXIF information. But with the TIFF format,
> the main image itself is stored in IFD0, so deleting this directory would
> destroy the image. The same is true for any TIFF-based RAW file such as DNG,
> CR2, NEF, etc. For these types of files, ExifTool just deletes the ExifIFD
> subdirectory, so any information stored in other directories is preserved (BUT
> NOTE THAT WITH PROPRIETARY RAW FORMATS THIS MAY DELETE INFORMATION THAT IS
> NECESSARY FOR PROPER RENDERING OF THE IMAGE).

> Use "`exiftool -a -G1 -s img.tif`" to see where the
> information is stored. Any tags remaining in other IFD's must be deleted
> individually from a TIFF-format file if desired. For convenience, a CommonIFD0
> [shortcut tag](https://exiftool.org/TagNames/Shortcuts.html) is provided to simplify the
> deletion of common metadata tags from IFD0 by adding "`-CommonIFD0=`"
> to the command line.

8a. **"All maker note information is lost if I change the Make or Model tag"**, or
  
8b. **"I can't copy maker note information to an image"**, or
  
8c. **"I can't view a RAW image after changing the model tag"**

> The Make and Model tags are used by some image utilities (including ExifTool) to
> determine the format of the maker note information. Deleting or changing either
> of these tags may prevent these utilities from recognizing or properly
> interpreting the maker notes (which, for a RAW image, may mean that the image
> can no longer be properly rendered). Also beware that the maker notes
> information may be damaged if an image is edited when the maker notes are not
> properly recognized. So it is a good idea not to edit the Make and Model tags in
> the first place.

> If you really want to delete the Make and Model information, you
> might as well delete the maker notes too. You can do this with either of the
> following commands:
>
> ```
> exiftool -make= -model= -makernotes:all= image.jpg
> exiftool -make= -model= -makernotes= image.jpg
> ```
>
> For the same reason, maker notes can not be copied to an image with an
> incompatible Make or Model. To do this, the Make and Model tags must also be
> copied. eg)
>
> ```
> exiftool -tagsfromfile src.jpg -makernotes -make -model dst.jpg
> ```
>
> (Note that in this case the "`-makernotes:all`" syntax does not work
> because it attempts to copy the maker note tags individually. Since maker note
> tags may not be created individually, they must instead be copied as a block
> with "`-makernotes`".)

9a. **"The information is different when I copy all tags to a new file"**, or
  
9b. **"The tag locations change when I use `-tagsfromfile`
to copy information"**

> This feature is explained under the `-tagsFromFile` option in
> the [exiftool application documentation](https://exiftool.org/exiftool_pod.html), but the
> question is common enough that it is discussed here in more detail.

> By default, ExifTool will store information in preferred locations
> when either writing new information or copying information between files. This
> freedom allows ExifTool to write or copy information to files of different
> formats without requiring the user to know details about where the information
> is stored.

> The preferred general locations for information written to JPEG
> images are 1) EXIF, 2) IPTC and 3) XMP. As an example, information extracted
> from the maker notes will be preferentially written (on a tag-by-tag basis) in
> EXIF format when copying information between two JPEG images. But if a specific
> tag doesn't exist in EXIF, then the tag is written to the first valid group in
> the order specified above. The advantage of "translating" the information to
> EXIF is that it then becomes readable by applications which only support
> standard EXIF. The disadvantage is that you don't get an exact copy of the
> original information structure.

> But ExifTool gives you the ability to customize this behaviour to
> write the information to wherever you want. This is done by specifying a group
> name for the tag(s) to be copied. This applies even if the group name is
> "`all`", in which case the original family 1 group is preserved. So
> to copy all information and preserve the original structure, use this syntax:
>
> ```
> exiftool -tagsfromfile src.jpg -all:all dst.jpg
> ```
>
> In this command, since no destination tag was specified, the destination is the
> same as the source (ie. "`-all:all>all:all`"), so the information is
> copied to the same family 1 group.

> Here are some examples to show you the type of control you have over
> where the information is written. All commands in each example are equivalent:
>
> ```
> # copy all tags to preferred groups (no destination group)
> exiftool -tagsfromfile src.jpg dst.jpg
> exiftool -tagsfromfile src.jpg -all dst.jpg
> exiftool -tagsfromfile src.jpg "-all>all" dst.jpg
> exiftool -tagsfromfile src.jpg "-all:all>all" dst.jpg
>
> # copy all tags, preserving family 1 group (destination group 'all')
> exiftool -tagsfromfile src.jpg -all:all dst.jpg
> exiftool -tagsfromfile src.jpg "-all>all:all" dst.jpg
> exiftool -tagsfromfile src.jpg "-all:all>all:all" dst.jpg
>
> # copy all tags to EXIF group (destination group 'exif')
> # [the destination family 1 group is the preferred EXIF IFD]
> exiftool -tagsfromfile src.jpg "-all>exif:all" dst.jpg
> exiftool -tagsfromfile src.jpg "-all:all>exif:all" dst.jpg
>
> # copy XMP tags to XMP group (destination group 'xmp')
> # [the destination family 1 group is the preferred XMP namespace]
> exiftool -tagsfromfile src.jpg "-xmp:all" dst.jpg
> exiftool -tagsfromfile src.jpg "-xmp:all>xmp:all" dst.jpg
>
> # copy XMP tags, preserving family 1 group (destination group 'all')
> exiftool -tagsfromfile src.jpg "-xmp:all>all:all" dst.jpg
>
> # copy XMP tags to preferred groups (no destination group)
> exiftool -tagsfromfile src.jpg "-xmp:all>all" dst.jpg
>
> # copy XMP tags to EXIF only (destination group 'exif')
> # [the destination family 1 group is the preferred EXIF IFD]
> exiftool -tagsfromfile src.jpg "-xmp:all>exif:all" dst.jpg
> ```
>
> The same rules illustrated above also apply when copying individual tags.

> Note: If no destination group is specified, a new tag is created if
> necessary only in the preferred group, but if the same tag already exists in
> another group, then this information is also updated. (Otherwise inconsistent
> values for the same information would exist in different locations. Of course,
> you can always generate inconsistencies like this if you really want to by
> specifically writing contradictory information to different groups.)

> Certain types of meta information (such as EXIF, IPTC, XMP and
> ICC\_Profile) may also be **copied as a block**. This technique copies all
> meta information, even if ExifTool doesn't have the ability to write some
> individual tags contained in the block. For all block types except EXIF, the
> metadata is copied byte-for-byte from the original image. With EXIF however,
> the metadata may be restructured to ensure that it is self-contained. Also note
> that EXIF may not be written as a block to TIFF-based file formats. Beware that
> **any existing metadata** of this type in the destination file **will be
> overwritten** by the new block.
>
> ```
> # copy EXIF as a block between same-named JPG files in different directories
> exiftool -tagsfromfile SRCDIR/%f.%e -exif -ext jpg DSTDIR
>
> # copy XMP as a block from one file to another
> exiftool -tagsfromfile src.jpg -xmp dst.cr2
> ```

10. **"How does ExifTool handle coded character sets?"**

> *[Also see [FAQ number 18](#Q18) for help with
> special characters in a Windows console.]*

> Certain meta information formats allow coded character sets other
> than plain ASCII. When reading, most known encodings are converted to the
> external character set according to the exiftool "`-charset CHARSET`"
> or `-L` option, or to UTF‑8 by default. When writing, the
> inverse conversion is performed. Alternatively, special characters may be
> converted to/from HTML character entities with the `-E` option.

> A distinction is made between the **external** character set
> visible to the ExifTool user, and the **internal** character used to store
> text in the metadata of a file. These character sets may be specified
> separately as follows:
>
> 1. The **external** character set for **tag values** passed to/from
>    ExifTool is UTF‑8 by default, but it may be changed through any of these
>    command-line options:
>    > `-charset CHARSET`   or  
>    > `-charset exiftool=CHARSET`   or   `-L`
>
>    The encoding of **file and directory names** (eg. the *FILE* argument on
>    the command line) is different. By default, these names are passed straight
>    through to the standard C I/O routines without recoding. On Mac/Linux these
>    routines expect UTF‑8, but on Windows they use the system code page (which
>    is dependent on your system settings). However, as of ExifTool 9.79, the
>    external filename encoding may be specified:
>    > `-charset filename=CHARSET`
>
>    When this is done, file and directory names are converted from the specified
>    encoding to one appropriate for system I/O routines. In Windows, this also has
>    the effect of enabling Unicode filename support via the special Windows
>    wide-character I/O routines if the required Perl modules are available
>    (these are included in the Windows executable version of ExifTool). See
>    [WINDOWS UNICODE FILE NAMES](https://exiftool.org/exiftool_pod.html#WINDOWS-UNICODE-FILE-NAMES)
>    in the application documentation for more details.
> 2. The **internal** character set for strings stored in file metadata may be
>    specified for some metadata types:
>    > `-charset TYPE=CHARSET`
>
>    (where `TYPE` is "`exif`", "`iptc`",
>    "`id3`", "`photoshop`", "`quicktime`" or
>    "`riff`")
>
> Valid `CHARSET` values are (with aliases given in brackets, case is
> not significant):
> > |  |  |  |  |
> > | --- | --- | --- | --- |
> > | UTF8 | (cp65001, UTF‑8) | DOSLatinUS | (cp437) |
> > | Latin | (cp1252, Latin1) | DOSLatin1 | (cp850) |
> > | Latin2 | (cp1250) | DOSCyrillic | (cp866) |
> > | Cyrillic | (cp1251, Russian) | MacRoman | (cp10000, Mac, Roman) |
> > | Greek | (cp1253) | MacLatin2 | (cp10029) |
> > | Turkish | (cp1254) | MacCyrillic | (cp10007) |
> > | Hebrew | (cp1255) | MacGreek | (cp10006) |
> > | Arabic | (cp1256) | MacTurkish | (cp10081) |
> > | Baltic | (cp1257) | MacRomanian | (cp10010) |
> > | Vietnam | (cp1258) | MacIceland | (cp10079) |
> > | Thai | (cp874) | MacCroatian | (cp10082) |
>
> The `-L` option is equivalent to "`-charset Latin`",
> "`-charset Latin1`" and "`-charset cp1252`".

> Type-specific details are given below about the special character
> handling for EXIF, IPTC, XMP, PNG, ID3, PDF, Photoshop, QuickTime, AIFF, RIFF,
> MIE and Vorbis information:

> **EXIF**: Most textual information in EXIF is
> stored in ASCII format (called "string" in the
> [EXIF Tags documentation](tag-names/exif.md)). By default ExifTool
> does not convert these strings. However, it is not uncommon for applications to
> write UTF‑8 or other encodings where ASCII is expected. To deal with
> these, ExifTool allows the internal EXIF string encoding to be specified with
> "`-charset exif=CHARSET`", which causes EXIF string values to be
> converted from the specified character set when reading, and stored with this
> character set when writing. The
> [MWG](http://www.metadataworkinggroup.org/) recommends using
> UTF‑8 encoding for EXIF strings, and in keeping with this the
> "`-use mwg`" feature sets the default internal EXIF string encoding
> to UTF‑8 (ie. "`-charset exif=utf8`"), but note that this will
> have no effect unless the external encoding is also set to something other than
> the default of UTF‑8.

> A few EXIF tags (UserComment, GPSProcessingMethod and
> GPSAreaInformation) support a designated internal text encoding, with values
> stored as ASCII, Unicode (UCS‑2) or JIS. When reading these tags, ExifTool
> converts Unicode and JIS to the external character set specified by the
> `-charset` or `-L` option, or to UTF‑8 by default.
> ASCII text is not converted. When writing, text is stored as ASCII unless the
> string contains special characters, in which case it is converted from the
> external character set (UTF‑8 by default), and stored as Unicode. ExifTool
> writes Unicode in native EXIF byte ordering by default, but the byte order may
> be specified by setting the ExifUnicodeByteOrder tag (see the
> [Extra Tags documentation](tag-names/extra.md)).

> The EXIF "XP" tags (XPTitle, XPComment, etc) are always stored
> internally as little-endian Unicode (UCS‑2), and are read and written
> using the specified external character set.

> **IPTC**†:
> The value of the IPTC:CodedCharacterSet tag determines how the internal IPTC
> string values are interpreted. If CodedCharacterSet exists and has a value of
> "`UTF8`" (or "`ESC % G`") then string values are
> assumed to be stored as UTF‑8. Otherwise the internal IPTC encoding is
> assumed to be Windows Latin1 (cp1252), but this can be changed with
> "`-charset iptc=CHARSET`". When reading, these strings are converted
> to UTF‑8 by default, or to the external character set specified by the
> `-charset` or `-L` option. When writing, the inverse
> conversions are performed. No conversion is done if the internal (IPTC) and
> external (ExifTool) character sets are the same. Note that ISO 2022 character
> set shifting is not supported. Instead, a warning is issued and the string is
> not converted if an ISO 2022 shift code is encountered. See the
> [IPTC IIM
> specification](http://www.iptc.org/std/IIM/4.1/specification/IIMV4.1.pdf) for more information about IPTC character coding.

> ExifTool may be used to convert IPTC values to a different internal
> encoding. To do this, all IPTC tags must be rewritten along with the desired
> value of CodedCharacterSet. For example, the following command changes the
> internal IPTC encoding to UTF‑8 (from Windows Latin1 unless
> CodedCharacterSet was already "UTF8"):
>
> ```
> exiftool -tagsfromfile @ -iptc:all -codedcharacterset=utf8 a.jpg
> ```
>
> or from Windows Latin2 (cp1250) to UTF‑8:
>
> ```
> exiftool -tagsfromfile @ -iptc:all -codedcharacterset=utf8 -charset iptc=latin2 a.jpg
> ```
>
> and this command changes it back from UTF‑8 to Windows Latin1 (cp1252):
>
> ```
> exiftool -tagsfromfile @ -iptc:all -codedcharacterset= a.jpg
> ```
>
> or to Windows Latin2:
>
> ```
> exiftool -tagsfromfile @ -iptc:all -codedcharacterset= -charset iptc=latin2 a.jpg
> ```
>
> Note that unless CodedCharacterSet is UTF‑8, applications have no
> reliable way to determine the IPTC character encoding. For this reason, it is
> recommended that CodedCharacterSet be set to "`UTF8`" when creating
> new IPTC.

> † Refers to the older
> [IPTC IIM](http://www.iptc.org/site/News_Exchange_Formats/IIM/) format.
> The more recent
> [IPTC
> Photo Metadata Standard](https://iptc.org/standards/photo-metadata/iptc-standard/) actually uses the XMP format (see below).

> **XMP**: Exiftool reads XMP encoded as
> UTF‑8, UTF‑16 or UTF‑32, and converts them all to UTF‑8
> internally. Also, all XML character entity references and numeric character
> references are converted. When writing, ExifTool always encodes XMP as
> UTF‑8, converting the following 5 characters to XML character references:
> `& < > ' "`. By default no further conversion is
> performed, however the `-charset` or `-L` option may be
> used to convert text to/from a specified external character set when
> reading/writing.

> **PNG**:
> [PNG TextualData tags](tag-names/png.md#TextualData) are stored as
> tEXt, zTXt and iTXt chunks in PNG images. The tEXt and zTXt chunks use ISO
> 8859-1 encoding, while iTXt uses UTF‑8. When reading, ExifTool converts
> all PNG textual data to the external character set specified by the
> `-charset` or `-L` option, or to UTF‑8 by default.
> When writing, ExifTool generates a tEXt chunk (or zTXt with the `-z`
> option) if the text doesn't contain special characters or if Latin encoding is
> specified (`-L` or `-charset latin`); otherwise an iTXt
> chunk is used and the text is converted from the specified external character
> set and stored as UTF‑8.

> **JPEG Comment**: The encoding for the JPEG
> Comment (COM segment) is not specified, so ExifTool reads/writes this text
> without conversion.

> **ID3**: The ID3v1 specification officially
> supports only ISO 8859‑1 encoding (a subset of Windows Latin1), although
> some applications may incorrectly use other character sets. By default ExifTool
> converts ID3v1 text from Latin to the external character set specified by the
> `-charset` or `-L` option, or to UTF‑8 by default.
> However, the internal ID3v1 charset may be specified with
> "`-charset id3=CHARSET`". The encoding for ID3v2 information is
> stored in the file, so ExifTool converts ID3v2 text from this encoding to the
> external character set specified by `-charset` or `-L`, or
> to UTF‑8 by default. ExifTool does not currently write ID3
> information.

> **PDF**: PDF text strings are stored in either
> PDFDocEncoding (similar to Windows Latin1) or Unicode (UCS‑2). When
> reading, ExifTool converts to the external character set specified by the
> `-charset` or `-L` option, or to UTF‑8 by default.
> When writing, ExifTool encodes input text from the specified character set as
> Unicode only if the string contains special characters, otherwise PDFDocEncoding
> is used.

> **Photoshop**: Some Photoshop resource
> names are stored as Pascal strings with unknown encoding. By default, ExifTool
> assumes MacRoman encoding and converts this to UTF‑8, but the internal and
> external character sets may be specified with
> "`-charset Photoshop=CHARSET`" and "`-charset CHARSET`"
> respectively.

> **QuickTime**: QuickTime text strings may
> be stored in a variety of poorly documented formats, and ExifTool does its best
> to decode these according to the `-charset` option setting. For some
> QuickTime strings where the internal encoding is not known, ExifTool assumes a
> default encoding of MacRoman, but this may be changed with
> "`-charset QuickTime=CHARSET`". When writing, ExifTool prefers
> to store as UTF‑8 if possible, and converts to this from the character
> set specified by the `-charset` option (UTF‑8 by default).

> **AIFF**: AIFF strings are assumed to be
> stored in MacRoman, and are converted according to the `-charset`
> option when reading.

> **RIFF**: The internal encoding of RIFF
> strings (eg. in AVI and WAV files) is assumed to be Latin unless otherwise
> specified by the RIFF CSET chunk or the "`-charset RIFF=CHARSET`"
> option.

> **MIE**: MIE strings are stored as either
> UTF‑8 or ISO 8859‑1. When reading, UTF‑8 strings are converted
> according to the `-charset` or `-L` option, and ISO
> 8859‑1 strings are never converted. When writing, input strings are
> converted from the specified character set to UTF‑8. The resulting
> strings are stored as UTF‑8 if they contain multi-byte UTF‑8
> character sequences, otherwise they are stored as ISO 8859‑1.

> **Vorbis**: Vorbis comments are stored as
> UTF‑8, and are converted to the character set specified by
> `-charset` or `-L` when reading.

> **Programmers**: ExifTool returns all values as byte strings of encoded
> characters. Perl wide characters are not used. The encoding is UTF‑8 by
> default, but valid UTF‑8 can not be guaranteed for all values, so the
> caller must validate the encoding if necessary. The encodings described above
> are set by the various [Charset options](https://exiftool.org/ExifTool.html#Charset) of
> the API.
>   
>   
> **Note**: Some settings of the system PERL\_UNICODE environment
> variable may be incompatible with ExifTool's character handling.

11. **"My user-defined tags don't work"**

> For examples of how to add user-defined tags, see the
> [ExifTool\_config](https://exiftool.org/config.html) file in the ExifTool distribution.
> It may be useful to activate this file as a test before trying to implement
> your own config file. To activate this file, copy it to your **HOME**
> directory then rename it to "`.ExifTool_config`".
> > **Note**: The config file must be renamed at the
> > command line because neither the Windows nor Mac GUI allow a file name to
> > begin with a "`.`". To do this in Windows, run "cmd.exe" and type
> > the following (pressing *ENTER* at the end of each line):
> >
> > ```
> > cd %HOMEPATH%
> > rename ExifTool_config .ExifTool_config
> > ```
> >
> > or on a Mac, open the "Terminal" application (from the /Applications/Utilities
> > folder) and type this command then press *RETURN*:
> >
> > ```
> > mv ExifTool_config .ExifTool_config
> > ```
>
> With the sample config file installed, you should be able to write the example
> tags. A command like this:
>
> ```
> exiftool -v2 -NewXMPxmpTag=test FILE
> ```
>
> should print this as the first line of its output:
>
> ```
> Writing XMP-xmp:NewXMPxmpTag
> ```
>
> If this doesn't work, the most common problem is that the
> "`.ExifTool_config`" configuration file isn't getting loaded. In
> this case, there are a few things you can try:
>
> 1. Make sure the config file name is correct. It must be
>    "`.ExifTool_config`" (note the leading "`.`", and the
>    capital "`T`").
> 2. Set either the **HOME** or the **EXIFTOOL\_HOME** environment variable
>    to the name of the directory where you put your "`.ExifTool_config`"
>    file.
> 3. Put the config file in the same directory as the exiftool app. (Also, be
>    sure the config filename starts with a dot! See the note above for help
>    renaming the config file.)
> 4. If you can't get the config file to load automatically, you can try loading
>    it manually with the exiftool `-config CFGFILE` option. (Note:
>    This must be the first option on the command line.) This allows loading
>    of a config file with any name.

> If necessary, you can verify that ExifTool is loading your config
> file by adding the following line to your file:
>
> ```
> print "LOADED!\n";
> ```
>
> If you see a "`LOADED!`" message when you run exiftool, but your new
> tags still don't work, make sure you are using the proper tag name and that the
> file you are writing can support this type of information.

> Note that all tag names in the config file are **case
> sensitive**. Specifically, the case must be correct for tag names in
> Composite tag Require/Desire entries. Also note that XMP tag names are
> generated automatically by capitalizing the tag ID unless the tag definition
> contains a "Name" entry.

> **Programmers**: To specify the config file directory from within
> a Perl script when using the ExifTool API, set the **EXIFTOOL\_HOME**
> environment variable before loading the ExifTool module:
>
> ```
> BEGIN { $ENV{EXIFTOOL_HOME} = '/config_file_directory' }
> use Image::ExifTool;
> ```
>
> Also see the [Configuration section of the
> ExifTool API documentation](https://exiftool.org/ExifTool.html#Config) for techniques to use a config file with another
> name, or to disable the config file feature.

12. **"How do I export information from exiftool to a database?"**

> *[See [FAQ number 26](#Q26) for help with the reverse
> -- importing metadata from a database.]*

> It is often easiest to export information formatted as a tab-delimited or
> comma-separated list of values using the exiftool `-T` or
> `-csv` option. As well, the `-r` option is useful for
> recursing through all images in a hierarchy of directories. For example:
>
> ```
> exiftool -T -r -filename -exposuremode -ISO t/images > out.txt
> ```
>
> This command recursively processes all images in the "`t/images`"
> directory, extracting FileName, ExposureMode and ISO tags, and writing the
> output to a tab-delimited text file called "`out.txt`". After the
> command has executed, "`out.txt`" will look something like this:
>
> ```
> Canon.jpg       Manual  100
> Casio.jpg       -       64
> Nikon.jpg       -       100
> OlympusE1.jpg   Auto    400
> ```
>
> One limitation of the `-T` option is that you must specify a list
> of tags to extract. Otherwise, all information is extracted from each input
> file, and the columns would contain values from random tags.

> The `-csv` (comma separated values) option solves this
> dilemma by pre-extracting information from all input files, then producing a
> sorted list of available tag names as the first row of the output, and
> organizing the information into columns for each tag. As well, a first column
> labelled "SourceFile" is generated. These features make it practical to use the
> `-csv` option for extracting all information from multiple images
> (but impractical for a large number of images due to memory restrictions).
> For example, this command:
>
> ```
> exiftool -csv -r t/images > out.csv
> ```
>
> gives an output like this:
>
> ```
> SourceFile,AEBBracketValue,AELock,AFAreaHeight,AFAreaMode,AFAreas,[...]
> t/images/Canon.jpg,0,,151,,,[...]
> t/images/Casio.jpg,,,,,,[...]
> t/images/Nikon.jpg,,,,Single Area,,[...]
> t/images/OlympusE1.jpg,,Off,,,"Center (121,121)-(133,133)",[...]
> ```
>
> Note that the number of columns in the `-csv` output may be very
> large if all information is extracted. Missing tags are indicated by empty
> strings as in the example above, or by dashes if the `-f` option is
> used.

> It should be possible to import these files directly into most
> database applications. On the command line, any list of tag names may be used,
> and any number of file or directory names may be specified. (Hint: If your
> command line starts to get too long, you may want to look into using the
> `-@` option and/or the [ShortCut](https://exiftool.org/index.html#shortcut)
> feature).

> In Windows, a .BAT file containing the exiftool command may be used
> to give drag and drop functionality. Dropping a folder on the following .BAT
> file will create "out.txt" in the folder:
>
> ```
> echo "FileName<tab>Aperture<tab>ISO" > %1\out.txt
> exiftool -T -r -filename -aperture -ISO %1 >> %1\out.txt
> ```
>
> The "`echo`" command was included to add column headings to the
> output. (The tab character in the echo command, indicated by
> "`<tab>`", may be generated in Mac/Linux shells with CTRL-v
> then TAB, or in a Windows cmd shell with TAB when cmd.exe is run with the
> `/f:off` option to disable tab completion.)

> Other possible export formats include RDF/XML (with the
> `-X` option), or JSON (with the `-j` option). These
> methods allow transfer of more complex data sets (including structured
> information with the `-struct` option), but require that the
> importing software supports these formats.

> Finally, the `-p` option may be used to generate any
> arbitrary output format. For example, the following format file
> (let's call it "`my.fmt`") may be used to emulate a CSV-formatted
> output:
>
> ```
> #[HEAD]FileName,Aperture,ISO
> $filename,$aperture,$iso
> ```
>
> with a command like this:
>
> ```
> exiftool -f -r -p my.fmt t/images > out.csv
> ```
>
> But note that any values containing commas, quotes or some other special
> characters may mess up the CSV formatting. If this is a possibility, the
> `-api filter` option may be added to the command to quote values
> if necessary. For example:
>
> ```
> # in a Windows CMD shell
> exiftool -api filter="$_ = qq{""""$_""""} if s/""/""""/g or /(^\s+|\s+$)/ or /[,\n\r]/" ...
>
> # in Mac/Linux
> exiftool -api filter='$_ = qq{"$_"} if s/"/""/g or /(^\s+|\s+$)/ or /[,\n\r]/' ...
> ```
>
> The `-p` option argument may also be a format string instead of a
> file name. The following command has the same effect as above except that the
> row of headings is not printed (Note: Use single quotes as below on Mac/Linux,
> or double quotes instead on Windows):
>
> ```
> exiftool -f -r -p '$filename,$aperture,$iso' t/images > out.csv
> ```
>
> With the `-f` option, the value of any missing tag is printed as a
> dash (or the value of the
> [API MissingTagValue option](https://exiftool.org/ExifTool.html#MissingTagValue), if set).
> Without this option, missing tags generate a minor warning and the line in the
> `-p` output is not printed. The `-m` option may be used
> to ignore minor warnings, which causes these lines to be printed with an empty
> value for missing tags.

> See the `-p` option in the [application
> documentation](https://exiftool.org/exiftool_pod.html) for more information about this feature.

13a. **"Why is my file smaller after I use ExifTool to write information?"**, or
  
13b. **"Why do some Offset tags change value when I write other tags?"**, or
  
13c. **"How does editing a file with ExifTool affect image quality?"**

> There are various specific reasons why this can happen, but the general answer
> is: When ExifTool writes an image, the meta information may be restructured in
> such a way that it takes less space than in the original file, or so that some
> tags are stored at different offsets in the file.

> The EXIF/TIFF standard allows for blocks of unreferenced data to
> exist in an image. Some digital cameras write JPEG or TIFF-based RAW files
> which contain large blocks of unused data, usually filled with binary zeros.
> The reason for this could be to simplify camera algorithms by allowing
> variable-sized information to be written at fixed offsets in the output image.
> When ExifTool rewrites an image it does not copy these unused blocks. This can
> result in a significant reduction in file size for some images. *[The
> `-htmlDump` option may be used to view the file structure if you are
> interested in seeing these unused data blocks -- use a command like
> "`exiftool -htmlDump a.jpg > out.html`", then open
> `out.html` in your web browser. Unused data blocks are
> brown in this output.]*

> Also, the size of an XMP record may easily shrink or grow when it is
> rewritten, even if no meta information is changed. This is partly due to the
> fact that the XMP specification recommends a few KB of padding at the end of the
> record (ExifTool adds 2424 bytes by default, but this padding is omitted if the
> `-z` command-line option or the
> [API Compact](https://exiftool.org/ExifTool.html#Compact) NoPadding setting is used), and
> partly due to the flexibility of the XMP format which allows the information to
> be written in various styles, some of which are more compact than others (the
> `-z` option and the [API Compact](https://exiftool.org/ExifTool.html#Compact)
> settings also cause a more compact form to be written). As well, the order
> of the tags in the XMP may change -- the specification doesn't dictate an order,
> and ExifTool sorts them alphabetically when writing.

> You may also notice that the values of some "offset" tags (like
> ThumbnailOffset and PreviewImageStart) may change when the file is rewritten.
> This is normal, and simply indicates that the associated data is now stored at a
> different position within the file.

> ExifTool does not modify the image data itself, so **editing a file
> with ExifTool is "lossless" as far as the image is concerned**.

14a. **"What format do I use for writing GPS coordinates?"**, or  
14b. **"How do I change the format of extracted GPS coordinates?"**

> ExifTool is very flexible in the formats allowed for entering GPS
> coordinates. Any string containing between 1 and 3 floating point numbers is
> valid. The numbers represent degrees, (and optionally) minutes and
> seconds with any number of decimal places.

> For EXIF GPS coordinates, the reference direction is specified
> separately with the EXIF:GPSLatitudeRef or EXIF:GPSLongitudeRef tag.
> GPSLatitudeRef may be written with a string containing "`N`",
> "`North`", "`S`" or "`South`", or with a signed
> coordinate value (positive for the northern hemisphere or negative for the
> south). GPSLongitudeRef accepts similar values, but for E/East (positive) and
> W/West (negative).

> For XMP GPS coordinates, the reference direction is specified within
> the XMP:GPSLatitude or XMP:GPSLongitude value, with west longitudes and south
> latitudes being specified either by negative coordinate values or by ending the
> string with "`W`" or "`S`".

> Here are some examples of equivalent ways to specify a GPS
> latitude in both EXIF and XMP:
>
> ```
> exiftool -exif:gpslatitude="42 30 0.00" -exif:gpslatituderef=S a.jpg
> exiftool -exif:gpslatitude="42 deg 30.00 min" -exif:gpslatituderef=S a.jpg
> exiftool -exif:gpslatitude=42.5 -exif:gpslatituderef=S a.jpg
>
> exiftool -xmp:gpslatitude="42 30 0.00 S" a.jpg
> exiftool -xmp:gpslatitude=42.50S a.jpg
> exiftool -xmp:gpslatitude=-42.5 a.jpg
> exiftool -xmp:gpslatitude="-42 -30" a.jpg
> ```
>
> Note the last example: The negative sign must be applied to all components of
> the coordinate. Similar styles may be used for longitude. ExifTool will convert
> any of these coordinate styles to the proper format for the specific tag used.

> ExifTool 12.22 and later allow combined lat/lon GPSCoordinates
> values to be written to GPSLatitude and GPSLongitude, and the appropriate
> latitude or longitude part will be pulled from the input string. Version 12.36
> and later make Composite:GPSPosition writable, allowing EXIF GPS coorinates and
> reference directions to be all writable via a single tag:
>
> ```
> # write all 4 EXIF GPS tags (version 12.36 and later)
> exiftool -gpsposition="42 30 0.00 S, 33 15 0.00 W"
> exiftool -gpsposition="-42.5, -33.25"
> ```
>
> Version 12.44 and later make Composite:GPSLatitude/GPSLongitude writable,
> allowing the separate EXIF coordinate and reference direction tags to be written
> together. (Note that the Composite group must be specified here because these
> tags are otherwise avoided when writing due to possible confusion when
> attempting to write EXIF tags.)
>
> ```
> # write EXIF:GPSLatitude and GPSLatitudeRef together (12.44 and later)
> exiftool -composite:gpslatitude="42 30 0.00 S" a.jpg
> exiftool -composite:gpslatitude="-42.5" a.jpg
> ```

> When reading, by default ExifTool reports coordinates in the format
>
> ```
> DDD deg MM' SS.SS"
> ```
>
> where `DDD` is degrees, `MM` is minutes, and `SS.SS`
> is seconds. The `-n` option may be used to change this to decimal
> degrees, or any arbitrary format may be specified with the `-c`
> command-line option (see the [application documentation](https://exiftool.org/exiftool_pod.html)),
> or the [API CoordFormat option](https://exiftool.org/ExifTool.html#CoordFormat).

15. **"I get MakerNote warnings or errors when reading or writing information"**

> Problems like this may be caused by image editing software which
> doesn't properly update offsets in the MakerNotes when rewriting an image. These
> offsets are used as pointers to reference tag values and structures within the
> metadata, and errors like this may lead to missing or incorrect values for some
> MakerNotes tags. In many cases, ExifTool will detect this type of problem and
> issue a warning like this when reading (or an error when writing):
>
> ```
> Warning: [minor] Possibly incorrect maker notes offsets (fix by -340?)
> ```
>
> *[Be aware that if multiple warnings occur, the `-a`
> option must be used to see them all, since by default only one warning is
> displayed per file.]*

> This is a particularly insidious problem that is sometimes difficult
> for ExifTool to correct automagically, so it requires some operator
> intervention. If this warning occurs, you have a few alternatives:

> 1) Use the `-F` option to allow ExifTool to attempt to
> fix the incorrect offsets. If ExifTool was correct in its diagnosis, then this
> option will fix the incorrect offsets. This is usually the appropriate choice
> if this problem was caused by editing the image with other
> software.

> 2) Use the `-m` option to ignore the warning (or downgrade
> the error to a warning when writing). This causes ExifTool to honour the
> existing maker note offsets, and may be the correct choice if images straight
> out of the camera have this problem.

> Often, the first choice (`-F`) is the right thing to do,
> but this depends on many factors, so it is best to try both methods then compare
> the resulting maker note information to see which works best for your
> situation.

> When writing, `-F` applies a permanent correction to the
> maker notes. Note that some MakerNote information may be lost permanently
> if the proper correction is not applied when writing images with this
> problem.

> 3) The third alternative is to adjust the maker note offsets by a
> specific amount. This is done by appending an integer to the `-F`
> option. For example, with the warning above (where ExifTool suggests "fix by
> -340?"), `-F` would be equivalent to `-F-340`. See the
> [-F option documentation](https://exiftool.org/exiftool_pod.html#F-OFFSET--fixBase) for
> more details. This advanced feature may require some technical knowledge about
> the structure of EXIF information (and here, ExifTool's `-htmlDump`
> feature may be very useful for visualizing this structure).

> Other types of MakerNote errors may also prevent the file from
> being written. However, most MakerNote errors are designated as **minor**,
> which allows them to be ignored by using the `-m` option. For
> example:
>
> ```
> Error: [minor] Bad format (65535) for MakerNotes entry 17
> ```
>
> Using `-m` will downgrade the minor error to a warning, allowing the
> file to be written, but some MakerNote information may be lost when ignoring
> errors like this.

> You may also get one of these warnings when reading or writing a
> file containing unknown maker notes:
>
> ```
> Warning: [minor] Unrecognized MakerNotes
> Warning: [minor] Maker notes could not be parsed
> ```
>
> These warnings indicate that ExifTool didn't recognize the maker notes in a
> file, so it couldn't extract any information from them when reading, or had to
> copy the maker notes as a block when writing. If the maker notes contain
> absolute offsets then this could result in corrupted makernote information when
> writing, but this is very unlikely.

16. **"Why doesn't ExifTool rename my video files?"**

> By default, ExifTool only processes writable file types
> † when any tag
> ‡ is being written and a directory
> name is specified on the command line, so AVI files won't be processed by
> default. To force exiftool to process other files, they must either be listed
> on the command line by name, or be specified using the `-ext` or
> `-ext+` option, something like this:
>
> ```
> # process AVI files in addition to other writable file types
> exiftool -ext+ AVI -d pics/%Y/%m "-directory<dateTimeOriginal" DIR
>
> # process only AVI and JPG files
> exiftool -ext AVI -ext JPG -d pics/%Y/%m "-directory<dateTimeOriginal" DIR
> ```
>
> When `-ext` is used, only files with the specified extension(s) are
> processed, however `-ext+` may be used to add to the list of normally
> processed files (as in the first example above). Multiple `-ext` or
> `-ext+` options may be used in the same command (as in the second
> example above) to process any number of different file types, or
> `-ext "*"` may be used to process files with any extension (or none at all).

> **Note:** The above commands generally still won't work for
> MOV/MP4 videos because these files typically don't contain a DateTimeOriginal
> tag. For these types of files, CreateDate should be used instead (possibly with
> the addition of `-api QuickTimeUTC` if these timestamps are based on
> UTC). Use this command to see which date/time tags are available:
>
> ```
> exiftool -time:all -a -G1 -s FILE
> ```

> † The
> `-listwf` option may be used to list the extensions of all writable
> file types, or see [here](https://exiftool.org/index.html#supported) for a table of
> supported file types.
>   
> ‡ This includes "pseudo" tags like
> FileName, Directory, FileModifyDate and FileCreateDate.

17. **"List-type tags do not behave as expected"**

> Tags indicated by a plus sign (`+`) in the
> [tag name documentation](https://exiftool.org/TagNames/index.html) are list-type tags.
> Two examples of common list-type tags are
> [IPTC:Keywords](tag-names/iptc.md#ApplicationRecord) and
> [XMP:Subject](tag-names/xmp.md#dc). These tags may contain multiple
> items which are combined into a single string when reading. (By default,
> extracted list items are separated by a comma and a space, but the
> `-sep` option may be used to change this.) When writing, separate
> items are assigned individually. For example, the following command writes
> three keywords to all writable files in directory `DIR`, replacing
> any previously existing keywords:
>
> ```
> exiftool -keywords=one -keywords=two -keywords=three DIR
> ```
>
> List items are assigned separately as above, NOT all together, because this
> would represent a single keyword:
>
> ```
> exiftool -keywords="one, two, three" test.jpg  (WRONG!)
> ```
>
> The `-sep` option may be used to split values of list-type tags into
> separate items when writing. For example,
>
> ```
> exiftool -sep ", " -keywords="one, two, three" DIR
> ```
>
> will store three separate keywords, the same as the first example above. This
> feature may also be used to split a tag value into separate items if it was
> originally stored incorrectly as a single string:
>
> ```
> exiftool -sep ", " -tagsfromfile @ -keywords test.jpg
> ```
>
> However, sometimes it is desirable to have list items which contain a comma, and
> this is allowed:
>
> ```
> exiftool -contributor="Harvey, Phil" -contributor="Marley, Bob" a.jpg
> ```
>
> But to distinguish these entries when extracting information, a different list
> separator or a different output format must be used. For instance, the
> following command uses "`//`" to separate list items,
>
> ```
> exiftool -contributor -sep "//" a.jpg
> ```
>
> and produces an output like this:
>
> ```
> Contributor  : Harvey, Phil//Marley, Bob
> ```
>
> Alternatively, the `-j`, `-php` and `-X`
> options use an output format which preserves the structure of a
> list (if `-sep` is NOT used).

> Note that the writing examples above overwrite any values which
> already existed in the original file for these tags. Instead, to add or delete
> items from an existing list, use "`+=`" or "`-=`" in place
> of "`=`". For example:
>
> ```
> exiftool -keywords+="add this" -keywords-="remove this" DIR
> ```
>
> With commands like this, new items are added to the list in place of the first
> deleted item, or at the end of the list if no items were removed.

> Note: Using "`=`" is equivalent to "`+=`" in
> any command where the same List-type tag is set with "`+=`" or
> "`-=`" in another assignment. (ie. existing items will be preserved
> unless specifically deleted with "`-=`".) *[For non
> List-type tags, "`+=`" has a different meaning, and is used to
> increment numerical values or shift dates.]*

> **To prevent duplication when adding new
> items**, specific items can be deleted then added back again in the same
> command. For example, the following command adds the keywords "one" and "two",
> ensuring that they are not duplicated if they already existed in the keywords of
> an image:
>
> ```
> exiftool -keywords-=one -keywords+=one -keywords-=two -keywords+=two DIR
> ```
>
> When **copying list tags** using the `-tagsFromFile` feature,
> items are copied individually to form proper lists if the tag is copied directly
> (note that `-tagsFromFile @` is implied by the "`<`"
> operation in this and the following commands, causing tags to be copied from the
> original file):
>
> ```
> exiftool "-keywords<subject" DIR
> ```
>
> However, this is not the case if the tag is interpolated within a format string
> (ie. has a leading "`$`" symbol), like this
>
> ```
> exiftool "-keywords<$subject" DIR  (WRONG!)
> ```
>
> but here the `-sep` option may be used to split the list back into
> separate items:
>
> ```
> exiftool "-keywords<$subject" -sep "//" DIR
> ```
>
> Note there is a complication when **copying multiple tags to a single list**
> tag: Here, any assignment to a tag overrides earlier assignments to the same
> tag in the command. For instance, this command:
>
> ```
> exiftool "-keywords<filename" "-keywords<comment" DIR  (WRONG!)
> ```
>
> writes only the value from the Comment tag. This may seem strange, but it prevents
> duplicate items from being added to a list when copying a group of tags from a
> file containing duplicate information. Alternatively, multiple tags may be copied to a
> single list either by adding a leading `+` or by using the
> `-addTagsFromFile` option:
>
> ```
> exiftool "-keywords<filename" "-+keywords<comment" DIR
> ```
>
> or
>
> ```
> exiftool -addTagsFromFile @ "-keywords<filename" "-keywords<comment" DIR
> ```
>
> Except for adding instead of replacing queued list values, the `-addTagsFromFile`
> option is identical to `-tagsFromFile`, but using `"-+TAG<SRCTAG"`
> is more flexible because it may be applied on a per-tag basis.

> But note that the "`<`" operation still overwrites any Keywords
> that existed previously in the original file. To add to or remove from the existing
> keywords, use "`+<`" or "`-<`".

> One final note: When copying the contents of two other
> tags into a single list, or if one of the source lists may already contain
> duplicates, the [API NoDups option](https://exiftool.org/ExifTool.html#NoDups) may be
> used to remove duplicate items from list values that are queued for writing.
> For example,
>
> ```
> exiftool -tagsfromfile a.jpg -subject -tagsfromfile b.jpg -+subject -api nodups c.jpg
> ```
>
> combines Subject items from a.jpg and b.jpg and writes them without duplicates
> to c.jpg (overwriting any previous Subject in c.jpg). Or to remove duplicates that
> may already exist in the target file when adding new items:
>
> ```
> exiftool -tagsfromfile @ -subject -subject="new item" -api nodups target.jpg
> ```

18a. **"Special characters don't display properly in my Windows console"**, or
  
18b. **"I'm having problems with special characters on the Windows command line"**

> The Windows cmd.exe console uses an MS-DOS encoding by default
> (cp437 or something similar, depending on your region). The exiftool
> `-charset` option may be used to encode the exiftool output for a
> specific Windows code page, which may help display some special characters, but
> instead it may be better to switch the console to UTF‑8 (the native
> ExifTool character encoding). This is especially useful if you are using the
> `-lang` option to translate exiftool output to another language. To
> change the Windows console to UTF‑8, follow these steps:
>
> 1. Run "cmd.exe" to open a Windows console (select "Run..." from the
>    Start menu and enter "cmd").
> 2. Change the font in the console Properties to any True Type font (eg. "TT
>    Lucida Console").
> 3. Type "`chcp 65001`" then press ENTER at the command prompt.
>
> The console should now be able to display UTF‑8 characters (cp65001). But
> note that the TT Lucida Console font shipped with Windows, at least my version,
> may not be very complete, and doesn't seem to contain Japanese or Chinese
> characters.

> To permanently set the font, select "Save properties for future
> windows" when changing the font Properties. Also, you can automatically run
> "`chcp 65001`" every time "cmd.exe" is launched by changing the
> Windows Registry for the Command Processor: Run "regedit" and put "`chcp
> 65001`" into Data field for "HKEY\_LOCAL\_MACHINE\Software\Microsoft\Command
> Processor\Autorun". (Unfortunately, I haven't been able to figure out how to
> change the code page for exiftool when launched via the Windows GUI. If anyone
> can figure out how to do this, please let me know.)

> Note that Windows will **recode arguments on the command
> line** from the current console code page to the system code page, so the
> ExifTool `-charset` should be set to the system code page for
> command-line arguments. However, this technique may yield unexpected results
> since not all characters may be represented using the system code page. To get
> around this limitation, arguments may be read from an ExifTool argument file
> using the `-@` option. UTF‑8 encoding is recommended for the
> argument file, and with this you would also set `-charset filename=utf8`
> if using special characters in filename arguments within the file.

> Also see
> [this StackOverflow answer](https://stackoverflow.com/questions/57131654/using-utf-8-encoding-chcp-65001-in-command-prompt-windows-powershell-window/57134096#57134096)
> for another possible solution, but note that this option has the side effect of
> changing the fonts of some older programs and causing problems with their GUIs,
> so you'll have to decide whether this is acceptable for you.

> Another way to bypass the console/command-line encoding problems for
> individual tag values is to extract/write to/from a separate text file and use a
> UTF‑8 aware text editor to view/edit the text. For example:
>
> ```
> # extracting...
> exiftool image.jpg > out.txt
>
> # writing...
> exiftool "-subject<=subject.txt" image.jpg
> ```

19. **"How do I change the format of an extracted tag value?"**

> The exiftool application has built-in options which allow you to
> display numeric values (`-n`), escape special HTML characters
> (`-E`), and change the date/time (`-d`) and GPS coordinate
> (`-c`) formats, but sometimes more control is needed over the
> formatting of a value...

> The `-p` and `-tagsFromFile` options provide
> an advanced translation feature that allows arbitrary Perl expressions to be
> used to modify tag values. The basic syntax is this:
>
> ```
> ${TAG;EXPR}
> ```
>
> where `TAG` is the tag name, and `EXPR` is a Perl
> expression acting on the default input variable (`$_`), which is
> initially the original value of the tag. For example, the following command
> sets the FileName from Artist, translating spaces to underlines:
>
> ```
> exiftool '-filename<${artist;tr/ /_/}.%e' image.jpg
> ```
>
> (Note: Use single quotes as above in Mac/Linux, or double quotes instead
> in Windows.)

> Another technique is to create a user-defined Composite tag to do
> the reformatting. Here is a basic config file that reformats the Artist tag to
> provide a new MyArtist tag with the same character translation as the example
> above:
>
> ```
> %Image::ExifTool::UserDefined = (
>    'Image::ExifTool::Composite' => {
>        MyArtist => {
>            Require => 'Artist',
>            ValueConv => '$val =~ tr/ /_/; $val',
>        },
>    },
> );
> 1; # end
> ```
>
> With this config file, an Artist value of "Phil Harvey" yields a corresponding
> MyArtist value of "Phil\_Harvey". The ValueConv string may be any valid Perl
> expression, and is evaluated to obtain the value for the new tag. In this
> expression, `$val` represents the ValueConv value of the Require'd
> tag.

> To activate the config file, it must be named
> "`.ExifTool_config`" and placed either in your home directory or in
> the same directory as the exiftool application. Note that the file name begins
> with a "`.`", so if you are in Windows or on a Mac you may need to
> rename the file from the command line since the GUI might not like file names
> beginning with a "`.`". *[An alternative is to load the
> config file with the `-config` option -- see the
> [application documentation](https://exiftool.org/exiftool_pod.html#config-CFGFILE)
> for details.]*

> User-defined Composite tags have many other features, including the
> ability to combine the values of multiple tags. See the
> [config file documentation](https://exiftool.org/config.html) for more details about
> user-defined tags, and lib/Image/ExifTool/README in the full distribution for a
> complete description of ValueConv features. Also, a
> [quick
> search of the ExifTool forum](https://exiftool.org/forum/index.php?action=search2&search=code+userdefined) should reveal a number of user-defined tag
> examples, and there are other good (and often more complex) examples which can
> be found in the %Image::ExifTool::Exif::Composite hash of the
> lib/Image/ExifTool/Exif.pm source code.

20a. **"ExifTool won't write an image due to errors"**, or
  
20b. **"How do I repair corrupted EXIF?"**

> Minor errors may be ignored using the `-m` option
> ([FAQ 15](#Q15) discusses this with respect to MakerNote errors), but
> sometimes there are more serious errors which can't be ignored. ExifTool may be
> used to fix metadata problems in JPEG images by deleting all metadata and
> rebuilding it from scratch. The command looks like this:
>
> ```
> exiftool -all= -tagsfromfile @ -all:all -unsafe -icc_profile bad.jpg
> ```
>
> where "`bad.jpg`" is the name of the image that requires fixing. This
> command deletes all metadata then copies all writable tags that can be extracted
> from the original image to the same locations in the updated image. The
> "`Unsafe`" tag is a [shortcut](https://exiftool.org/TagNames/Shortcuts.html)
> for unsafe EXIF tags in JPEG images which are not normally copied. JPEG images
> may also contain an ICC color profile which should be preserved. The
> "`ICC_Profile`" tag is also marked as unsafe, but is not part of the
> EXIF so it isn't covered by the "`Unsafe`" shortcut and must be
> specified separately.

> After repairing an image like this you should be able to write to it
> without errors, but note that some metadata from the original image may have
> been lost in the process.

> **Note**: ExifTool will not modify the JPEG image data, so if the
> image itself is corrupted (eg. if you get a message saying "Not a valid JPEG"),
> then ExifTool can not be used to repair the image. Also, ExifTool may not
> be used like this to repair TIFF-based files or RAW files -- the risk of image
> corruption is too great because the image is stored in the same IFD as the
> metadata in these files.

> If there are also MakerNote problems in the file, you may want to
> add the `-F` option to the command. See [FAQ 15](#Q15)
> for details. For example, to rebuild the EXIF only and fix the MakerNote
> offsets you could do this:
>
> ```
> exiftool -exif:all= -tagsfromfile @ -exif:all -unsafe -F bad.jpg
> ```
>
> **Advanced**: The byte order of the newly created EXIF is set by the value of
> the ExifByteOrder tag. Since this tag does not belong to the EXIF group, it is
> not copied with `-exif:all` above (but would be copied with
> `-all:all` as in the first example). If ExifByteOrder is not set
> then the byte order is determined by the ordering of the MakerNotes if they are
> copied, otherwise big-endian ("MM") byte order is used by default.
> ExifByteOrder may be set to a specific value to force a particular byte order
> when creating new EXIF (eg. "`-ExifByteOrder=II`" for little-endian).

21. **"How do I read/write values containing newline characters?"**

> When reading, by default exiftool converts all control characters to
> "." to avoid messing up the output formatting, so newlines will appear as a "."
> in the output. The `-b` option may be used to bypass all output
> formatting (except that a line-feed character or other separator specified by
> the `-sep` option is inserted between items in a list), but this may
> not be appropriate when the values of many tags must be extracted. In this
> case, the formatted output (`-p`), JSON (`-j`), XML
> (`-X`) and PHP (`-php`) options provide alternative output
> formats which preserve newlines in values.

> Alternatively, the [API Filter option](https://exiftool.org/ExifTool.html#Filter)
> may be used to apply an arbitrary filter to all extracted values. For example,
> the following command changes newlines to "\n":
>
> ```
> exiftool -api filter="s/\n/\\n/g" FILE
> ```
>
> When writing, there are a number of options:
>
> 1. In many shells, a newline may be inserted directly in the command
>    line:
>
>    Bourne shells (press *RETURN* inside a quoted string)
>
>    ```
>    exiftool -comment="line 1
>    line 2" image.jpg
>    ```
>
>    (Also, in Bourne shells the character sequence `$'\n'`
>    may be used for a newline.)
>
>    C shells (press "`\`" then *RETURN* inside a quoted string)
>
>    ```
>    exiftool -comment="line 1\
>    line 2" image.jpg
>    ```
>
>    *[Unfortunately the Windows cmd shell provides no method to get a
>    newline (CR/LF in Windows) into the command line. A linefeed (LF) may be
>    inserted with CTRL-T, but I have found no way to insert a carriage return
>    (CR).]*
> 2. Use the `-ec` or `-E` option to allow C-style escape
>    sequences or HTML character entities (Note:
>    In Windows a newline is "`\r\n`" or "`&#xd;&#xa;`"
>    instead of just "`\n`" or "`&#xa;`"). For example,
>    using C-style escape sequences:
>
>    ```
>    exiftool -ec "-comment=line 1\nline 2" image.jpg
>    ```
>
>    or using HTML character entities:
>
>    ```
>    exiftool -E "-comment=line 1&#xa;line 2" image.jpg
>    ```
> 3. Write the tag from the contents of a separate text file:
>
>    ```
>    exiftool "-comment<=file.txt" image.jpg
>    ```
> 4. Use `$/` in a redirection expression: (Note: Single quotes
>    must be used in Mac/Linux shells around arguments containing a dollar sign,
>    but double quotes are used instead in Windows. Also note that this technique
>    is slower since the implied `-tagsFromFile` adds an extra unnecessary
>    processing pass to read tags from the file, but most of this delay may be
>    avoided with the `-fast3` option.)
>
>    ```
>    exiftool '-comment<line 1$/line 2' image.jpg
>    ```
> 5. Use the "`#[CSTR]`" feature to allow C-style escape sequences
>    for a specific line in a `-@` argfile. For example, this command:
>
>    ```
>    exiftool -@ test.args image.jpg
>    ```
>
>    with this "test.args" file:
>
>    ```
>    #[CSTR]-comment=line 1\nline 2
>    ```

22. **"In what order are command-line assignments applied when writing?"**

> When writing, tag assignments on the command line are queued and
> applied together as each target file is processed. In general, assignments
> later on the command line override earlier assignments (ie. they are evaluated
> left-to-right), but there are exceptions:
>
> 1. When writing list-type tags (eg. `-keywords=one`), new values
>    are accumulated rather than overriding earlier assignments.
> 2. When copying values to list-type tags (eg.
>    `"-keywords<filename"`), subsequent copies to the same tag
>    override earlier operations with the exception that new values may be added to
>    the queued list if a leading `+` is added to the target tag name (eg.
>    `"-+keywords<filename"`).
> 3. Tags copied with the `-tagsFromFile` option are assigned in
>    order, and all together at the point in the command line where the
>    `-tagsFromFile` option is located, regardless of whether these tags
>    are specified immediately after the `-tagsFromFile` option or later
>    on the command line. Remember that unless otherwise specified,
>    "`-tagsFromFile @`" is implied before the first argument to redirect
>    tags (ie. `"-DSTTAG<SRCTAG"`).
>
> Note: When copying tag values, adding to lists, or shifting date/time values,
> the source value is always the original value found in the file, regardless of
> any previous assignments. For example, the following command sets Subject to
> the original value of Title in the file (NOT to "test"):
>
> ```
> exiftool -title=test "-subject<title" a.jpg
> ```

23a. **"Why do I get '`0 image files updated`' when writing?"**, or  
23b. **"ExifTool doesn't write some tags to a file"**

> There are a few reasons why this may happen:
>
> 1. The value of the tag is not being set correctly.
>
> This may be due to a tag value which can't be converted, in which case you
> should warning like this (note: you may need to use the `-v3` option
> to see the warning if other same-named tags are being set properly by the same
> assignment):
>
> ```
> Warning: Can't convert IFD0:Orientation (not in PrintConv)
> ```
>
> You get this warning if you write an invalid value to a tag which accepts only
> specific values. See the "Values" column in the appropriate table of the
> [tag name documentation](https://exiftool.org/TagNames/index.html) for a list of valid
> values for these types of tags. The value conversion may also be bypassed with
> the `-n` option, allowing numerical values to be written directly.
> See [FAQ number 6](#Q6) for more details.
>
> 2. The information type isn't supported by the format of the
>    target file.
>
> Warnings are NOT generated when a tag isn't written because it is
> normal that many tags can't be written when copying between files of different
> formats.

> Tags are not written if the format of the target file doesn't
> support the specific type of meta information. For example, CRW images do not
> support EXIF or IPTC metadata. See the
> [Supported File Types](https://exiftool.org/index.html#supported) table for an indication
> of the tags supported by your file. If the tags aren't supported for your file
> type, then a [metadata sidecar file](metafiles.md) is an
> alternative.

> Also note that MakerNotes tags can not be created or deleted
> individually, so they can only be written if they already exist in a
> file. The entire MakerNotes must be created or deleted as a block (see
> [FAQ number 8](#Q8) for details).
>
> 3. A time value is being shifted but the specified tag doesn't
>    exist.
>
> For example, `-datetimeoriginal+=1` will have no effect unless
> the DateTimeOriginal tag exists in the image.

24. **"When I write a file the date/time gets reset to today's date"**

> You should be aware of the difference between date/time values
> stored in the metadata of the file itself and date/time values stored in the
> filesystem (ie. in the disk directory information). A command like this may be
> used to extract all date/time information with an indication of where it is
> stored:
>
> ```
> exiftool -time:all -a -G0:1 -s c:\images\test.jpg
> ```
>
> and should give an output something like this:
>
> ```
> [File:System]   FileModifyDate                  : 2009:10:05 20:40:36-04:00
> [File:System]   FileAccessDate                  : 2009:10:07 09:22:12-04:00
> [File:System]   FileCreateDate                  : 2009:10:05 20:40:36-04:00
> [EXIF:IFD0]     ModifyDate                      : 2003:10:31 15:44:19
> [EXIF:ExifIFD]  DateTimeOriginal                : 2003:10:31 15:44:19
> [EXIF:ExifIFD]  CreateDate                      : 2003:10:31 15:44:19
> ```
>
> The `-G0:1` option causes the family 0 and 1 group names to be
> reported in square brackets for each tag. Tags labelled "**File:System**"
> are "**pseudo**" tags stored in the filesystem, while the others are real
> tags stored in the metadata of the file.

> ExifTool's **default behaviour is to set all filesystem times to
> the current date/time when any "real" tag is written**, but the
> `-P` option may be used to preserve the original FileModifyDate.
> FileAccessDate represents the time the file was last accessed, and is set to the
> current date/time whenever any software (including ExifTool) accesses the
> file.

> On systems where a filesystem creation date is maintained, ExifTool
> also sets this to the current date/time when the file is edited. On Windows the
> creation date is readable/writable through the FileCreateDate tag (see the
> [Extra Tags documentation](tag-names/extra.md)), and is preserved
> with the `-P` option. On MacOS, FileCreateDate is available but
> extracted only if specified explicitly, and is writable only if "setfile" is
> available. The `-P` option does not preserve the creation date when
> editing a file on Mac systems, but the `-overwrite_original_in_place`
> option may be used to preserve all Finder information including the creation
> date, or the FileCreateDate may be copied back specifically (ie.
> `-tagsfromfile @ -FileCreateDate`). On Linux, the file creation date
> is not stored.

> For example, commands like this act on common metadata tags, setting
> the filesystem modification date/time to the current date/time:
>
> ```
> # common metadata date/time tags are incremented by 1 hour, while
> # FileModifyDate is set to the current date/time
> exiftool -alldates+=1 c:\images
> ```
>
> *[The AllDates tag is a shortcut which represents the 3 common
> metadata date/time tags: DateTimeOriginal, CreateDate and
> ModifyDate.]*

> However, FileModifyDate may be preserved with the `-P`
> option:
>
> ```
> # FileModifyDate is not changed
> exiftool -alldates+=1 -P c:\images
> ```
>
> ExifTool also allows FileModifyDate to be written, which provides full control
> over the filesystem modification date/time when writing:
>
> ```
> # FileModifyDate is incremented by 1 hour
> exiftool -alldates+=1 -filemodifydate+=1 c:\images
>
> # FileModifyDate is set from the value of DateTimeOriginal
> # (before DateTimeOriginal is incremented by 1 hour)
> exiftool -alldates+=1 "-filemodifydate<datetimeoriginal" c:\images
> ```

25. **"Can ExifTool be used as an image validator?"**

> ExifTool is not designed as an image validator but it does have a
> `-validate` feature which enables extra validation checks, mainly for
> JPEG and TIFF-format images (officially released in version 10.97, May 2018,
> but continually being improved). Here is an example command to apply these
> validation checks to a JPEG image:
>
> ```
> exiftool -validate -warning -error -a test.jpg
> ```
>
> Note there are other packages specifically designed for file validation, for
> example: [JHOVE](https://github.com/openpreserve/jhove).

26. **"How do I import information from a database?"**

> *[See [FAQ number 12](#Q12) for help with the reverse
> -- exporting metadata to a database.]*

> ExifTool has the ability to import metadata from CSV and JSON format
> database files for writing to output image files. For example, the following
> commands use imported metadata to write to all image files in a directory.
>
> ```
> # import from CSV file
> exiftool -csv="c:\Users\Phil\test.csv" "c:\Users\Phil\Images"
>
> # import from JSON file
> exiftool -json="c:\Users\Phil\test.json" "c:\Users\Phil\Images"
> ```
>
> For the above commands, the input CSV or JSON file must have the same format as
> the output from these commands:
>
> ```
> # export to CSV file
> exiftool -csv "c:\Users\Phil\Images" > "c:\Users\Phil\test.csv"
>
> # export to JSON file
> exiftool -json "c:\Users\Phil\Images" > "c:\Users\Phil\test.json"
> ```
>
> Specifically, the first row of the CSV file must contain the tag names.
> The first column must be a special "SourceFile" column, containing the names of
> the associated image files, with paths specified in the same way as on the
> command line. The JSON file contains similar entries, but is not structured in
> row/column format.

> For each image file specified on the command line, all tags for the
> database entry with the corresponding SourceFile name are written (with the
> exception of the FileName and Directory tags, which are ignored). A special
> SourceFile name of "\*" may be used to match any image file. A warning is issued
> and nothing is written if a specified file does not match any SourceFile entry
> in the database.

> Tag names may be prefixed by a group name to write to a specific
> group (using the same format as when `-G` or `-G1` is
> added to the export command). To delete a tag, set the tag value to "-" (or the
> [MissingTagValue](https://exiftool.org/ExifTool.html#MissingTagValue) if this API option
> was used) and use the `-f` option when importing. Tags with an empty
> value are ignored in a CSV import, or set to an empty string in a JSON import
> (unless `-f` is used and the
> [API MissingTagValue option](https://exiftool.org/ExifTool.html#MissingTagValue) is set to
> an empty string, in which case the tag is deleted).

> See the `-csv` or `-j` option in the
> [application documentation](https://exiftool.org/exiftool_pod.html#input_output_text_formatting)
> for more details.

27. **"My ExifTool command doesn't work from a Windows .BAT file"**

> In a Windows .BAT file the "`%`" character is
> significant, so all "`%`" characters in ExifTool commands must be
> changed to "`%%`". For example, this command line:
>
> ```
> exiftool "-FileName<CreateDate" -d "%Y%m%d_%H%M%S.%%e" image.jpg
> ```
>
> must be changed to this in a .BAT file:
>
> ```
> exiftool "-FileName<CreateDate" -d "%%Y%%m%%d_%%H%%M%%S.%%%%e" image.jpg
> ```

28. **"How do I copy a shifted date/time value?"**

> The `-TAG+=` and `-TAG-=` arguments always act
> on the **existing** tag value, so they can not be used to shift a **new**
> tag value without running a second command. For example, this is **wrong**
> because the copy operation is superseded by the shift, and the result is that
> the existing DateTimeOriginal is shifted back by two hours:
>
> ```
> exiftool "-datetimeoriginal<filemodifydate" -datetimeoriginal-=2 image.jpg  (WRONG!)
> ```
>
> The `-globalTimeShift` option fills this niche -- it shifts all
> date/time tags by the specified amount when reading or copying, allowing a
> shifted date/time value to be copied to another tag. So this is the proper
> technique for shifting a date/time value when copying:
>
> ```
> exiftool "-datetimeoriginal<filemodifydate" -globaltimeshift -2 image.jpg
> ```
>
> An alternative is to use the ShiftTime function of the
> [advanced formatting feature](https://exiftool.org/exiftool_pod.html#Advanced-formatting-feature):
>
> ```
> exiftool '-datetimeoriginal<${filemodifydate;ShiftTime("-2")}' image.jpg
> ```
>
> (Note: Swap the single and double quotes when running this command under Windows.)

> **Programmers**: Here are the equivalent ExifTool API function calls:
>
> ```
> # using the GlobalTimeShift option
> $exiftool->Options(GlobalTimeShift => '-2');
> $exifTool->SetNewValuesFromFile($src, 'datetimeoriginal<filemodifydate');
>
> # using ShiftTime in an advanced formatting expression
> $exifTool->SetNewValuesFromFile($src, 'datetimeoriginal<${filemodifydate;ShiftTime("-2")}');
> ```

29. **"My options don't work in a `-@` ARGFILE"**

> The ExifTool application has the ability to read options from an
> ARGFILE using the `-@` option. The parsing of these arguments is
> different from the command line. Arguments in this file are separated by
> newline characters instead of spaces. Also, arguments should not be quoted.
> For example, on the command line you may have:
>
> ```
> -d "%Y:%m:%d %H:%M:%S"
> ```
>
> but in an ARGFILE, this should be
>
> ```
> -d
> %Y:%m:%d %H:%M:%S
> ```

30. **"How do I extract absolutely all metadata from a file?"**

> By default, duplicate tags, unknown tags, embedded tags, and System
> tags that require external utilities are not extracted. The main reason for
> this is performance; extracting these tags will significantly increase
> processing time for some files. The following command extracts everything
> possible with ExifTool:
>
> ```
> exiftool -ee3 -U -G3:1 -api requestall=3 -api largefilesupport FILE
> ```
>
> (The `-G3:1` option is included in the above command only to give an
> indication of where the metadata was stored.)

31. **"Why does ExifTool rewrite the entire file when I am only changing one small thing?"**

> Generally it is possible in theory to edit existing fixed-length tags without having to rewrite an entire file, but ExifTool doesn't do this for 3 reasons:
>
> 1. The algorithm to do this would be completely different than the more general
>    and powerful case where you want to be able to add/delete tags and/or write
>    values with different lengths. Plus, implementing this feature would be a lot
>    of work, and it would only be useful in certain situations.
> 2. Some file formats (like MP4) allow metadata to be written at the beginning
>    or the end of a file. Writing it at the end of the file could avoid the need to
>    rewrite the entire starting section, but metadata is more useful at the start of
>    a file because then other programs (especially ones that stream the file over
>    the internet) don't have to read through the entire file to find the metadata.
>    Also, some software won't read metadata that comes at the end of a file
>    (probably for this reason).
> 3. ExifTool is designed to allow files to be read/written via pipes, which are
>    not seekable, so in-place editing is not possible with these files and again,
>    like 1, two completely different algorithms would be required.

32. **"How do I safely delete all metadata from a file?"**

> First of all, all metadata shouldn't be removed from some file types
> (such as RAW images) because this information is necessary for display of the
> image. JPEG is the most popular image format and most suited to erasing all
> metadata because the image and metadata are well separated in this format.
> However, even with JPEG images care should be taken because the metadata
> may contain color space information which should be maintained to preserve the
> color rendition.

> Here is a command that may be used to safely delete all metadata
> from .JPG images in a directory:
>
> ```
> exiftool -ext jpg -all= --icc_profile:all -tagsfromfile @ -colorspacetags DIR
> ```
>
> This command deletes all metadata except the ICC Profile if it exists, then
> copies back any EXIF color space tags (adding any mandatory EXIF tags using
> default values if necessary).

33. **"Why do I get a '`No writable tags set from <file>`' warning?"**

> This warning occurs when copying tags from a file if
> nothing was copied (ie. if none of the specified tags were found in the
> source file, or tags existed but weren't copied to any writable tags). There
> are no warnings for individual tags which weren't copied; just this warning if
> no tags were copied. This message may be expected for some files when using
> certain commands, but may be suppressed by adding
> `-api "NoWarning=No writable tags"` to the command if desired.

---

*Last revised Jan 4, 2026*

[<-- Back to ExifTool home page](https://exiftool.org/index.html)
