//
//  IGSHPAVBInput.swift
//  SwiftUI
//
//  Created by Ruiqi Pang/ Haoyuan He on 10/4/2023.
//

import SwiftUI

struct IGSHPAHTInputView: View {
    // Heat Pump Specification
    @State private var copValue: String = "3.63"
    @State private var eerValue: String = "14.5"
    @State private var hcValue: String = "14"
    @State private var tcValue: String = "14"
    // Heat Pump Design Conditions
    @State private var ewt_minValue: String = "-1.11"
    @State private var lwt_minValue: String = "-3.667"
    @State private var ewt_maxValue: String = "24.44"
    @State private var lwt_maxValue: String = "30"
    @State private var rt_clgValue: String = "476"
    @State private var rt_htgValue: String = "476"
    // Ground Properties
    @State private var tmValue: String = "5.56"
    @State private var asValue: String = "0.556"
    @State private var rsValue: String = "4.74"
    @State private var alphaValue: String = "0.047"
    // Borehole Parameters
    @State private var dpoValue: String = "0.027"
    @State private var dpiValue: String = "0.022"
    @State private var kpValue: String = "0.4"
    @State private var dValue: String = "2.438"
    @State private var smValue: String = "1.1"
    @State private var pmValue: String = "1"
    // Borehole Configuration
    @State private var trenchNumberValue: String = ""
    @State private var pipePerTrenchValue: String = ""

    // Heat Pump Specification Unit
    @State private var copUnit: Int = 0
    @State private var eerUnit: Int = 0
    @State private var hcUnit: Int = 0
    @State private var tcUnit: Int = 0
    // Heat Pump Design Conditions Unit
    @State private var ewt_minUnit: Int = 0
    @State private var lwt_minUnit: Int = 0
    @State private var ewt_maxUnit: Int = 0
    @State private var lwt_maxUnit: Int = 0
    @State private var rt_clgUnit: Int = 0
    @State private var rt_htgUnit: Int = 0
    // Ground Properties Unit
    @State private var tmUnit: Int = 0
    @State private var asUnit: Int = 0
    @State private var rsUnit: Int = 0
    @State private var alphaUnit: Int = 0
    // Borehole Parameters Unit
    @State private var dpoUnit: Int = 0
    @State private var dpiUnit: Int = 0
    @State private var kpUnit: Int = 0
    @State private var dUnit: Int = 0
    @State private var smUnit: Int = 0
    @State private var pmUnit: Int = 0
    // Borehole Configuration Unit
    @State private var trenchNumberUnit: Int = 0
    @State private var pipePerTrenchUnit: Int = 0

    // Alert Parameters
    @State private var showAlert = false
    @State private var alertMessage = ""

    // Navigation Parameters
    @State private var showResultView = false

    // IGSHPAHT Calculation Model
    @StateObject var HTCalculator = IGSHPAHTCalculation(heatPumpHeatingCapacity: 1,
                                                        heatPumpCoolingCapacity: 2,
                                                        coefficientOfPerformance: 3,
                                                        energyEfficientRatio: 4,
                                                        meanEarthTempearture: 5,
                                                        minEnteringWaterTemp: 6,
                                                        minLeavingWaterTemp: 7,
                                                        maxEnteringWaterTemp: 8,
                                                        maxLeavingWaterTemp: 9,
                                                        soilResistance: 10,
                                                        trenchSpaceMulti: 11,
                                                        pipeDiameterMulti: 12,
                                                        pipeOuterDiameter: 13,
                                                        pipeInnerDiameter: 14,
                                                        pipeThermalConductivity: 15,
                                                        coolingRunningTime: 16,
                                                        heatingRunningTime: 17,
                                                        avgPipeDepth: 18,
                                                        surfaceTempAmplitude: 19,
                                                        soilThermalDiffusivity: 20,
                                                        trenchNumberInput: 21,
                                                        pipePerTrenchInput: 22)

    func initCalculator() {
        HTCalculator.heatPumpHeatingCapacity = Double(convertWatt(oldUnit: hcUnit, newUnit: 0, value: hcValue))!
        HTCalculator.heatPumpCoolingCapacity = Double(convertWatt(oldUnit: tcUnit, newUnit: 0, value: tcValue))!
        HTCalculator.energyEfficientRatio = Double(eerValue)!
        HTCalculator.coefficientOfPerformance = Double(copValue)!
        HTCalculator.meanEarthTempearture = Double(convertTemperature(oldUnit: tmUnit, newUnit: 0, value: tmValue))!
        HTCalculator.minEnteringWaterTemp = Double(convertTemperature(oldUnit: ewt_minUnit, newUnit: 0, value: ewt_minValue))!
        HTCalculator.minLeavingWaterTemp = Double(convertTemperature(oldUnit: lwt_minUnit, newUnit: 0, value: lwt_minValue))!
        HTCalculator.maxEnteringWaterTemp = Double(convertTemperature(oldUnit: ewt_maxUnit, newUnit: 0, value: ewt_maxValue))!
        HTCalculator.maxLeavingWaterTemp = Double(convertTemperature(oldUnit: lwt_maxUnit, newUnit: 0, value: lwt_maxValue))!
        HTCalculator.soilResistance = Double(convertMTempW(oldUnit: rsUnit, newUnit: 0, value: rsValue))!
        HTCalculator.trenchSpaceMulti = Double(smValue)!
        HTCalculator.pipeDiameterMulti = Double(pmValue)!
        HTCalculator.pipeOuterDiameter = Double(convertMeterInch(oldUnit: dpoUnit, newUnit: 0, value: dpoValue))!
        HTCalculator.pipeInnerDiameter = Double(convertMeterInch(oldUnit: dpiUnit, newUnit: 0, value: dpiValue))!
        HTCalculator.pipeThermalConductivity = Double(convertWMTemp(oldUnit: kpUnit, newUnit: 0, value: kpValue))!
        HTCalculator.coolingRunningTime = Double(convertHour(oldUnit: rt_clgUnit, newUnit: 0, value: rt_clgValue))!
        HTCalculator.heatingRunningTime = Double(convertHour(oldUnit: rt_htgUnit, newUnit: 0, value: rt_htgValue))!
        HTCalculator.avgPipeDepth = Double(convertMeterFoot(oldUnit: dUnit, newUnit: 0, value: dValue))!
        HTCalculator.surfaceTempAmplitude = Double(convertTemperature(oldUnit: asUnit, newUnit: 0, value: asValue))!
        HTCalculator.soilThermalDiffusivity = Double(convertM2Day(oldUnit: alphaUnit, newUnit: 0, value: alphaValue))!
        if trenchNumberValue.isEmpty {
            HTCalculator.trenchNumberInput = 0
        } else {
            HTCalculator.trenchNumberInput = Double(trenchNumberValue)!
        }
        if pipePerTrenchValue.isEmpty {
            HTCalculator.pipePerTrenchInput = 0
        } else {
            HTCalculator.pipePerTrenchInput = Double(pipePerTrenchValue)!
        }
    }

    // Input Validation
    var inputIsValid: Bool {
        if copValue.isEmpty || eerValue.isEmpty || hcValue.isEmpty || tcValue.isEmpty || ewt_minValue.isEmpty || lwt_minValue.isEmpty || ewt_maxValue.isEmpty || lwt_maxValue.isEmpty || rt_clgValue.isEmpty || rt_htgValue.isEmpty || tmValue.isEmpty || asValue.isEmpty || rsValue.isEmpty || alphaValue.isEmpty || dpoValue.isEmpty || dpiValue.isEmpty || kpValue.isEmpty || dValue.isEmpty || smValue.isEmpty || pmValue.isEmpty {
            alertMessage = "Please fill in all required fields."
            return false
        }
        alertMessage = ""
        return true
    }

    var body: some View {
        Form {
            Section(header: Text("Heat Pump Specification")) {
                Row(paramName: "COP(D)",
                    defaultValue: $copValue,
                    units: [],
                    selectedUnit: $copUnit,
                    infoText: "Designed Coefficient of Performance.\n(suggested value 4)",
                    convertValue: convertUnchanged,
                    isDec: true)
                Row(paramName: "EER(D)",
                    defaultValue: $eerValue,
                    units: [],
                    selectedUnit: $eerUnit,
                    infoText: "Energy Efficiency Ratio at design cooling condition.\n(Suggested value 14.5)",
                    convertValue: convertUnchanged,
                    isDec: true)
                Row(paramName: "HC(D)",
                    defaultValue: $hcValue,
                    units: ["kW"],
                    selectedUnit: $hcUnit,
                    infoText: "Total Heating Capacity of the Heat Pump at design conditions.\n(Suggested value 20)",
                    convertValue: convertWatt,
                    isDec: true)
                Row(paramName: "TC(D)",
                    defaultValue: $tcValue,
                    units: ["kW"],
                    selectedUnit: $tcUnit,
                    infoText: "Total Cooling Capacity of the Heat Pump at design conditions.\n(Suggested value 20)",
                    convertValue: convertWatt,
                    isDec: true)
            }
            Section(header: Text("Heat Pump Design Conditions")) {
                Row(paramName: "EWT(min)",
                    defaultValue: $ewt_minValue,
                    units: ["℃", "℉"],
                    selectedUnit: $ewt_minUnit,
                    infoText: "Minimum Entering Water Temperature at heating design conditions.\n(Suggested value 4 for Melbourne)",
                    convertValue: convertTemperature,
                    isDec: true)
                Row(paramName: "LWT(min)",
                    defaultValue: $lwt_minValue,
                    units: ["℃", "℉"],
                    selectedUnit: $lwt_minUnit,
                    infoText: "Minimum Leaving Water Temperature at heating design conditions.\n(Suggested value 1 for Melbourne)",
                    convertValue: convertTemperature,
                    isDec: true)
                Row(paramName: "EWT(max)",
                    defaultValue: $ewt_maxValue,
                    units: ["℃", "℉"],
                    selectedUnit: $ewt_maxUnit,
                    infoText: "Minimum entering water temperature at heating design conditions.\n(Suggested value 30 for Melbourne)",
                    convertValue: convertTemperature,
                    isDec: true)
                Row(paramName: "LWT(max)",
                    defaultValue: $lwt_maxValue,
                    units: ["℃", "℉"],
                    selectedUnit: $lwt_maxUnit,
                    infoText: "Minimum entering water temperature at heating design conditions.\n(Suggested value 34 for Melbourne)",
                    convertValue: convertTemperature,
                    isDec: true)
                Row(paramName: "RT(CLG)",
                    defaultValue: $rt_clgValue,
                    units: ["h"],
                    selectedUnit: $rt_clgUnit,
                    infoText: "Actual Equipment Run Time in cooling mode per month.\n(Suggested value 595)",
                    convertValue: convertHour,
                    isDec: true)
                Row(paramName: "RT(HTG)",
                    defaultValue: $rt_htgValue,
                    units: ["h"],
                    selectedUnit: $rt_htgUnit,
                    infoText: "Actual Equipment Run Time in heating mode per month.\n(Suggested value 595)",
                    convertValue: convertHour,
                    isDec: true)
            }
            Section(header: Text("Ground Properties")) {
                Row(paramName: "T(M)",
                    defaultValue: $tmValue,
                    units: ["℃", "℉"],
                    selectedUnit: $tmUnit,
                    infoText: "Mean Earth Temperature in top 10 feet of soil.\n(suggested value 24 for Melbourne)",
                    convertValue: convertTemperature,
                    isDec: true)
                Row(paramName: "A(S)",
                    defaultValue: $asValue,
                    units: ["℃", "℉"],
                    selectedUnit: $asUnit,
                    infoText: "Annual Swing of earth surface temperature above and below TM.\n(suggested value -0.1)",
                    convertValue: convertTemperature,
                    isDec: true)
                Row(paramName: "R(S)",
                    defaultValue: $rsValue,
                    units: ["m ℃/W"],
                    selectedUnit: $rsUnit,
                    infoText: "Soil Thermal Resistance.\n(suggested value 1.6)",
                    convertValue: convertMTempW,
                    isDec: true)
                Row(paramName: "ɑ",
                    defaultValue: $alphaValue,
                    units: ["m²/day", "ft²/s"],
                    selectedUnit: $alphaUnit,
                    infoText: "Soil Thermal Diffusivity.\n(suggested value 0.06)",
                    convertValue: convertM2Day,
                    isDec: true)
            }

            Section(header: Text("Borehole Parameters")) {
                Row(paramName: "D(P,O)",
                    defaultValue: $dpoValue,
                    units: ["m", "in"],
                    selectedUnit: $dpoUnit,
                    infoText: "Outer Pipe Diameter.\n(suggested value 0.027)",
                    convertValue: convertMeterInch,
                    isDec: true)
                Row(paramName: "D(P,I)",
                    defaultValue: $dpiValue,
                    units: ["m", "in"],
                    selectedUnit: $dpiUnit,
                    infoText: "Inner Pipe Diameter.\n(suggested value 0.022)",
                    convertValue: convertMeterInch,
                    isDec: true)
                Row(paramName: "k(p)",
                    defaultValue: $kpValue,
                    units: ["W/m ℃"],
                    selectedUnit: $kpUnit,
                    infoText: "Pipe Thermal Conductivity.\n(suggested value 0.346)",
                    convertValue: convertWMTemp,
                    isDec: true)
                Row(paramName: "d",
                    defaultValue: $dValue,
                    units: ["m", "ft"],
                    selectedUnit: $dUnit,
                    infoText: "Average Pipe Depth.\n(suggested value 3.1)",
                    convertValue: convertMeterFoot,
                    isDec: true)
                Row(paramName: "S(M)",
                    defaultValue: $smValue,
                    units: [],
                    selectedUnit: $smUnit,
                    infoText: "Trench Spacing Multiplier.\n(suggested value 1.2)",
                    convertValue: convertUnchanged,
                    isDec: true)
                Row(paramName: "P(M)",
                    defaultValue: $pmValue,
                    units: [],
                    selectedUnit: $pmUnit,
                    infoText: "Pipe Diameter Multiplier.\n(suggested value 1)",
                    convertValue: convertUnchanged,
                    isDec: true)
            }

            Section(header: Text("Borehole Configuration (optional)")) {
                Row(paramName: "Number of Trenches",
                    defaultValue: $trenchNumberValue,
                    units: [],
                    selectedUnit: $trenchNumberUnit,
                    infoText: "Number of Trenches.",
                    convertValue: convertUnchanged,
                    isDec: false)
                Row(paramName: "Pipes Per Trench",
                    defaultValue: $pipePerTrenchValue,
                    units: [],
                    selectedUnit: $pipePerTrenchUnit,
                    infoText: "Number of Pipes in each Trench.",
                    convertValue: convertUnchanged,
                    isDec: false)
            }

            ZStack {
                NavigationLink(destination: IGSHPAHTResultView(calculator: self.HTCalculator), isActive: self.$showResultView) {
                    EmptyView()
                }
                .opacity(0)
                
                Button(action: {
                    if !inputIsValid {
                        showAlert = true
                        showResultView = false
                    } else {
                        showAlert = false
                        initCalculator()
                        showResultView = true
                    }
                }) {
                    Text("Calculate")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Warning"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }.navigationTitle("IGSHPA HT Data Input")
            .onAppear {
                UITextField.appearance().clearButtonMode = .whileEditing
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Spacer()
                }
                ToolbarItem(placement: .keyboard) {
                    Button {
                        hideKeyboard()
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
    }
}

struct IGSHPAHTInput_Previews: PreviewProvider {
    static var previews: some View {
        IGSHPAHTInputView()
    }
}
