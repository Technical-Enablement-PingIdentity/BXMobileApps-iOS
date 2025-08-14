//
//  CredentialCardView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 8/11/25.
//

import SwiftUI

struct CredentialCardView: View {
    let name: String
    let attributes: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.title3)
                .bold()
                .foregroundColor(.bxPrimary)
                .padding(.bottom, 4)
            ForEach(attributes, id: \.self) {
                Text($0)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.cardBackground)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
        )
    }
}
