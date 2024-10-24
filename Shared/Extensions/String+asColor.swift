//
//  String+asColor.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 9/17/24.
//

import SwiftUI

extension String {
    func asColorArray() -> [CGFloat]? {
        var cString = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return [
            CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            CGFloat(rgbValue & 0x0000FF) / 255.0,
            CGFloat(1.0)
        ]
    }

}
