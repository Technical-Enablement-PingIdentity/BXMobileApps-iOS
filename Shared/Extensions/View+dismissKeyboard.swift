//
//  View+dismissKeyboard.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/25/23.
//

import SwiftUI

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
