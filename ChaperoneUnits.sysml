// Copyright © 2026 Model Based Innovation LLC. All rights reserved. BSD 2-Clause, see LICENSE.
package ChaperoneUnits {
    doc /* The units Chaperone's controlled language accepts that the SI and US customary libraries of
         * SysML v2 do not define under the same short name. Each short name is the spelling of
         * Chaperone's unit table, so a quantity written with them reads back as it was written. */
    private import ISQ::*;
    private import SI::*;
    private import MeasurementReferences::*;

    attribute <ms> millisecond : DurationUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = s; :>> conversionFactor = 0.001; } }
    attribute <kPa> kilopascal : PressureUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = Pa; :>> conversionFactor = 1000.0; } }
    attribute <bar> bar : PressureUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = Pa; :>> conversionFactor = 100000.0; } }
    attribute <mbar> millibar : PressureUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = Pa; :>> conversionFactor = 100.0; } }
    attribute <kft> kilofoot : LengthUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = m; :>> conversionFactor = 304.8; } }
    attribute <rpm> revolutionPerMinute : AngularVelocityUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = rad/s; :>> conversionFactor = 0.10471975511965977; } }
    attribute <'rev/min'> revolutionsPerMinute : AngularVelocityUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = rad/s; :>> conversionFactor = 0.10471975511965977; } }
    attribute <'%'> percent : DimensionOneUnit { :>> unitConversion : ConversionByConvention { :>> referenceUnit = one; :>> conversionFactor = 0.01; } }
}
