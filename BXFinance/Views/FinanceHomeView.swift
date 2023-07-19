//
//  FinanceHomeView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/13/23.
//

import SwiftUI

struct FinanceHomeView: View {
    
    private let verifyClient: VerifyClient
    
    @ObservedObject private var homeModel: FinanceHomeViewModel
    @ObservedObject private var mainModel: MainViewModel
    
    @State var selectedTab = "home"
    @State var lastActiveTab = "home"
    
    init() {
        mainModel = MainViewModel.shared
        
        let model = FinanceHomeViewModel.shared
        homeModel = model

        verifyClient = VerifyClient(model: model)
    }
    
    var body: some View {
        Group {
            TabView(selection: $selectedTab) {
                VStack {
                    AddDeviceView(issuer: K.issuer, redirectUri: K.redirectUri, clientId: K.clientId)
                        .padding(.top, 36)
                        .padding(.bottom, 12)
                    BXButton(text: "Verify Your Identity".localizedForApp()) {
                        verifyClient.launchVerify()
                    }
                    Spacer()
                }
                .defaultBackground()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag("home")
                
                VStack {
                    Text("Protect data TK")
                }
                .defaultBackground()
                .tabItem {
                    Image(systemName: "lock.shield")
                    Text("Protect")
                }
                .tag("protect")
                
                VStack {
                    Text("Nothing to see here")
                }
                .defaultBackground()
                .tabItem {
                    Image(systemName: "building.columns")
                    Text("Accounts")
                }
                .tag("accounts")
                
                VStack {
                    Text("Nothing to see here")
                }
                .defaultBackground()
                .tabItem {
                    Image(systemName: "creditcard")
                    Text("Loans")
                }
                .tag("loans")
                
                VStack {
                    Text("Nothing to see here")
                }
                .defaultBackground()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Investments")
                }
                .tag("investments")
            }
            .onAppear() {
                UITabBar.appearance().barTintColor = .white
            }
            .accentColor(Color.white)
            .onChange(of: selectedTab) { newValue in
                let activeTabs = ["home"/*, "protect"*/]
                if activeTabs.contains(newValue) {
                    selectedTab = newValue
                    lastActiveTab = newValue
                } else {
                    selectedTab = lastActiveTab
                }
            }
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
    }
}

struct FinanceHomeView_Previews: PreviewProvider {
    static var previews: some View {
        FinanceHomeView()
    }
}
