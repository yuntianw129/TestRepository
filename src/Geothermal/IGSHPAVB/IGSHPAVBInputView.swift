//
//  IGSHPAVBInputView.swift
//  Geothermal
//
//  Created by Ruiqi Pang/ Haoyuan He on 10/4/2023.
//

import SwiftUI

struct IGSHPAVBInputView: View {
    // Heat Pump Specification
    @State private var copValue: String = "4"
    @State private var eerValue: String = "14.5"
    @State private var hcValue: String = "20"
    @State private var tcValue: String = "1.73"
    // Heat Pump Design Conditions
    @State private var ewtMinValue: String = "4"
    @State private var lwtMinValue: String = "1"
    @State private var ewtMaxValue: String = "30"
    @State private var lwtMaxValue: String = "34"
    @State private var rtClgValue: String = "595"
    @State private var rtHtgValue: String = "595"
    // Ground Properties
    @State private var kgValue: String = "1.73"
    @State private var tgValue: String = "18"
    @State private var dgoValue: String = "4.572"
    // Borehole Parameters
    @State private var dbValue: String = "0.128"
    @State private var dpoValue: String = "0.027"
    @State private var dpiValue: String = "0.022"
    @State private var kGroutValue: String = "0.692"
    @State private var kpValue: String = "0.346"
    // Borehole Configuration
    @State private var boreholeNumberValue: String = ""
    @State private var boreholeLengthValue: String = ""

    // Heat Pump Specification Unit
    @State private var copUnit: Int = 0
    @State private var eerUnit: Int = 0
    @State private var hcUnit: Int = 0
    @State private var tcUnit: Int = 0
    // Heat Pump Design Conditions Unit
    @State private var ewtMinUnit: Int = 0
    @State private var lwtMinUnit: Int = 0
    @State private var ewtMaxUnit: Int = 0
    @State private var lwtMaxUnit: Int = 0
    @State private var rtClgUnit: Int = 0
    @State private var rtHtgUnit: Int = 0
    // Ground Properties Unit
    @State private var kgUnit: Int = 0
    @State private var tgUnit: Int = 0
    @State private var dgoUnit: Int = 0
    // Borehole Parameters Unit
    @State private var dbUnit: Int = 0
    @State private var dpoUnit: Int = 0
    @State private var dpiUnit: Int = 0
    @State private var kGroutUnit: Int = 0
    @State private var kpUnit: Int = 0
    // Borehole Configuration Unit
    @State private var boreholeNumberUnit: Int = 0
    @State private var boreholeLengthUnit: Int = 0

    // IGSHPAVB Calculation Model
    @StateObject var VBCalculator = IGSHPAVBCalculation(heatPumpHeatingCapacity: 1,
                                                        heatPumpCoolingCapacity: 2,
                                                        coefficientOfPerformance: 3,
                                                        energyEfficientRatio: 4,
                                                        deepEarthTempearture: 5,
                                                        minEnteringWaterTemp: 6,
                                                        minLeavingWaterTemp: 7,
                                                        maxEnteringWaterTemp: 8,
                                                        maxLeavingWaterTemp: 9,
                                                        groundThermalConductivity: 10,
                                                        groudHeatTransferDiameter: 11,
                                                        boreholeDiameter: 12,
                                                        pipeOuterDiameter: 13,
                                                        pipeInnerDiameter: 14,
                                                        groutThermalConductivity: 15,
                                                        pipeThermalConductivity: 16,
                                                        coolingRunningTime: 17,
                                                        heatingRunningTime: 18,
                                                        boreholeNumberInput: 19,
                                                        boreholeLengthInput: 20)
    func initCalculator() {
        VBCalculator.heatPumpHeatingCapacity = Double(convertWatt(oldUnit: hcUnit, newUnit: 0, value: hcValue))!
        VBCalculator.coefficientOfPerformance = Double(convertUnchanged(oldUnit: copUnit, newUnit: 0, value: copValue))!
        VBCalculator.heatPumpCoolingCapacity = Double(convertWatt(oldUnit: tcUnit, newUnit: 0, value: tcValue))!
        VBCalculator.energyEfficientRatio = Double(convertUnchanged(oldUnit: eerUnit, newUnit: 0, value: eerValue))!
        VBCalculator.deepEarthTempearture = Double(convertTemperature(oldUnit: tgUnit, newUnit: 0, value: tgValue))!
        VBCalculator.minEnteringWaterTemp = Double(convertTemperature(oldUnit: ewtMinUnit, newUnit: 0, value: ewtMinValue))!
        VBCalculator.minLeavingWaterTemp = Double(convertTemperature(oldUnit: lwtMinUnit, newUnit: 0, value: lwtMinValue))!
        VBCalculator.maxEnteringWaterTemp = Double(convertTemperature(oldUnit: ewtMaxUnit, newUnit: 0, value: ewtMaxValue))!
        VBCalculator.maxLeavingWaterTemp = Double(convertTemperature(oldUnit: lwtMaxUnit, newUnit: 0, value: lwtMaxValue))!
        VBCalculator.groundThermalConductivity = Double(convertWMTemp(oldUnit: kgUnit, newUnit: 0, value: kgValue))!
        VBCalculator.groundHeatTransferDiameter = Double(convertMeterFoot(oldUnit: dgoUnit, newUnit: 0, value: dgoValue))!
        VBCalculator.boreholeDiameter = Double(convertMeterInch(oldUnit: dbUnit, newUnit: 0, value: dbValue))!
        VBCalculator.pipeOuterDiameter = Double(convertMeterInch(oldUnit: dpoUnit, newUnit: 0, value: dpoValue))!
        VBCalculator.pipeInnerDiameter = Double(convertMeterInch(oldUnit: dpiUnit, newUnit: 0, value: dpiValue))!
        VBCalculator.groutThermalConductivity = Double(convertWMTemp(oldUnit: kGroutUnit, newUnit: 0, value: kGroutValue))!
        VBCalculator.pipeThermalConductivity = Double(convertWMTemp(oldUnit: kpUnit, newUnit: 0, value: kpValue))!
        VBCalculator.coolingRunningTime = Double(convertHour(oldUnit: rtClgUnit, newUnit: 0, value: rtClgValue))!
        VBCalculator.heatingRunningTime = Double(convertHour(oldUnit: rtHtgUnit, newUnit: 0, value: rtHtgValue))!
        if boreholeNumberValue.isEmpty {
            VBCalculator.boreholeNumberInput = 0
        } else {
            VBCalculator.boreholeNumberInput = Double(boreholeNumberValue)!
        }
        if boreholeLengthValue.isEmpty {
            VBCalculator.boreholeLengthInput = 0
        } else {
            VBCalculator.boreholeLengthInput = Double(convertMeterFoot(oldUnit: boreholeLengthUnit, newUnit: 0, value: boreholeLengthValue))!
        }
    }

    // Alert Parameters
    @State private var showAlert = false
    @State private var alertMessage = ""

    // Navigation Parameters
    @State private var showResultView = false

    // Input Validation
    var inputIsValid: Bool {
        if copValue.isEmpty || eerValue.isEmpty || hcValue.isEmpty || tcValue.isEmpty || ewtMinValue.isEmpty || lwtMinValue.isEmpty || ewtMaxValue.isEmpty || lwtMaxValue.isEmpty || rtClgValue.isEmpty || rtHtgValue.isEmpty || kgValue.isEmpty || tgValue.isEmpty || dgoValue.isEmpty || dbValue.isEmpty || dpoValue.isEmpty || dpiValue.isEmpty || kGroutValue.isEmpty || kpValue.isEmpty {
            alertMessage = "Please fill in all required fields."
            return false
        }
        if !boreholeNumberValue.isEmpty && !boreholeLengthValue.isEmpty {
            alertMessage = "Please fill in either borehole number or borehole length."
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
                    infoText: "Designed Coefficient of Performance.\n(Suggested value 4)",
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
                    defaultValue: $ewtMinValue,
                    units: ["℃", "℉"],
                    selectedUnit: $ewtMinUnit,
                    infoText: "Minimum Entering Water Temperature at heating design conditions.\n(Suggested value 4 for Melbourne)",
                    convertValue: convertTemperature,
                    isDec: true)
                Row(paramName: "LWT(min)",
                    defaultValue: $lwtMinValue,
                    units: ["℃", "℉"],
                    selectedUnit: $lwtMinUnit,
                    infoText: "Minimum Leaving Water Temperature at heating design conditions.\n(Suggested value 1 for Melbourne)",
                    convertValue: convertTemperature,
                    isDec: true)
                Row(paramName: "EWT(max)",
                    defaultValue: $ewtMaxValue,
                    units: ["℃", "℉"],
                    selectedUnit: $ewtMaxUnit,
                    infoText: "Minimum entering water temperature at heating design conditions.\n(Suggested value 30 for Melbourne)",
                    convertValue: convertTemperature,
                    isDec: true)
                Row(paramName: "LWT(max)",
                    defaultValue: $lwtMaxValue,
                    units: ["℃", "℉"],
                    selectedUnit: $lwtMaxUnit,
                    infoText: "Minimum entering water temperature at heating design conditions.\n(Suggested value 34 for Melbourne)",
                    convertValue: convertTemperature,
                    isDec: true)
                Row(paramName: "RT(CLG)",
                    defaultValue: $rtClgValue,
                    units: ["h"],
                    selectedUnit: $rtClgUnit,
                    infoText: "Actual Equipment Run Time in cooling mode per month.\n(Suggested value 595)",
                    convertValue: convertHour,
                    isDec: true)
                Row(paramName: "RT(HTG)",
                    defaultValue: $rtHtgValue,
                    units: ["h"],
                    selectedUnit: $rtHtgUnit,
                    infoText: "Actual Equipment Run Time in heating mode per month.\n(Suggested value 595)",
                    convertValue: convertHour,
                    isDec: true)
            }
            Section(header: Text("Ground Properties")) {
                Row(paramName: "k(G)",
                    defaultValue: $kgValue,
                    units: ["W/m ℃"],
                    selectedUnit: $kgUnit,
                    infoText: "Ground Thermal Conductivity.\n(Suggested value 1.73 for Melbourne)",
                    convertValue: convertWMTemp,
                    isDec: true)
                Row(paramName: "T(G)",
                    defaultValue: $tgValue,
                    units: ["℃", "℉"],
                    selectedUnit: $tgUnit,
                    infoText: "Deep – Earth Temperature.\n(Suggested value 18 for Melbourne)",
                    convertValue: convertTemperature,
                    isDec: true)
                Row(paramName: "D(G,O)",
                    defaultValue: $dgoValue,
                    units: ["m", "ft"],
                    selectedUnit: $dgoUnit,
                    infoText: "Diameter of the ground surrounding the borehole affected by heat transfer.\n(Suggested value 4.572)",
                    convertValue: convertMeterFoot,
                    isDec: true)
            }

            Section(header: Text("Borehole Parameters")) {
                Row(paramName: "D(B)",
                    defaultValue: $dbValue,
                    units: ["m", "in"],
                    selectedUnit: $dbUnit,
                    infoText: "Diameter of Borehole.\n(Suggested value 0.128)",
                    convertValue: convertMeterInch,
                    isDec: true)
                Row(paramName: "D(P,O)",
                    defaultValue: $dpoValue,
                    units: ["m", "in"],
                    selectedUnit: $dpoUnit,
                    infoText: "Outer Pipe Diameter.\n(Suggested value 0.027)",
                    convertValue: convertMeterInch,
                    isDec: true)
                Row(paramName: "D(P,I)",
                    defaultValue: $dpiValue,
                    units: ["m", "in"],
                    selectedUnit: $dpiUnit,
                    infoText: "Inner Pipe Diameter.\n(Suggested value 0.022)",
                    convertValue: convertMeterInch,
                    isDec: true)
                Row(paramName: "k(Grout)",
                    defaultValue: $kGroutValue,
                    units: ["W/m ℃"],
                    selectedUnit: $kGroutUnit,
                    infoText: "Grout Thermal Conductivity.\n(Suggested value 0.692)",
                    convertValue: convertWMTemp,
                    isDec: true)
                Row(paramName: "k(p)",
                    defaultValue: $kpValue,
                    units: ["W/m ℃"],
                    selectedUnit: $kpUnit,
                    infoText: "Pipe Thermal Conductivity.\n(Suggested value 0.346)",
                    convertValue: convertWMTemp,
                    isDec: true)
            }

            Section(header: Text("Borehole Configuration (optional)")) {
                Row(paramName: "Borehole Number",
                    defaultValue: $boreholeNumberValue,
                    units: [],
                    selectedUnit: $boreholeNumberUnit,
                    infoText: "Number of boreholes.",
                    convertValue: convertUnchanged,
                    isDec: false)
                Row(paramName: "Borehole Length",
                    defaultValue: $boreholeLengthValue,
                    units: ["m", "ft"],
                    selectedUnit: $boreholeLengthUnit,
                    infoText: "Max length of a single borehole.",
                    convertValue: convertMeterFoot,
                    isDec: true)
            }

            ZStack {
                NavigationLink(destination: IGSHPAVBResultView(calculator: self.VBCalculator), isActive: self.$showResultView) {
                    EmptyView()
                }
                .opacity(0)

                Button(action: {
                    if !inputIsValid {
                        showResultView = false
                        showAlert = true
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
        }.navigationTitle("IGSHPA VB Data Input")
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

struct IGSHPAVBInput_Previews: PreviewProvider {
    static var previews: some View {
        IGSHPAVBInputView()
    }
}
