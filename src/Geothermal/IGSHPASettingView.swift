//
//  IGSHPASettingViw.swift
//  Geothermal
//
//  Created by Ruiqi Pang on 11/4/2023.
//

import Foundation
import SwiftUI

struct IGSHPASettingView: View {
    let infoVB = "Vertically bored systems are commonly used in both residential and commercial buildings as this configuration requires minimal land to be available to install. However, this system can be significantly expensive as a result of the cost of drilling and therefore both vertical and horizontal systems should be considered to determine the most viable configuration."
    let infoHB = "Horizontally bored systems are a common configuration for properties that have large areas of earth to utilize. The benefit of using this configuration is that extensive excavation is not required. Depending on the property, the cost of damaging and replacing what currently occupies the land can exceed the cost of the drilling, making this an optimal setup."
    let infoHT = "Horizontally trenched systems are typically the cheapest installation of the three systems because no drilling is required. However, these systems require large areas of available land to excavate in order to be installed and even when enough land is available, the cost of removing and replacing what is currently there can in itself be significantly expensive."

    var body: some View {
        VStack {
            // Text("IGSHPA System Setting")
            //    .font(.title)
            Spacer()
            ButtonWithInfo(title: "Vertically-Bored", info: infoVB, destination: IGSHPAVBInputView())
            ButtonWithInfo(title: "Horizontally-Bored", info: infoHB, destination: IGSHPAHBInputView())
            ButtonWithInfo(title: "Horizontally-Trenched", info: infoHT, destination: IGSHPAHTInputView())
            Spacer()
        }.fixedSize()
        .navigationBarTitle("IGSHPA System Setting", displayMode: .inline)
    }
}


struct SystemSettingView_Previews: PreviewProvider {
    static var previews: some View {
        IGSHPASettingView()
    }
}
