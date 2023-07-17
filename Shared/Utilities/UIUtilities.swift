//
//  UIUtilities.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/17/23.
//

import SwiftUI

struct UIUtilities {
    static func getRootViewController() -> UIViewController? {
        // Grabbing the root view controller when using SwiftUI seems to be a bit of a moving target. Apple likes to deprecate things in the UIApplication.shared class
        let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        
        guard let rootViewController = scene?.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            print("Could not find root view controller, unable to launch PingOne Verify")
            return nil
        }
        
        return rootViewController
    }
}
