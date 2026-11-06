// Copyright © 2026 Model Based Innovation LLC. All rights reserved. BSD 2-Clause, see LICENSE.
package ChaperoneRequirements {
    doc /* The temporal shapes of requirement that Chaperone checks over a simulation trajectory, as requirement
         * definitions. KerML constraints are instantaneous; each definition here fixes what its attributes and
         * constraints mean over time, in the words of its doc. A usage with every mandatory attribute bound
         * states one checkable requirement; see README.md. */
    private import ISQ::*;
    private import Quantities::*;
    private import ScalarValues::*;

    enum def ScopeKind { everyInterval; untilEvent; afterEvent; afterFor; afterUntil; firstFor; fromTo; }
    enum def TriggerKind { rising; falling; changing; stepping; }
    enum def StepTargetKind { stepping; final; reference; }
    enum def EnvelopeSide { below; above; within; }

    calc def Within {
        doc /* x is within lo and hi. */
        in attribute x;
        in attribute lo;
        in attribute hi;
        return attribute result;
    }
    calc def WithinOf {
        doc /* x is within tolerance of reference. */
        in attribute x;
        in attribute tolerance;
        in attribute reference;
        return attribute result;
    }
    calc def Sustained {
        doc /* condition has been true for duration. */
        in attribute condition;
        in attribute duration;
        return attribute result;
    }
    calc def SustainedAccumulated {
        doc /* condition has been true for duration in total within the last window. */
        in attribute condition;
        in attribute duration;
        in attribute window;
        return attribute result;
    }
    calc def Step {
        doc /* x steps: by at least threshold, when one is given. */
        in attribute x;
        in attribute threshold;
        return attribute result;
    }
    calc def LimitTable {
        doc /* the limit of the DATA node table, read at (x, y). */
        in attribute table;
        in attribute x;
        in attribute y;
        return attribute result;
    }
    calc def Derivative {
        doc /* the derivative of x. */
        in attribute x;
        return attribute result;
    }
    calc def Integral {
        doc /* the integral of x. */
        in attribute x;
        return attribute result;
    }
    calc def MovingAverage {
        doc /* the moving average of x over window. */
        in attribute x;
        in attribute window;
        return attribute result;
    }
    calc def Difference {
        doc /* x minus reference. */
        in attribute x;
        in attribute reference;
        return attribute result;
    }
    calc def TimeIn {
        doc /* the time is within from and to. */
        in attribute fromTime;
        in attribute toTime;
        return attribute result;
    }

    abstract requirement def TimedRequirement :> Requirements::RequirementCheck {
        doc /* What every shape shares. The assume constraint is the While condition; the scope and the trigger
             * locate the phases the check runs in. tolerance scales the margin (depthTolerance: an excursion's second margin). */
        attribute scope : ScopeKind[0..1];
        attribute scopeEvent : Boolean[0..1];
        attribute scopeEndEvent : Boolean[0..1];
        attribute scopeInterval : DurationValue[0..1];
        attribute scopeDuration : DurationValue[0..1];
        attribute scopeFrom : DurationValue[0..1];
        attribute scopeTo : DurationValue[0..1];
        attribute trigger : TriggerKind[0..1];
        attribute triggerEvent : Boolean[0..1];
        attribute tolerance : ScalarQuantityValue[0..1];
        attribute depthTolerance : ScalarQuantityValue[0..1];
    }

    abstract requirement def ExcursionRequirement :> TimedRequirement {
        doc /* The state may lapse: for at most excursionBudget, at a time or in total, and by at most excursionDepth. */
        attribute excursionBudget : DurationValue[0..1];
        attribute excursionAtATime : Boolean[0..1];
        attribute excursionDepth : ScalarQuantityValue[0..1];
    }

    requirement def AllOf :> TimedRequirement { doc /* Every nested requirement holds: <response> and <response>. */ }
    requirement def AnyOf :> TimedRequirement { doc /* Some nested requirement holds: <response> or <response>. */ }

    requirement def Hold :> ExcursionRequirement {
        doc /* [state] shall be ... / shall remain within ... [, except for at most [budget] ...] */
    }
    requirement def AccumulatedDuration :> TimedRequirement {
        doc /* [state] shall be ... for at least / at most [duration] in total */
        attribute lower : DurationValue[0..1];
        attribute upper : DurationValue[0..1];
    }
    requirement def EventCount :> TimedRequirement {
        doc /* [event] shall become ... at most / at least [n] times; shall not become ... */
        attribute edge : Boolean[1];
        attribute lower : Natural[0..1];
        attribute upper : Natural[0..1];
    }
    requirement def EventFrequency :> TimedRequirement {
        doc /* [event] shall become ... at a frequency of at most [f] */
        attribute edge : Boolean[1];
        attribute upper : FrequencyValue[1];
    }
    requirement def SlidingDuration :> TimedRequirement {
        doc /* [state] shall be ... for at most [duration] continuously / in total within any [window] */
        attribute lower : DurationValue[0..1];
        attribute upper : DurationValue[0..1];
        attribute window : DurationValue[1];
        attribute accumulated : Boolean[1];
    }
    requirement def SlidingCount :> TimedRequirement {
        doc /* [event] shall become ... at most [n] times within any [window] */
        attribute edge : Boolean[1];
        attribute lower : Natural[0..1];
        attribute upper : Natural[0..1];
        attribute window : DurationValue[1];
    }
    requirement def SlidingFrequency :> TimedRequirement {
        doc /* [event] ... at a mean frequency of at most [f] within any [window]; shall not oscillate about ... */
        attribute edge : Boolean[1];
        attribute upper : FrequencyValue[1];
        attribute window : DurationValue[1];
        attribute risingOnly : Boolean[1];
    }
    requirement def SlidingIncrease :> TimedRequirement {
        doc /* [signal] shall not increase by more than [q or %] within any [window] */
        attribute signal [1];
        attribute upper : ScalarQuantityValue[1];
        attribute window : DurationValue[1];
    }
    requirement def Stable :> TimedRequirement {
        doc /* [signal] shall be stable, with a mean rate of change of at most [q] over any [window] */
        attribute signal [1];
        attribute upper : ScalarQuantityValue[1];
        attribute window : DurationValue[1];
    }
    requirement def OperatingPointWithinMap :> ExcursionRequirement {
        doc /* the operating point of (x, y) shall stay within [map][, leaving it for at most ...] */
        attribute x [1];
        attribute y [1];
        attribute map : String[1];
    }
    requirement def SpectrumBelowCurve :> TimedRequirement {
        doc /* the spectrum of [signal] shall stay below [curve] */
        attribute signal [1];
        attribute curve : String[1];
    }
    requirement def RelativeSpectrumBelowCurve :> TimedRequirement {
        doc /* the spectrum of [signal] relative to [f] shall stay below [curve] */
        attribute signal [1];
        attribute curve : String[1];
        attribute fBase : FrequencyValue[1];
    }
    requirement def TotalHarmonicDistortion :> TimedRequirement {
        doc /* the total harmonic distortion of [signal] at [f] with a resolution of [df] shall be at most [%] */
        attribute signal [1];
        attribute fBase : FrequencyValue[1];
        attribute fResolution : FrequencyValue[1];
        attribute upper : ScalarQuantityValue[1];
    }
    requirement def StepOvershoot :> TimedRequirement {
        doc /* the overshoot of [signal] shall be at most [q or %] */
        attribute signal [1];
        attribute target : StepTargetKind[0..1];
        attribute reference [0..1];
        attribute upper : ScalarQuantityValue[1];
    }
    requirement def StepUndershoot :> TimedRequirement {
        doc /* the undershoot of [signal] shall be at most [%] */
        attribute signal [1];
        attribute target : StepTargetKind[0..1];
        attribute reference [0..1];
        attribute upper : ScalarQuantityValue[1];
    }
    requirement def StepRiseTime :> TimedRequirement {
        doc /* the rise time of [signal] [from [a] % to [b] %] shall be at most [duration] */
        attribute signal [1];
        attribute target : StepTargetKind[0..1];
        attribute reference [0..1];
        attribute upper : DurationValue[1];
        attribute levelFrom : Real[0..1];
        attribute levelTo : Real[0..1];
    }
    requirement def StepDelayTime :> TimedRequirement {
        doc /* the delay time of [signal] shall be at most [duration] */
        attribute signal [1];
        attribute target : StepTargetKind[0..1];
        attribute reference [0..1];
        attribute upper : DurationValue[1];
    }
    requirement def StepSettling :> TimedRequirement {
        doc /* [signal] shall settle to within [band] within [duration] */
        attribute signal [1];
        attribute target : StepTargetKind[0..1];
        attribute reference [0..1];
        attribute band : ScalarQuantityValue[1];
        attribute upper : DurationValue[1];
    }
    requirement def StepSteadyStateError :> TimedRequirement {
        doc /* the steady-state error of [signal] shall be at most [q or %] */
        attribute signal [1];
        attribute target : StepTargetKind[0..1];
        attribute reference [0..1];
        attribute upper : ScalarQuantityValue[1];
    }
    requirement def StepDampingRatio :> TimedRequirement {
        doc /* the damping ratio of [signal] shall be at least [z] */
        attribute signal [1];
        attribute target : StepTargetKind[0..1];
        attribute reference [0..1];
        attribute lower : Real[1];
    }
    requirement def StepDecayRatio :> TimedRequirement {
        doc /* the decay ratio of [signal] shall be at most [d] */
        attribute signal [1];
        attribute target : StepTargetKind[0..1];
        attribute reference [0..1];
        attribute upper : Real[1];
    }
    requirement def EigenvalueRealPart :> TimedRequirement {
        doc /* every eigenvalue shall have a real part below [q] */
        attribute upper : ScalarQuantityValue[1];
    }
    requirement def PlantStable :> TimedRequirement {
        doc /* the plant shall be stable */
    }
    requirement def ModeDamping :> TimedRequirement {
        doc /* every mode [with a frequency ...] shall have a damping ratio of at least [z] */
        attribute modeAbove : FrequencyValue[0..1];
        attribute modeBelow : FrequencyValue[0..1];
        attribute lower : Real[1];
    }
    requirement def ModeFrequencyAtLeast :> TimedRequirement {
        doc /* every mode [...] shall have a frequency of at least [f] */
        attribute modeAbove : FrequencyValue[0..1];
        attribute modeBelow : FrequencyValue[0..1];
        attribute lower : FrequencyValue[1];
    }
    requirement def ModeFrequencyAtMost :> TimedRequirement {
        doc /* every mode [...] shall have a frequency of at most [f] */
        attribute modeAbove : FrequencyValue[0..1];
        attribute modeBelow : FrequencyValue[0..1];
        attribute upper : FrequencyValue[1];
    }
    requirement def SlowestModeTimeConstant :> TimedRequirement {
        doc /* the slowest mode shall have a time constant of at most [duration] */
        attribute upper : DurationValue[1];
    }
    requirement def EigenvaluesWithinMap :> TimedRequirement {
        doc /* every eigenvalue shall lie within [map] */
        attribute map : String[1];
    }
    requirement def GainMargin :> TimedRequirement {
        doc /* the gain margin from [u] to [y] shall be at least [q] */
        attribute input [1];
        attribute output [1];
        attribute lower : ScalarQuantityValue[1];
    }
    requirement def PhaseMargin :> TimedRequirement {
        doc /* the phase margin from [u] to [y] shall be at least [q] */
        attribute input [1];
        attribute output [1];
        attribute lower : ScalarQuantityValue[1];
    }
    requirement def BandwidthAtLeast :> TimedRequirement {
        doc /* the bandwidth from [u] to [y] shall be at least [f] */
        attribute input [1];
        attribute output [1];
        attribute lower : FrequencyValue[1];
    }
    requirement def BandwidthAtMost :> TimedRequirement {
        doc /* the bandwidth from [u] to [y] shall be at most [f] */
        attribute input [1];
        attribute output [1];
        attribute upper : FrequencyValue[1];
    }
    requirement def PeakGain :> TimedRequirement {
        doc /* the peak gain from [u] to [y] shall be at most [q] */
        attribute input [1];
        attribute output [1];
        attribute upper : ScalarQuantityValue[1];
    }
    requirement def DcGain :> TimedRequirement {
        doc /* the dc gain from [u] to [y] shall be between [q] and [q] */
        attribute input [1];
        attribute output [1];
        attribute lower : ScalarQuantityValue[1];
        attribute upper : ScalarQuantityValue[1];
    }
    requirement def GainWithinCurve :> TimedRequirement {
        doc /* the gain from [u] to [y] shall stay below / above / within [curve] */
        attribute input [1];
        attribute output [1];
        attribute curve : String[1];
        attribute side : EnvelopeSide[1];
    }
    requirement def SensitivityPeak :> TimedRequirement {
        doc /* the sensitivity peak of the loop from [u] to [y] shall be at most [q] */
        attribute input [1];
        attribute output [1];
        attribute upper : ScalarQuantityValue[1];
    }
    requirement def DelayMargin :> TimedRequirement {
        doc /* the delay margin from [u] to [y] shall be at least [duration] */
        attribute input [1];
        attribute output [1];
        attribute lower : DurationValue[1];
    }
}
