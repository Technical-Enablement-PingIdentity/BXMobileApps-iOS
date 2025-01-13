//
//  Untitled.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/25/24.
//

import SwiftUI

struct FinanceButtonStyle: ButtonStyle {
    
    let backgroundColor: Color
    
    init(backgroundColor: Color? = nil) {
        if let backgroundColor {
            self.backgroundColor = backgroundColor
        } else {
            self.backgroundColor = Color(K.Colors.Primary)
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 10)
            .padding(.horizontal, 24)
            .background(self.backgroundColor)
            .foregroundStyle(.white)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct FinanceFullWidthButtonStyle: ButtonStyle {
    let backgroundColor: Color
    
    init(backgroundColor: Color? = nil) {
        if let backgroundColor {
            self.backgroundColor = backgroundColor
        } else {
            self.backgroundColor = Color(K.Colors.Primary)
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(self.backgroundColor)
            .foregroundStyle(.white)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
