//
//  BXIndustryConfigurator.swift
//  BXIndustry
//
//  Created by Eric Anderson on 9/12/24.
//

import SwiftUI

struct BXIndustryConfiguratorView: View {
    @ObservedObject private var model: BXIndustryMainViewModel
    @State private var bgColor: Color
    @State private var primaryColor: Color
    @State private var secondaryColor: Color
    @State private var buttonPressedColor: Color
    
    init () {
        let model = BXIndustryMainViewModel.shared
        self.model = model
        
        if model.customBackgroundColor != nil {
            _bgColor = State(initialValue: model.customBackgroundColor!.asColor()!)
        } else {
            _bgColor = State(initialValue: Color.white)
        }
        
        primaryColor = model.primaryColor.asColor()!
        secondaryColor = model.secondaryColor.asColor()!
        buttonPressedColor = model.buttonPressedColor.asColor()!
    }
    
    var body: some View {

        VStack {
            if (model.userHasSetVertical) {
                ZStack(alignment: .leading) {
                    Button(action: {
                        model.showConfigurator = false
                    }) {
                        Image(systemName: "chevron.left")
                        Text("Back".localizedForApp())
                    }
                    
                    Text("Settings".localizedForApp())
                        .font(.system(size: 24))
                        .fontWeight(.semibold)
                    
                        .frame(maxWidth: .infinity)
                }
                .padding([.top, .horizontal], 20)
            } else {
                Text("Welcome to BXIndustry!".localizedForApp())
                    .font(.system(size: 24))
                    .fontWeight(.semibold)
                    .padding(.all, 20)
                Text("To get started, please select a vertical for branding of the app.")
                    .font(.system(size: 14))
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }
        }
        
        Form {
            Section(header: Text("App Vertical Branding".localizedForApp())) {
                ScrollView(.horizontal, showsIndicators: false, content: {
                    HStack(spacing: 12) {
                        ForEach(model.allVerticals.indices, id: \.self) { item in
                            let vertical = model.allVerticals[item]
                            Button(action: {
                                model.updateActiveVertical(vertical: vertical)
                                
                                primaryColor = model.primaryColor.asColor()!
                                secondaryColor = model.secondaryColor.asColor()!
                                buttonPressedColor = model.buttonPressedColor.asColor()!
                                
                                UIApplication.shared.setAlternateIconName("AppIcon-\(vertical)") {
                                    error in
                                    if error != nil {
                                        print("Failed request to update the icon: \(String(describing: error?.localizedDescription))")
                                    }
                                }
                            }, label: {
                                VStack {
                                    Image("AppIcon-\(model.allVerticals[item])-Preview")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(16)
                                    Text(model.allVerticals[item].replacingOccurrences(of: "BX", with: ""))
                                        .font(.system(size: 12))
                                }
                            })
                            .if(vertical == model.activeVertical, if: { button in
                                button.buttonStyle(BorderedButtonStyle())
                            }, else: { button in
                                button.buttonStyle(DefaultButtonStyle())
                            })
                        }
                    }
                })
                Text("Note: Changing the vertical will reset Vertical Colors".localizedForApp())
                    .font(.system(size: 12))
            }
            
            Section(header: Text("Enabled SDKS".localizedForApp())) {
                Toggle("PingOne Protect".localizedForApp(), isOn: $model.enableProtectTab)
                    .onChange(of: model.enableProtectTab) { value in
                        model.updateProtectTab(value: value)
                    }
                Toggle("PingOne Verify".localizedForApp(), isOn: $model.enableVerifyTab)
                    .onChange(of: model.enableVerifyTab) { value in
                        model.updateVerifyTab(value: value)
                    }
                Toggle("PingOne MFA".localizedForApp(), isOn: $model.enablePairingTab)
                    .onChange(of: model.enablePairingTab) { value in
                        model.updatePairingTab(value: value)
                    }
                Toggle("PingOne Credentials".localizedForApp(), isOn: $model.enableWalletTab)
                    .onChange(of: model.enableWalletTab) { value in
                        model.updateWalletTab(value: value)
                    }
            }
            
            Section(header: Text("Header Style Options".localizedForApp())) {

                Toggle("Custom Background Color".localizedForApp(), isOn: $model.hasCustomBackgroundColor)
                    .onChange(of: model.hasCustomBackgroundColor) { value in
                        if value {
                            model.updateCustomBackgroundColor(value: [1.0, 1.0, 1.0, 1.0])
                            bgColor = Color.white
                        } else {
                            model.updateCustomBackgroundColor(value: nil)
                        }
                    }
                
                if model.hasCustomBackgroundColor {
                    ColorPicker("Set Background Color".localizedForApp(), selection: $bgColor, supportsOpacity: false)
                        .onChange(of: bgColor) { color in
                            if color.cgColor != nil {
                                model.updateCustomBackgroundColor(value: color.cgColor!.components)
                            }
                        }
                }
                
                Toggle("Use White Logo".localizedForApp(), isOn: $model.useWhiteLogo)
                    .onChange(of: model.useWhiteLogo) { value in
                        model.updateUseWhiteLogo(value: value)
                    }
            }
            
            Section(header: Text("Vertical Colors".localizedForApp())) {
                ColorPicker("Set Primary Color".localizedForApp(), selection: $primaryColor, supportsOpacity: false)
                    .onChange(of: primaryColor) { color in
                        if color.cgColor?.components != nil {
                            model.updatePrimaryColor(value: color.cgColor!.components!)
                        }
                    }
                // Currently un-used, may need it later though so leaving for now
//                ColorPicker("Set Secondary Color".localizedForApp(), selection: $secondaryColor, supportsOpacity: false)
//                    .onChange(of: secondaryColor) { color in
//                        if color.cgColor?.components != nil {
//                            model.updateSecondaryColor(value: color.cgColor!.components!)
//                        }
//                    }
                ColorPicker("Set Button Pressed Color".localizedForApp(), selection: $buttonPressedColor, supportsOpacity: false)
                    .onChange(of: buttonPressedColor) { color in
                        if color.cgColor?.components != nil {
                            model.updateButtonPressedColor(value: color.cgColor!.components!)
                        }
                    }
            }
            
            Section(header: Text("Tab Names".localizedForApp())) {
                VStack{
                    if (model.enablePairingTab) {
                        Text("Pair Tab Name")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                            .font(.system(size: 12)).padding(.bottom, 0)
                            
                        TextField("Pair Tab".localizedForApp(), text: $model.pairTabName)
                            .onChange(of: model.pairTabName) { newValue in
                                model.updatePairTabName(value: newValue)
                            }
                    }

                    if (model.enableProtectTab) {
                        Text("Protect Tab Name")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                            .padding(.top, 12)
                            
                        TextField("Protect Tab".localizedForApp(), text: $model.protectTabName)
                            .onChange(of: model.protectTabName) { newValue in
                                model.updateProtectTabName(value: newValue)
                            }
                    }
                    
                    if (model.enableVerifyTab) {
                        Text("Verify Tab Name")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                            .padding(.top, 12)
                            
                        TextField("Verify Tab".localizedForApp(), text: $model.verifyTabName)
                            .onChange(of: model.verifyTabName) { newValue in
                                model.updateVerifyTabName(value: newValue)
                            }
                    }
                    
                    if (model.enableWalletTab) {
                        Text("Wallet Tab Name")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                            .padding(.top, 12)
                            
                        TextField("Wallet Tab".localizedForApp(), text: $model.walletTabName)
                            .onChange(of: model.walletTabName) { newValue in
                                model.updateWalletTabName(value: newValue)
                            }
                    }
                }
            }.textFieldStyle(.roundedBorder)
        }
    }
}

#Preview {
    BXIndustryConfiguratorView()
}
