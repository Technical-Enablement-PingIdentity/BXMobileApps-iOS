//
//  AppDelegate+Firebase.swift
//  BXHealth
//
//  Created by Eric Anderson on 3/4/25.
//

import SwiftUI
import Firebase

extension AppDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
    
}
