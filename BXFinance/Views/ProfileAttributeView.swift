//
//  ProfileAttributeView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/12/24.
//

import SwiftUI

public struct ProfileAttributeView: View {
    
    let label: LocalizedStringKey
    let value: String
    let valueSizeOverride: CGFloat
    
    init(label: LocalizedStringKey, value: String, valueSizeOverride: CGFloat = 28) {
        self.label = label
        self.value = value
        self.valueSizeOverride = valueSizeOverride
    }
    
    public var body: some View {
        Text(label)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        Text(value)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: valueSizeOverride))
            .padding(.bottom, 20)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ProfileAttributeView(label: "First Name", value: "Eric")
}
