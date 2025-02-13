//
//  SendLogsScreen.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 2/10/25.
//

import SwiftUI
import PingOneSDK

struct SendLogsScreen: View {
    @State var supportId: String? = nil
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(LocalizedStringKey("send_logs")) {
                PingOne.sendLogs { supportId, error in
                    
                    self.supportId = supportId
                    
                    if let error = error {
                        print("Error sending logs: \(error.localizedDescription)")
                    }
                }
            }
            .buttonStyle(BXButtonStyle())
            
            if supportId != nil {
                Text(LocalizedStringKey("send_logs.support_id \(supportId!)"))
            }
            
            Spacer()
        }
    }
}
