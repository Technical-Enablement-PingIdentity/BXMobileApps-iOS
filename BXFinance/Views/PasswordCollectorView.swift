//
//  Untitled.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/11/24.
//

import SwiftUI

struct PasswordCollectorView: View {
    
    enum FocusedField {
        case password
    }
    
    @Binding var password: String
    @Binding var validationMessage: String?
    @FocusState var focusedField: FocusedField?
    
    var username: String?
    var submitCompletionHandler: () -> Void
    
    private var isPasswordValid: Bool {
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        VStack {
            Text(LocalizedStringKey("authentication.password.header \(username ?? "nil")"))
                .padding(.bottom, 16)
                .font(.system(size: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Section(header: FormFieldLabelView(LocalizedStringKey("authentication.password.label"))) {
                SecureField(LocalizedStringKey("authentication.password.label"), text: $password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(RoundedBorderTextFieldCustomStyle())
                    .padding(.bottom, 8)
                    .focused($focusedField, equals: .password)
                if validationMessage != nil {
                    Text(validationMessage!)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 0)
                        .font(.system(size: 14))
                }
            }
            
            Spacer()
            
            Button(LocalizedStringKey("submit")) {
                submitCompletionHandler()
            }
            .disabled(!isPasswordValid)
            .buttonStyle(BXFullWidthButtonStyle())
        }
        .onAppear {
            focusedField = .password
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    struct Preview: View {
        @State var password = ""
        @State var validationMessage: String? = "Some issue with the password"
        
        var body: some View {
           VStack {
                PasswordCollectorView(password: $password, validationMessage: $validationMessage, username: "tuser") {
                    print("Submitted \(password)")
                }
           }
           .padding()
        }
    }

    return Preview()
}
