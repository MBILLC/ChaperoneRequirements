// Copyright © 2026 Model Based Innovation LLC. All rights reserved. BSD 2-Clause, see LICENSE.
package DerivationExample {
    doc /* A customer's requirement, kept as it was written, and its rewrite as a usage of the library,
         * linked by the standard Derivation connection. The verdict attaches to the derived requirement. */
    private import SI::*;
    private import RequirementDerivation::*;
    private import ChaperoneRequirements::*;
    private import ChaperoneMetadata::*;

    part def Cabin {
        attribute <Cabin_pack> 'the pack is on' : ScalarValues::Boolean;
        attribute <Cabin_door> 'the door is open' : ScalarValues::Boolean;
        attribute <Cabin_T> 'the cabin temperature' : ISQ::ThermodynamicTemperatureValue;
    }

    package Original {
        requirement <'CUST-1'> 'Door openings' {
            doc /* The door must not cycle more than three times while the pack runs. */
            subject plant : Cabin;
        }
        requirement <'CUST-2'> 'Comfort' {
            doc /* The cabin shall be comfortable, between 18 and 27 degrees, and not too warm at night. */
            subject plant : Cabin;
        }
    }

    requirement <'REQ-1'> 'Door openings' : EventCount {
        subject plant : Cabin;
        assume constraint { plant.'the pack is on' }
        attribute :>> edge = plant.'the door is open';
        attribute :>> upper = 3;
    }

    requirement <'REQ-2a'> 'Comfort band' : Hold {
        subject plant : Cabin;
        require constraint { Within(plant.'the cabin temperature', 18['°C_abs'], 27['°C_abs']) }
    }

    #derivation connection {
        end #original ::> Original::'CUST-1';
        end #derive ::> 'REQ-1';
        @ChaperoneRewrite { status = "accepted"; approver = "an engineer"; date = "2026-11-06"; }
    }

    #derivation connection {
        end #original ::> Original::'CUST-2';
        end #derive ::> 'REQ-2a';
        @ChaperoneRewrite { status = "proposed"; refused = "'not too warm at night': no value and no condition (R7)"; }
    }
}
