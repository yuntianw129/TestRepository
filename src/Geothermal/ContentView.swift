//
//  ContentView.swift
//  Geothermal
//
//  Created by Yuntian Wan on 13/4/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedLanguage = 0
   
    @State private var isTermsAccepted = false
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image("Logo")
                        .resizable()
                        .cornerRadius(5)
                        .aspectRatio(contentMode: .fit)
                        .padding(/*@START_MENU_TOKEN@*/ .all/*@END_MENU_TOKEN@*/)
                    Text("GEOTHERMAL")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.textColor)
                    Text("V 0.1.0")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.textColor)

                    HStack {
                        Spacer()
                        Spacer()
                        Text("Language")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.trailing)
                        Spacer()
                        Picker(selection: $selectedLanguage, label: Text("")) {
                            Text("English").tag(0)
                        }
                        .pickerStyle(MenuPickerStyle())
                        Spacer()
                        Spacer()
                    }
                    .padding(.top)

                    HStack {
                        Spacer()
                        Spacer()
                        Text("Theme")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.trailing)
                        Spacer()
                        Picker(selection: $isDarkMode, label: Text("")) {
                            Text("Light").tag(false)
                            Text("Dark").tag(true)
                        }
                        Spacer()
                        Spacer()
                            .pickerStyle(MenuPickerStyle())
                    }
                    .padding(.top)
                }

                
                // TODO: Check if the terms checkbox is checked.
                if isTermsAccepted{
                    NavigationLink(destination: MethodView()) {
                        Text("Start")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top)

                }else{
                    TermsAndConditions(isTermsAccepted: $isTermsAccepted)
                }
                Spacer()

                Text("COPYRIGHT @2016 UNIVERSITY OF MELBOURNE. ALL RIGHTS RESERVED")
                    .font(.footnote)
                    .fontWeight(.light)
                    .foregroundColor(Color.black)
                    .padding(.bottom)
            }
            .padding()
        }
    }
}
struct TermsAndConditions: View {
    @Binding var isTermsAccepted: Bool
    
    var body: some View {
        HStack {
            // TODO: Automatically check if the app is not executed for the first time.
            Toggle("", isOn: $isTermsAccepted)
                .toggleStyle(CheckboxToggleStyle())
            Text("I accept the")
                .font(.callout)
                .fontWeight(.semibold)
            NavigationLink(destination: TermsAndConditionsView()) {
                Text("terms and conditions")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .underline()
            }
        }
        .padding(.top)

        }
    }

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Button(action: { configuration.isOn.toggle() }) {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(configuration.isOn ? .blue : .gray)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
