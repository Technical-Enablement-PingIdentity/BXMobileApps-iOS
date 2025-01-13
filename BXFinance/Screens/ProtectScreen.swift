//
//  ProtectScreen.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/12/24.
//

import SwiftUI

struct ProtectScreen: View {
    
    let username: String
    
    @State var riskAssessment = ""
    @State var loading: Bool = true
    
    var body: some View {
        VStack {
            LogoView()
            
            Text("Risk Assessment for \(username)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
                .font(.system(size: 24))
            
            Text("** Please note a risk assessment is generated in PingOne through the log in flow. You can view those events in the audit logs. **")
                .frame(maxWidth: .infinity, alignment: .leading)

                .font(.system(size: 12))

            if loading {
                VStack {
                    Spacer()
                    Text("Loading...")
                    ProgressView()
                    Spacer()
                }
            } else {
                ScrollView {
                    Text(riskAssessment)
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(false)
        .task {
            do {
                riskAssessment = try await ProtectClient.getRiskEvaluation(username: username)
                loading = false
            } catch {
                riskAssessment = "An error occurred getting risk assessment: \(error.localizedDescription)"
                loading = false
            }
        }
    }
}

#Preview {
    ProtectScreen(username: "etest")
}
