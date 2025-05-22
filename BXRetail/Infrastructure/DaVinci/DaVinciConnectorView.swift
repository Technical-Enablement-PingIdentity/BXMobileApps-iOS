//
//  DaVinciConnectorView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 5/19/25.
//

import SwiftUI
import PingOrchestrate
import PingDavinci

struct DaVinciConnectorView: View {
    let daVinciClient: DaVinci
    /// View model for managing field validation across the form
    @StateObject var validationViewModel: DaVinciValidationViewModel  = DaVinciValidationViewModel()
    /// The Davinci view model managing the flow.
    @ObservedObject var daVinciViewModel: DaVinciViewModel
    /// The next node to process in the flow.
    public var node: ContinueNode
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            /// App logo displayed at the top of the view
            LogoView(assetName: colorScheme == .light ? K.Assets.Logo : K.Assets.LogoWhite)
            
            /// The main node view that handles user interactions with the current flow step
            DaVinciContinueNodeView(continueNode: node,
                             onNodeUpdated:  { daVinciViewModel.refresh() },
                             onStart: { Task { await daVinciViewModel.startDaVinci(daVinciClient: daVinciClient) }},
                             onNext: { isSubmit in Task {
                /// Determines if validation should occur based on the submission state and node configuration
                validationViewModel.shouldValidate = isSubmit && daVinciViewModel.shouldValidate(node: node)
                if !validationViewModel.shouldValidate {
                    await daVinciViewModel.next(node: node)
                }
            }})
            .environmentObject(validationViewModel)
        }
    }
}
