//
//  ASHRAEInputView.swift
//  Geothermal
//
//  Created by Ruiqi Pang/Haoyuan He on 13/4/2023.
//

import SwiftUI

struct ASHRAEInputView: View {
    // Heat Pump Specification
    @State private var cpValue: String = "4000"
    @State private var tInHpValue: String = "4.44"
    @State private var mFlsValue: String = "0.074"
    // Ground Properties
    @State private var alphaValue: String = "0.068"
    @State private var kValue: String = "2.25"
    @State private var tgValue: String = "12.41"
    @State private var qyValue: String = "-1.762"
    @State private var qmValue: String = "-100"
    @State private var qhValue: String = "-392.25"
    // Borehole Parameters
    @State private var bValue: String = "6.1"
    @State private var nbValue: String = "120"
    @State private var aValue: String = "1.2"
    @State private var rBoreValue: String = "0.054"
    @State private var kGroutValue: String = "1.73"
    @State private var luValue: String = "0.0471"
    @State private var rPinValue: String = "0.0137"
    @State private var rPextValue: String = "0.0167"
    @State private var kPipeValue: String = "0.45"
    @State private var hConvValue: String = "1000"
    // Borehole Configuration
    @State private var boreholeNumberValue: String = ""
    @State private var boreholeLengthValue: String = ""

    // Heat Pump Specification Unit
    @State private var cpUnit: Int = 0
    @State private var tInHpUnit: Int = 0
    @State private var mFlsUnit: Int = 0
    // Ground Properties Unit
    @State private var alphaUnit: Int = 0
    @State private var kUnit: Int = 0
    @State private var tgUnit: Int = 0
    @State private var qyUnit: Int = 0
    @State private var qmUnit: Int = 0
    @State private var qhUnit: Int = 0
    // Borehole Parameters Unit
    @State private var bUnit: Int = 0
    @State private var nbUnit: Int = 0
    @State private var aUnit: Int = 0
    @State private var rBoreUnit: Int = 0
    @State private var kGroutUnit: Int = 0
    @State private var luUnit: Int = 0
    @State private var rPinUnit: Int = 0
    @State private var rPextUnit: Int = 0
    @State private var kPipeUnit: Int = 0
    @State private var hConvUnit: Int = 0
    // Borehole Configuration Unit
    @State private var boreholeNumberUnit: Int = 0
    @State private var boreholeLengthUnit: Int = 0

    // Alert Parameters
    @State private var showAlert = false
    @State private var alertMessage = ""

    // Navigation Parameters
    @State private var showResultView = false

    // ASHRAE Calculation Model
    @StateObject var ASHRAECalculator = ASHRAECalculation(loopInnerRadius: 1,
                                                          loopOuterRadius: 2,
                                                          boreholeRadius: 3,
                                                          groundThermalConductivity: 4,
                                                          groutThermalConductivity: 5,
                                                          ULoopPipeThermalConductivity: 6,
                                                          centreDistanceBetweenPipes: 7,
                                                          internalConvectionCoefficient: 8,
                                                          groundThermalDiffusivity: 9,
                                                          enteringWaterTemp: 10,
                                                          massFlowRate: 11,
                                                          GHEThermalCapacity: 12,
                                                          distanceBetweenBoreholes: 13,
                                                          numberOfBoreholes: 14,
                                                          geoAspectRatio: 15,
                                                          undisturbedGroundTemp: 16,
                                                          yearAvgGroundLoad: 17,
                                                          monthGroundLoad: 18,
                                                          hourGroundLoad: 19,
                                                          boreholeNumber: 20,
                                                          boreholeLength: 21)

    func initCalculator() {
        ASHRAECalculator.loopInnerRadius = Double(convertMeterInch(oldUnit: rPinUnit, newUnit: 0, value: rPinValue))!
        ASHRAECalculator.loopOuterRadius = Double(convertMeterInch(oldUnit: rPextUnit, newUnit: 0, value: rPextValue))!
        ASHRAECalculator.boreholeRadius = Double(convertMeterInch(oldUnit: rBoreUnit, newUnit: 0, value: rBoreValue))!
        ASHRAECalculator.groundThermalConductivity = Double(convertWMK(oldUnit: kUnit, newUnit: 0, value: kValue))!
        ASHRAECalculator.groutThermalConductivity = Double(convertWMK(oldUnit: kGroutUnit, newUnit: 0, value: kGroutValue))!
        ASHRAECalculator.ULoopPipeThermalConductivity = Double(convertWMK(oldUnit: kPipeUnit, newUnit: 0, value: kPipeValue))!
        ASHRAECalculator.centreDistanceBetweenPipes = Double(convertMeterInch(oldUnit: luUnit, newUnit: 0, value: luValue))!
        ASHRAECalculator.internalConvectionCoefficient = Double(convertWM2K(oldUnit: hConvUnit, newUnit: 0, value: hConvValue))!
        ASHRAECalculator.groundThermalDiffusivity = Double(convertM2Day(oldUnit: alphaUnit, newUnit: 0, value: alphaValue))!
        ASHRAECalculator.enteringWaterTemp = Double(convertTemperature(oldUnit: tInHpUnit, newUnit: 0, value: tInHpValue))!
        ASHRAECalculator.massFlowRate = Double(convertKgSKw(oldUnit: mFlsUnit, newUnit: 0, value: mFlsValue))!
        ASHRAECalculator.GHEThermalCapacity = Double(convertJKgK(oldUnit: cpUnit, newUnit: 0, value: cpValue))!
        ASHRAECalculator.distanceBetweenBoreholes = Double(convertMeterFoot(oldUnit: bUnit, newUnit: 0, value: bValue))!
        ASHRAECalculator.numberOfBoreholes = Double(nbValue)!
        ASHRAECalculator.geoAspectRatio = Double(aValue)!
        ASHRAECalculator.undisturbedGroundTemp = Double(convertTemperature(oldUnit: tgUnit, newUnit: 0, value: tgValue))!
        ASHRAECalculator.yearAvgGroundLoad = Double(convertWatt(oldUnit: qyUnit, newUnit: 0, value: qyValue))!
        ASHRAECalculator.monthGroundLoad = Double(convertWatt(oldUnit: qmUnit, newUnit: 0, value: qmValue))!
        ASHRAECalculator.hourGroundLoad = Double(convertWatt(oldUnit: qhUnit, newUnit: 0, value: qhValue))!
        ASHRAECalculator.boreholeNumberInput = 0
        ASHRAECalculator.boreholeLengthInput = 0
    }

    // Input Validation
    var inputIsValid: Bool {
        if cpValue.isEmpty || tInHpValue.isEmpty || mFlsValue.isEmpty || alphaValue.isEmpty || kValue.isEmpty || tgValue.isEmpty || qyValue.isEmpty || qmValue.isEmpty || qhValue.isEmpty || bValue.isEmpty || nbValue.isEmpty || aValue.isEmpty || rBoreValue.isEmpty || kGroutValue.isEmpty || luValue.isEmpty || rPinValue.isEmpty || rPextValue.isEmpty || kPipeValue.isEmpty || hConvValue.isEmpty {
            alertMessage = "Please fill in all required fields."
            return false
        }
        return true
    }

    var body: some View {
        Form {
            Section(header: Text("Heat Pump Specification")) {
                Row(paramName: "Cp",
                    defaultValue: $cpValue,
                    units: ["J/kg K", "BTU/lb ℉"],
                    selectedUnit: $cpUnit,
                    infoText: "Ground Heat Exchanger (GHE) fluid (water) thermal heat capacity.\n(Suggested value 4000)",
                    convertValue: convertJKgK,
                    isDec: true)
                Row(paramName: "T(inHP)",
                    defaultValue: $tInHpValue,
                    units: ["℃", "℉"],
                    selectedUnit: $tInHpUnit,
                    infoText: "Heat Pump Entering Water Temperature.\n(Suggested value 4.4)",
                    convertValue: convertTemperature,
                    isDec: true)
                Row(paramName: "m(fls)",
                    defaultValue: $mFlsValue,
                    units: ["kg/s kW"],
                    selectedUnit: $mFlsUnit,
                    infoText: "Mass Flow Rate of Fluid per kilowatt of peak hourly ground load.\n(Suggested value 0.074)",
                    convertValue: convertKgSKw,
                    isDec: true)
            }
            Section(header: Text("Ground Properties")) {
                Row(paramName: "α",
                    defaultValue: $alphaValue,
                    units: ["m²/day", "ft²/s"],
                    selectedUnit: $alphaUnit,
                    infoText: "Soil Thermal Diffusity.\n(Suggested value 0.06)",
                    convertValue: convertM2Day,
                    isDec: true)
                Row(paramName: "k",
                    defaultValue: $kValue,
                    units: ["W/m K", "BTU/h ft ℉"],
                    selectedUnit: $kUnit,
                    infoText: "Ground Thermal Conductivity.\n(Suggested value 1.73 for Melbourne)",
                    convertValue: convertWMK,
                    isDec: true)
                Row(paramName: "Tg",
                    defaultValue: $tgValue,
                    units: ["℃", "℉"],
                    selectedUnit: $tgUnit,
                    infoText: "Undisturbed Ground Temperature.\n(Suggested value 12.41 for Melbourne)",
                    convertValue: convertTemperature,
                    isDec: true)
                Row(paramName: "q(y)",
                    defaultValue: $qyValue,
                    units: ["kW"],
                    selectedUnit: $qyUnit,
                    infoText: "Yearly Average Ground Load.\n(Suggested value -1.762)",
                    convertValue: convertWatt,
                    isDec: true)
                Row(paramName: "q(m)",
                    defaultValue: $qmValue,
                    units: ["kW"],
                    selectedUnit: $qmUnit,
                    infoText: "Monthly Ground Load.\n(Suggested value -100)",
                    convertValue: convertWatt,
                    isDec: true)
                Row(paramName: "q(h)",
                    defaultValue: $qhValue,
                    units: ["kW"],
                    selectedUnit: $qhUnit,
                    infoText: "Hourly Average Ground Load.\n(Suggested value -392.25)",
                    convertValue: convertWatt,
                    isDec: true)
            }
            Section(header: Text("Borehole Parameters")) {
                Row(paramName: "B",
                    defaultValue: $bValue,
                    units: ["m", "ft"],
                    selectedUnit: $bUnit,
                    infoText: "Distance between boreholes.\n(Suggested value 6.1)",
                    convertValue: convertMeterFoot,
                    isDec: true)
                Row(paramName: "NB",
                    defaultValue: $nbValue,
                    units: [],
                    selectedUnit: $nbUnit,
                    infoText: "Number of Borehole GHEs.\n(Suggested value 120)",
                    convertValue: convertUnchanged,
                    isDec: true)
                Row(paramName: "A",
                    defaultValue: $aValue,
                    units: [],
                    selectedUnit: $aUnit,
                    infoText: "Borefield Geometrical Aspect Ratio.\n(Suggested value 1.2)",
                    convertValue: convertUnchanged,
                    isDec: true)
                Row(paramName: "r(bore)",
                    defaultValue: $rBoreValue,
                    units: ["m", "in"],
                    selectedUnit: $rBoreUnit,
                    infoText: "Radius of Borehole.\n(Suggested value 0.054)",
                    convertValue: convertMeterInch,
                    isDec: true)
                Row(paramName: "k(grout)",
                    defaultValue: $kGroutValue,
                    units: ["W/m K", "BTU/h ft ℉"],
                    selectedUnit: $kGroutUnit,
                    infoText: "Grout Thermal Conductivity.\n(Suggested value 0.692)",
                    convertValue: convertWMK,
                    isDec: true)
                Row(paramName: "Lu",
                    defaultValue: $luValue,
                    units: ["m", "in"],
                    selectedUnit: $luUnit,
                    infoText: "Centre-to-centre distance between pipes of U loop.\n(Suggested value 0.0471)",
                    convertValue: convertMeterInch,
                    isDec: true)
                Row(paramName: "r(p,in)",
                    defaultValue: $rPinValue,
                    units: ["m", "in"],
                    selectedUnit: $rPinUnit,
                    infoText: "Inner Radius of U loop.\n(Suggested value 0.0137)",
                    convertValue: convertMeterInch,
                    isDec: true)
                Row(paramName: "r(p,ext)",
                    defaultValue: $rPextValue,
                    units: ["m", "in"],
                    selectedUnit: $rPextUnit,
                    infoText: "Outer Radius of U loop.\n(Suggested value 0.0167)",
                    convertValue: convertMeterInch,
                    isDec: true)
                Row(paramName: "k(pipe)",
                    defaultValue: $kPipeValue,
                    units: ["W/m K", "BTU/h ft ℉"],
                    selectedUnit: $kPipeUnit,
                    infoText: "Pipe Thermal Conductivity.\n(Suggested value 0.346)",
                    convertValue: convertWMK,
                    isDec: true)
                Row(paramName: "h(conv)",
                    defaultValue: $hConvValue,
                    units: ["W/m² K", "BTU/h ft² ℉"],
                    selectedUnit: $hConvUnit,
                    infoText: "Internal Convection Coefficient.\n(Suggested value 1000)",
                    convertValue: convertWM2K,
                    isDec: true)
            }

            // Temporarily disabled until further notice from client.
//            Section(header: Text("Borehole Configuration (optional)")) {
//                Row(paramName: "Borehole Number",
//                    defaultValue: $boreholeNumberValue,
//                    units: [],
//                    selectedUnit: $boreholeNumberUnit,
//                    infoText: "Number of boreholes.",
//                    convertValue: convertUnchanged,
//                    isDec: false)
//                Row(paramName: "Borehole Length",
//                    defaultValue: $boreholeLengthValue,
//                    units: ["m", "ft"],
//                    selectedUnit: $boreholeLengthUnit,
//                    infoText: "Max length of a single borehole.",
//                    convertValue: convertMeterFoot,
//                    isDec: true)
//            }

            ZStack {
                NavigationLink(destination: ASHRAEResultView(calculator: self.ASHRAECalculator), isActive: self.$showResultView) {
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

//                if inputIsValid {
//                    NavigationLink(destination: ASHRAEResultViewDemo(calculator: ASHRAECalculator)) {}
//                        .frame(width: 0, height: 0)
//                        .opacity(0)
//                }
            }.alert(isPresented: $showAlert) {
                Alert(title: Text("Warning"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }

        }.navigationTitle("ASHRAE Data Input")
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

struct ASHRAEInputView_Previews: PreviewProvider {
    static var previews: some View {
        ASHRAEInputView()
    }
}
