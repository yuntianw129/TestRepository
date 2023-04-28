//
//  MethodView.swift
//  Geothermal
//
//  Created by Yuntian Wan on 13/4/2023.
//

import SwiftUI

struct MethodView: View {
    let infoIGSHPA = "The International Ground Source Heat Pump Association (IGSHPA) provides pre-design calculation methods for vertically bored, horizontally bored and horizontally trenched systems. Their methods are based on the assumption that the ground, from which heat is exchanged, has a constant temperature at certain depths below the surface."
    let infoASHRAE = "The American Society of Heating, Refrigerating and Air-Conditioning Engineers (ASHRAE) method used in this iOS application has been recast by Philippe et al. (2010) and is used for vertical systems. This method is derived from the assumption that heat transfer in the ground only occurs by conduction and that moisture evaporation or underground water movement is not significant."

    var body: some View {
            VStack(spacing: 30) {
                ButtonWithInfo(title: "IGSHPA", info: infoIGSHPA, destination: IGSHPASettingView())

                ButtonWithInfo(title: "ASHRAE", info: infoASHRAE, destination: ASHRAEInputView())
            }.fixedSize()
            .navigationBarTitle("Method", displayMode: .inline)
        }
}

struct ButtonWithInfo<Content: View>: View {
    let title: String
    let info: String
    let destination: Content

    @State private var showingInfo = false

    var body: some View {
        HStack(spacing: 10) {
            NavigationLink(destination: destination) {
                Text(title)
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .cornerRadius(10)
                    
            }
            Button(action: { showingInfo.toggle() }) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
            .popover(isPresented: $showingInfo) {
                VStack {
                    Text(info)
                        .padding()
                    Button(action: { showingInfo.toggle() }) {
                        Text("Close")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                }
                .frame(maxWidth: 300)
            }
        }
    }
}

struct MethodView_Previews: PreviewProvider {
    static var previews: some View {
        MethodView()
    }
}
