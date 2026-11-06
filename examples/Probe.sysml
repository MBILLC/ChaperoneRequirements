// Copyright © 2026 Model Based Innovation LLC. All rights reserved. BSD 2-Clause, see LICENSE.
package Probe {
    private import ISQ::*;
    private import SI::*;
    private import ScalarValues::*;
    private import ChaperoneMetadata::*;
    private import ChaperoneUnits::*;
    private import VerificationCases::*;

    part def CabinModel {
        attribute <SIG_T> 'the cabin temperature' : ThermodynamicTemperatureValue {
            @ChaperoneSignal { unit = "degC"; }
        }
        attribute <SIG_P> 'the pack is on' : Boolean;
        part <'APU-1'> apu [2] {
            @ChaperoneComponent { componentType = "auxiliary power unit"; }
            attribute <SIG_R> 'the unit is running' : Boolean;
        }
    }

    @ChaperoneData { uid = "DATA-1"; name = "the map"; values = "1, 2\n3, 4\n"; }

    requirement <'REQ-AC-1'> 'Cabin temperature limit' {
        doc /* While the pack is on, the cabin temperature shall remain within 18 degC and 27 degC. */
        subject plant : CabinModel;
        attribute tolerance : TemperatureDifferenceValue = 2['°C'];
        @ChaperoneReq { verification = "Simulation"; uses = ("SIG_T", "SIG_P"); }
        @ChaperoneSource { informal = "The cabin shall be comfortable."; }
        assume constraint { plant.'the pack is on' }
        require constraint { plant.'the cabin temperature' >= 291.15[K] and plant.'the cabin temperature' <= 300.15[K] }
    }

    verification def <'TC-1'> 'Case one' {
        subject plant : CabinModel;
        objective { verify 'REQ-AC-1'; }
        @VerificationMethod { kind = VerificationMethodKind::analyze; }
        @ChaperoneTestCase { stopTime = "10"; interval = "0.1"; scenario = "a.b=1.5"; }
    }

    verification <'TC-1::REQ-AC-1'> 'Case one on REQ-AC-1' : 'Case one' {
        return :>> verdict = VerdictKind::fail;
        @ChaperoneVerdict { property = PropertyKind::violated; method = VerdictMethodKind::simulationTrace; margin = -1.5; tWorst = 8.0; attempts = 1; recordHash = "abc"; }
    }
}
