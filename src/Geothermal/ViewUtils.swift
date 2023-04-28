//
//  ViewUtils.swift
//  Geothermal
//
//  Created by Yuntian Wan on 13/4/2023.
//

import Combine
import Foundation
import SwiftUI

enum Theme {
    static let textColor = Color("TextColor")
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func numbersOnly(_ text: Binding<String>, includeDecimal: Bool = false) -> some View {
        modifier(NumberOnlyViewModifier(text: text, includeDecimal: includeDecimal))
    }
}

// Data item view used in result pages.
struct DataItemView: View {
    var name: String
    var value: String
    var unit: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("\(value) \(unit)")
                .font(.subheadline)
        }
    }
}

// Row view used in input pages.
struct Row: View {
    @State var paramName: String
    @State var placeHolder: String = "Enter a number"
    @Binding var defaultValue: String
    @State var units: [String]
    @Binding var selectedUnit: Int
    @State var infoText: String
    @State private var showingPopover = false
    var convertValue: ((Int, Int, String) -> String)?
    @State var isDec: Bool
    @State private var previousUnit = 0

    var body: some View {
        HStack {
            Text(paramName)
                .frame(width: 85)

            Image(systemName: "info")
                .symbolVariant(.circle.fill)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(.blue)
                .padding(.leading, 4)
                .onTapGesture {
                    showingPopover = true
                }
                .popover(isPresented: $showingPopover) {
                    Text(infoText)
                        .font(.headline)
                        .padding()
                }
                .scaledToFit()

            TextField(placeHolder, text: $defaultValue)
                .numbersOnly($defaultValue, includeDecimal: isDec)

            if units.count > 1 {
                Picker(selection: $selectedUnit, label: EmptyView()) {
                    ForEach(Array(units.enumerated()), id: \.1) { index, unit in
                        Text(unit)
                            .tag(index)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .labelsHidden()
                .accentColor(Theme.textColor)
                .onChange(of: selectedUnit) { newUnit in
                    if let convert = convertValue, newUnit != previousUnit {
                        defaultValue = convert(previousUnit, newUnit, defaultValue)
                        previousUnit = newUnit
                    }
                }
            } else if units.count == 1 {
                Text(units[0])
            }
        }
    }
}

struct NumberOnlyViewModifier: ViewModifier {
    @Binding var text: String
    var includeDecimal: Bool

    func body(content: Content) -> some View {
        content
            .keyboardType(includeDecimal ? .numbersAndPunctuation : .numberPad)
            .onReceive(Just(text)) { newValue in
                var numbers = "0123456789"
                let decimalSeparator: String = Locale.current.decimalSeparator ?? "."
                if includeDecimal {
                    numbers += decimalSeparator
                }
                if newValue.isEmpty {
                    numbers += "-"
                }

                if newValue.components(separatedBy: decimalSeparator).count - 1 > 1 {
                    let filtered = newValue
                    self.text = String(filtered.dropLast())
                } else if newValue.hasPrefix("-") {
                    if newValue.components(separatedBy: "-").count - 1 > 1 {
                        let filtered = newValue
                        self.text = String(filtered.dropLast())
                    }
                } else {
                    let filtered = newValue.filter { numbers.contains($0) }
                    if filtered != newValue {
                        self.text = filtered
                    }
                }
            }
    }
}

// Keep up to five decimal places while omitting trailing zeros
func formatNumber(_ number: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 5
    formatter.minimumFractionDigits = 0
    formatter.groupingSeparator = ""
    return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
}

func formatNumber(_ number: Double, _ dec: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = dec
    formatter.minimumFractionDigits = 0
    formatter.groupingSeparator = ""
    return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
}

func convertWatt(oldUnit: Int, newUnit: Int, value: String) -> String {
    // Convert between ["kW", "W"], discarded for now.
//    guard let doubleValue = Double(value) else { return value }
//    let conversionFactor: Double
//    if oldUnit == 0 && newUnit == 1 {
//        conversionFactor = 1000
//    } else if oldUnit == 1 && newUnit == 0 {
//        conversionFactor = 0.001
//    } else {
//        conversionFactor = 1
//    }
//    let convertedValue = doubleValue * conversionFactor
//    return formatNumber(convertedValue)
    return value
}

// Convert between ["℃", "℉"]
func convertTemperature(oldUnit: Int, newUnit: Int, value: String) -> String {
    guard let doubleValue = Double(value) else { return value }
    let convertedValue: Double
    if oldUnit == 0 && newUnit == 1 { // Celsius to Fahrenheit
        convertedValue = (doubleValue * 9/5) + 32
    } else if oldUnit == 1 && newUnit == 0 { // Fahrenheit to Celsius
        convertedValue = (doubleValue - 32) * 5/9
    } else {
        convertedValue = doubleValue
    }
    return formatNumber(convertedValue)
}

// Convert between ["m", "ft"].
func convertMeterFoot(oldUnit: Int, newUnit: Int, value: String) -> String {
    guard let doubleValue = Double(value) else { return value }
    let conversionFactor: Double
    if oldUnit == 0 && newUnit == 1 {
        conversionFactor = 3.28084
    } else if oldUnit == 1 && newUnit == 0 {
        conversionFactor = 0.3048
    } else {
        conversionFactor = 1
    }
    let convertedValue = doubleValue * conversionFactor
    return formatNumber(convertedValue)
}

// Convert between ["m", "in"].
func convertMeterInch(oldUnit: Int, newUnit: Int, value: String) -> String {
    guard let doubleValue = Double(value) else { return value }
    let conversionFactor: Double
    if oldUnit == 0 && newUnit == 1 {
        conversionFactor = 39.3701
    } else if oldUnit == 1 && newUnit == 0 {
        conversionFactor = 0.0254
    } else {
        conversionFactor = 1
    }
    let convertedValue = doubleValue * conversionFactor
    return formatNumber(convertedValue)
}

// Convert between ["m²/day", "ft²/s"]
func convertM2Day(oldUnit: Int, newUnit: Int, value: String) -> String {
    guard let doubleValue = Double(value) else { return value }
    let conversionFactor: Double
    if oldUnit == 0 && newUnit == 1 {
        conversionFactor = 0.0000115741
    } else if oldUnit == 1 && newUnit == 0 {
        conversionFactor = 86400
    } else {
        conversionFactor = 1
    }
    let convertedValue = doubleValue * conversionFactor
    return formatNumber(convertedValue)
}

// Convert between ["W/m K", "BTU/h ft ℉"]
func convertWMK(oldUnit: Int, newUnit: Int, value: String) -> String {
    guard let doubleValue = Double(value) else { return value }
    let conversionFactor: Double
    if oldUnit == 0 && newUnit == 1 {
        conversionFactor = 0.577789
    } else if oldUnit == 1 && newUnit == 0 {
        conversionFactor = 1.73073
    } else {
        conversionFactor = 1
    }
    let convertedValue = doubleValue * conversionFactor
    return formatNumber(convertedValue)
}

// Convert between ["W/m² K", "BTU/h ft² ℉"]
func convertWM2K(oldUnit: Int, newUnit: Int, value: String) -> String {
    guard let doubleValue = Double(value) else { return value }
    let conversionFactor: Double
    if oldUnit == 0 && newUnit == 1 {
        conversionFactor = 0.17611
    } else if oldUnit == 1 && newUnit == 0 {
        conversionFactor = 5.67826
    } else {
        conversionFactor = 1
    }
    let convertedValue = doubleValue * conversionFactor
    return formatNumber(convertedValue)
}

// Convert between ["J/kg K", "BTU/lb ℉"]
func convertJKgK(oldUnit: Int, newUnit: Int, value: String) -> String {
    guard let doubleValue = Double(value) else { return value }
    let conversionFactor: Double
    if oldUnit == 0 && newUnit == 1 {
        conversionFactor = 0.238846
    } else if oldUnit == 1 && newUnit == 0 {
        conversionFactor = 4.1868
    } else {
        conversionFactor = 1
    }
    let convertedValue = doubleValue * conversionFactor
    return formatNumber(convertedValue)
}

func convertKgSKw(oldUnit: Int, newUnit: Int, value: String) -> String {
    return value
}

func convertHour(oldUnit: Int, newUnit: Int, value: String) -> String {
    return value
}

func convertMTempW(oldUnit: Int, newUnit: Int, value: String) -> String {
    return value
}

func convertWMTemp(oldUnit: Int, newUnit: Int, value: String) -> String {
    return value
}

func convertUnchanged(oldUnit: Int, newUnit: Int, value: String) -> String {
    return value
}
