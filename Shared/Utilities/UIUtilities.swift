//
//  UIUtilities.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/13/24.
//

import SwiftUI

struct UIUtilities {
    static func getKeyWindow() -> UIWindow? {
        let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        
        guard let window = scene?.windows.first(where: { $0.isKeyWindow }) else {
            print("Could not find key window")
            return nil
        }
        
        return window
    }
    
    static func getRootViewController() -> UIViewController? {
        guard let rootViewController = UIUtilities.getKeyWindow()?.rootViewController else {
            print("Could not find root view controller")
            return nil
        }
        
        return rootViewController
    }
}
