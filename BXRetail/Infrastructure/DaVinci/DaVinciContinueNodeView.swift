//
//  DaVinciContinueNodeView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 5/19/25.
//

import SwiftUI
import PingOrchestrate
import PingDavinci
import PingExternal_idp

/// A view for displaying and handling user interaction with a continue node in the authentication flow.
/// - This view renders different collectors based on their type and handles user input and validation.
struct DaVinciContinueNodeView: View {
    /// The continue node containing collectors and flow information.
    var continueNode: ContinueNode
    /// Callback for when a node is updated through user interaction.
    let onNodeUpdated: () -> Void
    /// Callback for when the flow should be started/restarted.
    let onStart: () -> Void
    /// Callback for when the user proceeds to the next step, with a flag indicating if this is a submission.
    let onNext: (Bool) -> Void
    
    /// The validation view model shared across collectors to manage form validation state.
    @EnvironmentObject var validationViewModel: DaVinciValidationViewModel
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var orderedCollectors: [any Collector] {
        get {
            switch continueNode.name {
            case "Sign On":
                return [
                    continueNode.collectors.first(where: {$0.id == "user.email"})!,
                    continueNode.collectors.first(where: {$0.id == "user.password"})!,
                    continueNode.collectors.first(where: {$0.id == "submit"})!,
                    continueNode.collectors.first(where: {$0.id == "link-register"})!,
                    continueNode.collectors.first(where: {$0.id == "link-password-reset"})!
                ]
            case "Create Profile":
                return [
                    continueNode.collectors.first(where: {$0.id == "user.email"})!,
                    continueNode.collectors.first(where: {$0.id == "user.password"})!,
                    continueNode.collectors.first(where: {$0.id == "submit"})!,
                    continueNode.collectors.first(where: {$0.id == "link-cancel"})!
                ]
            case "Recovery Email":
                return [
                    continueNode.collectors.first(where: {$0.id == "user.email"})!,
                    continueNode.collectors.first(where: {$0.id == "submit"})!,
                    continueNode.collectors.first(where: {$0.id == "link-back"})!,
                ]
            case "Forgot Password":
                return [
                    continueNode.collectors.first(where: {$0.id == "recovery-code-field"})!,
                    continueNode.collectors.first(where: {$0.id == "user.newPassword"})!,
                    continueNode.collectors.first(where: {$0.id == "submit"})!,
                    continueNode.collectors.first(where: {$0.id == "link-resend"})!,
                    continueNode.collectors.first(where: {$0.id == "link-cancel"})!,
                ]
            case "Verification Code":
                return [
                    continueNode.collectors.first(where: {$0.id == "verificaiton-code-field"})!,
                    continueNode.collectors.first(where: {$0.id == "submit"})!,
                    continueNode.collectors.first(where: {$0.id == "link-resend"})!,
                ]
            default:
                return continueNode.collectors
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            /// Title display showing the node name
            Text(continueNode.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(colorScheme == .light ? .black : .white)
            /// Description text providing context about the current step
            Text(continueNode.description)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(colorScheme == .light ? .black : .white)
                .padding(.bottom, 8)
            
            Divider()
                .padding(.bottom, 8)
            
            /// Renders the appropriate view for each collector in the node
            ForEach(orderedCollectors , id: \.id) { collector in
                switch collector {
                case is FlowCollector:
                    if let flowCollector = collector as? FlowCollector {
                        /// View for flow-related buttons that can navigate between flow branches
                        DaVinciFlowButtonView(field: flowCollector, onNext: onNext)
                    }
                case is PasswordCollector:
                    if let passwordCollector = collector as? PasswordCollector {
                        /// View for password input fields with secure entry
                        DaVinciPasswordView(field: passwordCollector, onNodeUpdated: onNodeUpdated)
                    }
                case is SubmitCollector:
                    if let submitCollector = collector as? SubmitCollector {
                        /// View for form submission buttons
                        DaVinciSubmitButtonView(field: submitCollector, onNext: onNext)
                    }
                case is TextCollector:
                    if let textCollector = collector as? TextCollector {
                        /// View for text input fields
                        DaVinciTextView(field: textCollector, onNodeUpdated: onNodeUpdated)
                    }
                case is LabelCollector:
                    if let labelCollector = collector as? LabelCollector {
                        /// View for displaying static text labels
                        DaVinciLabelView(field: labelCollector)
                    }
                case is MultiSelectCollector:
                    if let multiSelectCollector = collector as? MultiSelectCollector {
                        if multiSelectCollector.type == "COMBOBOX" {
                            /// View for combo box selection with multiple choices
                            DaVinciComboBoxView(field: multiSelectCollector, onNodeUpdated: onNodeUpdated)
                        } else {
                            /// View for checkbox selection with multiple choices
                            DaVinciCheckBoxView(field: multiSelectCollector, onNodeUpdated: onNodeUpdated)
                        }
                    }
                case is SingleSelectCollector:
                    if let singleSelectCollector = collector as? SingleSelectCollector {
                        if singleSelectCollector.type == "DROPDOWN" {
                            /// View for dropdown selection with single choice
                            DaVinciDropdownView(field: singleSelectCollector, onNodeUpdated: onNodeUpdated)
                        } else {
                            /// View for radio button selection with single choice
                            DaVinciRadioButtonView(field: singleSelectCollector, onNodeUpdated: onNodeUpdated)
                        }
                    }
                default:
                    EmptyView()
                }
            }
            
            /// Fallback button shown when no other navigation elements are present
            if !continueNode.collectors.contains(where: { $0 is FlowCollector || $0 is SubmitCollector }) {
                Button(action: { onNext(false) }) {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(K.Colors.Primary))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 16)
            }
        }
    }
}
