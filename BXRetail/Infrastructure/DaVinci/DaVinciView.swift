//
//  DaVinciView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 5/19/25.
//

import Foundation
import SwiftUI
import PingOrchestrate
import PingDavinci

/// The main view for orchestrating the Davinci flow.
struct DaVinciView: View {
    
    let daVinciClient: DaVinci
    
    let successCallback: () -> Void
    
    /// The view model that manages the Davinci flow logic.
    @StateObject private var daVinciViewModel = DaVinciViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Spacer()
                    // Handle different types of nodes in the flow.
                    switch daVinciViewModel.state.node {
                    case let continueNode as ContinueNode:
                        // Display the connector view for the next node.
                        DaVinciConnectorView(daVinciClient: daVinciClient, daVinciViewModel: daVinciViewModel, node: continueNode)
                    case is SuccessNode:
                        ProgressView()
                        .onAppear {
                            successCallback()
                        }
                    case let failureNode as FailureNode:
                        let apiError = failureNode.cause as? ApiError
                        switch apiError {
                        case .error(_, _, let message):
                            // Show error message from the API.
                            DaVinciErrorView(message: message)
                        default:
                            // Show a default error message.
                            DaVinciErrorView(message: "unknown error")
                        }
                        // Handle failure node scenarios.
                        if let nextNode = daVinciViewModel.state.previous as? ContinueNode {
                            DaVinciConnectorView(daVinciClient: daVinciClient, daVinciViewModel: daVinciViewModel, node: nextNode)
                        }
                    case let errorNode as ErrorNode:
                        /// Displays the error node view with detailed error information
                        DaVinciErrorNodeView(node: errorNode)
                        
                        // TODO - It would be ideal to do allow users to view previous node and re-submit but unfortunately the SDK doesn't currently allow for that
                        
                        /// Provides a way to return to the previous valid node if available
                        if let nextNode = daVinciViewModel.state.previous as? ContinueNode {
                            DaVinciConnectorView(daVinciClient: daVinciClient, daVinciViewModel: daVinciViewModel, node: nextNode)
                        }
                    default:
                        // Show an empty view for unhandled cases.
                        EmptyView()
                    }
                }
            }
            
            Spacer()
            
            // Show an activity indicator when loading.
            if daVinciViewModel.isLoading {
                /// Semi-transparent overlay to indicate loading state
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                /// Circular progress indicator that provides visual feedback during loading operations
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .tint(Color(K.Colors.Primary))
            }
        }
        .onAppear {
            Task {
                await daVinciViewModel.startDaVinci(daVinciClient: daVinciClient)
            }
        }
    }
}
