---
generated_from: vendor/exiftool/html/install.html
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
Installing ExifTool

# Installing ExifTool

> **Note:** ExifTool **does not need
> to be installed** to run. Just download and extract either the full Perl
> distribution on Mac/Linux, or the Windows EXE version on Windows, and run it
> directly. *[But note that if you move the Perl "exiftool"
> application you must also move its "lib" directory to the same location, and
> if you move the Windows "exiftool(-k).exe" or "exiftool.exe" you must also move the
> "exiftool\_files" folder.]*  
>   
> However, the benefits of installation are:
>
> - Makes ExifTool available to all users.
> - Saves typing on the command line (by placing "exiftool" in your PATH).
> - Installs the ExifTool documentation and API libraries (full Perl version only).

See the appropriate section below with instructions for installing or
uninstalling ExifTool on your specific platform:

- [Windows](#Windows)
- [MacOS](#MacOS)
- [Unix Platforms](#Unix)

Also see [these instructions](https://exiftool.org/index.html#running) for help running
ExifTool.

---

## Windows

In Windows, there is a choice of two different versions of ExifTool to
install. The Perl distribution requires Perl to be installed on your system.
(A good, free Perl interpreter can be downloaded from
[activeperl.com](https://www.activestate.com/products/perl/) or
[strawberryperl.com](https://strawberryperl.com/).)

If you don't already have Perl, it is easier to install the ExifTool
executable version, but note that this version doesn't include the HTML
documentation or some other files of the full distribution.

### Windows Executable

1. **Download** the 32-bit or 64-bit **Windows Executable** from the [ExifTool home page](https://exiftool.org/index.html).
     
   (The file you download should be named "`exiftool-13.58_32.zip`"
   or "`exiftool-13.58_64.zip`".)
2. **Extract the "`exiftool-13.58_xx`" folder** from
   the "`.zip`" file, and place it **on your Desktop**.
     
   (Double-click on "`exiftool-13.58_xx.zip`" to open
   the archive, then drag "`exiftool-13.58_xx`" folder to your Desktop.)
3. Open the "`exiftool-13.58_xx`" folder from your Desktop.

You can now double-click on "`exiftool(-k).exe`" in this folder to read
the application documentation, or drag-and-drop files and folders to run exiftool on
selected files. To install exiftool for **use from the command line**,
continue with the following steps:

4. **Rename** "`exiftool(-k).exe`" to **"`exiftool.exe`"**.
     
   (or "`exiftool(-k)`" to "`exiftool`" if file name
   extensions are hidden on your system)
5. **Move "`exiftool.exe`" and the "`exiftool_files`" folder**
   to any directory in your PATH (or any other directory of your choosing).

You can now run exiftool by typing "`exiftool`" at the command
prompt (or "`c:\path\to\exiftool`" if the directory isn't in your
PATH).   
(To get to the command prompt, select "Run..." from
the Windows "Start" menu, then type "`cmd`" and press Return.)

**Uninstalling:**

1. Drag "`exiftool(-k).exe`" (or "`exiftool.exe`" if you renamed
   it) and the "`exiftool_files`" folder into the Recycle bin.

### Full Perl Distribution

You must have Perl installed to use this version. (A free version of Perl
can be downloaded from
[activeperl.com](http://www.activestate.com/activeperl/) or
[strawberryperl.com](https://strawberryperl.com/).)

1. **Download** the **Image-ExifTool distribution** from the [ExifTool home page](https://exiftool.org/index.html)
     
   (The file you download should be named "`Image-ExifTool-13.58.tar.gz`".)
2. **Extract the ExifTool files** from the archive.
     
   (The archive is a gzipped tar file, and can be opened with
   various Windows utilities, including WinZip.)
3. **Rename** "`exiftool`" to **"`exiftool.pl`"**
   in the exiftool distribution.
4. **Move "`exiftool.pl`"** and the **"`lib`"**
   directory from the exiftool distribution to any directory in your PATH.

Now, if you have made the proper Windows associations for the
"`.pl`" extension (an option in the ActivePerl installation), you
can run exiftool by typing "`exiftool.pl`" at the
"`cmd.exe`" prompt. Otherwise you should type
"`perl c:\path\to\exiftool.pl`".

**Uninstalling:**

1. Drag "`exiftool.pl`" and the
   "`lib`" into the Recycle bin. You should first confirm
   that "`lib`" contains only the "`File`"
   and "`Image`" sub-directories. Do not delete it if it
   contains anything else.

---

## MacOS

If you have installed the BSDSDK package from the Xcode Developer Tools
(*ie. if you have the* "`make`" *utility*), you should
follow the install procedure for [Unix platforms](#Unix) in the next
section instead of the steps below. The Unix install has the advantage of making
the ExifTool library available for your Perl scripts, as well as installing the
man pages and POD documentation.

Otherwise, you have a choice of two packages to install: The MacOS package, or
the full Perl distribution. Both of the procedures below install the ExifTool
files in the same location. Installing from the MacOS package is easier, but the
full distribution includes HTML documentation and some other files not included
in the MacOS package. Both versions run natively on PPC and Intel Macs.

### MacOS Package

1. **Download** the **ExifTool MacOS Package** from the [ExifTool home page](https://exiftool.org/index.html).
     
   (The file you download should be named "`ExifTool-13.58.pkg`".)
2. **Install** as a normal **MacOS package**.
     
   (Double-click on the install package, and follow the instructions.
   See the Notes below if you are stopped with an "unidentified developer"
   or "could not verify" message.)

You can now run exiftool by typing "`exiftool`" in a Terminal window.

If this doesn't work, then it is likely you have an older version of MacOS for which
/usr/local/bin isn't in the default PATH. To fix this, add the following line to your
~/.profile settings using a text editor:

> `export PATH=$PATH:/usr/local/bin`

**Notes:**

*Apple blocks apps from unknown vendors and extorts a developer fee
which seems incongruous with the concept of open source software so I refuse to pay
it, hence the following inconvenience... - PH*

- In MacOS 10.8 to MacOS 14, you may see this message when you try to open the install package:
  > "ExifTool-13.58.pkg" can't be opened because it is from an
  > unidentified developer.

  The solution is to control-click on the pkg then
  select "Open" from the pop-up menu instead of just double-clicking. An alternative
  is to lower the security settings by changing "Allow applications downloaded from"
  to "Anywhere" in the General "Security & Privacy" System Preferences.
  ([Read here](https://support.apple.com/en-us/HT202491) or
  [here](http://news.softpedia.com/news/Fix-OS-X-Error-Application-Can-t-Be-Opened-Because-it-Is-from-an-Unidentified-Developer-407375.shtml)
  for a full description.)
- In MacOS 15 or later, you may see this message when you try to open the install package:
  > Apple could not verify "ExifTool-13.58.pkg" is free of malware
  > that may harm your Mac or compromise your privacy.

  The solution is to
  open the "Privacy & Security" System Settings and find the "Open Anyway" button
  in the Security section.
- Another possibility if you already have another version of ExifTool installed
  is to remove the quarantine flag by running this command in a Terminal window,
  allowing the installer to be launched:
  > ```
  > exiftool -XAttrQuarantine= ExifTool-13.58.pkg
  > ```

  or if you don't already have ExifTool installed, you can do this:
  > ```
  > xattr -d com.apple.quarantine ExifTool-13.58.pkg
  > ```

  Note that you should "cd" into the directory containing the package file
  before running either of the above commands, or specify the full path name of
  the package file.

### Full Perl Distribution

1. **Download** the **Image-ExifTool distribution** from the [ExifTool home page](https://exiftool.org/index.html)
   to your Desktop.
     
   (The file you download should be named "`Image-ExifTool-13.58.tar.gz`".)
2. **Launch** the **Terminal** application from the Utilities folder in your Applications folder.
3. In the Terminal window, **type the following**:

   ```
       cd ~/Desktop
       tar -xzf Image-ExifTool-13.58.tar.gz
       cd Image-ExifTool-13.58
       sudo cp -r exiftool lib /usr/local/bin
   ```

   (Note: The last step above will require you to enter your
   password.)

You can now run exiftool by typing "`exiftool`" in a Terminal window.

**Note:**

- Both MacOS installation techniques outlined above place
  exiftool and its lib directory in /usr/local/bin, while the standard Unix
  "`make install`" described below puts "`exiftool`" in
  /usr/local/bin and the individual libraries in /Library/Perl/#.#.#, where "#.#.#" is
  your Perl version. If both sets of libraries exist, /usr/local/bin/lib takes
  precedence for exiftool, but /Library/Perl/#.#.# is the default for any other
  Perl scripts.

### Uninstalling

1. Launch the "Terminal" application from the Applications Utilities folder.
2. Type "`open /usr/local/bin`" (without the quotes) in the Terminal
   window, then press RETURN. (This opens a folder that you normally can't access
   from MacOS.)
3. Drag "`exiftool`" and "`lib`" into the trash from the
   "`bin`" folder you opened. You should first confirm that
   "`lib`" contains only two sub-folders: "`File`" and
   "`Image`". If it contains anything else, don't trash it because you
   have the wrong "`lib`" folder.

---

## Unix Platforms

1. **Download** the **Image-ExifTool distribution** from the [ExifTool home page](https://exiftool.org/index.html)
     
   (The file you download should be named "`Image-ExifTool-13.58.tar.gz`".)
2. **Unpack the distribution** and **make it your current directory** by typing:

   ```
       cd <your download directory>
       gzip -dc Image-ExifTool-13.58.tar.gz | tar -xf -
       cd Image-ExifTool-13.58
   ```

   (At this point you may run exiftool by typing
   "`./exiftool <image file name>`".)
3. **Test and install ExifTool** by typing:

   ```
       perl Makefile.PL
       make test
       sudo make install
   ```

   (Note: The "`make test`" step is not required, but
   useful because it runs a full suite of tests to verify that ExifTool is working
   properly on your system. The "`sudo make install`" command requires
   that you have su access, and will prompt for your password. This will make
   ExifTool and its documentation accessible to all users on your system. If you
   don't have su access, you can run ExifTool in your own account by moving
   "`exiftool`" and its "`lib`" directory to any convenient
   location, preferably somewhere in your PATH.)

You can now run exiftool by typing "`exiftool`". Also, you can
consult the ExifTool documentation with commands like:

> ```
> perldoc exiftool
> perldoc Image::ExifTool
> perldoc Image::ExifTool::TagNames
> ```

or

> ```
> man exiftool
> man Image::ExifTool
> man Image::ExifTool::TagNames
> ```

### Uninstalling

1. Type "`sudo make uninstall`" from the distribution directory.
     
   (Note: Unfortunately, newer systems may give an *"Uninstall
   is unsafe and deprecated"* message even though uninstalling ExifTool is safe
   because it has no dependencies. If this happens, the necessary commands to
   remove the installed files will be listed, and these commands must be run
   manually.)

---

[<-- Back to ExifTool home page](https://exiftool.org/index.html)
