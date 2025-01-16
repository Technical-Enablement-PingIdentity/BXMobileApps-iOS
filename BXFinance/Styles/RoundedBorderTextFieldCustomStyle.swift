//
//  TextFieldStyle.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/29/24.
//

import SwiftUI

struct RoundedBorderTextFieldCustomStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .textFieldStyle(.plain)
            .padding(8)
            .background(.clear)
            .overlay {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 1)
            }
    }
}
