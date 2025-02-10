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
            ToastPresenter.show(style: .error, toast: String(localized: "verify.invalid_url"))
        } else {
            ToastPresenter.show(style: .error, toast: error)
        }
        
    }
    
    var body: some View {
        VStack {
            Text(LocalizedStringKey("verify.message"))
                .font(.system(size: 14))
            Spacer()

            VStack {
                Spacer()
                Image(systemName: "person.crop.circle.badge.checkmark")
                    .font(.system(size: 150))
                    .foregroundStyle(Color(K.Colors.Primary))
                Text(LocalizedStringKey("verify.success"))
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(K.Colors.Primary))
                Spacer()
            }
            .scaleEffect(verifiedScale)
            .animation(.easeInOut(duration: 1), value: verifiedScale)

            Button(LocalizedStringKey("verify.identity")) {
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
