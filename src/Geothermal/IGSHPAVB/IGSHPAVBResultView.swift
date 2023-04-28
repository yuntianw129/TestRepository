//
//  IGSHPAVBResultView.swift
//  Geothermal
//
//  Created by Yuntian Wan on 22/4/2023.
//

import SwiftUI

struct IGSHPAVBResultView: View {
    @State private var showPopover = false

    @ObservedObject var calculator: IGSHPAVBCalculation

    let inputData: [(String, String, String)]

    let resultData: [(String, String, String)]

    init(calculator: IGSHPAVBCalculation) {
        self.calculator = calculator
        self.inputData = [
            ("COP(D)", formatNumber(calculator.coefficientOfPerformance), ""),
            ("EER(D)", formatNumber(calculator.energyEfficientRatio), ""),
            ("HC(D)", formatNumber(calculator.heatPumpHeatingCapacity), "kW"),
            ("TC(D)", formatNumber(calculator.heatPumpCoolingCapacity), "kW"),
            ("EWT(min)", formatNumber(calculator.minEnteringWaterTemp), "℃"),
            ("LWT(min)", formatNumber(calculator.minLeavingWaterTemp), "℃"),
            ("EWT(max)", formatNumber(calculator.maxEnteringWaterTemp), "℃"),
            ("LWT(max)", formatNumber(calculator.maxLeavingWaterTemp), "℃"),
            ("RT(CLG)", formatNumber(calculator.coolingRunningTime), "h"),
            ("RT(HTG)", formatNumber(calculator.heatingRunningTime), "h"),
            ("k(G)", formatNumber(calculator.groutThermalConductivity), "W/m ℃"),
            ("T(G)", formatNumber(calculator.deepEarthTempearture), "℃"),
            ("D(G,O)", formatNumber(calculator.groundHeatTransferDiameter), "m"),
            ("D(B)", formatNumber(calculator.boreholeDiameter), "m"),
            ("D(P,O)", formatNumber(calculator.pipeOuterDiameter), "m"),
            ("D(P,I)", formatNumber(calculator.pipeInnerDiameter), "m"),
            ("k(Grout)", formatNumber(calculator.groutThermalConductivity), "W/m ℃"),
            ("k(p)", formatNumber(calculator.pipeThermalConductivity), "W/m ℃")
        ]
        self.resultData = [
            ("R(G)", formatNumber(calculator.groundThermalResistance, 1), "m ℃/W"),
            ("S(B)", formatNumber(calculator.boreholeShapeFactor, 1), ""),
            ("R(PP)", formatNumber(calculator.pipeWallThermalResistance, 1), "m ℃/W"),
            ("R(Grout)", formatNumber(calculator.groutThermalResistance, 1), "m ℃/W"),
            ("R(B)", formatNumber(calculator.boreholeThermalResistance, 1), "m ℃/W"),
            ("", "", ""),
            ("F(H)", formatNumber(calculator.heatingRunFraction, 1), ""),
            ("F(C)", formatNumber(calculator.coolingRunFraction, 1), ""),
            ("L(H.T)", formatNumber(calculator.heatingBoreholeLength, 1), "m"),
            ("L(C.T)", formatNumber(calculator.coolingBoreholeLength, 1), "m")
        ]
    }

    var body: some View {
        List {
            Section(header:
                Text("Input Data")
            ) {
                ForEach(0 ..< inputData.count / 2+inputData.count % 2, id: \.self) { index in
                    HStack(spacing: 16) {
                        DataItemView(name: self.inputData[index*2].0, value: self.inputData[index*2].1, unit: self.inputData[index*2].2)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Spacer()

                        if index*2+1 < self.inputData.count {
                            DataItemView(name: self.inputData[index*2+1].0, value: self.inputData[index*2+1].1, unit: self.inputData[index*2+1].2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            DataItemView(name: "", value: "", unit: "")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Spacer()
                    }
                    .padding(.vertical, 0.25)
                }
            }

            Section(header:
                HStack {
                    Text("Calculated Results")
                    Spacer()
                    Button(action: {
                        showPopover.toggle()
                    }) {
                        Image(systemName: "info.circle")
                    }
                    .popover(isPresented: $showPopover) {
                        VBResultInfoView()
                    }
                }) {
                    ForEach(0 ..< resultData.count / 2+resultData.count % 2, id: \.self) { index in
                        HStack(spacing: 16) {
                            DataItemView(name: self.resultData[index*2].0, value: String(self.resultData[index*2].1), unit: self.resultData[index*2].2)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Spacer()

                            if index*2+1 < self.resultData.count {
                                DataItemView(name: self.resultData[index*2+1].0, value: String(self.resultData[index*2+1].1), unit: self.resultData[index*2+1].2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                DataItemView(name: "", value: "", unit: "")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            Spacer()
                        }
                        .padding(.vertical, 0.25)
                    }
                }
            Section(header:
                Text("Recommended Setup")
            ) {
                let (no, len) = calculator.getConfiguration()
                HStack(spacing: 16) {
                    DataItemView(name: "Number of Boreholes", value: String(no), unit: "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    DataItemView(name: "Minimum Boreholes Length", value: formatNumber(len, 1), unit: "m")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                }
                .padding(.vertical, 0.25)

                VStack(alignment: .leading) {
                    Text("Configuration")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    ZStack(alignment: .leading) {
                        Image("IGSHPAVB")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("Minimum Borehole Length:\n\(formatNumber(len, 1)) m ✕ \(no) Boreholes")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(y: UIScreen.main.bounds.height*0.08)
                            .padding(.leading, 16)
                    }
                }
            }
        }
        .navigationTitle("Calculation Result")
    }
}

struct VBResultInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // TODO: Maybe add underline to the parameter names like the old app if we have time.
            Text("R(G): Ground Thermal Resistance. \nS(B): Borehole Shape Factor. \nR(PP): Thermal Resistance of Pipe Walls for Two Pipes in Parallel. \nR(Grout): Thermal Resistance Due To Grout And Pipe Position In Borehole. \nR(B): Borehole Thermal Resistance. \nF(H): Run Fraction In Heating Mode During Heating Design Month. \nF(C): Run Fraction In Cooling Mode During Cooling Design Month. \nT(S.L): Design Soil Temperature For Heating At Average GHEX Pipe Depth. \nT(S.H): Design Soil Temperature For Cooling At Average GHEX Pipe Depth. \nR(P): Pipe Thermal Resistance. \nL(HT): Total Borehole Design Length For Heating. \nL(CT): Total Borehole Design Length For Cooling.")
                .textCase(nil)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(Theme.textColor)
    }
}

struct IGSHPAVBResultView_Previews: PreviewProvider {
    static var previews: some View {
        IGSHPAVBResultView(calculator: IGSHPAVBCalculation(heatPumpHeatingCapacity: 1,
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
                                                          boreholeLengthInput: 20))
    }
}
