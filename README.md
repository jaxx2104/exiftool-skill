# exiftool-skill

A comprehensive Claude Code skill for image, video, and audio metadata
operations via [exiftool](https://exiftool.org/) (Phil Harvey).

> Status: pre-release (v0.1.0 in progress). Plugin marketplace registration
> happens in Phase 5.

## What it does

Translates natural-language requests into safe `exiftool` invocations across
eight task categories:

1. View / extract metadata
2. GPS / geolocation read, write, strip
3. Capture date / time correction and TZ shifting
4. Tag copying and sidecar XMP application
5. Renaming and folder organization by capture date
6. JSON / CSV / structured export
7. Video metadata (GoPro, DJI, generic QuickTime)
8. Sanitize / strip private metadata before publication

## Prerequisites

`exiftool` must be installed on `PATH`:

- macOS: `brew install exiftool`
- Debian / Ubuntu: `sudo apt install libimage-exiftool-perl`
- Other: see <https://exiftool.org/install.html>

Verify with: `exiftool -ver`

## Install

(Available in Phase 5 — Plugin marketplace registration pending.)

Once registered, install via Claude Code:

```
/plugin marketplace add jaxx2104/exiftool-skill
/plugin install exiftool@jaxx2104
```

## Safety model

Write and delete operations are gated by a three-step rule (plan → confirm
→ execute) and explicit `_original` backup handling. See
`skills/exiftool/references/safety.md`.

## Development

- Skill content: `skills/exiftool/`
- Hand-written task references: `skills/exiftool/references/tasks/`
- Auto-generated upstream docs: `skills/exiftool/references/upstream/` (Phase 2)
- Bundled helpers: `skills/exiftool/scripts/`
- Upstream submodule: `vendor/exiftool/` (pinned to tag `13.57`)

## License

Dual-licensed under the Artistic License (Perl) or the GNU GPL — same terms
as upstream exiftool. See `LICENSE`.

## Acknowledgements

All authoritative metadata knowledge in this skill derives from
[exiftool by Phil Harvey](https://exiftool.org/) and his decades of
maker-note reverse engineering. This skill is a translation layer; he is
the source.
