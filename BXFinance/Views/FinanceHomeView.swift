//
//  FinanceHomeView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/13/23.
//

import SwiftUI
import PingOneSignals

struct FinanceHomeView: View {
    
    private let verifyClient: VerifyClient
    
    @ObservedObject private var homeModel: FinanceHomeViewModel
    
    init() {
        let model = FinanceHomeViewModel.shared
        homeModel = model

        verifyClient = VerifyClient(model: model)
        
        initPingOneSignalsSdk()
    }
    
    var body: some View {
        Group {
            TabView(selection: $homeModel.selectedTab) {
                VStack {
                    AddDeviceView(issuer: K.issuer, redirectUri: K.redirectUri, clientId: K.clientId)
                }
                .colorBackground(color: Color.secondaryColor)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag("home")
                
                VStack {
                    BXButton(text: "Verify Your Identity".localizedForApp()) {
                        verifyClient.launchVerify()
                    }
                }
                .colorBackground(color: Color.secondaryColor)
                .tabItem {
                    Image(systemName: "person.badge.shield.checkmark.fill")
                    Text("Verify")
                }
                .tag("verify")
                
                VStack {
                    WalletView()
                }
                .colorBackground(color: Color.secondaryColor)
                .tabItem {
                    Image(systemName: "wallet.bifold.fill")
                    Text("Wallet")
                }
                .tag("wallet")
                
                VStack {
                    PingOneProtectView(apiBaseUrl: K.apiBaseUrl)
                }
                .colorBackground(color: Color.secondaryColor)
                .tabItem {
                    Image(systemName: "lock.shield")
                    Text("Protect")
                }
                .tag("protect")
                
                VStack {
                    Text("Nothing to see here")
                }
                .colorBackground(color: Color.secondaryColor)
                .tabItem {
                    Image(systemName: "building.columns")
                    Text("Accounts")
                }
                .tag("accounts")
            }
            .onAppear() {
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.backgroundColor = UIColor(.secondaryColor)
                
                UITabBar.appearance().standardAppearance = tabBarAppearance
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
            .accentColor(Color.white)
        }
        .alert("Client Builder Error".localizedForApp(), isPresented: $homeModel.displayClientBuilderErrorAlert, actions: {
            Button("Okay") {
                homeModel.displayClientBuilderErrorAlert = false
            }
        }, message: {
            Text(homeModel.clientBuilderErrorDescription ?? "An unknown error occurred building verify client")
        })
        .alert("Document Submission Complete".localizedForApp(), isPresented: $homeModel.displayDocumentSubmissionSuccessfulAlert, actions: {
            Button("Okay") {
                homeModel.displayClientBuilderErrorAlert = false
            }
        }, message: {
            Text("All documents\(self.homeModel.documentSubmissionNameResult != nil ? " for " + self.homeModel.documentSubmissionNameResult! : "") have been submitted and verification has successfully completed.")
        })
        .onChange(of: homeModel.selectedTab) { newValue in
            homeModel.switchToTab(newValue)
        }
    }
}

struct FinanceHomeView_Previews: PreviewProvider {
    static var previews: some View {
        FinanceHomeView()
    }
}

extension FinanceHomeView {
    func initPingOneSignalsSdk() {
        let initParams = POInitParams()
        initParams.envId = K.pingOneEnvId
        
        let pingOneSignals = PingOneSignals.initSDK(initParams: initParams)
        
        pingOneSignals.setInitCallback { error in
            if let error {
                self.homeModel.signalsStatus = "Initialization Failed"
                print("PingOne Signals init failed: \(error.localizedDescription)")
            } else {
                self.homeModel.signalsStatus = "Initialized successfully"
                print("PingOne Signals initialized!")
            }
        }
    }
}
