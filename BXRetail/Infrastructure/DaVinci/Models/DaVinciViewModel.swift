//
//  DaVinciViewModel.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 5/19/25.
//

import Foundation
import PingDavinci
import PingOidc
import PingOrchestrate
import PingExternal_idp

/// A view model that manages the flow and state of the DaVinci orchestration process.
/// - Responsible for:
///   - Starting the DaVinci flow
///   - Progressing to the next node in the flow
///   - Maintaining the current and previous flow state
///   - Handling loading states
@MainActor
class DaVinciViewModel: ObservableObject {
    /// Published property that holds the current state node data.
    @Published public var state: DaVinciState = DaVinciState()
    /// Published property to track whether the view is currently loading.
    @Published public var isLoading: Bool = false
    
    /// Starts the DaVinci orchestration process.
    /// - Sets the initial node and updates the `data` property with the starting node.
    public func startDaVinci(daVinciClient: DaVinci) async {
        await MainActor.run {
            isLoading = true
        }
        
        // Starts the DaVinci orchestration process and retrieves the first node.
        let next = await daVinciClient.start()
        
        await MainActor.run {
            self.state = DaVinciState(previous: next , node: next)
            isLoading = false
        }
    }
    
    /// Advances to the next node in the orchestration process.
    /// - Parameter node: The current node to progress from.
    public func next(node: Node) async {
        await MainActor.run {
            isLoading = true
        }
        if let current = node as? ContinueNode {
            // Retrieves the next node in the flow.
            let next = await current.next()
            await MainActor.run {
                self.state = DaVinciState(previous: current, node: next)
                isLoading = false
            }
        }
    }
    
    /// Determines if field validation should be performed before advancing to the next node.
    /// - Parameter node: The current node being processed.
    /// - Returns: A boolean indicating whether validation should be performed.
    public func shouldValidate(node: ContinueNode) -> Bool {
        var shouldValidate = false
        for collector in node.collectors {
            // Check if the collector is a social collector and if it has a resume request.
            // In that case, we should not validate the collectors and continue with the submission of the flow.
            if let socialCollector = collector as? IdpCollector {
                if socialCollector.resumeRequest != nil {
                    shouldValidate = false
                    return shouldValidate
                }
            }
            if let collector = collector as? ValidatedCollector {
                if collector.validate().count > 0 {
                    shouldValidate = true
                }
            }
        }
        return shouldValidate
    }
    
    /// Refreshes the current state to trigger UI updates.
    /// - This function maintains the same nodes but updates the state object to force view refreshes.
    public func refresh() {
        state = DaVinciState(previous: state.previous, node: state.node)
    }
}

/// A model class that represents the state of the current and previous nodes in the DaVinci flow.
class DaVinciState {
    /// The previous node in the flow, which may be used for navigation or recovery from errors.
    var previous: Node? = nil
    /// The current active node in the flow.
    var node: Node? = nil
    
    /// Initializes a new DavinciState with optional previous and current nodes.
    /// - Parameters:
    ///   - previous: The previous node in the flow, if any.
    ///   - node: The current node in the flow, if any.
    init(previous: Node?  = nil, node: Node? = nil) {
        self.previous = previous
        self.node = node
    }
}
