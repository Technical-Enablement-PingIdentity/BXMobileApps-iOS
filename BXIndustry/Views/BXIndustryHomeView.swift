//
//  BXIndustryHomeView.swift
//  BXIndustry
//
//  Created by Eric Anderson on 9/12/24.
//

import SwiftUI

struct BXIndustryHomeView: View {
    @ObservedObject private var model: BXIndustryMainViewModel
    
    @State var selectedTab = "home"
    @State var lastActiveTab = "home"
    
    @State var updateView = false
    
    init() {
        model = BXIndustryMainViewModel.shared
    }

    var body: some View {
        Group {
            TabView(selection: $selectedTab) {
                if model.enablePairingTab {
                    VStack {
                        AddDeviceView(issuer: "https://auth.pingone.com/b7848c51-0711-4f1e-891a-dd8c0b75ceeb/as", redirectUri: "pingonesdk://sample", clientId: "ef97bc28-37b5-4829-b2ce-5601f8768932")
                    }
                    .tabItem {
                        Image(systemName: "house")
                        Text(model.pairTabName)
                    }
                    .tag("home")
                }
                
                if model.enableVerifyTab {
                    VStack {
                        BXButton(text: "Verify Identity") {
                            // TODO
                            print("Todo")
                        }
                    }
                    .tabItem {
                        Image(systemName: "person.badge.shield.checkmark.fill")
                        Text(model.verifyTabName)
                    }
                    .tag("verify")
                }

                if model.enableProtectTab {
                    VStack {
                        PingOneProtectView(apiBaseUrl: "") // TODO
                    }
                    .tabItem {
                        Image(systemName: "lock.shield")
                        Text(model.protectTabName)
                    }
                    .tag("protect")
                }
                
                if model.enableWalletTab {
                    VStack {
                        Text("TK")
                    }
                    .tabItem {
                        Image(systemName: "wallet.pass.fill")
                        Text(model.walletTabName)
                    }
                    .tag("wallet")
                }

                VStack { /* Intentionally empty, launches ConfiguratorView in popover*/ }
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag("settings")
            }
            .onChange(of: selectedTab) { newValue in
                if newValue == "settings" {
                    model.showConfigurator = true
                    selectedTab = lastActiveTab
                } else {
                    selectedTab = newValue
                    lastActiveTab = newValue
                }
            }
            .accentColor(Color.primaryColor)
        }
        .popover(isPresented: $model.showConfigurator) {
            BXIndustryConfiguratorView()
        }
        .onAppear {
            if !model.userHasSetVertical {
                model.showConfigurator = true
            }
        }
        /* Hack to force view to update, otherwise some of the colors will be stuck */
        .onChange(of: model.showConfigurator) { newValue in
            if (!newValue) {
                updateView.toggle()
            }
        }
        .id(updateView)
        /* End Hack */
    }
}

#Preview {
    BXIndustryHomeView()
}
