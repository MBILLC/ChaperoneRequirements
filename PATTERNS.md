# The definitions

Written from Chaperone's vocabulary table.

| Definition | The controlled-English phrase | Attributes (**mandatory**) |
|---|---|---|
| `Hold` | <state> shall be ... / shall remain within ... [, except for at most <budget> ...] | ; a `require constraint` |
| `AccumulatedDuration` | <state> shall be ... for at least / at most <duration> in total | lower, upper; a `require constraint` |
| `EventCount` | <event> shall become ... at most / at least <n> times; shall not become ... | **edge**, lower, upper |
| `EventFrequency` | <event> shall become ... at a frequency of at most <f> | **edge**, **upper** |
| `SlidingDuration` | <state> shall be ... for at most <duration> continuously / in total within any <window> | lower, upper, **window**, **accumulated**; a `require constraint` |
| `SlidingCount` | <event> shall become ... at most <n> times within any <window> | **edge**, lower, upper, **window** |
| `SlidingFrequency` | <event> ... at a mean frequency of at most <f> within any <window>; shall not oscillate about ... | **edge**, **upper**, **window**, **risingOnly** |
| `SlidingIncrease` | <signal> shall not increase by more than <q or %> within any <window> | **signal**, **upper**, **window** |
| `Stable` | <signal> shall be stable, with a mean rate of change of at most <q> over any <window> | **signal**, **upper**, **window** |
| `OperatingPointWithinMap` | the operating point of (x, y) shall stay within <map>[, leaving it for at most ...] | **x**, **y**, **map** |
| `SpectrumBelowCurve` | the spectrum of <signal> shall stay below <curve> | **signal**, **curve** |
| `RelativeSpectrumBelowCurve` | the spectrum of <signal> relative to <f> shall stay below <curve> | **signal**, **curve**, **fBase** |
| `TotalHarmonicDistortion` | the total harmonic distortion of <signal> at <f> with a resolution of <df> shall be at most <%> | **signal**, **fBase**, **fResolution**, **upper** |
| `StepOvershoot` | the overshoot of <signal> shall be at most <q or %> | **signal**, target, reference, **upper** |
| `StepUndershoot` | the undershoot of <signal> shall be at most <%> | **signal**, target, reference, **upper** |
| `StepRiseTime` | the rise time of <signal> [from <a> % to <b> %] shall be at most <duration> | **signal**, target, reference, **upper**, levelFrom, levelTo |
| `StepDelayTime` | the delay time of <signal> shall be at most <duration> | **signal**, target, reference, **upper** |
| `StepSettling` | <signal> shall settle to within <band> within <duration> | **signal**, target, reference, **band**, **upper** |
| `StepSteadyStateError` | the steady-state error of <signal> shall be at most <q or %> | **signal**, target, reference, **upper** |
| `StepDampingRatio` | the damping ratio of <signal> shall be at least <z> | **signal**, target, reference, **lower** |
| `StepDecayRatio` | the decay ratio of <signal> shall be at most <d> | **signal**, target, reference, **upper** |
| `EigenvalueRealPart` | every eigenvalue shall have a real part below <q> | **upper** |
| `PlantStable` | the plant shall be stable | — |
| `ModeDamping` | every mode [with a frequency ...] shall have a damping ratio of at least <z> | modeAbove, modeBelow, **lower** |
| `ModeFrequencyAtLeast` | every mode [...] shall have a frequency of at least <f> | modeAbove, modeBelow, **lower** |
| `ModeFrequencyAtMost` | every mode [...] shall have a frequency of at most <f> | modeAbove, modeBelow, **upper** |
| `SlowestModeTimeConstant` | the slowest mode shall have a time constant of at most <duration> | **upper** |
| `EigenvaluesWithinMap` | every eigenvalue shall lie within <map> | **map** |
| `GainMargin` | the gain margin from <u> to <y> shall be at least <q> | **input**, **output**, **lower** |
| `PhaseMargin` | the phase margin from <u> to <y> shall be at least <q> | **input**, **output**, **lower** |
| `BandwidthAtLeast` | the bandwidth from <u> to <y> shall be at least <f> | **input**, **output**, **lower** |
| `BandwidthAtMost` | the bandwidth from <u> to <y> shall be at most <f> | **input**, **output**, **upper** |
| `PeakGain` | the peak gain from <u> to <y> shall be at most <q> | **input**, **output**, **upper** |
| `DcGain` | the dc gain from <u> to <y> shall be between <q> and <q> | **input**, **output**, **lower**, **upper** |
| `GainWithinCurve` | the gain from <u> to <y> shall stay below / above / within <curve> | **input**, **output**, **curve**, **side** |
| `SensitivityPeak` | the sensitivity peak of the loop from <u> to <y> shall be at most <q> | **input**, **output**, **upper** |
| `DelayMargin` | the delay margin from <u> to <y> shall be at least <duration> | **input**, **output**, **lower** |
