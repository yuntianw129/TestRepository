//
//  IGSHPAHTcal.swift
//  Geothermal
//
//  Created by Ruiqi Pang/Haoyuan He on 17/4/2023.
//

import Foundation

class IGSHPAHTCalculation: ObservableObject {
    @Published var heatPumpHeatingCapacity: Double
    @Published var heatPumpCoolingCapacity: Double
    @Published var coefficientOfPerformance: Double
    @Published var energyEfficientRatio: Double
    @Published var meanEarthTempearture: Double
    @Published var minEnteringWaterTemp: Double
    @Published var minLeavingWaterTemp: Double
    @Published var maxEnteringWaterTemp: Double
    @Published var maxLeavingWaterTemp: Double
    @Published var soilResistance: Double
    @Published var trenchSpaceMulti: Double
    @Published var pipeDiameterMulti: Double
    @Published var pipeOuterDiameter: Double
    @Published var pipeInnerDiameter: Double
    @Published var pipeThermalConductivity: Double
    @Published var coolingRunningTime: Double
    @Published var heatingRunningTime: Double
    @Published var avgPipeDepth: Double
    @Published var surfaceTempAmplitude: Double
    @Published var soilThermalDiffusivity: Double
    @Published var trenchNumberInput: Double
    @Published var pipePerTrenchInput: Double
    
    var pipeThermalResistanceE: Double {
        return (log(pipeOuterDiameter / pipeInnerDiameter) / (2 * Double.pi * (pipeThermalConductivity / 1.73)))
    }
    
    var pipeThermalResistance: Double {
        return pipeThermalResistanceE * 1.73
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
        return -exp((-avgPipeDepth * 0.305) * pow(Constant, 0.5)) * cos((2 * Double.pi / 365) * ((-avgPipeDepth * 0.305) / 2) * pow(365 / (Double.pi * soilThermalDiffusivity * 0.093), 0.5)) * (surfaceTempAmplitude * 1.8 + 32) + meanEarthTempeartureE
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
        return (((heatPumpHeatingCapacity * 1000 / 0.293) * ((coefficientOfPerformance - 1) / coefficientOfPerformance) * (pipeThermalResistanceE + (soilResistance / 1.73) * heatingRunFraction * pipeDiameterMulti * trenchSpaceMulti)) / (designHeatingEarthTempE - (((minEnteringWaterTemp * 1.8 + 32) + (minLeavingWaterTemp * 1.8 + 32)) / 2))) * 0.305
    }
    
    var coolingBoreholeLength: Double {
        return (((heatPumpCoolingCapacity * 1000 / 0.293) * ((energyEfficientRatio + 3.412) / energyEfficientRatio) * (pipeThermalResistanceE + (soilResistance / 1.73) * heatingRunFraction * pipeDiameterMulti * trenchSpaceMulti)) / ((((maxEnteringWaterTemp * 1.8 + 32) + (maxLeavingWaterTemp * 1.8 + 32)) / 2) - designCoolingEarthTempE)) * 0.305
    }
    
    var totalBoreholeLength: Double {
        if coolingBoreholeLength > heatingBoreholeLength {
            return coolingBoreholeLength
        } else {
            return heatingBoreholeLength
        }
    }
    
    func getConfiguration() -> (Int, Int, Double) {
        var noT: Double = 0
        var noP: Double = 0
        var length: Double = 0
        if trenchNumberInput == 0 {
            noT = 1
            noP = 1
            length = 90
            if pipePerTrenchInput == 0 {
                while (totalBoreholeLength / (noT * noP)) > 90 {
                    if noT < 5 {
                        noT += 1
                    } else {
                        noP += 1
                    }
                    length = totalBoreholeLength / (noT * noP)
                    length = ceil(length)
                }
            } else {
                noP = Double(pipePerTrenchInput)
                while (totalBoreholeLength / (noT * noP)) > 90 {
                    noT += 1
                    length = totalBoreholeLength / (noT * noP)
                    length = ceil(length)
                }
            }
        } else {
            noT = Double(trenchNumberInput)
            if pipePerTrenchInput == 0 {
                noP = 1
                length = 90
                while (totalBoreholeLength / (noT * noP)) > 90 {
                    noP += 1
                    length = totalBoreholeLength / (noT * noP)
                    length = ceil(length)
                }
            } else {
                noP = Double(pipePerTrenchInput)
                length = totalBoreholeLength / (noT * noP)
                length = ceil(length)
            }
        }
        return (Int(noT), Int(noP), length)
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
         soilResistance: Double,
         trenchSpaceMulti: Double,
         pipeDiameterMulti: Double,
         pipeOuterDiameter: Double,
         pipeInnerDiameter: Double,
         pipeThermalConductivity: Double,
         coolingRunningTime: Double,
         heatingRunningTime: Double,
         avgPipeDepth: Double,
         surfaceTempAmplitude: Double,
         soilThermalDiffusivity: Double,
         trenchNumberInput: Double,
         pipePerTrenchInput: Double)
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
        self.soilResistance = soilResistance
        self.trenchSpaceMulti = trenchSpaceMulti
        self.pipeDiameterMulti = pipeDiameterMulti
        self.pipeOuterDiameter = pipeOuterDiameter
        self.pipeInnerDiameter = pipeInnerDiameter
        self.pipeThermalConductivity = pipeThermalConductivity
        self.coolingRunningTime = coolingRunningTime
        self.heatingRunningTime = heatingRunningTime
        self.avgPipeDepth = avgPipeDepth
        self.surfaceTempAmplitude = surfaceTempAmplitude
        self.soilThermalDiffusivity = soilThermalDiffusivity
        self.trenchNumberInput = trenchNumberInput
        self.pipePerTrenchInput = pipePerTrenchInput
        
    }
}
