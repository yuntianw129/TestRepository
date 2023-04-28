//
//  IGSHPAHBcal.swift
//  Geothermal
//
//  Created by Ruiqi Pang/ Haoyuan He on 17/4/2023.
//

import Foundation

class IGSHPAHBCalculation: ObservableObject {
    @Published var heatPumpHeatingCapacity: Double
    @Published var heatPumpCoolingCapacity: Double
    @Published var coefficientOfPerformance: Double
    @Published var energyEfficientRatio: Double
    @Published var meanEarthTempearture: Double
    @Published var minEnteringWaterTemp: Double
    @Published var minLeavingWaterTemp: Double
    @Published var maxEnteringWaterTemp: Double
    @Published var maxLeavingWaterTemp: Double
    @Published var groundThermalConductivity: Double
    @Published var groundHeatTransferDiameter: Double
    @Published var boreholeDiameter: Double
    @Published var pipeOuterDiameter: Double
    @Published var pipeInnerDiameter: Double
    @Published var groutThermalConductivity: Double
    @Published var pipeThermalConductivity: Double
    @Published var coolingRunningTime: Double
    @Published var heatingRunningTime: Double
    @Published var avgPipeDepth: Double
    @Published var surfaceTempAmplitude: Double
    @Published var soilThermalDiffusivity: Double
    @Published var boreholeNumberInput: Double
    @Published var boreholeLengthInput: Double
    
    var groundThermalResistanceE: Double {
        return (log(groundHeatTransferDiameter / boreholeDiameter) / (2 * Double.pi * groundThermalConductivity / 1.73))
    }

    var groundThermalResistance: Double {
        return (log(groundHeatTransferDiameter / boreholeDiameter) / (2 * Double.pi * groundThermalConductivity / 1.73)) / 1.73
    }
    
    var boreholeShapeFactor: Double {
        var boreholePipeOuterDiamterRatio: Double {
            return (boreholeDiameter / pipeOuterDiameter)
        }
        return (((17.44 * pow(boreholePipeOuterDiamterRatio, -0.6025)) + (21.91 * pow(boreholePipeOuterDiamterRatio, -0.3796))) / 2)
    }
    
    var groutThermalResistanceE: Double {
        return (1 / (boreholeShapeFactor * (groutThermalConductivity / 1.73)))
    }

    var groutThermalResistance: Double {
        return (1 / (boreholeShapeFactor * (groutThermalConductivity / 1.73))) / 1.73
    }
    
    var pipeWallThermalResistanceE: Double {
        return ((log(pipeOuterDiameter / pipeInnerDiameter) / (2 * Double.pi * (pipeThermalConductivity / 1.73))) / 2)
    }

    var pipeWallThermalResistance: Double {
        return ((log(pipeOuterDiameter / pipeInnerDiameter) / (2 * Double.pi * (pipeThermalConductivity / 1.73))) / 2) / 1.73
    }
    
    var boreholeThermalResistanceE: Double {
        return (groutThermalResistanceE + pipeWallThermalResistanceE)
    }
    
    var boreholeThermalResistance: Double {
        return (groutThermalResistanceE + pipeWallThermalResistanceE) / 1.73
    }
    
    var coolingRunFraction: Double {
        return (coolingRunningTime / 744)
    }
    
    var heatingRunFraction: Double {
        return (heatingRunningTime / 744)
    }
    
    var meanEarthTempeartureE: Double {
        return (meanEarthTempearture * 1.8 + 32)
    }
    
    var surfaceTempAmplitudeE: Double {
        return (surfaceTempAmplitude * 1.8 + 32)
    }
    
    var Constant: Double {
        return (Double.pi / (365 * soilThermalDiffusivity * 0.093))
    }
    
    var expValue: Double {
        var exp1: Double {
            return (-avgPipeDepth * 0.305)
        }
            
        return (-exp(exp1 * pow(Constant, 0.5)))
    }
    
    var designHeatingEarthTempE: Double {
        return (-exp((-avgPipeDepth * 0.305) * pow(Constant, 0.5))) * cos((2 * Double.pi / 365) * ((-avgPipeDepth * 0.305) / 2) * pow(365 / (Double.pi * soilThermalDiffusivity * 0.093), 0.5)) * (surfaceTempAmplitude * 1.8 + 32) + meanEarthTempeartureE
    }
    
    var designHeatingEarthTemp: Double {
        return (designHeatingEarthTempE - 32) / 1.8
    }
    
    var cosValue: Double {
        return cos((2 * Double.pi / 365) * (180 - (avgPipeDepth * 0.305 / 2) * pow(365 / (Double.pi * soilThermalDiffusivity * 0.093), 0.5)))
    }
    
    var designCoolingEarthTempE: Double {
        return expValue * cosValue * surfaceTempAmplitudeE + meanEarthTempeartureE
    }
    
    var designCoolingEarthTemp: Double {
        return (designCoolingEarthTempE - 32) / 1.8
    }
    
    var heatingBoreholeLength: Double {
        return (((heatPumpHeatingCapacity * 1000 / 0.293) * ((coefficientOfPerformance - 1) / coefficientOfPerformance) * (boreholeThermalResistanceE + groundThermalResistanceE * heatingRunFraction)) / (designHeatingEarthTempE - (((minEnteringWaterTemp * 1.8 + 32) + (minLeavingWaterTemp * 1.8 + 32)) / 2))) * 0.305
    }
    
    var coolingBoreholeLength: Double {
        return (((heatPumpCoolingCapacity * 1000 / 0.293) * ((energyEfficientRatio + 3.412) / energyEfficientRatio) * (boreholeThermalResistanceE + groundThermalResistanceE * coolingRunFraction)) / ((((maxEnteringWaterTemp * 1.8 + 32) + (maxLeavingWaterTemp * 1.8 + 32)) / 2) - designCoolingEarthTempE)) * 0.305
    }
    
    var totalBoreholeLength: Double {
        if coolingBoreholeLength > heatingBoreholeLength {
            return coolingBoreholeLength
        } else {
            return heatingBoreholeLength
        }
    }
    
    // Returns the suggested borehole number and length.
    func getConfiguration() -> (Int, Double) {
        if boreholeNumberInput == 0 && boreholeLengthInput == 0 {
            var no: Double = 1
            var length: Double = 90
            while (totalBoreholeLength / no) > 90 {
                no += 1
                length = totalBoreholeLength / no
                length = ceil(length)
            }
            return (Int(no), length)
        } else if boreholeNumberInput != 0 {
            let length: Double = totalBoreholeLength / boreholeNumberInput
            return (Int(boreholeNumberInput), ceil(length))
        } else if boreholeLengthInput != 0 {
            let no: Double = totalBoreholeLength / boreholeLengthInput
            return (Int(no), ceil(boreholeLengthInput))
        }
        return (0, 0)
    }
    
    init(heatPumpHeatingCapacity: Double,
         heatPumpCoolingCapacity: Double,
         coefficientOfPerformance: Double,
         energyEfficientRatio: Double,
         meanEarthTempearture: Double,
         minEnteringWaterTemp: Double,
         minLeavingWaterTemp: Double,
         maxEnteringWaterTemp: Double,
         maxLeavingWaterTemp: Double,
         groundThermalConductivity: Double,
         groudHeatTransferDiameter: Double,
         boreholeDiameter: Double,
         pipeOuterDiameter: Double,
         pipeInnerDiameter: Double,
         groutThermalConductivity: Double,
         pipeThermalConductivity: Double,
         coolingRunningTime: Double,
         heatingRunningTime: Double,
         avgPipeDepth: Double,
         surfaceTempAmplitude: Double,
         soilThermalDiffusivity: Double,
         boreholeNumberInput: Double,
         boreholeLengthInput: Double)
    {
        self.heatPumpHeatingCapacity = heatPumpHeatingCapacity
        self.heatPumpCoolingCapacity = heatPumpCoolingCapacity
        self.coefficientOfPerformance = coefficientOfPerformance
        self.energyEfficientRatio = energyEfficientRatio
        self.meanEarthTempearture = meanEarthTempearture
        self.minEnteringWaterTemp = minEnteringWaterTemp
        self.minLeavingWaterTemp = minLeavingWaterTemp
        self.maxEnteringWaterTemp = maxEnteringWaterTemp
        self.maxLeavingWaterTemp = maxLeavingWaterTemp
        self.groundThermalConductivity = groundThermalConductivity
        self.groundHeatTransferDiameter = groudHeatTransferDiameter
        self.boreholeDiameter = boreholeDiameter
        self.pipeOuterDiameter = pipeOuterDiameter
        self.pipeInnerDiameter = pipeInnerDiameter
        self.groutThermalConductivity = groundThermalConductivity
        self.pipeThermalConductivity = pipeThermalConductivity
        self.coolingRunningTime = coolingRunningTime
        self.heatingRunningTime = heatingRunningTime
        self.avgPipeDepth = avgPipeDepth
        self.surfaceTempAmplitude = surfaceTempAmplitude
        self.soilThermalDiffusivity = soilThermalDiffusivity
        self.boreholeNumberInput = boreholeNumberInput
        self.boreholeLengthInput = boreholeLengthInput
    }
}
