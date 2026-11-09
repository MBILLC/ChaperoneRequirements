# Changelog

## v0.16.0 — 2026-11-09

- Phasors (Chaperone, `Planning/MSL_PHRASEBOOK_SURVEY.md`, step 5): a glossary phasor is an attribute typed `ScalarValues::Complex`, its unit in `@ChaperoneSignal`, and the parts a requirement names are attributes nested in it: `magnitude`, `'phase angle'`, `'real part'`, `'imaginary part'` and `'phase angle relative to <another phasor>'`, typed by their ISQ value types. The `ChaperoneSignal` doc and the README say so; no definition changed. The Modelica side is Requirements 0.17.0 (`Units.Phasors`).

## v0.15.0 — 2026-11-09

- `ChaperoneUnits`: display units of the quantities of the MSL's components (Chaperone, `Planning/MSL_PHRASEBOOK_SURVEY.md`, step 4) that the SI library of SysML v2 lacks: `kOhm`, `MOhm`, `mOhm` (resistance); `uF`, `nF`, `pF` (capacitance); `'kV⋅A'` and `kvar` (apparent and reactive power); `'A⋅h'` (charge); `'kJ/(kg⋅K)'` (specific heat capacity); `'mPa⋅s'` (dynamic viscosity); `mT` (magnetic flux density). The coherent SI units of that step (`'Ω'`, `S`, `F`, `'V⋅A'`, `var`, `C`, `'J/(kg⋅K)'`, `'Pa⋅s'`, `'W/(m⋅K)'`, `'W/(m²⋅K)'`, `'J/K'`, `'K/W'`, `'W/m²'`, `'kg⋅m²'`, `T`, ...) are the SI library's, and `g/cm3`, `cm2`, `mm2` and `bar/s` are composed from units it, or this package, defines. The Modelica side is Requirements 0.16.0.

## v0.14.4 — 2026-11-09

- `ChaperoneUnits`: `mH`, `uH` (inductance) and `mWb` (magnetic flux), display units of quantities the MSL's connectors carry (Chaperone, `Planning/MSL_PHRASEBOOK_SURVEY.md`, step 3). The SI library of SysML v2 has `H` and `Wb` but not these prefixed forms. The other display units of that step (`deg/s`, `deg/s2`, `l/min`, `m3/h`, `kJ/kg`, `g/kg`) are composed from units the SI library defines, and need nothing here. The Modelica side is Requirements 0.15.0.

## v0.14.3 — 2026-11-07

- `ChaperoneUnits`: `bar` has no short name. `<bar> bar` named it twice, and SysON v2026.11.0 does not resolve an element whose short name equals its name (eclipse-syson/syson#2106), so `2[bar]` lost its unit there. `[bar]` is written and read as before.

## v0.14.2 — 2026-11-07

- `examples/ExampleLibrary.sysml` writes `<=` and `>=` on Reals. `PATTERNS.md` and the README state the rule and its one exception, the eigenvalue family.
- `ChaperoneMetadata`: `rtol` on a verification case is now `relativeTolerance`, the name SysPhS 2's analysis case uses, as `startTime` and `stopTime` already are. Nothing is imported from SysPhS.

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
