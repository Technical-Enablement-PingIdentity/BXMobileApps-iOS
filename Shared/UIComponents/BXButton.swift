//
//  BXButton.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/12/23.
//

import SwiftUI

struct BXButton: View {
    let text: String
    let action: () -> Void
    let width: CGFloat?
    
    init(text: String, action: @escaping () -> Void, width: CGFloat? = 210) {
        self.text = text
        self.action = action
        self.width = width
    }
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .frame(width: width)
        }
        .buttonStyle(BXButtonStyle())
            
    }
}

public struct BXButtonStyle: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .font(Font.body.bold())
            .background(configuration.isPressed ? Color.buttonPressedColor : Color.primaryColor)
    }
}

struct BXButton_Previews: PreviewProvider {
    static var previews: some View {
        BXButton(text: "Test Button") {
            () in
            print("Pressed")
        }
    }
}
