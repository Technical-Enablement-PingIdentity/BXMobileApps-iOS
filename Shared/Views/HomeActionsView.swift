//
//  ActionsView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/13/23.
//

import SwiftUI

struct HomeActionsView: View {
    
    var body: some View {
        VStack {
            Text("Use the App".localized()).padding(.bottom, 6)
                .foregroundColor(.primaryColor)
                .font(.system(size: 16, weight: .bold))
                
            BXButton(text: "Home Action 1".localized()) { print("Home Action 1 Pressed") }
            BXButton(text: "Home Action 2".localized()) { print("Home Action 2 Pressed") }
            BXButton(text: "Home Action 3".localized()) { print("Home Action 3 Pressed") }
            BXButton(text: "Home Action 4".localized()) { print("Home Action 4 Pressed") }
            BXButton(text: "Home Action 5".localized()) { print("Home Action 5 Pressed") }
            BXButton(text: "Home Action 6".localized()) { print("Home Action 6 Pressed") }

        }
        .padding(24)
        .background(.white)
    }
}

struct HomeActionsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeActionsView()
    }
}
