//
//  DaVinciErrorView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 5/19/25.
//

import SwiftUI
import PingDavinci
import PingOrchestrate

/// A view for displaying error messages.
/// - Provides a consistent UI for error presentation across the application.
struct DaVinciErrorView: View {
    /// The error message to display to the user.
    let message: String
    
    var body: some View {
        HStack {
            /// Warning triangle icon to visually indicate an error
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(Color.red)
                .padding(.trailing, 8)
            /// The error message text
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .foregroundStyle(Color.red)
            Spacer()
        }
        .padding()
//        .background(
//            /// Rounded background with subtle shadow for visual emphasis
//            RoundedRectangle(cornerRadius: 8)
//                .fill(Color(.systemBackground))
//                .shadow(color: .gray, radius: 1, x: 0, y: 1)
//        )
//        .padding(.horizontal, 16)
    }
}
