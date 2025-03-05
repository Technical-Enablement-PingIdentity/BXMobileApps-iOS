//
//  PairDeviceView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/18/24.
//

import SwiftUI

struct PairDeviceScreen: View {
    
    @EnvironmentObject var financeModel: FinanceGlobalViewModel
    
    var body: some View {
        VStack {
            let username = financeModel.getAttributeFromToken(attribute: "sub", type: .accessToken)
            PairDeviceView(username: username)
                .onAppear {
                    GoogleAnalytics.userViewedScreen(screenName: "pair_device_screen")
                }
        }
    }
}

#Preview {
    PairDeviceScreen()
}
