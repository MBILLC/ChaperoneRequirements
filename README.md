# ChaperoneRequirements

Requirement patterns in SysML v2: the temporal vocabulary [Chaperone](https://www.modelbased.cloud) checks over simulation trajectories.

SysML v2 gives a requirement an identity, a subject, assumptions, typed parameters and traceability. Its constraints, though, are instantaneous Boolean expressions: it has no standard way to say *within any window of 1 h*, *has been true for 30 s*, *at most 3 rising edges while ...*, *overshoot* or *settling time*. This library adds those shapes as ordinary requirement definitions, so a SysML tool user can state a requirement that a simulation-based checker can decide, and can import the library without any Chaperone tooling.

It holds three packages:

| Package | What |
|---|---|
| `ChaperoneRequirements.sysml` | one requirement definition per temporal shape, and the functions their expressions use |
| `ChaperoneMetadata.sysml` | the metadata a requirement, signal or verdict carries where SysML v2 has no slot |
| `ChaperoneUnits.sysml` | the units the shapes accept that the SI and US customary libraries do not define under the same name |

[PATTERNS.md](PATTERNS.md) maps every definition to its controlled-English phrase and lists its attributes.

## A requirement

```sysml
package Cabin {
    private import ISQ::*;
    private import SI::*;
    private import ChaperoneRequirements::*;

    part def CabinModel {
        attribute 'the pack is on' : ScalarValues::Boolean;
        attribute 'the door is open' : ScalarValues::Boolean;
    }

    requirement <'REQ-1'> 'Door openings' : EventCount {
        subject plant : CabinModel;
        assume constraint { plant.'the pack is on' }
        attribute :>> edge = plant.'the door is open';
        attribute :>> upper = 3;
    }
}
```

This reads *While the pack is on, the door shall become open at most 3 times.* A usage with every mandatory attribute bound states one checkable requirement. Chaperone refuses any other usage rather than completing it.

## Reading a model

Chaperone reads the normative JSON of Systems Modeling API & Services 1.0:

- the short name of a requirement usage is its ID, and the declared name its title;
- the attributes of the subject are the glossary; the declared name is the noun phrase, and the ISQ type gives the dimension;
- what binds an attribute to a plant variable is a separate file, not part of the model.

A verdict is written back as a `verification` usage with `VerdictKind` and `@ChaperoneVerdict`. `VerdictKind` has no neutral element, so *not applicable* reads `inconclusive` with `property = notApplicable` in the metadata, never `pass`.

## Checks

CI loads the three packages and the two examples into the OMG pilot implementation (release pinned in `.github/workflows/ci.yml`) and fails on any error. `examples/` holds one synthetic project twice: `Example.sysml` with the requirements as sentences, and `ExampleLibrary.sysml` as usages of this library, covering every definition.

## Versions

A tag follows the version of the [Requirements](https://github.com/MBILLC/Requirements) Modelica library it was written against. See [CHANGELOG.md](CHANGELOG.md).

This is a user library for SysML v2. It is not part of the OMG standard and is not endorsed by OMG.

## Copyright

Copyright © 2026 Model Based Innovation LLC. All rights reserved. Licensed under the BSD 2-Clause License; see [LICENSE](LICENSE).
