//
//  Color.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 8/12/25.
//

import SwiftUI

extension Color {
   
    public static var bxPrimary: Color {
        do {
            if let stored = UserDefaults.standard.data(forKey: K.AppStorage.PrimaryColor) {
                if let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: stored) {
                    return Color(color)
                }
            }
        } catch {}
        
        return .accent
    }
    

}

