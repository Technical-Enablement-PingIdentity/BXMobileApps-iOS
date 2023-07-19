//
//  FinanceHome.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/13/23.
//

import SwiftUI
import PingOneSignals

struct FinanceRootView: View {
    
    @ObservedObject private var model: MainViewModel
    
    init() {
        self.model = MainViewModel.shared
        initPingOneSignalsSdk()
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
        .defaultBackground()
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

extension FinanceRootView {
    func initPingOneSignalsSdk() {
        let initParams = POInitParams()
        initParams.envId = "6c77a243-4622-4c89-a0ca-5905fb4eb3f4"
        
        let pingOneSignals = PingOneSignals.initSDK(initParams: initParams)
        
        pingOneSignals.setInitCallback { error in
            if let error {
                print("PingOne Signals init failed: \(error.localizedDescription)")
            } else {
                print("PingOne Signals initialized!")
            }
        }
    }
}
