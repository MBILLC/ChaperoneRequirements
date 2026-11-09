// Copyright © 2026 Model Based Innovation LLC. All rights reserved. BSD 2-Clause, see LICENSE.
package ChaperoneUnits {
    doc /* The units Chaperone's controlled language accepts that the SI and US customary libraries of
         * SysML v2 do not define under the same short name. Each short name is the spelling of
         * Chaperone's unit table, so a quantity written with them reads back as it was written; a unit
         * composed with a product is spelled as the SI library spells its own ('kV⋅A' beside 'V⋅A').
         * Where that spelling is already the name (bar), the unit has no short name: a short name
         * equal to the name does not resolve in SysON (eclipse-syson/syson#2106). */
    private import ISQ::*;
    private import SI::*;
    private import MeasurementReferences::*;

    attribute <ms> millisecond : DurationUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = s; :>> conversionFactor = 0.001; } }
    attribute <kPa> kilopascal : PressureUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = Pa; :>> conversionFactor = 1000.0; } }
    attribute bar : PressureUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = Pa; :>> conversionFactor = 100000.0; } }
    attribute <mbar> millibar : PressureUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = Pa; :>> conversionFactor = 100.0; } }
    attribute <kft> kilofoot : LengthUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = m; :>> conversionFactor = 304.8; } }
    attribute <rpm> revolutionPerMinute : AngularVelocityUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = rad/s; :>> conversionFactor = 0.10471975511965977; } }
    attribute <'rev/min'> revolutionsPerMinute : AngularVelocityUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = rad/s; :>> conversionFactor = 0.10471975511965977; } }
    attribute <mH> millihenry : InductanceUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = H; :>> conversionFactor = 0.001; } }
    attribute <uH> microhenry : InductanceUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = H; :>> conversionFactor = 1.0E-6; } }
    attribute <mWb> milliweber : MagneticFluxUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = Wb; :>> conversionFactor = 0.001; } }
    attribute <kOhm> kiloohm : ResistanceUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = 'Ω'; :>> conversionFactor = 1000.0; } }
    attribute <MOhm> megaohm : ResistanceUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = 'Ω'; :>> conversionFactor = 1000000.0; } }
    attribute <mOhm> milliohm : ResistanceUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = 'Ω'; :>> conversionFactor = 0.001; } }
    attribute <uF> microfarad : CapacitanceUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = F; :>> conversionFactor = 1.0E-6; } }
    attribute <nF> nanofarad : CapacitanceUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = F; :>> conversionFactor = 1.0E-9; } }
    attribute <pF> picofarad : CapacitanceUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = F; :>> conversionFactor = 1.0E-12; } }
    attribute <'kV⋅A'> 'kilovolt ampere' : PowerUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = 'V⋅A'; :>> conversionFactor = 1000.0; } }
    attribute <kvar> 'kilovolt ampere reactive' : PowerUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = var; :>> conversionFactor = 1000.0; } }
    attribute <'A⋅h'> 'ampere hour' : ElectricChargeUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = C; :>> conversionFactor = 3600.0; } }
    attribute <'kJ/(kg⋅K)'> 'kilojoule per kilogram kelvin' : SpecificHeatCapacityUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = 'J/(kg⋅K)'; :>> conversionFactor = 1000.0; } }
    attribute <'mPa⋅s'> 'millipascal second' : DynamicViscosityUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = 'Pa⋅s'; :>> conversionFactor = 0.001; } }
    attribute <mT> millitesla : MagneticFluxDensityUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = T; :>> conversionFactor = 0.001; } }
    attribute <'%'> percent : DimensionOneUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = one; :>> conversionFactor = 0.01; } }
}
