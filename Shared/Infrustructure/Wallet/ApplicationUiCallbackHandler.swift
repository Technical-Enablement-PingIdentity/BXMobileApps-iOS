//
//  ApplicationCallbackHandler.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/2/24.
//

import Foundation
import UIKit
import DIDSDK

public protocol ApplicationUiCallbackHandler {
    
    func showConfirmationAlert(title: String, message: String, positiveActionTitle: String, cancelActionTitle: String, actionHandler: @escaping (Bool) -> Void)
    func showErrorAlert(title: String, message: String, actionTitle: String?, actionHandler: (() -> Void)?)
    func selectCredentialForPresentation(_ credentials: [Claim], requestedKeys: [String], onItemPicked: @escaping ((Claim?,[String]) -> Void))
    func openUrl(url: String, onComplete: @escaping (Bool, String) -> Void)
    
}
