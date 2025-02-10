//
//  UsernameCollectorView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/11/24.
//

import SwiftUI

struct UsernameCollectorView: View {
    
    enum FocusedField {
        case username
    }
    
    @Binding var username: String
    @Binding var validationMessage: String?
    
    @FocusState var focusedField: FocusedField?
    
    var submitCompletionHandler: () -> Void
    
    private var isUsernameValid: Bool {
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        VStack {
            Section(header: FormFieldLabelView(LocalizedStringKey("authentication.username.label"))) {
                TextField(LocalizedStringKey("authentication.username.label"), text: $username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(RoundedBorderTextFieldCustomStyle())
                    .padding(.bottom, 8)
                    .focused($focusedField, equals: .username)
                
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
            .disabled(!isUsernameValid)
            .buttonStyle(FinanceFullWidthButtonStyle())
        }
        .onAppear {
            focusedField = .username
        }
    }
}

#Preview {
    struct Preview: View {
        @State var username = ""
        @State var validationMessage: String? = "Some issue with the username"
        
        var body: some View {
           VStack {
                UsernameCollectorView(username: $username, validationMessage: $validationMessage) {
                    print("Submitted \(username)")
                }
           }
           .padding()
        }
    }

    return Preview()
}
