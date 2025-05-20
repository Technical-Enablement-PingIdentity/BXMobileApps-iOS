//
//  DaVinciErrorNodeView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 5/19/25.
//

import SwiftUI
import PingOrchestrate

/// A view for displaying detailed error information from an ErrorNode.
/// - Provides both a summary view and detailed information via an alert.
struct DaVinciErrorNodeView: View {
    /// The error node containing detailed error information.
    let node: ErrorNode
    /// State to control whether detailed error information is shown.
    @State private var showDetails: Bool = false
    
    /// Formats the error details for display in the alert.
    /// - Extracts error messages and inner error details from the node.
    private var errorText: String {
        var error = ""
        
        for detail in node.details {
            if let details = detail.rawResponse.details {
                for detail in details {
                    error += "\(String(describing: detail.message))\n\n"
                    
                    if let innerError = detail.innerError {
                        for (key, value) in innerError.errors {
                            error += "\(key): \(value)\n\n"
                        }
                    }
                }
                
            }
        }
        
        return error
    }
    
    var body: some View {
        /// Uses the standard ErrorView for consistent UI presentation
        DaVinciErrorView(message: node.message)
            .onTapGesture {
                /// Shows detailed error information when tapped
                showDetails = true
            }
            .alert("Error Details", isPresented: $showDetails) {
                Button("OK") {
                    showDetails = false
                }
            } message: {
                Text(errorText)
            }
    }
}
