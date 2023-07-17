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
            Text("Use the App".localizedForApp()).padding(.bottom, 6)
                .foregroundColor(.primaryColor)
                .font(.system(size: 16, weight: .bold))
                
            BXButton(text: "Home Action 1".localizedForApp()) { print("Home Action 1 Pressed") }
            BXButton(text: "Home Action 2".localizedForApp()) { print("Home Action 2 Pressed") }
            BXButton(text: "Home Action 3".localizedForApp()) { print("Home Action 3 Pressed") }
            BXButton(text: "Home Action 4".localizedForApp()) { print("Home Action 4 Pressed") }
            BXButton(text: "Home Action 5".localizedForApp()) { print("Home Action 5 Pressed") }
            BXButton(text: "Home Action 6".localizedForApp()) { print("Home Action 6 Pressed") }

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
