//
//  PingOneProtectView.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/18/23.
//

import SwiftUI
import PingOneSignals

struct PingOneProtectView: View {
    
    init() {
        guard let pingOneSignals = PingOneSignals.sharedInstance() else {
            print("No ping one signals shared instance")
            return
        }
        
        pingOneSignals.getData { data, error in
            if let data {
                print("PingOne Protect data :\(data)")
            } else if let error {
                print("Error getting PingOne Protect data: \(error)")
            }
        }
    }
    
    var body: some View {
        Spacer()
        BXButton(text: "View Protect Data") {
            
        }
        Spacer()
    }
}

struct PingOneProtectView_Previews: PreviewProvider {
    static var previews: some View {
        PingOneProtectView()
    }
}
