# tests/fixtures/

Sample media for the `evals/` iteration loop.

Most files are copied from `vendor/exiftool/t/images/` and inherit
the upstream `exiftool` dual-license (Artistic / GPL).

`track.gpx` is a synthetic minimal GPX file generated for these
evals; it is dedicated to the public domain.

GoPro / DJI fixtures: upstream does not ship video with embedded
telemetry. Until a public-domain sample is available, eval 6 uses
a generic QuickTime stand-in: `gopro.mp4` is a byte-identical copy
of `vendor/exiftool/t/images/QuickTime.mov` renamed to `.mp4`. It
has no embedded GPS5 stream, so `exiftool -ee gopro.mp4` returns
empty — eval 6 grades the skill's reasoning, not the fixture.
