//
//  VerifyView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/13/24.
//

import SwiftUI

struct VerifyView: View {
    
    @State var verifiedScale = 0.0
    
    @EnvironmentObject var globalModel: GlobalViewModel
    
    func submissionComplete(verifyResult: String) {
        globalModel.showToast(style: .success, message: verifyResult)
        verifiedScale = 1.0
    }
    
    func submissionError(error: String) {
        globalModel.showToast(style: .error, message: error)
    }
    
    var body: some View {
        VStack {
            Text("To verify your identity for a shine rewards card please have your ID or Passport ready and scan the QR code displayed on your application through the BXFinance website.")
                .font(.system(size: 14))
            Spacer()

            VStack {
                Spacer()
                Image(systemName: "person.crop.circle.badge.checkmark")
                    .font(.system(size: 150))
                    .foregroundStyle(Color(K.Colors.Primary))
                Text("You've successfully verified your identity")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(K.Colors.Primary))
                Spacer()
            }
            .scaleEffect(verifiedScale)
            .animation(.easeInOut(duration: 1), value: verifiedScale)

            Button("Verify Identity") {
                let verifyClient = VerifyClient(submissionCompleteCallback: submissionComplete, submissionErrorCallback: submissionError)
                
                verifyClient.launchVerify()
            }
            .buttonStyle(FinanceFullWidthButtonStyle())
        }
        .padding()
    }
}

#Preview {
    VerifyView()
        .environmentObject(GlobalViewModel.preview)
}
