//
//  Color.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/12/23.
//

import SwiftUI

extension Color {
    static var primaryColor: Color {
        if let overrideColor = UserDefaults.standard.object(forKey: SharedConstants.primaryColorOverrideKey) as? [CGFloat] {
            return overrideColor.asColor() ?? Color("PrimaryColor")
        }
        
        return Color("PrimaryColor")
    }
    
    static var secondaryColor: Color {
        if let overrideColor = UserDefaults.standard.object(forKey: SharedConstants.secondaryColorOverrideKey) as? [CGFloat] {
            return overrideColor.asColor() ?? Color("SecondaryColor")
        }
        
        return Color("SecondaryColor")
    }
    
    static var buttonPressedColor: Color {
        if let overrideColor = UserDefaults.standard.object(forKey: SharedConstants.buttonPressedColorOverrideKey) as? [CGFloat] {
            return overrideColor.asColor() ?? Color("ButtonPressedColor")
        }
        
        return Color("ButtonPressedColor")
    }
}
