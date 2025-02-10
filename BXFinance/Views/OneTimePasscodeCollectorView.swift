//
//  OneTimePasscodeCollector.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 1/15/25.
//

import SwiftUI

struct OneTimePasscodeCollectorView: View {
    
    enum FocusedField {
        case otp
    }
    
    let selectedDevice: SelectableDevice
    
    @Binding var oneTimePasscode: String
    @Binding var validationMessage: String?
    
    @FocusState var focusedField: FocusedField?
    
    var submitCompletionHandler: () -> Void
    
    private var isOtpValid: Bool {
        oneTimePasscode.count == 6
    }
    
    var body: some View {
        VStack {
            Text(LocalizedStringKey("authentication.totp.message"))
                .padding(.bottom, 8)
                .font(.system(size: 24))
                .multilineTextAlignment(.center)
            Text(getHeaderText())
                .padding(.bottom, 16)
                .multilineTextAlignment(.center)
            
            VStack {
                Image(systemName: getSystemImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 92, height: 92)
                    .padding(20)
                    .foregroundStyle(Color.white)
                    .background(Color(K.Colors.Primary))
                    .clipShape(Circle())
            }
            .padding(.bottom, 16)

            
            Section(header: FormFieldLabelView(LocalizedStringKey("authentication.totp.label"))) {
                TextField(LocalizedStringKey("authentication.totp.label"), text: $oneTimePasscode)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(RoundedBorderTextFieldCustomStyle())
                    .padding(.bottom, 8)
                    .focused($focusedField, equals: .otp)
                    .keyboardType(.numberPad)
            }
            
            if validationMessage != nil {
                Text(validationMessage!)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 0)
                    .font(.system(size: 14))
            }
            
            Spacer()
            
            Button(LocalizedStringKey("submit")) {
                submitCompletionHandler()
            }
            .disabled(!isOtpValid)
            .buttonStyle(FinanceFullWidthButtonStyle())
        }
        .onAppear {
            focusedField = .otp
        }
    }
    
    func getHeaderText() -> String {
        switch selectedDevice.type {
        case .email:
            return "\(String(localized: "authentication.email.header")) \(selectedDevice.target)"
        case .sms:
            return "\(String(localized: "authentication.sms.header")) \(selectedDevice.target)"
        case .totp:
            return String(localized: "authentication.totp.header")
        default:
            return ""
        }
    }
    
    func getSystemImage() -> String {
        switch selectedDevice.type {
        case .sms:
            return "text.bubble"
        case .email:
            return "envelope"
        case .totp:
            return "app.badge.clock"
        default:
            return "questionmark.app.dashed"
        }
    }
}

#if DEBUG
struct OneTimePasscodeCollectorView_Previews: PreviewProvider {
    static var previews: some View {
        struct Preview: View {
            @State var oneTimePasscode = ""
            @State var validationMessage: String? = "Some issue with the one time passcode"
            
            var body: some View {
                VStack {
                    OneTimePasscodeCollectorView(selectedDevice: MockDevices().devices[3], oneTimePasscode: $oneTimePasscode, validationMessage: $validationMessage) {
                        print("Submitted \(oneTimePasscode)")
                    }
                }
                .padding()
            }
        }
        
        return Preview()
    }
}
#endif
