// Copyright © 2026 Model Based Innovation LLC. All rights reserved. BSD 2-Clause, see LICENSE.
package ChaperoneMetadata {
    doc /* What a Chaperone project keeps about a requirement that SysML v2 has no standard slot for.
         * One metadata definition per kind of Chaperone node; its attributes are the node's fields
         * as written in the strictdoc project, so a model annotated with them is a lossless peer of
         * that project. Every attribute is optional. A tool that does not know Chaperone ignores
         * them, and a model without them can still be read (see README.md, "Reading a model").
         */
    private import ScalarValues::*;

    metadata def ChaperoneDocument {
        doc /* On a package: the strictdoc document it was exported from. */
        attribute document : String[0..1];
    }

    metadata def ChaperoneSignal {
        doc /* On an attribute of a subject: a glossary signal. Without it the attribute's declared
             * name is the noun phrase and its ISQ type gives the SI unit. */
        attribute phrase : String[0..1];
        attribute unit : String[0..1];
        attribute description : String[0..1];
    }

    metadata def ChaperoneComponent {
        doc /* On a part of a subject: a component, or a set of like ones. */
        attribute uid : String[0..1];
        attribute name : String[0..1];
        attribute componentType : String[0..1];
        attribute description : String[0..1];
    }

    metadata def ChaperoneReq {
        doc /* On a requirement: what the sdoc REQUIREMENT node has beside id, title and statement. */
        attribute title : String[0..1];
        attribute tolerance : String[0..1];
        attribute rationale : String[0..1];
        attribute verificationMethod : String[0..1];
        attribute tags : String[0..1];
        attribute criticality : String[0..1];
        attribute tbd : String[0..1];
        attribute reviewComment : String[0..1];
        attribute uses : String[0..*];
        attribute derivesFrom : String[0..*];
    }

    metadata def ChaperoneSource {
        doc /* On a requirement: the informal sentence the statement formalises, quoted from its source. */
        attribute informal : String[0..1];
        attribute statement : String[0..1];
    }

    metadata def ChaperoneRewrite {
        doc /* On a Derivation connection: the rewrite of an original requirement into usages of the library.
             * status is proposed until a person accepts it; refused says what of the original was not carried
             * over and why, with the rule. A rewrite is never completed silently. */
        attribute status : String[0..1];
        attribute approver : String[0..1];
        attribute date : String[0..1];
        attribute refused : String[0..*];
    }

    metadata def ChaperoneData {
        doc /* On a package: a map, a curve or a limit table the requirements refer to by name. */
        attribute uid : String[0..1];
        attribute name : String[0..1];
        attribute kind : String[0..1];
        attribute fMax : String[0..1];
        attribute fResolution : String[0..1];
        attribute values : String[0..1];
        attribute file : String[0..1];
        attribute table : String[0..1];
        attribute x : String[0..1];
        attribute y : String[0..1];
        attribute unit : String[0..1];
        attribute xUnit : String[0..1];
        attribute yUnit : String[0..1];
        attribute description : String[0..1];
    }

    metadata def ChaperoneTestCase {
        doc /* On a verification case: how the case is run. */
        attribute title : String[0..1];
        attribute plant : String[0..1];
        attribute kind : String[0..1];
        attribute fault : String[0..1];
        attribute scenario : String[0..1];
        attribute points : String[0..1];
        attribute method : String[0..1];
        attribute tLinearize : String[0..1];
        attribute timeConstants : String[0..1];
        attribute startTime : String[0..1];
        attribute warmUp : String[0..1];
        attribute traceInterval : String[0..1];
        attribute solver : String[0..1];
        attribute stopTime : String[0..1];
        attribute interval : String[0..1];
        attribute rtol : String[0..1];
        attribute instrumentation : String[0..1];
        attribute engines : String[0..1];
        attribute original : String[0..1];
        attribute expected : String[0..1];
        attribute expectedMargin : String[0..1];
        attribute file : String[0..1];
        attribute signalMap : String[0..1];
        attribute satisfies : String[0..*];
        attribute implements : String[0..*];
        attribute verifies : String[0..*];
    }

    metadata def ChaperoneWaiver {
        doc /* On a package: a waiver of a test rule. */
        attribute uid : String[0..1];
        attribute rule : String[0..1];
        attribute requirementId : String[0..1];
        attribute rationale : String[0..1];
        attribute approver : String[0..1];
        attribute decidedBy : String[0..1];
    }

    metadata def ChaperoneCredibility {
        doc /* On a package: how credible a plant is, a human's statement. */
        attribute uid : String[0..1];
        attribute plant : String[0..1];
        attribute level : String[0..1];
        attribute contextOfUse : String[0..1];
        attribute validity : String[0..1];
        attribute record : String[0..1];
        attribute recordHash : String[0..1];
        attribute plantIdentity : String[0..1];
        attribute date : String[0..1];
        attribute responsible : String[0..1];
        attribute description : String[0..1];
        attribute decidedBy : String[0..1];
    }

    metadata def ChaperoneActivity {
        doc /* On a package: a verification activity over the requirements it verifies. */
        attribute uid : String[0..1];
        attribute title : String[0..1];
        attribute method : String[0..1];
        attribute stage : String[0..1];
        attribute article : String[0..1];
        attribute standing : String[0..1];
        attribute acceptedBy : String[0..1];
        attribute acceptedOn : String[0..1];
        attribute description : String[0..1];
        attribute decidedBy : String[0..1];
        attribute verifies : String[0..*];
    }

    metadata def ChaperoneDisposition {
        doc /* On a package: what was decided about a violated or mismatched verdict. */
        attribute uid : String[0..1];
        attribute requirementId : String[0..1];
        attribute testCase : String[0..1];
        attribute recordHash : String[0..1];
        attribute decision : String[0..1];
        attribute rationale : String[0..1];
        attribute approver : String[0..1];
        attribute secondApprover : String[0..1];
        attribute date : String[0..1];
        attribute reference : String[0..1];
        attribute status : String[0..1];
        attribute decidedBy : String[0..1];
    }

    metadata def ChaperoneNeed {
        doc /* On a package: a stakeholder need a requirement derives from. */
        attribute uid : String[0..1];
        attribute title : String[0..1];
        attribute statement : String[0..1];
        attribute source : String[0..1];
        attribute assumed : String[0..1];
        attribute rationale : String[0..1];
        attribute decidedBy : String[0..1];
    }

    enum def PropertyKind {
        doc /* The verdict as Chaperone decided it. SysML's VerdictKind has no neutral element, so
             * notApplicable and undecided both read inconclusive there and are told apart here. */
        satisfied;
        violated;
        undecided;
        notApplicable;
        runFailure;
    }

    enum def VerdictMethodKind {
        doc /* What kind of claim the verdict is. simulationTrace: Chaperone's verdict over a
             * trajectory, not a tool's evaluation of the constraint at one model-level instant. */
        simulationTrace;
        measuredTrace;
        steadyStatePoints;
        linearization;
    }

    metadata def ChaperoneVerdict {
        doc /* On a verification usage: the result of one test case on one requirement. The evidence
             * stays in the SSP Traceability record stmdRef points at; this is its summary. */
        attribute property : PropertyKind[0..1];
        attribute method : VerdictMethodKind[0..1];
        attribute margin : Real[0..1];
        attribute marginUnit : String[0..1];
        attribute tWorst : Real[0..1];
        attribute attempts : Integer[0..1];
        attribute episodes : Integer[0..1];
        attribute instances : String[0..1];
        attribute recordHash : String[0..1];
        attribute stmdRef : String[0..1];
    }
}
