//
//  Array+asColor.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 9/16/24.
//

import SwiftUI

extension Array where Element == CGFloat {
    func asColor() -> Color? {
        if self.count < 4 {
            return nil
        } else {
            return Color(.sRGB, red: self[0], green: self[1], blue: self[2], opacity: self[3])
        }
    }
}
