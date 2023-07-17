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
    
    init() {
        let model = FinanceHomeViewModel.shared
        homeModel = model
        verifyClient = VerifyClient(model: model)
    }
    
    var body: some View {
        Group {
            AddDeviceView(issuer: K.issuer, redirectUri: K.redirectUri, clientId: K.clientId)
                .padding(.top, 36)
                .padding(.bottom, 12)
            BXButton(text: "Verify Your Identity".localizedForApp()) {
                verifyClient.launchVerify()
            }
            Spacer()
            HomeActionsView()
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
