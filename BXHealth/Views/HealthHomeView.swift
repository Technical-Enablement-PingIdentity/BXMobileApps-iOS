//
//  HealthRootView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/13/23.
//

import SwiftUI

struct HealthHomeView: View {
    var body: some View {
        AddDeviceView()
            .padding(.top, 48)
        Spacer()
        HomeActionsView()
    }
}

struct HealthHomeView_Previews: PreviewProvider {
    static var previews: some View {
        HealthHomeView()
    }
}
