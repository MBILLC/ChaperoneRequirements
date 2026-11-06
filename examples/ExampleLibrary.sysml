// Copyright © 2026 Model Based Innovation LLC. All rights reserved.
package ExampleLibrary {
    private import ISQ::*;
    private import SI::*;
    private import ScalarValues::*;
    private import VerificationCases::*;
    private import USCustomaryUnits::ft;
    private import ChaperoneUnits::*;
    private import ChaperoneMetadata::*;
    private import ChaperoneRequirements::*;
    package Plants {
        part def Cabin {
            part <VLV> 'the bypass valve' [2] {
                @ChaperoneComponent { componentType = "bypass valve"; }
                attribute <Cabin_vlvOpen> 'the bypass of VLV is open' : ScalarValues::Boolean;
            }
            attribute <Cabin_T> 'the cabin temperature' : ISQ::ThermodynamicTemperatureValue {
                @ChaperoneSignal { unit = "degC"; }
            }
            attribute <Cabin_Tset> 'the temperature setpoint' : ISQ::ThermodynamicTemperatureValue {
                @ChaperoneSignal { unit = "degC"; }
            }
            attribute <Cabin_V> 'the bus voltage' : ISQ::ElectricPotentialDifferenceValue;
            attribute <Cabin_mdot> 'the bleed flow' : ISQ::MassFlowRateValue;
            attribute <Cabin_n> 'the fan speed' : ISQ::AngularVelocityValue {
                @ChaperoneSignal { unit = "rpm"; }
            }
            attribute <Cabin_alt> 'the altitude' : ISQ::LengthValue {
                @ChaperoneSignal { unit = "kft"; }
            }
            attribute <Cabin_acc> 'the acceleration' : ISQ::AccelerationValue;
            attribute <Cabin_tq> 'the shaft torque' : ISQ::TorqueValue;
            attribute <Cabin_t> 'the time' : ISQ::DurationValue;
            attribute <Cabin_phase> 'the flight phase' : ScalarValues::Integer {
                @ChaperoneSignal { unit = "1"; }
            }
            attribute <Cabin_pack> 'the pack is on' : ScalarValues::Boolean;
            attribute <Cabin_door> 'the door is open' : ScalarValues::Boolean {
                @ChaperoneSignal { description = "A \"quoted\" note\nwith a \\ second line"; }
            }
            in attribute <Cabin_u> 'the valve command' : ScalarValues::Real {
                @ChaperoneSignal { unit = "1"; description = "dimensionless: a fraction of full travel"; }
            }
            attribute <Cabin_y> 'the valve position' : ScalarValues::Real {
                @ChaperoneSignal { unit = "1"; description = "dimensionless: a fraction of full travel"; }
            }
        }
    }
    package example {
        @ChaperoneDocument { document = "example.sdoc"; }
        @ChaperoneData { uid = "DATA-MAP"; name = "the envelope map"; kind = "region"; values = "0, 0\n100, 0\n100, 100\n0, 100\n0, 0"; }
        @ChaperoneData { uid = "DATA-POLE"; name = "the pole map"; kind = "convex_hull"; values = "-10, -10\n-1, -10\n-1, 10\n-10, 10\n-10, -10"; }
        @ChaperoneData { uid = "DATA-SPEC"; name = "the limit spectrum curve"; kind = "spectrum"; values = "10, 1\n100, 0.5"; fMax = "100"; fResolution = "1"; }
        @ChaperoneData { uid = "DATA-GAIN"; name = "the gain limit curve"; kind = "gain_curve"; values = "0.1, 3\n10, -20"; }
        @ChaperoneData { uid = "DATA-TABLE"; name = "the limit table"; kind = "limit_table"; values = "0, 0, 10\n0, 20, 21\n100, 25, 26"; x = "Cabin_t"; y = "Cabin_alt"; unit = "degC"; }
        requirement <'REQ-EX-hold'> 'Example hold' : ChaperoneRequirements::Hold {
            doc /* While the pack is on, the cabin temperature shall remain within 18 degC and 27 degC. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> tolerance = 2['°C'];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            assume constraint { plant.'the pack is on' }
            require constraint { Within(plant.'the cabin temperature', 18['°C_abs'], 27['°C_abs']) }
        }
        requirement <'REQ-EX-hold_x'> 'Example hold_x' : ChaperoneRequirements::Hold {
            doc /* The cabin temperature shall be at most 30 degC, except for at most 1 h in total and by at most 2 K. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> tolerance = 1[h];
            attribute :>> depthTolerance = 0.5[K];
            attribute :>> excursionBudget = 1[h];
            attribute :>> excursionAtATime = false;
            attribute :>> excursionDepth = 2[K];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { plant.'the cabin temperature' <= 30['°C_abs'] }
        }
        requirement <'REQ-EX-hold_x2'> 'Example hold_x2' : ChaperoneRequirements::Hold {
            doc /* The bus voltage shall remain within 200 V and 240 V, leaving it for at most 5 s at a time. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> tolerance = 1[s];
            attribute :>> excursionBudget = 5[s];
            attribute :>> excursionAtATime = true;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { Within(plant.'the bus voltage', 200[V], 240[V]) }
        }
        requirement <'REQ-EX-when'> 'Example when' : ChaperoneRequirements::Hold {
            doc /* When the bus voltage falls below 200 V, the pack shall be on. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> trigger = TriggerKind::rising;
            attribute :>> triggerEvent = plant.'the bus voltage' < 200[V];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { plant.'the pack is on' }
        }
        requirement <'REQ-EX-falling'> 'Example falling' : ChaperoneRequirements::Hold {
            doc /* When the pack is no longer on, the door shall be open. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> trigger = TriggerKind::falling;
            attribute :>> triggerEvent = plant.'the pack is on';
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { plant.'the door is open' }
        }
        requirement <'REQ-EX-first'> 'Example first' : ChaperoneRequirements::Hold {
            doc /* During the first 10 s, the bus voltage shall be above 100 V. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> tolerance = 5[V];
            attribute :>> scope = ScopeKind::firstFor;
            attribute :>> scopeDuration = 10[s];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { plant.'the bus voltage' > 100[V] }
        }
        requirement <'REQ-EX-every'> 'Example every' : ChaperoneRequirements::Hold {
            doc /* Every 2 s for 0.5 s, the pack shall be on. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> scope = ScopeKind::everyInterval;
            attribute :>> scopeInterval = 2[s];
            attribute :>> scopeDuration = 0.5[s];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { plant.'the pack is on' }
        }
        requirement <'REQ-EX-after_for'> 'Example after_for' : ChaperoneRequirements::Hold {
            doc /* For 3 min after the pack becomes on, the bleed flow shall be at least 0.5 kg/s. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> scope = ScopeKind::afterFor;
            attribute :>> scopeEvent = plant.'the pack is on';
            attribute :>> scopeDuration = 3[min];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { plant.'the bleed flow' >= 0.5[kg/s] }
        }
        requirement <'REQ-EX-after_until'> 'Example after_until' : ChaperoneRequirements::Hold {
            doc /* After the pack becomes on until the door becomes open, the fan speed shall be above 100 rpm. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> scope = ScopeKind::afterUntil;
            attribute :>> scopeEvent = plant.'the pack is on';
            attribute :>> scopeEndEvent = plant.'the door is open';
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { plant.'the fan speed' > 100[rpm] }
        }
        requirement <'REQ-EX-until'> 'Example until' : ChaperoneRequirements::Hold {
            doc /* Until the pack becomes on, the altitude shall be below 10 kft. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> scope = ScopeKind::untilEvent;
            attribute :>> scopeEvent = plant.'the pack is on';
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { plant.'the altitude' < 10[kft] }
        }
        requirement <'REQ-EX-cmp_sig'> 'Example cmp_sig' : ChaperoneRequirements::Hold {
            doc /* The cabin temperature shall be at most the temperature setpoint. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { plant.'the cabin temperature' <= plant.'the temperature setpoint' }
        }
        requirement <'REQ-EX-within_of'> 'Example within_of' : ChaperoneRequirements::Hold {
            doc /* The cabin temperature shall remain within 0.5 K of the temperature setpoint. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { WithinOf(plant.'the cabin temperature', 0.5[K], plant.'the temperature setpoint') }
        }
        requirement <'REQ-EX-table'> 'Example table' : ChaperoneRequirements::Hold {
            doc /* The cabin temperature shall be at most the limit table at the time and the altitude. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { plant.'the cabin temperature' <= LimitTable("DATA-TABLE", plant.'the time', plant.'the altitude') }
        }
        requirement <'REQ-EX-compound'> 'Example compound' : ChaperoneRequirements::Hold {
            doc /* While the pack is on or the door is open, the bus voltage shall be above 100 V. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            assume constraint { plant.'the pack is on' or plant.'the door is open' }
            require constraint { plant.'the bus voltage' > 100[V] }
        }
        requirement <'REQ-EX-and'> 'Example and' : ChaperoneRequirements::AllOf {
            doc /* While the pack is on, the bus voltage shall be above 100 V and the bleed flow shall be above 0.1 kg/s. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            assume constraint { plant.'the pack is on' }
            requirement response1 : ChaperoneRequirements::Hold {
                require constraint { plant.'the bus voltage' > 100[V] }
            }
            requirement response2 : ChaperoneRequirements::Hold {
                require constraint { plant.'the bleed flow' > 0.1[kg/s] }
            }
        }
        requirement <'REQ-EX-or'> 'Example or' : ChaperoneRequirements::AnyOf {
            doc /* The bus voltage shall be above 100 V or the pack shall be on. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            requirement response1 : ChaperoneRequirements::Hold {
                require constraint { plant.'the bus voltage' > 100[V] }
            }
            requirement response2 : ChaperoneRequirements::Hold {
                require constraint { plant.'the pack is on' }
            }
        }
        requirement <'REQ-EX-not'> 'Example not' : ChaperoneRequirements::Hold {
            doc /* While the door is open, the pack shall not be on. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            assume constraint { plant.'the door is open' }
            require constraint { not plant.'the pack is on' }
        }
        requirement <'REQ-EX-sustained'> 'Example sustained' : ChaperoneRequirements::Hold {
            doc /* While the pack has been on for 10 s, the fan speed shall be above 100 rpm. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            assume constraint { Sustained(plant.'the pack is on', 10[s]) }
            require constraint { plant.'the fan speed' > 100[rpm] }
        }
        requirement <'REQ-EX-sustained_cmp'> 'Example sustained_cmp' : ChaperoneRequirements::Hold {
            doc /* When the bus voltage has been above 200 V for 10 s, the pack shall be on. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> trigger = TriggerKind::rising;
            attribute :>> triggerEvent = Sustained(plant.'the bus voltage' > 200[V], 10[s]);
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { plant.'the pack is on' }
        }
        requirement <'REQ-EX-integer'> 'Example integer' : ChaperoneRequirements::Hold {
            doc /* While the flight phase is 2, the pack shall be on. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            assume constraint { plant.'the flight phase' == 2 }
            require constraint { plant.'the pack is on' }
        }
        requirement <'REQ-EX-derivative'> 'Example derivative' : ChaperoneRequirements::Hold {
            doc /* The derivative of the cabin temperature shall be at most 3 K/s. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { Derivative(plant.'the cabin temperature') <= 3[K/s] }
        }
        requirement <'REQ-EX-integral'> 'Example integral' : ChaperoneRequirements::Hold {
            doc /* The integral of the bleed flow shall be below 8 kg. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { Integral(plant.'the bleed flow') < 8[kg] }
        }
        requirement <'REQ-EX-moving'> 'Example moving' : ChaperoneRequirements::Hold {
            doc /* The moving average of the bus voltage over 5 s shall be above 100 V. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { MovingAverage(plant.'the bus voltage', 5[s]) > 100[V] }
        }
        requirement <'REQ-EX-difference'> 'Example difference' : ChaperoneRequirements::Hold {
            doc /* The difference between the cabin temperature and the temperature setpoint shall be at most 2 K. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { Difference(plant.'the cabin temperature', plant.'the temperature setpoint') <= 2[K] }
        }
        requirement <'REQ-EX-torque'> 'Example torque' : ChaperoneRequirements::Hold {
            doc /* The acceleration shall be at most 2 m/s2. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { plant.'the acceleration' <= 2[m/s^2] }
        }
        requirement <'REQ-EX-torque2'> 'Example torque2' : ChaperoneRequirements::Hold {
            doc /* The shaft torque shall be at most 20 N.m. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { plant.'the shaft torque' <= 20[N*m] }
        }
        requirement <'REQ-EX-negative'> 'Example negative' : ChaperoneRequirements::Hold {
            doc /* The cabin temperature shall be above -20.5 degC. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { plant.'the cabin temperature' > -20.5['°C_abs'] }
        }
        requirement <'REQ-EX-duration'> 'Example duration' : ChaperoneRequirements::AccumulatedDuration {
            doc /* While the pack is on, the door shall be open for at most 5 s in total. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> upper = 5[s];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            assume constraint { plant.'the pack is on' }
            require constraint { plant.'the door is open' }
        }
        requirement <'REQ-EX-dwell'> 'Example dwell' : ChaperoneRequirements::AccumulatedDuration {
            doc /* When the pack becomes on, the pack shall stay on for at least 10 min. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> lower = 10[min];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            assume constraint { plant.'the pack is on' }
            require constraint { plant.'the pack is on' }
        }
        requirement <'REQ-EX-count'> 'Example count' : ChaperoneRequirements::EventCount {
            doc /* While the pack is on, the door shall become open at most 3 times. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> edge = plant.'the door is open';
            attribute :>> upper = 3;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            assume constraint { plant.'the pack is on' }
        }
        requirement <'REQ-EX-never'> 'Example never' : ChaperoneRequirements::EventCount {
            doc /* The door shall not become open. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> edge = plant.'the door is open';
            attribute :>> upper = 0;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-frequency'> 'Example frequency' : ChaperoneRequirements::EventFrequency {
            doc /* The door shall become open at a frequency of at most 2 Hz. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> edge = plant.'the door is open';
            attribute :>> upper = 2[Hz];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-s_dur'> 'Example s_dur' : ChaperoneRequirements::SlidingDuration {
            doc /* The pack shall be on for at most 5 s continuously within any 1 min. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> upper = 5[s];
            attribute :>> window = 1[min];
            attribute :>> accumulated = false;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { plant.'the pack is on' }
        }
        requirement <'REQ-EX-s_dur2'> 'Example s_dur2' : ChaperoneRequirements::SlidingDuration {
            doc /* The pack shall be on for at least 5 s in total within any 1 min. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> lower = 5[s];
            attribute :>> window = 1[min];
            attribute :>> accumulated = true;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
            require constraint { plant.'the pack is on' }
        }
        requirement <'REQ-EX-s_count'> 'Example s_count' : ChaperoneRequirements::SlidingCount {
            doc /* The door shall become open at most 3 times within any 1 h. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> edge = plant.'the door is open';
            attribute :>> upper = 3;
            attribute :>> window = 1[h];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-s_freq'> 'Example s_freq' : ChaperoneRequirements::SlidingFrequency {
            doc /* The door shall become open at a mean frequency of at most 2 Hz within any 1 min. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> edge = plant.'the door is open';
            attribute :>> upper = 2[Hz];
            attribute :>> window = 1[min];
            attribute :>> risingOnly = true;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-oscillate'> 'Example oscillate' : ChaperoneRequirements::SlidingFrequency {
            doc /* The bus voltage shall not oscillate about 220 V faster than 2 Hz on average over any 1 min. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> edge = plant.'the bus voltage' > 220[V];
            attribute :>> upper = 2[Hz];
            attribute :>> window = 1[min];
            attribute :>> risingOnly = false;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-increase'> 'Example increase' : ChaperoneRequirements::SlidingIncrease {
            doc /* The cabin temperature shall not increase by more than 3 K within any 10 s. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> signal = plant.'the cabin temperature';
            attribute :>> upper = 3[K];
            attribute :>> window = 10[s];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-increase_pct'> 'Example increase_pct' : ChaperoneRequirements::SlidingIncrease {
            doc /* The bus voltage shall not increase by more than 5 % within any 10 s. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> signal = plant.'the bus voltage';
            attribute :>> upper = 5['%'];
            attribute :>> window = 10[s];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-stable'> 'Example stable' : ChaperoneRequirements::Stable {
            doc /* The cabin temperature shall be stable, with a mean rate of change of at most 0.1 K/s over any 1 min. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> signal = plant.'the cabin temperature';
            attribute :>> upper = 0.1[K/s];
            attribute :>> window = 1[min];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-domain'> 'Example domain' : ChaperoneRequirements::OperatingPointWithinMap {
            doc /* The operating point of (time, derivative of altitude) shall stay within the envelope map. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> x = plant.'the time';
            attribute :>> y = Derivative(plant.'the altitude');
            attribute :>> map = "DATA-MAP";
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-domain_x'> 'Example domain_x' : ChaperoneRequirements::OperatingPointWithinMap {
            doc /* The operating point of (time, altitude) shall stay within the envelope map, leaving it for at most 5 s at a time. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> excursionBudget = 5[s];
            attribute :>> excursionAtATime = true;
            attribute :>> x = plant.'the time';
            attribute :>> y = plant.'the altitude';
            attribute :>> map = "DATA-MAP";
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-spectrum'> 'Example spectrum' : ChaperoneRequirements::SpectrumBelowCurve {
            doc /* The spectrum of the bus voltage shall stay below the limit spectrum curve. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> signal = plant.'the bus voltage';
            attribute :>> curve = "DATA-SPEC";
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-spectrum_rel'> 'Example spectrum_rel' : ChaperoneRequirements::RelativeSpectrumBelowCurve {
            doc /* The spectrum of the bus voltage relative to 50 Hz shall stay below the limit spectrum curve. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> signal = plant.'the bus voltage';
            attribute :>> curve = "DATA-SPEC";
            attribute :>> fBase = 50[Hz];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-thd'> 'Example thd' : ChaperoneRequirements::TotalHarmonicDistortion {
            doc /* The total harmonic distortion of the bus voltage at 50 Hz with a resolution of 1 Hz shall be at most 5 %. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> signal = plant.'the bus voltage';
            attribute :>> fBase = 50[Hz];
            attribute :>> fResolution = 1[Hz];
            attribute :>> upper = 5['%'];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_over'> 'Example step_over' : ChaperoneRequirements::StepOvershoot {
            doc /* When the temperature setpoint steps, the overshoot of the cabin temperature shall be at most 10 %. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> trigger = TriggerKind::stepping;
            attribute :>> triggerEvent = Step(plant.'the temperature setpoint');
            attribute :>> signal = plant.'the cabin temperature';
            attribute :>> upper = 10['%'];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_over_abs'> 'Example step_over_abs' : ChaperoneRequirements::StepOvershoot {
            doc /* When the temperature setpoint steps by at least 2 K, the overshoot of the cabin temperature shall be at most 1 K. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> trigger = TriggerKind::stepping;
            attribute :>> triggerEvent = Step(plant.'the temperature setpoint', 2[K]);
            attribute :>> signal = plant.'the cabin temperature';
            attribute :>> upper = 1[K];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_under'> 'Example step_under' : ChaperoneRequirements::StepUndershoot {
            doc /* When the temperature setpoint steps, the undershoot of the cabin temperature shall be at most 5 %. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> trigger = TriggerKind::stepping;
            attribute :>> triggerEvent = Step(plant.'the temperature setpoint');
            attribute :>> signal = plant.'the cabin temperature';
            attribute :>> upper = 5['%'];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_rise'> 'Example step_rise' : ChaperoneRequirements::StepRiseTime {
            doc /* When the temperature setpoint steps, the rise time of the cabin temperature shall be at most 5 s. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> trigger = TriggerKind::stepping;
            attribute :>> triggerEvent = Step(plant.'the temperature setpoint');
            attribute :>> signal = plant.'the cabin temperature';
            attribute :>> upper = 5[s];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_rise_l'> 'Example step_rise_l' : ChaperoneRequirements::StepRiseTime {
            doc /* When the temperature setpoint steps, the rise time of the cabin temperature from 20 % to 80 % shall be at most 5 s. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> trigger = TriggerKind::stepping;
            attribute :>> triggerEvent = Step(plant.'the temperature setpoint');
            attribute :>> signal = plant.'the cabin temperature';
            attribute :>> upper = 5[s];
            attribute :>> levelFrom = 20;
            attribute :>> levelTo = 80;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_delay'> 'Example step_delay' : ChaperoneRequirements::StepDelayTime {
            doc /* When the temperature setpoint steps, the delay time of the cabin temperature shall be at most 1 s. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> trigger = TriggerKind::stepping;
            attribute :>> triggerEvent = Step(plant.'the temperature setpoint');
            attribute :>> signal = plant.'the cabin temperature';
            attribute :>> upper = 1[s];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_settle'> 'Example step_settle' : ChaperoneRequirements::StepSettling {
            doc /* When the temperature setpoint steps, the cabin temperature shall settle to within 5 % within 30 s. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> trigger = TriggerKind::stepping;
            attribute :>> triggerEvent = Step(plant.'the temperature setpoint');
            attribute :>> signal = plant.'the cabin temperature';
            attribute :>> upper = 30[s];
            attribute :>> band = 5['%'];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_settle_a'> 'Example step_settle_a' : ChaperoneRequirements::StepSettling {
            doc /* For 1 min after the temperature setpoint steps, the cabin temperature shall settle to within 0.5 K relative to the temperature setpoint within 30 s. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> scope = ScopeKind::afterFor;
            attribute :>> scopeEvent = Step(plant.'the temperature setpoint');
            attribute :>> scopeDuration = 1[min];
            attribute :>> signal = plant.'the cabin temperature';
            attribute :>> upper = 30[s];
            attribute :>> band = 0.5[K];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_error'> 'Example step_error' : ChaperoneRequirements::StepSteadyStateError {
            doc /* When the temperature setpoint steps, the steady-state error of the cabin temperature relative to its final value shall be at most 0.5 K. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> trigger = TriggerKind::stepping;
            attribute :>> triggerEvent = Step(plant.'the temperature setpoint');
            attribute :>> signal = plant.'the cabin temperature';
            attribute :>> target = StepTargetKind::final;
            attribute :>> upper = 0.5[K];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_damp'> 'Example step_damp' : ChaperoneRequirements::StepDampingRatio {
            doc /* When the temperature setpoint steps, the damping ratio of the cabin temperature shall be at least 0.7. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> trigger = TriggerKind::stepping;
            attribute :>> triggerEvent = Step(plant.'the temperature setpoint');
            attribute :>> signal = plant.'the cabin temperature';
            attribute :>> lower = 0.7;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_decay'> 'Example step_decay' : ChaperoneRequirements::StepDecayRatio {
            doc /* When the temperature setpoint steps, the decay ratio of the cabin temperature shall be at most 0.25. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> trigger = TriggerKind::stepping;
            attribute :>> triggerEvent = Step(plant.'the temperature setpoint');
            attribute :>> signal = plant.'the cabin temperature';
            attribute :>> upper = 0.25;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-eig_real'> 'Example eig_real' : ChaperoneRequirements::EigenvalueRealPart {
            doc /* Every eigenvalue shall have a real part below -0.5 1/s. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> upper = -0.5['1'/s];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-eig_stable'> 'Example eig_stable' : ChaperoneRequirements::PlantStable {
            doc /* The plant shall be stable. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-eig_damp'> 'Example eig_damp' : ChaperoneRequirements::ModeDamping {
            doc /* Every mode with a frequency below 1 Hz shall have a damping ratio of at least 0.5. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> modeBelow = 1[Hz];
            attribute :>> lower = 0.5;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-eig_fmin'> 'Example eig_fmin' : ChaperoneRequirements::ModeFrequencyAtLeast {
            doc /* Every mode with a frequency above 1 Hz shall have a frequency of at least 2 Hz. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> modeAbove = 1[Hz];
            attribute :>> lower = 2[Hz];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-eig_fmax'> 'Example eig_fmax' : ChaperoneRequirements::ModeFrequencyAtMost {
            doc /* Every mode with a frequency between 1 Hz and 5 Hz shall have a frequency of at most 4 Hz. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> modeAbove = 1[Hz];
            attribute :>> modeBelow = 5[Hz];
            attribute :>> upper = 4[Hz];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-eig_tau'> 'Example eig_tau' : ChaperoneRequirements::SlowestModeTimeConstant {
            doc /* The slowest mode shall have a time constant of at most 10 s. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> upper = 10[s];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-eig_region'> 'Example eig_region' : ChaperoneRequirements::EigenvaluesWithinMap {
            doc /* Every eigenvalue shall lie within the pole map. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> map = "DATA-POLE";
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-gm'> 'Example gm' : ChaperoneRequirements::GainMargin {
            doc /* The gain margin from the valve command to the valve position shall be at least 6 dB. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> input = plant.'the valve command';
            attribute :>> output = plant.'the valve position';
            attribute :>> lower = 6[dB];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-pm'> 'Example pm' : ChaperoneRequirements::PhaseMargin {
            doc /* The phase margin from the valve command to the valve position shall be at least 45 deg. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> input = plant.'the valve command';
            attribute :>> output = plant.'the valve position';
            attribute :>> lower = 45['°'];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-bw_min'> 'Example bw_min' : ChaperoneRequirements::BandwidthAtLeast {
            doc /* The bandwidth from the valve command to the valve position shall be at least 1 Hz. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> input = plant.'the valve command';
            attribute :>> output = plant.'the valve position';
            attribute :>> lower = 1[Hz];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-bw_max'> 'Example bw_max' : ChaperoneRequirements::BandwidthAtMost {
            doc /* The bandwidth from the valve command to the valve position shall be at most 10 Hz. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> input = plant.'the valve command';
            attribute :>> output = plant.'the valve position';
            attribute :>> upper = 10[Hz];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-peak'> 'Example peak' : ChaperoneRequirements::PeakGain {
            doc /* The peak gain from the valve command to the valve position shall be at most 3 dB. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> input = plant.'the valve command';
            attribute :>> output = plant.'the valve position';
            attribute :>> upper = 3[dB];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-dc'> 'Example dc' : ChaperoneRequirements::DcGain {
            doc /* The dc gain from the valve command to the valve position shall be between -1 dB and 1 dB. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> input = plant.'the valve command';
            attribute :>> output = plant.'the valve position';
            attribute :>> lower = -1[dB];
            attribute :>> upper = 1[dB];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-env'> 'Example env' : ChaperoneRequirements::GainWithinCurve {
            doc /* The gain from the valve command to the valve position shall stay below the gain limit curve. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> input = plant.'the valve command';
            attribute :>> output = plant.'the valve position';
            attribute :>> curve = "DATA-GAIN";
            attribute :>> side = EnvelopeSide::below;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-sens'> 'Example sens' : ChaperoneRequirements::SensitivityPeak {
            doc /* The sensitivity peak of the loop from the valve command to the valve position shall be at most 6 dB. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> input = plant.'the valve command';
            attribute :>> output = plant.'the valve position';
            attribute :>> upper = 6[dB];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-dm'> 'Example dm' : ChaperoneRequirements::DelayMargin {
            doc /* The delay margin from the valve command to the valve position shall be at least 10 ms. */
            subject plant : ExampleLibrary::Plants::Cabin;
            attribute :>> input = plant.'the valve command';
            attribute :>> output = plant.'the valve position';
            attribute :>> lower = 10[ms];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-comp'> REQ_EX_comp : ChaperoneRequirements::Hold {
            doc /* While the pack is on, the bypass of VLV shall be open. */
            subject plant : ExampleLibrary::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; title = "Example hold"; }
            assume constraint { plant.'the pack is on' }
            require constraint { plant.'the bypass valve'.'the bypass of VLV is open' }
        }
        requirement <'REQ-EX-prose'> Prose {
            doc /* The valve shall be easy to replace. */
            @ChaperoneReq { verificationMethod = "Inspection"; }
        }
        verification def <'TC-EX'> 'The example case' {
            subject plant : ExampleLibrary::Plants::Cabin;
            objective {
                verify ExampleLibrary::example::'Example hold';
                verify ExampleLibrary::example::'Example hold_x';
                verify ExampleLibrary::example::'Example hold_x2';
                verify ExampleLibrary::example::'Example when';
                verify ExampleLibrary::example::'Example falling';
                verify ExampleLibrary::example::'Example first';
                verify ExampleLibrary::example::'Example every';
                verify ExampleLibrary::example::'Example after_for';
                verify ExampleLibrary::example::'Example after_until';
                verify ExampleLibrary::example::'Example until';
                verify ExampleLibrary::example::'Example cmp_sig';
                verify ExampleLibrary::example::'Example within_of';
                verify ExampleLibrary::example::'Example table';
                verify ExampleLibrary::example::'Example compound';
                verify ExampleLibrary::example::'Example and';
                verify ExampleLibrary::example::'Example or';
                verify ExampleLibrary::example::'Example not';
                verify ExampleLibrary::example::'Example sustained';
                verify ExampleLibrary::example::'Example sustained_cmp';
                verify ExampleLibrary::example::'Example integer';
                verify ExampleLibrary::example::'Example derivative';
                verify ExampleLibrary::example::'Example integral';
                verify ExampleLibrary::example::'Example moving';
                verify ExampleLibrary::example::'Example difference';
                verify ExampleLibrary::example::'Example torque';
                verify ExampleLibrary::example::'Example torque2';
                verify ExampleLibrary::example::'Example negative';
                verify ExampleLibrary::example::'Example duration';
                verify ExampleLibrary::example::'Example dwell';
                verify ExampleLibrary::example::'Example count';
                verify ExampleLibrary::example::'Example never';
                verify ExampleLibrary::example::'Example frequency';
                verify ExampleLibrary::example::'Example s_dur';
                verify ExampleLibrary::example::'Example s_dur2';
                verify ExampleLibrary::example::'Example s_count';
                verify ExampleLibrary::example::'Example s_freq';
                verify ExampleLibrary::example::'Example oscillate';
                verify ExampleLibrary::example::'Example increase';
                verify ExampleLibrary::example::'Example increase_pct';
                verify ExampleLibrary::example::'Example stable';
                verify ExampleLibrary::example::'Example domain';
                verify ExampleLibrary::example::'Example domain_x';
                verify ExampleLibrary::example::'Example spectrum';
                verify ExampleLibrary::example::'Example spectrum_rel';
                verify ExampleLibrary::example::'Example thd';
                verify ExampleLibrary::example::'Example step_over';
                verify ExampleLibrary::example::'Example step_over_abs';
                verify ExampleLibrary::example::'Example step_under';
                verify ExampleLibrary::example::'Example step_rise';
                verify ExampleLibrary::example::'Example step_rise_l';
                verify ExampleLibrary::example::'Example step_delay';
                verify ExampleLibrary::example::'Example step_settle';
                verify ExampleLibrary::example::'Example step_settle_a';
                verify ExampleLibrary::example::'Example step_error';
                verify ExampleLibrary::example::'Example step_damp';
                verify ExampleLibrary::example::'Example step_decay';
                verify ExampleLibrary::example::'Example eig_real';
                verify ExampleLibrary::example::'Example eig_stable';
                verify ExampleLibrary::example::'Example eig_damp';
                verify ExampleLibrary::example::'Example eig_fmin';
                verify ExampleLibrary::example::'Example eig_fmax';
                verify ExampleLibrary::example::'Example eig_tau';
                verify ExampleLibrary::example::'Example eig_region';
                verify ExampleLibrary::example::'Example gm';
                verify ExampleLibrary::example::'Example pm';
                verify ExampleLibrary::example::'Example bw_min';
                verify ExampleLibrary::example::'Example bw_max';
                verify ExampleLibrary::example::'Example peak';
                verify ExampleLibrary::example::'Example dc';
                verify ExampleLibrary::example::'Example env';
                verify ExampleLibrary::example::'Example sens';
                verify ExampleLibrary::example::'Example dm';
                verify ExampleLibrary::example::REQ_EX_comp;
            }
            @VerificationMethod { kind = VerificationMethodKind::analyze; }
            @ChaperoneTestCase { stopTime = "100"; interval = "0.1"; scenario = "cabin.a=1.5; cabin.b=true; cabin.c=\"x\""; }
        }
    }
    package Verdicts {
        verification <'TC-EX::REQ-EX-hold'> 'TC-EX on REQ-EX-hold' : ExampleLibrary::example::'The example case' {
            objective {
                verify ExampleLibrary::example::'Example hold';
            }
            return :>> verdict = VerdictKind::fail;
            @ChaperoneVerdict { property = PropertyKind::violated; method = VerdictMethodKind::simulationTrace; margin = -1.5; tWorst = 8; attempts = 1; marginUnit = "K"; recordHash = "abc"; }
        }
        verification <'TC-EX::REQ-EX-when'> 'TC-EX on REQ-EX-when' : ExampleLibrary::example::'The example case' {
            objective {
                verify ExampleLibrary::example::'Example when';
            }
            return :>> verdict = VerdictKind::inconclusive;
            @ChaperoneVerdict { property = PropertyKind::notApplicable; method = VerdictMethodKind::simulationTrace; }
        }
    }
}
