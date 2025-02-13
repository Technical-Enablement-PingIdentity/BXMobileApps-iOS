//
//  FormFieldLabel.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/29/24.
//

import SwiftUI

struct FormFieldLabelView : View {
    
    @Environment(\.colorScheme) var colorScheme
    
    private let label: LocalizedStringKey
    
    init(_ label: LocalizedStringKey) {
        self.label = label
    }
    
    var body: some View {
        Text(label)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(colorScheme == .dark ? .white : .black)
            .font(.system(size: 14))
            .fontWeight(.semibold)
            .textCase(nil)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    FormFieldLabelView("Label")
}
