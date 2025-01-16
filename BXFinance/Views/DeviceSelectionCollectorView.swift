//
//  DeviceSelectionCollector.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 1/15/25.
//

import SwiftUI
import SwiftyJSON

struct DeviceSelectionCollectorView: View {
    
    let selectableDevices: [SelectableDevice]
    
    var deviceSelectedHandler: (SelectableDevice) -> Void
    
    var body: some View {
        Text("How would you like to sign in?")
            .font(.system(size: 20))
            .fontWeight(.bold)
            .padding(.bottom, 16)
        ScrollView {
            ForEach(selectableDevices) { device in
                if device.type != .hidden {
                    Button(action: {
                        deviceSelectedHandler(device)
                    }, label: {
                        HStack {
                            Image(systemName: getSystemImage(type: device.type))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .padding(.trailing, 16)
                            
                            VStack {
                                Text(getDeviceName(type: device.type))
                                    .font(.system(size: 14))
                                Text(device.target)
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)

                        }.padding(16)
                    })
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 16)
                    .tint(Color(K.Colors.Primary))
                }
            }
        }
    }
    
    func getSystemImage(type: SelectableDeviceType) -> String {
        switch type {
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
    
    func getDeviceName(type: SelectableDeviceType) -> String {
        switch type {
        case .sms:
            return "Text me a one-time passcode"
        case .email:
            return "Email me a one-time passcode"
        case .totp:
            return "Authenticator App (TOTP)"
        default:
            return "Unknown"
        }
    }
}

#if DEBUG
struct DeviceSelectionCollectorView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceSelectionCollectorView(selectableDevices: MockDevices().devices) { device in
            print("Selected Device: \(device.id)")
        }
    }
}
#endif
