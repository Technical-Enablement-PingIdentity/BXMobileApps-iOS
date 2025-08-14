//
//  DefaultCredentialPicker.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/4/24.
//

import Foundation
import UIKit
import DIDSDK
import PingOneWallet

public class DefaultCredentialPicker: CredentialPicker {
    
    public let applicationUiCallbackHandler: ApplicationUiCallbackHandler
    
    init(applicationUiCallbackHandler: ApplicationUiCallbackHandler) {
        self.applicationUiCallbackHandler = applicationUiCallbackHandler
    }
    
    public func selectCredentialFor(presentationRequest: PresentationRequest, credentialMatcherResults: [CredentialMatcherResult], onResult: @escaping (_ result: CredentialsPresentation?) -> Void) {
        let listener = DefaultCredentialPickerListener(for: presentationRequest, onEvent: onResult)
        self.selectCredentialToPresent(credentialMatcherResults, index: 0, listener: listener)
    }
    
    private func selectCredentialToPresent(_ credentialMatcherResults: [CredentialMatcherResult], index: Int, listener: CredentialPickerListener) {
        guard (index < credentialMatcherResults.count) else {
            listener.onPickerComplete()
            return
        }
        
        let credentialMatcherResult = credentialMatcherResults[index]
        guard credentialMatcherResult.claims.count > 0 else {
            self.selectCredentialToPresent(credentialMatcherResults, index: index + 1, listener: listener)
            return
        }
        
        //MARK: UI Code
        // Don't want to make CardType selectabled by user
        self.applicationUiCallbackHandler.selectCredentialForPresentation(credentialMatcherResult.claims, requestedKeys: credentialMatcherResult.requestedKeys) { selectedClaim, selectedKeys in
            guard let claim = selectedClaim else {
                listener.onPickerCanceled()
                return
            }
            
            listener.onCredentialPicked(claim, keys: selectedKeys) // Add cardType back in just in case, unsure if this is strictly necessary
            self.selectCredentialToPresent(credentialMatcherResults, index: index + 1, listener: listener)
        }
        
    }
    
}

class DefaultCredentialPickerListener: CredentialPickerListener {
    
    var result: CredentialsPresentation
    var onEvent: ((CredentialsPresentation?) -> Void)
    
    init(for presentationRequest: PresentationRequest, onEvent: @escaping (CredentialsPresentation?) -> Void) {
        self.result = CredentialsPresentation(presentationRequest: presentationRequest)
        self.onEvent = onEvent
    }
    
    func onCredentialPicked(_ claim: Claim, keys: [String]) {
        self.result.addClaimForKeys(claim, keys: keys)
    }
    
    func onPickerComplete() {
        self.onEvent(self.result)
    }
    
    func onPickerCanceled() {
        self.onEvent(nil)
    }
    
}
