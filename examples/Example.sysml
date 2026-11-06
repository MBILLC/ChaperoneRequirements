// Copyright © 2026 Model Based Innovation LLC. All rights reserved.
package Example {
    private import ISQ::*;
    private import SI::*;
    private import ScalarValues::*;
    private import VerificationCases::*;
    private import USCustomaryUnits::ft;
    private import ChaperoneUnits::*;
    private import ChaperoneMetadata::*;
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
        requirement <'REQ-EX-hold'> 'Example hold' {
            doc /* While the pack is on, the cabin temperature shall remain within 18 degC and 27 degC. */
            subject plant : Example::Plants::Cabin;
            attribute tolerance : ISQ::TemperatureDifferenceValue = 2['°C'];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-hold_x'> 'Example hold_x' {
            doc /* The cabin temperature shall be at most 30 degC, except for at most 1 h in total and by at most 2 K. */
            subject plant : Example::Plants::Cabin;
            attribute tolerance : ISQ::DurationValue = 1[h];
            attribute depthTolerance : ISQ::TemperatureDifferenceValue = 0.5[K];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-hold_x2'> 'Example hold_x2' {
            doc /* The bus voltage shall remain within 200 V and 240 V, leaving it for at most 5 s at a time. */
            subject plant : Example::Plants::Cabin;
            attribute tolerance : ISQ::DurationValue = 1[s];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-when'> 'Example when' {
            doc /* When the bus voltage falls below 200 V, the pack shall be on. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-falling'> 'Example falling' {
            doc /* When the pack is no longer on, the door shall be open. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-first'> 'Example first' {
            doc /* During the first 10 s, the bus voltage shall be above 100 V. */
            subject plant : Example::Plants::Cabin;
            attribute tolerance : ISQ::ElectricPotentialDifferenceValue = 5[V];
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-every'> 'Example every' {
            doc /* Every 2 s for 0.5 s, the pack shall be on. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-after_for'> 'Example after_for' {
            doc /* For 3 min after the pack becomes on, the bleed flow shall be at least 0.5 kg/s. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-after_until'> 'Example after_until' {
            doc /* After the pack becomes on until the door becomes open, the fan speed shall be above 100 rpm. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-until'> 'Example until' {
            doc /* Until the pack becomes on, the altitude shall be below 10 kft. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-cmp_sig'> 'Example cmp_sig' {
            doc /* The cabin temperature shall be at most the temperature setpoint. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-within_of'> 'Example within_of' {
            doc /* The cabin temperature shall remain within 0.5 K of the temperature setpoint. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-table'> 'Example table' {
            doc /* The cabin temperature shall be at most the limit table at the time and the altitude. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-compound'> 'Example compound' {
            doc /* While the pack is on or the door is open, the bus voltage shall be above 100 V. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-and'> 'Example and' {
            doc /* While the pack is on, the bus voltage shall be above 100 V and the bleed flow shall be above 0.1 kg/s. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-or'> 'Example or' {
            doc /* The bus voltage shall be above 100 V or the pack shall be on. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-not'> 'Example not' {
            doc /* While the door is open, the pack shall not be on. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-sustained'> 'Example sustained' {
            doc /* While the pack has been on for 10 s, the fan speed shall be above 100 rpm. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-sustained_cmp'> 'Example sustained_cmp' {
            doc /* When the bus voltage has been above 200 V for 10 s, the pack shall be on. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-integer'> 'Example integer' {
            doc /* While the flight phase is 2, the pack shall be on. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-derivative'> 'Example derivative' {
            doc /* The derivative of the cabin temperature shall be at most 3 K/s. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-integral'> 'Example integral' {
            doc /* The integral of the bleed flow shall be below 8 kg. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-moving'> 'Example moving' {
            doc /* The moving average of the bus voltage over 5 s shall be above 100 V. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-difference'> 'Example difference' {
            doc /* The difference between the cabin temperature and the temperature setpoint shall be at most 2 K. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-torque'> 'Example torque' {
            doc /* The acceleration shall be at most 2 m/s2. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-torque2'> 'Example torque2' {
            doc /* The shaft torque shall be at most 20 N.m. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-negative'> 'Example negative' {
            doc /* The cabin temperature shall be above -20.5 degC. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-duration'> 'Example duration' {
            doc /* While the pack is on, the door shall be open for at most 5 s in total. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-dwell'> 'Example dwell' {
            doc /* When the pack becomes on, the pack shall stay on for at least 10 min. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-count'> 'Example count' {
            doc /* While the pack is on, the door shall become open at most 3 times. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-never'> 'Example never' {
            doc /* The door shall not become open. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-frequency'> 'Example frequency' {
            doc /* The door shall become open at a frequency of at most 2 Hz. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-s_dur'> 'Example s_dur' {
            doc /* The pack shall be on for at most 5 s continuously within any 1 min. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-s_dur2'> 'Example s_dur2' {
            doc /* The pack shall be on for at least 5 s in total within any 1 min. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-s_count'> 'Example s_count' {
            doc /* The door shall become open at most 3 times within any 1 h. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-s_freq'> 'Example s_freq' {
            doc /* The door shall become open at a mean frequency of at most 2 Hz within any 1 min. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-oscillate'> 'Example oscillate' {
            doc /* The bus voltage shall not oscillate about 220 V faster than 2 Hz on average over any 1 min. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-increase'> 'Example increase' {
            doc /* The cabin temperature shall not increase by more than 3 K within any 10 s. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-increase_pct'> 'Example increase_pct' {
            doc /* The bus voltage shall not increase by more than 5 % within any 10 s. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-stable'> 'Example stable' {
            doc /* The cabin temperature shall be stable, with a mean rate of change of at most 0.1 K/s over any 1 min. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-domain'> 'Example domain' {
            doc /* The operating point of (time, derivative of altitude) shall stay within the envelope map. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-domain_x'> 'Example domain_x' {
            doc /* The operating point of (time, altitude) shall stay within the envelope map, leaving it for at most 5 s at a time. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-spectrum'> 'Example spectrum' {
            doc /* The spectrum of the bus voltage shall stay below the limit spectrum curve. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-spectrum_rel'> 'Example spectrum_rel' {
            doc /* The spectrum of the bus voltage relative to 50 Hz shall stay below the limit spectrum curve. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-thd'> 'Example thd' {
            doc /* The total harmonic distortion of the bus voltage at 50 Hz with a resolution of 1 Hz shall be at most 5 %. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_over'> 'Example step_over' {
            doc /* When the temperature setpoint steps, the overshoot of the cabin temperature shall be at most 10 %. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_over_abs'> 'Example step_over_abs' {
            doc /* When the temperature setpoint steps by at least 2 K, the overshoot of the cabin temperature shall be at most 1 K. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_under'> 'Example step_under' {
            doc /* When the temperature setpoint steps, the undershoot of the cabin temperature shall be at most 5 %. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_rise'> 'Example step_rise' {
            doc /* When the temperature setpoint steps, the rise time of the cabin temperature shall be at most 5 s. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_rise_l'> 'Example step_rise_l' {
            doc /* When the temperature setpoint steps, the rise time of the cabin temperature from 20 % to 80 % shall be at most 5 s. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_delay'> 'Example step_delay' {
            doc /* When the temperature setpoint steps, the delay time of the cabin temperature shall be at most 1 s. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_settle'> 'Example step_settle' {
            doc /* When the temperature setpoint steps, the cabin temperature shall settle to within 5 % within 30 s. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_settle_a'> 'Example step_settle_a' {
            doc /* For 1 min after the temperature setpoint steps, the cabin temperature shall settle to within 0.5 K relative to the temperature setpoint within 30 s. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_error'> 'Example step_error' {
            doc /* When the temperature setpoint steps, the steady-state error of the cabin temperature relative to its final value shall be at most 0.5 K. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_damp'> 'Example step_damp' {
            doc /* When the temperature setpoint steps, the damping ratio of the cabin temperature shall be at least 0.7. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-step_decay'> 'Example step_decay' {
            doc /* When the temperature setpoint steps, the decay ratio of the cabin temperature shall be at most 0.25. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-eig_real'> 'Example eig_real' {
            doc /* Every eigenvalue shall have a real part below -0.5 1/s. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-eig_stable'> 'Example eig_stable' {
            doc /* The plant shall be stable. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-eig_damp'> 'Example eig_damp' {
            doc /* Every mode with a frequency below 1 Hz shall have a damping ratio of at least 0.5. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-eig_fmin'> 'Example eig_fmin' {
            doc /* Every mode with a frequency above 1 Hz shall have a frequency of at least 2 Hz. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-eig_fmax'> 'Example eig_fmax' {
            doc /* Every mode with a frequency between 1 Hz and 5 Hz shall have a frequency of at most 4 Hz. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-eig_tau'> 'Example eig_tau' {
            doc /* The slowest mode shall have a time constant of at most 10 s. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-eig_region'> 'Example eig_region' {
            doc /* Every eigenvalue shall lie within the pole map. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-gm'> 'Example gm' {
            doc /* The gain margin from the valve command to the valve position shall be at least 6 dB. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-pm'> 'Example pm' {
            doc /* The phase margin from the valve command to the valve position shall be at least 45 deg. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-bw_min'> 'Example bw_min' {
            doc /* The bandwidth from the valve command to the valve position shall be at least 1 Hz. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-bw_max'> 'Example bw_max' {
            doc /* The bandwidth from the valve command to the valve position shall be at most 10 Hz. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-peak'> 'Example peak' {
            doc /* The peak gain from the valve command to the valve position shall be at most 3 dB. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-dc'> 'Example dc' {
            doc /* The dc gain from the valve command to the valve position shall be between -1 dB and 1 dB. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-env'> 'Example env' {
            doc /* The gain from the valve command to the valve position shall stay below the gain limit curve. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-sens'> 'Example sens' {
            doc /* The sensitivity peak of the loop from the valve command to the valve position shall be at most 6 dB. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-dm'> 'Example dm' {
            doc /* The delay margin from the valve command to the valve position shall be at least 10 ms. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; rationale = "A rationale with \"quotes\", a \\ backslash and a second\nline."; tags = "example"; }
        }
        requirement <'REQ-EX-comp'> REQ_EX_comp {
            doc /* While the pack is on, the bypass of VLV shall be open. */
            subject plant : Example::Plants::Cabin;
            @ChaperoneReq { verificationMethod = "Simulation"; title = "Example hold"; }
        }
        requirement <'REQ-EX-prose'> Prose {
            doc /* The valve shall be easy to replace. */
            @ChaperoneReq { verificationMethod = "Inspection"; }
        }
        verification def <'TC-EX'> 'The example case' {
            subject plant : Example::Plants::Cabin;
            objective {
                verify Example::example::'Example hold';
                verify Example::example::'Example hold_x';
                verify Example::example::'Example hold_x2';
                verify Example::example::'Example when';
                verify Example::example::'Example falling';
                verify Example::example::'Example first';
                verify Example::example::'Example every';
                verify Example::example::'Example after_for';
                verify Example::example::'Example after_until';
                verify Example::example::'Example until';
                verify Example::example::'Example cmp_sig';
                verify Example::example::'Example within_of';
                verify Example::example::'Example table';
                verify Example::example::'Example compound';
                verify Example::example::'Example and';
                verify Example::example::'Example or';
                verify Example::example::'Example not';
                verify Example::example::'Example sustained';
                verify Example::example::'Example sustained_cmp';
                verify Example::example::'Example integer';
                verify Example::example::'Example derivative';
                verify Example::example::'Example integral';
                verify Example::example::'Example moving';
                verify Example::example::'Example difference';
                verify Example::example::'Example torque';
                verify Example::example::'Example torque2';
                verify Example::example::'Example negative';
                verify Example::example::'Example duration';
                verify Example::example::'Example dwell';
                verify Example::example::'Example count';
                verify Example::example::'Example never';
                verify Example::example::'Example frequency';
                verify Example::example::'Example s_dur';
                verify Example::example::'Example s_dur2';
                verify Example::example::'Example s_count';
                verify Example::example::'Example s_freq';
                verify Example::example::'Example oscillate';
                verify Example::example::'Example increase';
                verify Example::example::'Example increase_pct';
                verify Example::example::'Example stable';
                verify Example::example::'Example domain';
                verify Example::example::'Example domain_x';
                verify Example::example::'Example spectrum';
                verify Example::example::'Example spectrum_rel';
                verify Example::example::'Example thd';
                verify Example::example::'Example step_over';
                verify Example::example::'Example step_over_abs';
                verify Example::example::'Example step_under';
                verify Example::example::'Example step_rise';
                verify Example::example::'Example step_rise_l';
                verify Example::example::'Example step_delay';
                verify Example::example::'Example step_settle';
                verify Example::example::'Example step_settle_a';
                verify Example::example::'Example step_error';
                verify Example::example::'Example step_damp';
                verify Example::example::'Example step_decay';
                verify Example::example::'Example eig_real';
                verify Example::example::'Example eig_stable';
                verify Example::example::'Example eig_damp';
                verify Example::example::'Example eig_fmin';
                verify Example::example::'Example eig_fmax';
                verify Example::example::'Example eig_tau';
                verify Example::example::'Example eig_region';
                verify Example::example::'Example gm';
                verify Example::example::'Example pm';
                verify Example::example::'Example bw_min';
                verify Example::example::'Example bw_max';
                verify Example::example::'Example peak';
                verify Example::example::'Example dc';
                verify Example::example::'Example env';
                verify Example::example::'Example sens';
                verify Example::example::'Example dm';
                verify Example::example::REQ_EX_comp;
            }
            @VerificationMethod { kind = VerificationMethodKind::analyze; }
            @ChaperoneTestCase { stopTime = "100"; interval = "0.1"; scenario = "cabin.a=1.5; cabin.b=true; cabin.c=\"x\""; }
        }
    }
    package Verdicts {
        verification <'TC-EX::REQ-EX-hold'> 'TC-EX on REQ-EX-hold' : Example::example::'The example case' {
            objective {
                verify Example::example::'Example hold';
            }
            return :>> verdict = VerdictKind::fail;
            @ChaperoneVerdict { property = PropertyKind::violated; method = VerdictMethodKind::simulationTrace; margin = -1.5; tWorst = 8; attempts = 1; marginUnit = "K"; recordHash = "abc"; }
        }
        verification <'TC-EX::REQ-EX-when'> 'TC-EX on REQ-EX-when' : Example::example::'The example case' {
            objective {
                verify Example::example::'Example when';
            }
            return :>> verdict = VerdictKind::inconclusive;
            @ChaperoneVerdict { property = PropertyKind::notApplicable; method = VerdictMethodKind::simulationTrace; }
        }
    }
}
