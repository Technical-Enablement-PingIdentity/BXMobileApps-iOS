//
//  TextView.swift
//  Davinci
//
//  Copyright (c) 2025 Ping Identity Corporation. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//


import SwiftUI
import PingDavinci

/// A SwiftUI view that creates a text input field.
///
/// The TextView creates a standard text input field with validation capabilities.
/// It manages the text value and validation state, displaying error messages when
/// validation fails.
///
/// Properties:
/// - field: The TextCollector that manages the text state and validation
/// - onNodeUpdated: A callback function that notifies the parent when the field value changes
/// - text: State variable for the text value
/// - isValid: State variable that tracks the validation state of the field
///
/// The view updates validation state when ValidationViewModel triggers validation
/// and when the text value changes.
struct DaVinciTextView: View {
    let field: TextCollector
    let onNodeUpdated: () -> Void
    
    @EnvironmentObject var validationViewModel: DaVinciValidationViewModel
    @State var text: String = ""
    @State private var isValid: Bool = true
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(field.required ? "\(field.label)*" : field.label)
                    .font(.system(size: 14))
                    .padding(.bottom, 4)
                TextField(
                    field.label,
                    text: $text
                )
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(isValid ? Color.gray : Color.red, lineWidth: 1)
                )
                .onAppear(perform: {
                    text = field.value
                })
                .onChange(of: text) { _, newValue in
                    field.value = newValue
                    isValid = field.validate().isEmpty
                    onNodeUpdated()
                }
                if !isValid {
                    DaVinciErrorMessageView(errors: field.validate().map { $0.errorMessage }.sorted())
                }
            }
        }
        .padding(.horizontal)
        .onChange(of: validationViewModel.shouldValidate) { _, newValue in
            if newValue {
                isValid = field.validate().isEmpty
            }
        }
    }
}
