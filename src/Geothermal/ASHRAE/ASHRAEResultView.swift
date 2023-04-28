//
//  ASHRAEResultView.swift
//  Geothermal
//
//  Created by Yuntian Wan on 17/4/2023.
//

import SwiftUI

struct ASHRAEResultView: View {
    @State private var showPopover = false

    @ObservedObject var calculator: ASHRAECalculation

    let inputData: [(String, String, String)]

    let resultData: [(String, String, String)]

    init(calculator: ASHRAECalculation) {
        self.calculator = calculator
        self.inputData = [
            ("Cp", formatNumber(calculator.GHEThermalCapacity), "J/kg K"),
            ("T(inHP)", formatNumber(calculator.enteringWaterTemp), "℃"),
            ("m(fls)", formatNumber(calculator.massFlowRate), "kg/s kW"),
            ("k", formatNumber(calculator.groundThermalConductivity), "W/m·K"),
            ("α", formatNumber(calculator.groundThermalDiffusivity), "m²/day"),
            ("Tg", formatNumber(calculator.undisturbedGroundTemp), "℃"),
            ("q(y)", formatNumber(calculator.yearAvgGroundLoad), "kW"),
            ("q(m)", formatNumber(calculator.monthGroundLoad), "kW"),
            ("q(h)", formatNumber(calculator.hourGroundLoad), "kW"),
            ("B", formatNumber(calculator.distanceBetweenBoreholes), "m"),
            ("NB", formatNumber(calculator.numberOfBoreholes), ""),
            ("A", formatNumber(calculator.geoAspectRatio), ""),
            ("k(grout)", formatNumber(calculator.groutThermalConductivity), "W/m K"),
            ("r(bore)", formatNumber(calculator.boreholeRadius), "m"),
            ("Lu", formatNumber(calculator.centreDistanceBetweenPipes), "m"),
            ("r(p.in)", formatNumber(calculator.loopInnerRadius), "m"),
            ("k(pipe)", formatNumber(calculator.ULoopPipeThermalConductivity), "W/m K"),
            ("r(p.ext)", formatNumber(calculator.loopOuterRadius), "m"),
            ("h(conv)", formatNumber(calculator.internalConvectionCoefficient), "W/m² K")
        ]
        self.resultData = [
            ("T(outHHP)", formatNumber(calculator.outletWaterTempHeating, 1), "℃"),
            ("T(outCHP)", formatNumber(calculator.outletWaterTempCooling, 1), "℃"),
            ("T(mc)", formatNumber(calculator.meanWaterTempCooling, 1), "℃"),
            ("T(mh)", formatNumber(calculator.meanWaterTempHeating, 1), "℃"),
            ("T(pc)", formatNumber(calculator.tempPenaltyCooling, 1), "℃"),
            ("T(ph)", formatNumber(calculator.tempPenaltyHeating, 1), "℃"),
            ("In(t/ts)", formatNumber(calculator.dimensionlessTime, 1), ""),
            ("F", formatNumber(calculator.correlationFunc, 1), ""),
            ("R(10y)", formatNumber(calculator.tenyearResistance, 1), "m K/W"),
            ("R(1m)", formatNumber(calculator.onemonthResistance, 1), "m K/W"),
            ("R(6h)", formatNumber(calculator.sixhourResistance, 1), "m K/W"),
            ("R(conv)", formatNumber(calculator.innerPipeConvectionResistance, 1), "m K/W"),
            ("R(p)", formatNumber(calculator.pipeConvectionResistance, 1), "m K/W"),
            ("R(grout)", formatNumber(calculator.groutResistance, 1), "m K/W"),
            ("R(b)", formatNumber(calculator.boreholeResistance, 1), "m K/W"),
            ("", "", ""),
            ("L(CU)", formatNumber(calculator.undisturbedCoolingLength, 1), "km"),
            ("L(HU)", formatNumber(calculator.undisturbedHeatingLength, 1), "km"),
            ("L(CT)", formatNumber(calculator.totalCoolingBoreholeLength, 1), "km"),
            ("L(HT)", formatNumber(calculator.totalHeatingBoreholeLength, 1), "km")
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
                        ASHRAEResultInfoView()
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
                HStack(spacing: 16) {
                    DataItemView(name: "Number of Boreholes", value: String(Int(calculator.numberOfBoreholes)), unit: "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    DataItemView(name: "Minimum Boreholes Length", value: formatNumber(calculator.boreholeLengthOutput, 1), unit: "m")
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
                        Text("Minimum Borehole Length:\n\(formatNumber(calculator.boreholeLengthOutput, 1)) m ✕ \(Int(calculator.numberOfBoreholes)) Boreholes")
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

struct ASHRAEResultInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // TODO: Maybe add underline to the parameter names like the old app if we have time.
            Text("T(outHHP): Heating Mode Heat Pump Outlet Water Temperature.\nT(outCHP): Cooling Mode Heat Pump Outlet Water Temperature.\nT(mh): Heating Mode Mean GHE Fluid Temperature.\nT(mc): Cooling Mode Mean GHE Fluid Temperature.\nT(pc): Cooling Mode Temperature Penalty.\nT(ph): Heating Mode Temperature Penalty.\nIn(t/ts): Dimensionless Time.\nF:Correlation Function.\nR(10y): Effective Thermal Resistance Of The Ground To 10-Year Ground Load.\nR(1m): Effective Thermal Resistance Of The Ground To 1-Month Ground Load.\nR(6h): EffectiveThermal Resistance Of The Ground To 6-Hour Ground Load.\nR(conv): Convection ResistanceInside Each Tube Of The U Loop.\nR(p): Convection Resistance For Each Tube Of The U Loop.\nR(Grout): Grout Resistance.\nR(B): Effective Thermal Resistance of The Borehole.\nL(CU): Undisturbed Total Borehole Design Length For Cooling.\nL(HU): Undisturbed Total Borehole Design Length For Heating.\nL(HT): Total Borehole Design Length For Heating.\nL(CT): Total Borehole Design Length For Cooling.")
                .textCase(nil)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(Theme.textColor)
    }
}

struct ASHRAEResultViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        ASHRAEResultView(calculator: ASHRAECalculation(loopInnerRadius: 1,
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
                                                       boreholeLength: 21))
    }
}
