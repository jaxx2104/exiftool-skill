---
generated_from: vendor/exiftool/html/geolocation.html
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
ExifTool Geolocation Feature

[Reading Geolocation](#Read)
  
  - [Default tags](#DefTags)
  
  - [Default input](#DefInput)
  
  - [Regular expressions](#Reg)
  
[Writing Geolocation](#Write)
  
  - [While geotagging](#Geotag)
  
[Extra Features](#Extra)
  
  - [Language translations](#Lang)
  
  - [Optional parameters](#Params)
  
  - [Alternate databases](#Alt)
  
  - [Listing the database](#List)
  
  - [Customization](#Custom)
  
[Troubleshooting](#Troubleshooting)

# ExifTool Geolocation Feature *(aka "Reverse Geocoding")*

ExifTool has the ability to generate geolocation information (including city,
region, subregion and country) from GPS coordinates (and visa versa) using an
included database of all cities with population 2000 or greater based
on a Creative Commons database from [geonames.org](http://www.geonames.org/export/).
(An extended version of the ExifTool database is available with cities down to a
population of 500. [See below](#Alt) for more information.) There are
two basic modes of operation: one to generate geolocation information when
reading from a file, and another to write geolocation information to a file.

### Reading Geolocation Information

> Geolocation tags may be generated when reading a file by setting the
> [API Geolocation option](https://exiftool.org/ExifTool.html#Geolocation). For example,
>
> ```
> exiftool -api geolocation "-geolocation*" test.jpg
> ```
>
> produces an output similar to this for a file containing GPS coordinates:
>
> ```
> Geolocation City                : Saint-Hyacinthe
> Geolocation Region              : Quebec
> Geolocation Subregion           : Montérégie
> Geolocation Country Code        : CA
> Geolocation Country             : Canada
> Geolocation Time Zone           : America/Toronto
> Geolocation Feature Code        : PPL
> Geolocation Feature Type        : Populated Place
> Geolocation Population          : 50000
> Geolocation Position            : 45.6307, -72.9571
> Geolocation Distance            : 1.8 km
> Geolocation Bearing             : 226
> ```
>
> The above tags are generated based on either a GPS position (preferentially), or
> from city, state/province and country information. Note that the term "City"
> used in this context may be more aptly called "Feature Name" since the database
> may include some features which are not cities. Also, the meanings of the
> resulting region and subregion tags vary by country. In North America for
> example, region corresponds to state or province, and subregion corresponds to
> county. The population is rounded to 2 significant digits, and the distance and
> bearing are generated only when an input GPS position is provided, and give the
> distance in km and the compass bearing from the input GPS point to the
> GeolocationPosition of the returned city. See the
> [Extra Tags documentation](tag-names/extra.md) for a brief description
> of each Geolocation tag.

**Default tags**

> The Geolocation option has a list of default tags that it looks for
> in the source file to use as inputs for determining the nearest city. These tags
> are, in order:
> > GPSLatitude, GPSLongitude, GPSLatitudeRef, GPSLongitudeRef,
> > GPSCoordinates, LocationShownGPSLatitude, LocationShownGPSLongitude,
> > XMP:City, State, CountryCode, Country,
> > IPTC:City, Province-State, Country-PrimaryLocationCode, Country-PrimaryLocationName,
> > LocationShownCity, LocationShownProvinceState, LocationShownCountryCode,
> > LocationShownCountryName
>
> First, the file is checked for GPS tags in this list, and coordinates from the
> first available of these tags are used as inputs to determine the geolocation.
> If no GPS position is found, the file is checked for
> city/state/province/country/countrycode tags in the list, and the inputs are
> taken from the first available city information. Note that each specified city
> tag must come before the corresponding state/province, etc. If multiple
> matches are found, the city with the largest population is returned unless
> the `-a` (API [Duplicates](https://exiftool.org/ExifTool.html#Duplicates))
> option is used in which case all matching cities are returned.

> To override the default list of tags, set the Geolocation option
> to a comma-separated list of tags beginning with dollar signs, but **note that
> Composite tags may not be used**. For example:
>
> ```
> exiftool -api geolocation="$XMP:GPSLatitude,$XMP:GPSLongitude" test.jpg
> ```
>
> *(Note: On Mac/Linux/PowerShell, use single quotes (`'`) instead
> of double quotes (`"`) around arguments containing a dollar sign
> (`$`).)*

**Default input**

> It may be useful to specify a default input for the case where none
> of the specified tags are found. For this, the default input is added to the
> Geolocation setting. For example, the information returned by this command
> includes Geolocation information for the specified coordinates if none of the
> default tags listed above are found:
>
> ```
> exiftool -api geolocation="44.3414,-72,1234" test.jpg
> ```
>
> Alternately, default city information may be specified. When doing this, the
> city name comes first, and is optionally followed by region (eg. state or
> province), subregion (eg. county), country code and/or country name in any
> order, separated by commas. For example:
>
> ```
> exiftool -api geolocation="London,England" test.jpg
> ```
>
> The default tags may be specified at the same time as the default value to
> override the pre-defined list of default tags, for example:
>
> ```
> exiftool -api geolocation="$gpslatitude,$gpslatituderef,\
>     $gpslongitude,$gpslongituderef,-37.81,144.96" test.jpg
> ```
>
> This feature may be used to generate geolocation information with no input file
> at all. For example, this command:
>
> ```
> exiftool -api geolocation=Munich,Germany
> ```
>
> produces this output:
>
> ```
> Geolocation City                : Munich
> Geolocation Region              : Bavaria
> Geolocation Subregion           : Upper Bavaria
> Geolocation Country Code        : DE
> Geolocation Country             : Germany
> Geolocation Time Zone           : Europe/Berlin
> Geolocation Feature Code        : PPLA
> Geolocation Feature Type        : Seat Of A First-order Administrative Division
> Geolocation Population          : 1300000
> Geolocation Position            : 48.1375, 11.5755
> ```
>
> If both city name and GPS coordinates are provided, the nearest city
> matching the specified name(s) is returned, and the result includes the
> distance and compass bearing from the specified GPS position to this city.
> For example:
>
> ```
> > exiftool -api geolocation=44,-76,Kingston
> Geolocation City                : Kingston
> Geolocation Region              : Ontario
> Geolocation Subregion           : Frontenac County
> Geolocation Country Code        : CA
> Geolocation Country             : Canada
> Geolocation Time Zone           : America/Toronto
> Geolocation Feature Code        : PPL
> Geolocation Feature Type        : Populated Place
> Geolocation Population          : 110000
> Geolocation Position            : 44.2298, -76.4810
> Geolocation Distance            : 46.12 km
> Geolocation Bearing             : 296
> ```
>
> Multiple nearby cities may be returned instead of just the nearest by adding
> `num=##` to the Geolocation option string, where `##` is the
> desired number of cities. The returned cities are ordered from nearest to
> furthest, and distinguished by the family 3 (document number) group which allows
> them to be output as separate lines with the `-p` option. For example,
> the nearest cities to a specified GPS position:
>
> ```
> > exiftool -ee -p geo.fmt -api geolocation=49.48,6.37,num=4
> 7.00 km,286 deg,PPLA3,Mondorf-les-Bains,Luxembourg
> 7.24 km,357 deg,PPLA2,Remich,Luxembourg
> 11.55 km,80 deg,PPL,Orscholz,Germany
> 12.32 km,240 deg,PPL,Cattenom,France
> ```
>
> or the nearest cities to a specified city:
>
> ```
> > exiftool -ee -p geo.fmt -api geolocation="new york city,num=5"
> 0.00 km,0 deg,PPL,New York City,United States
> 0.31 km,287 deg,PPL,Tribeca,United States
> 0.74 km,203 deg,PPLX,Financial District,United States
> 0.85 km,77 deg,PPLX,Chinatown,United States
> 0.92 km,255 deg,PPL,Battery Park City,United States
> ```
>
> Note that the `-ee` option must be used for the `-p`
> option to iterate through the returned cities since they are returned as
> sub-documents. Here is the "geo.fmt" file used in the above commands:
>
> ```
> $geolocationdistance,$geolocationbearing deg,$geolocationfeaturecode,$geolocationcity,$geolocationcountry
> ```
>
> Or for a JSON-format output, a command like this may be useful:
>
> ```
> exiftool -j -g3 -api geolocation=49.48,6.37,num=4
> ```

**Regular expressions**

> An advanced feature allows standard Perl regular expressions of the
> form `/expr/` to be used to match city, region, etc names. The
> regular expression may be prefixed by "`ci`", "`re`",
> "`sr`", "`cc`" or "`co`" to apply only to City,
> Region, Subregion, CountryCode or Country names, otherwise the expression
> matches any of these. A dash at the start is used to exclude matching entries
> (eg. `-co/Canada/` excludes cities in Canada from the search). The
> **regular expression matches are case sensitive** unless "`i`" is
> added after the expression. For example:
>
> ```
> # this matches "Frontenac" in any place name (case insensitive†)
> exiftool -api geolocation=/frontenac/i
>
> # while this matches "Frontenac" only in subregion names
> exiftool -api geolocation=sr/frontenac/i
>
> # and this matches the city "Kingston" with "Ontario" in any other field
> exiftool -api geolocation=kingston,/ontario/i
> ```
>
> One more feature allows both GPS and place names to be used together if no input
> tags are found and the default value includes both of these. In this case the
> closest city matching all of the specified names is returned. For example, to
> find the closest city in Canada to a specified location, you could do this:
>
> ```
> exiftool -api geolocation="40.784,-73.966,co/Canada/"
> ```
>
> This technique may be useful if you were travelling near the border of
> a country and want to keep the geolocated cities within that country.

> † *Currently case insensitivity applies only to ASCII characters.*

---

### Writing Geolocation Information

> A write-only [Geolocate tag](tag-names/extra.md) is
> provided as a convenience to simplify the writing of standard geolocation tags.
> This is an alternative to using the API [Geolocation](https://exiftool.org/ExifTool.html#Geolocation)
> option and copying the generated Geolocation tags individually to the desired
> locations, and is completely independent of the API Geolocation setting
> (although the [optional parameters](#Params) still apply).

> Writing the Geolocate tag with GPS coordinates generates city,
> state/province, country code and country tags. By default, XMP tags are
> generated (plus Keys:LocationName for videos), but group name(s) may be
> specified to write tags to other locations (see table below). For example, to
> write the XMP City, State, CountryCode and Country tags from specified GPS
> coordinates:
>
> ```
> exiftool "-geolocate=45.6429,-72.9374" test.jpg
> ```
>
> or to write the IPTC tags from GPS coordinates in a file:
>
> ```
> exiftool "-iptc:geolocate<gpsposition" test.jpg
> ```
>
> Conversely, GPS coordinates may be generated by writing Geolocate with a city
> name. A region, subregion, country code and/or country name may be added in any
> order after the city name, separated by commas. Fields must match exactly the
> entries in the database, but case is not significant†. Regular expressions may
> also be used in the same format as for the API Geolocation option
> ([see above](#Reg)). If more than one matching city is found then a
> minor warning is issued and the tags are not written, but the IgnoreMinorErrors
> option may be used to write tags for the matching city with the largest
> population. For example, the following command writes XMP:GPSLatitude, etc and
> IPTC:City, etc for Paris France.
>
> ```
> exiftool -xmp:iptc:geolocate="paris,fr" test.jpg
> ```
>
> The table below lists the tags that are written for each group name specified
> for the Geolocate tag. Multiple group names may be used. In some cases,
> different tags are written based on whether input GPS coordinates or a city name
> were used. As mentioned, the Geolocate tag is for convenience only, and makes
> it easier to write common tags listed in the table below. The API
> [Geolocation](https://exiftool.org/ExifTool.html#Geolocation) option is more flexible and
> may be used with the `-tagsFromFile` option to write any combination
> of tags, but the command may be more complicated.
> > | Group Name(s) Specified | Tags Written based on input... | |
> > | --- | --- | --- |
> > | GPS coordinates | City name |
> > | *(none)* | XMP:City  XMP:State  XMP:CountryCode  XMP:Country  Keys:LocationName | GPSLatitude  GPSLongitude  GPSLatitudeRef  GPSLongitudeRef  QuickTime::GPSCoordinates |
> > | XMP | XMP:City  XMP:State  XMP:CountryCode  XMP:Country | *(only if XMP-exif not specified)*  XMP:GPSLatitude  XMP:GPSLongitude |
> > | XMP-photoshop | XMP-photoshop:City  XMP-photoshop:State  XMP-photoshop:Country | |
> > | XMP-iptcCore | XMP-iptcCore:CountryCode | |
> > | XMP-exif | XMP-exif:GPSLatitude  XMP-exif:GPSLongitude | |
> > | XMP-iptcExt | XMP-iptcExt:LocationShownCity  XMP-iptcExt:LocationShownProvinceState  XMP-iptcExt:LocationShownCountryCode  XMP-iptcExt:LocationShownCountryName  XMP-iptcExt:LocationShownGPSLatitude  XMP-iptcExt:LocationShownGPSLongitude | |
> > | IPTC *(older IIM spec.)* | IPTC:City  IPTC:Province-State  IPTC:Country-PrimaryLocationCode  IPTC:Country-PrimaryLocationName | |
> > | GPS or EXIF | GPS:GPSLatitude  GPS:GPSLongitude  GPS:GPSLatitudeRef  GPS:GPSLongitudeRef | |
> > | Keys | Keys:LocationName (with "City, Region, Country") | Keys:GPSCoordinates |
> > | ItemList | ItemList:GPSCoordinates | |
> > | UserData | UserData:GPSCoordinates | |
> > | QuickTime | *(only if not written to Keys, ItemList or UserData)*  QuickTime:GPSCoordinates | |

**While geotagging**

> The special value of "geotag" may be used to represent the GPS
> coordinates determined while [geotagging](geotag.md) from a GPS
> track file. For example:
>
> ```
> exiftool -geolocate=geotag -geotag track.gpx c:\images
> ```
>
> Regular expressions may be also used when geotagging. For example, to constrain
> the search to cities within France or Germany:
>
> ```
> exiftool -geolocate="geotag,co/France|Germany/" -geotag track.gpx c:\images
> ```
>
> Limiting the search like this will result in better performance when geotagging
> a large number of files, but the overhead is significant so it would degrade
> performance if geotagging only a small number of files.

---

### Extra Features

**Language translations**

> The exiftool `-lang` option (API [Lang](https://exiftool.org/ExifTool.html#Lang)
> option) applies to the tags generated by the API
> [Geolocation](https://exiftool.org/ExifTool.html#Geolocation) option.
> **Note that this language translation feature is optional**, and requires
> installation of an [alternate database](#Alt). For example,
> with an alternate database installed:
>
> ```
> exiftool -api geolocation=Munich,Germany -lang de
> ```
>
> gives this output
>
> ```
> Geolocation City                : Muenchen
> Geolocation Region              : Bayern
> Geolocation Subregion           : Regierungsbezirk Oberbayern
> Geolocation Country Code        : DE
> Geolocation Country             : Bundesrepublik Deutschland
> Geolocation Time Zone           : Europe/Berlin
> Geolocation Feature Code        : PPLA
> Geolocation Feature Type        : Seat Of A First-order Administrative Division
> Geolocation Population          : 1300000
> Geolocation Position            : 48.1375, 11.5755
> ```
>
> Note that the language coverage currently isn't very comprehensive, and may only
> be used when reading (ie. not when writing the Geolocate tag or in the API
> [Geolocation](https://exiftool.org/ExifTool.html#Geolocation) option setting), but may be
> extended via user-defined translations (see [Customization](#Custom)
> below).

**Optional parameters**

> Four special API options are used as parameters in the geolocation
> search for both the API Geolocation option and when writing the Geolocate tag.
> > | API Option | Description |
> > | --- | --- |
> > | [GeolocMinPop](https://exiftool.org/ExifTool.html#GeolocMinPop) | Minimum city population to consider when searching for a city in the database. This is compared with the populations from the database which are stored with 2 significant digits. Cities with populations lower than this are not considered in the search. |
> > | [GeolocMaxDist](https://exiftool.org/ExifTool.html#GeolocMaxDist) | When determining geolocation from input GPS coordinates, cities with distances in km greater than this are ignored. |
> > | [GeolocFeature](https://exiftool.org/ExifTool.html#GeolocFeature) | Comma-separated list of feature codes to include in search, or to exclude if the list starts with a dash (-). Valid feature codes are PPL, PPLA, PPLA2, PPLA3, PPLA4, PPLA5, PPLC, PPLCH, PPLF, PPLG, PPLH, PPLL, PPLQ, PPLR, PPLS, PPLW, PPLX, STLMT and Other, plus possible user-included codes if an alternate database is used. See [here](http://www.geonames.org/export/codes.html#P) for a description of these codes. |
> > | [GeolocAltNames](https://exiftool.org/ExifTool.html#GeolocAltNames) | Flag to use alternate names if available when search for a city name. Default is 1. See [Alternate databases](#Alt) below for more information. |

**Alternate databases**

> ExifTool is distributed with a geolocation database of cities
> with population 2000 or greater (plus adm div down to
> [PPLA2](http://www.geonames.org/export/codes.html#P)), but a larger
> database of cities with population 500 or greater and adm div down to
> [PPLA4](http://www.geonames.org/export/codes.html#P) may be downloaded
> from the link below. This database also includes alternate city names and
> language translations. To use the new database, unzip the downloaded file and add
> the following line to your [ExifTool config file](https://exiftool.org/config.html):
>
> ```
> $Image::ExifTool::Geolocation::geoDir = '/PATH/TO/Geolocation500';
> ```
>
> where `/PATH/TO` is the name of the directory containing the unzipped
> Geolocation500 directory. *(Note that this may not work in Windows if there
> are Unicode characters in the path name.)* The `$geoDir` variable
> may also be set to an empty string to completely disable loading of a
> Geolocation database, which may be useful for working with only a user-defined
> database. As a convenience, `$geoDir` may be set at runtime via the
> API [GeoDir](https://exiftool.org/ExifTool.html#GeoDir) pseudo-option.

> A database of alternate city names and language translation files are
> also included in the zip file. The alternate names are consulted only when a full
> city name is provided in a search (ie. not using a regular expression), the API
> [GeolocAltNames](https://exiftool.org/ExifTool.html#GeolocAltNames) option is set (which is
> the default), and the AltNames.dat file is found and matches the number of
> entries in the currently loaded Geolocation.dat database. For example, searching
> for "Big Apple" with the alternate names enabled would return the information for
> New York City.
> > |  |  |
> > | --- | --- |
> > | Download database with cities of population 500 or  greater, including alternate names and translations:  (requires ExifTool 12.82 or later) | [Geolocation500-20260407.zip](https://exiftool.org/Geolocation500-20260407.zip) (8.1 MB) |

> A "build\_geolocation" utility script is available to allow users
> to build their own alternate geolocation databases for ExifTool. This utility
> requires that the necessary input database files from
> [geonames.org](https://download.geonames.org/export/dump/) have been
> downloaded, and provides control over the population thresholds and included
> feature codes on a per-country basis.
> [Read the help documentation](build_geolocation.txt) or
> [download the utility](https://exiftool.org/build_geolocation.zip)
> (requires Perl to run).

> For example, the command below generates a database including cities
> of population 2000 or greater, except 500 or greater in Canada and the U.S.,
> plus all cities with feature class "PPL" regardless of population in Ontario
> Canada and New York State, with alternate names and translations only for
> English, French and German:
>
> ```
> build_geolocation -p 2000 -p ca,us=500 -c "ca.ontario,us.new york=+PPL" -l en,fr,de DIR
> ```
>
> For this command, the necessary geonames database files must exist in the
> `DIR` directory, and the output will go to
> "DIR/Geolocation\_out" but the `-o` option may be used to specify
> another directory (see `build_geolocation -h` for details). The
> "`+PPL`" adds PPL to the list of features to always keep (which is
> "PPLA,PPLA2" by default). Any feature type(s) from the geonames database
> may be added -- this isn't restricted to just cities.

**Listing the database**

> The exiftool application `-listgeo` option may be used to
> list all entries in the Geolocation database, including any user-defined entries
> (see below for a description of how to create these). For this output, the API
> [GeolocMinPop](https://exiftool.org/ExifTool.html#GeolocMinPop),
> [GeolocFeature](https://exiftool.org/ExifTool.html#GeolocFeature) and
> [GeolocAltNames](https://exiftool.org/ExifTool.html#GeolocAltNames) options are in effect, and
> the application `-sort` and `-lang` options may be used to
> sort the output alphabetically and/or apply a language translation.

**Customization**

> User-defined database entries and language translations may be added
> through definitions in the [ExifTool config file](https://exiftool.org/config.html). (Note
> that the config file must be UTF-8 encoded.)

> Database entries are added in this format:
>
> ```
> # Add user-defined cities to the Geolocation lookup
> @Image::ExifTool::UserDefined::Geolocation = (
>     # (city,region,subregion,country_code,country,timezone,feature_code,population,lat,lon)
>     ['Sinemorets','Burgas','Obshtina Tsarevo','BG','','Europe/Sofia','PPL',400,42.06115,27.97833],
>     ['Silistar','Burgas','Obshtina Tsarevo','BG','','Europe/Sofia','PPL',0,42.02199,28.00959],
>     ['Krapets','Dobrich','Obshtina Shabla','BG','','Europe/Sofia','PPL',300,43.62621,28.56669],
> );
> ```
>
> The city name, country\_code, population and latitude/longitude fields must be
> filled, but all other fields may be left empty if they are not applicable or not
> known. If the country name is empty (as above), then the name from the database
> is used if available, based on the specified country code. An optional
> comma-separated list of alternate city names may be added as an additional item
> after the longitude.

> User-defined language translations take this format:
>
> ```
> # Add user-defined language translations (note that user-defined
> # translations override any preexisting translations)
> %Image::ExifTool::Geolocation::geoLang = (
>     # translations for the Russian language
>     ru => {
>         # city, region, subregion and/or country names may be specified
>         # alone to provide a translation for any matching name
>         'Sinemorets' => 'синеморец',
>         'Bulgaria' => 'Болгария',
>         # a country code and optional region (joined without a comma) and an
>         # optional subregion may be added before the city to be more specific
>         'BGBurgas,Obshtina Shabla,Silistar' => 'силистар',
>         'BG,Krapets' => 'Крапец',
>         # the city is omitted to specify only region, subregion or country name
>         'GR,' => 'Греция',          # translate country name only
>         'BGBurgas,' => 'Бургас',    # translate region name only
>         'BGBurgas,Obshtina Tsarevo,' => 'Муниципалитет Царево',# subregion only
>     },
>     # (add other languages here)
> );
> ```
>
> Translations in are organized into sections in the `%geoLang` hash
> based on the language code (eg. "`ru`" in the example above). Within
> each section are the key/value pairs which are used to apply the translation for
> that language. The keys on the left are used to match names in the database,
> translating them to the values on the right. Here is a breakdown of the format
> of the keys on the left:
> > | Key format | Matches... |
> > | --- | --- |
> > | Nnnn | any city, region, subregion or country with name "Nnnn" |
> > | ,Nnnn | any city with name "Nnnn" in any region or country |
> > | CC,Nnnn | any city with name "Nnnn" in any region and any subregion of the country with code "CC" |
> > | CCRrrr,Nnnn | any city with name "Nnnn" in region "Rrrr" and any subregion of the country with code "CC" |
> > | CCRrrr,Ssss,Nnnn | any city with name "Nnnn" in region "Rrrr" and subregion "Ssss" of the country with code "CC" |
> > | CC, | the country with code "CC" |
> > | CCRrrr, | the region "Rrrr" in the country with code "CC" |
> > | CCRrrr,Ssss, | the subregion "Ssss" in region "Rrrr" of the country with code "CC" |
>
> Entries in the table above are ordered from lowest priority at the top to
> highest at the bottom, with the match of highest priority taking precedence when
> translating a name.

> User-defined language translations may be added for the default 'en'
> language to affect the returned names when no language is specified.

---

### Troubleshooting

1. **"ExifTool returns an unexpected city for the specified GPS coordinates"**

> First, try listing a number of nearby cities to see if ExifTool is
> just finding something closer. For example the following command lists the
> 10 cities nearest to a specified GPS position, where "LAT" and "LON" are signed
> floating-point latitude and longitude:
>
> ```
> exiftool -api geolocation=LAT,LON,num=10 -a -g3
> ```
>
> If the expected city is in this list, take note of the feature codes and populations
> of these cities. The API [GeolocFeature](https://exiftool.org/ExifTool.html#GeolocFeature)
> and API [GeolocMinPop](https://exiftool.org/ExifTool.html#GeolocMinPop) options may be used
> to limit the feature types and/or population of the returned cities according
> to your requirements. For example, to avoid returning PPLX city types and cities
> with population less than 10000, you could do this:
>
> ```
> exiftool -api geolocfeature=-PPLX -api geolocminpop=10000 ...
> ```
>
> However, if your city doesn't appear in the list, then it is likely that it
> doesn't exist in the ExifTool Geolocation database. You can check this by
> searching for the specific city in the ExifTool database. This command returns
> all cities with name "CITYNAME" exactly (case insensitive):
>
> ```
> exiftool -api geolocation="CITYNAME" -m -a -g3
> ```
>
> or this command may be used to match cities with "STRING" anywhere in their name
> (the added "`i`" makes the match case insensitive):
>
> ```
> exiftool -api geolocation="ci/STRING/i" -m -a -g3
> ```
>
> A city may not appear in the ExifTool Geolocation database if the population
> is lower than a minimum, which is 2000 for the standard database. An
> [alternate database](#Alt) is available with cities down to population
> 500, but it may be a good idea to first see if the city exists in the source
> geonames.org database. Use the search field [here](https://www.geonames.org)
> to see if the city does exist and to determine its population and feature codes
> (click on the appropriate city in the list returned by the search).

> If the city doesn't exist at geonames.org or has incorrect information,
> there are two things you can do: 1. Create an account and geonames.org and update
> their database with the correct information. This information will eventually
> propagate down to ExifTool (probably within a few months), or you can build your
> own [alternate database](#Alt). Or 2. Create a
> [user-defined entry](#Custom) for your city in the ExifTool config file.

---

*Created Mar 12, 2024*  
*Last revised Apr 7, 2026*

[<-- Back to ExifTool home page](https://exiftool.org/index.html)
