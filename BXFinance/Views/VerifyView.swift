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
        ToastPresenter.show(style: .success, toast: verifyResult)
        verifiedScale = 1.0
    }
    
    func submissionError(error: String) {
        if error.contains("Invalid URL") {
            ToastPresenter.show(style: .error, toast: "Invalid URL for ID Verification, please ensure you aren't scanning a QR code meant for wallet pairing or credential verification")
        } else {
            ToastPresenter.show(style: .error, toast: error)
        }
        
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

#if DEBUG
struct VerifyView_Previews: PreviewProvider {
    static var previews: some View {
        VerifyView()
            .environmentObject(GlobalViewModel.preview)
    }
}
#endif
