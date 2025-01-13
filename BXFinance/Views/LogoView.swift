//
//  DashboardLogoView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/12/24.
//

import SwiftUI

struct LogoView: View {
    enum LogoSize {
        case small
        case large
    }
    
    let size: LogoSize
    
    init (size: LogoSize = .small) {
        self.size = size
    }
    
    var body: some View {
        Image("BXFinanceLogo")
            .resizable()
            .scaledToFit()
            .frame(width: size == .large ? 280 : 200)
    }
}

#Preview {
    LogoView()
}
