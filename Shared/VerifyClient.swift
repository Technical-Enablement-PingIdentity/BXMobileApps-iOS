//
//  VerifyClient.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/13/23.
//

import SwiftUI
import PingOneVerify

class VerifyClient {
    private var model: VerifyViewModel
    
    init(model: VerifyViewModel) {
        self.model = model
    }
    
    func launchVerify() {
        guard let rootViewController = UIUtilities.getRootViewController() else {
            print("rootViewController was null, cannot launch verify")
            return
        }
        
        let appearanceSettings = UIAppearanceSettings()
            .setBodyTextColor(.white)
            .setHeadingTextColor(.white)
        
        PingOneVerifyClient.Builder(isOverridingAssets: false)
            .setListener(self)
            .setRootViewController(rootViewController)
            .setUIAppearance(appearanceSettings)
            .startVerification { pingOneVerifyClient, clientBuilderError in
                if let clientBuilderError {
                    logerror(clientBuilderError.localizedDescription ?? "Unknown error occurred")
                    self.model.displayClientBuilderErrorAlert = true
                    self.model.clientBuilderErrorDescription = clientBuilderError.localizedDescription
                }
            }
    }
}

extension VerifyClient: DocumentSubmissionListener {
    func onDocumentSubmitted(response: DocumentSubmissionResponse) {
        print("The document status is \(String(describing: response.documentStatus))")
        print("The document submission status is \(String(describing: response.documentSubmissionStatus))")
        
        guard let documents = response.document else { return }
        for (key, value) in documents {
            print("\(key): \(value)")
        }
        
        if let verifiedFirstName = documents["firstName"],
           let verifiedLastName = documents["lastName"] {
            DispatchQueue.main.async {
                self.model.documentSubmissionNameResult = "\(verifiedFirstName.capitalized) \(verifiedLastName.capitalized)"
            }
        }
    }
    
    func onSubmissionComplete(status: DocumentSubmissionStatus) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // need to wait for verify to close
            self.model.displayDocumentSubmissionSuccessfulAlert = true
        }
    }
    
    func onSubmissionError(error: DocumentSubmissionError) {
        print(error.localizedDescription ?? "Unknown submission error occurred")
    }
}
