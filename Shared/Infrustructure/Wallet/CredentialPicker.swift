//
//  CredentialPicker.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/2/24.
//

import Foundation
import DIDSDK
import PingOneWallet

public protocol CredentialPicker {
    
    func selectCredentialFor(presentationRequest: PresentationRequest, credentialMatcherResults: [CredentialMatcherResult], onResult: @escaping (_ result: CredentialsPresentation?) -> Void)
    
}

public protocol CredentialPickerListener {
    
    func onCredentialPicked(_ claim: Claim, keys: [String])
    func onPickerComplete()
    func onPickerCanceled()
    
}
