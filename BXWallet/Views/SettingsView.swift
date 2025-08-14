//
//  SettingsView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 8/12/25.
//

import SwiftUI

struct SettingsView: View {
    
    let closeTapped: () -> Void
    
    private let width = UIScreen.main.bounds.width - 50
    
    @State private var primaryColor: Color = .bxPrimary
    
    @Environment(\.colorScheme) private var colorScheme
    
    @EnvironmentObject var walletAppModel: WalletAppViewModel
    
    var body: some View {
        HStack {
            ZStack{
                Rectangle()
                    .fill(.white)
                    .frame(width: width)
                    .shadow(color: .purple.opacity(0.1), radius: 5, x: 0, y: 3)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("app_settings")
                            .font(.title)
                        Spacer()
                        Button {
                            closeTapped()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .tint(colorScheme == .light ? .black : .white)
                        }
                        .padding(.top, 6)
                        .padding(.trailing, 4)
                    }
                    .padding(.top, 70)
                    .padding(.bottom)
                    
                    Text("settings.logo_url")
                        .bold()
                        .padding(.top)
                    TextField("settings.placeholder_url", text: $walletAppModel.appLogoUrl)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .onChange(of: walletAppModel.appLogoUrl) { _, newValue in
                            walletAppModel.updateAppLogoUrl(url: newValue)
                        }
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(.secondary.opacity(0.5), lineWidth: 1)
                        )
                    Text("settings.logo_url.note")
                        .font(.system(size: 10))
                        .padding(.bottom)
                    
                    
                    ColorPicker(selection: $walletAppModel.primaryColor, supportsOpacity: false) {
                        Text("settings.primary_color")
                            .bold()
                    }
                    .onChange(of: walletAppModel.primaryColor) { _, newValue in
                        walletAppModel.updatePrimaryColor(color: newValue)
                    }
                    
                    Text("settings.description_key")
                        .bold()
                        .padding(.top)
                    TextField("settings.placeholder_key", text: $walletAppModel.credentialDescriptionKey)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .onChange(of: walletAppModel.credentialDescriptionKey) { _, newValue in
                            walletAppModel.updateCredentialDescriptionKey(key: newValue)
                        }
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(.secondary.opacity(0.5), lineWidth: 1)
                        )
                    Text("settings.issue_date_key")
                        .bold()
                        .padding(.top)
                    TextField("settings.placeholder_key", text: $walletAppModel.credentialIssueDateKey)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .onChange(of: walletAppModel.credentialIssueDateKey) { _, newValue in
                            walletAppModel.updateCredentialIssueDateKey(key: newValue)
                        }
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(.secondary.opacity(0.5), lineWidth: 1)
                        )
                    Spacer()
                }
                .padding(.horizontal)
                .frame(width: width)
                .background(.cardBackground)
            }
            
            Spacer()
        }
        .background(.clear)
    }
}

#Preview {
    @Previewable @State var update: Bool = false
    SettingsView {
        print("tapped")
    }
}
