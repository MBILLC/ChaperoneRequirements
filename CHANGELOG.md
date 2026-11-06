# Changelog

## v0.14.1 — 2026-11-06

- `ChaperoneMetadata`: `ChaperoneRewrite`, on a Derivation connection: status, approver, date, what was refused.
- `examples/Derivation.sysml`: an original, its rewrite, and a partial refusal.
- CI: `sysmlpy analyze` on the three packages. `PATTERNS.md`: a stray separator.

## v0.14.0 — 2026-11-06

First release, written against Requirements 0.14.0.

- `ChaperoneRequirements`: one requirement definition per temporal shape, scope, trigger, excursion and depth attributes, and the functions their expressions use.
- `ChaperoneMetadata`: metadata for requirements, signals, components, data, verification cases and verdicts.
- `ChaperoneUnits`: `ms`, `kPa`, `bar`, `mbar`, `kft`, `rpm`, `rev/min`, `%`.
- CI: the OMG pilot implementation 0.63.1 (release 2026-09.1) loads the library and the examples without errors.

## Copyright

Copyright © 2026 Model Based Innovation LLC. All rights reserved.
