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
    
    init() {
        mainModel = MainViewModel.shared
        
        let model = FinanceHomeViewModel.shared
        homeModel = model

        verifyClient = VerifyClient(model: model)
    }
    
    var body: some View {
        Group {
            TabView {
                VStack {
                    AddDeviceView(issuer: K.issuer, redirectUri: K.redirectUri, clientId: K.clientId)
                        .padding(.top, 36)
                        .padding(.bottom, 12)
                    BXButton(text: "Verify Your Identity".localizedForApp()) {
                        verifyClient.launchVerify()
                    }
                    Spacer()
                }
                .background(TabViewTransparentBackground())
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                
                VStack {
                    Text("Protect data TK")
                }
                .background(TabViewTransparentBackground())
                .tabItem {
                    Image(systemName: "lock.shield")
                    Text("Protect")
                }
                
                VStack {
                    Text("Nothing to see here")
                }
                .background(TabViewTransparentBackground())
                .tabItem {
                    Image(systemName: "building.columns")
                    Text("Accounts")
                }
                
                VStack {
                    Text("Nothing to see here")
                }
                .background(TabViewTransparentBackground())
                .tabItem {
                    Image(systemName: "creditcard")
                    Text("Loans")
                }
                
                VStack {
                    Text("Nothing to see here")
                }
                .background(TabViewTransparentBackground())
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Investments")
                }
            }
            .onAppear() {
                UITabBar.appearance().barTintColor = .white
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
    }
}

struct FinanceHomeView_Previews: PreviewProvider {
    static var previews: some View {
        FinanceHomeView()
    }
}
