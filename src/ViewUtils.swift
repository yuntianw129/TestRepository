//
//  ViewUtils.swift
//  Geothermal
//
//  Created by Yuntian Wan on 13/4/2023.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func numbersOnly(_ text: Binding<String> , includeDecimal: Bool = false) -> some View {
        self.modifier(NumberOnlyViewModifier(text: text, includeDecimal: includeDecimal))
    }
}
