//
//  FinanceHome.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/13/23.
//

import SwiftUI

struct FinanceRootView: View {
    
    @ObservedObject private var model: MainViewModel
    
    init() {
        self.model = MainViewModel.shared
    }
    
    var body: some View {
        VStack {
            Image("LogoWhite")
                .resizable()
                .scaledToFit()
                .padding([.leading, .trailing], 30)
                .padding(.top, 80)

                switch model.currentRoute {
                case .welcome: WelcomeView(versionColor: .white)
                case .home: FinanceHomeView()
                }
            
            Spacer().frame(height: 50)
        }
        .colorBackground(color: Color.secondaryColor)
        .animation(.default, value: model.currentRoute)
        .alert("Authorize Request".localizedForApp(), isPresented: $model.displayAuthenticationAlert) {
            Button("Approve".localizedForApp()) {
                model.finishAuthenticationPrompt(userAccepted: true)
            }
            Button("Deny".localizedForApp(), role: .destructive) {
                model.finishAuthenticationPrompt(userAccepted: false)
            }
        }
    }
}

struct FinanceRootView_Previews: PreviewProvider {
    static var previews: some View {
        FinanceRootView()
    }
}
