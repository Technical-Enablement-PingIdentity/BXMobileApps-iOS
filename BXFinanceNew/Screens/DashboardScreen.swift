//
//  DashboardView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/25/24.
//

import SwiftUI

struct DashboardScreen: View {
    
    @State var accounts: [Account] = []
    
    @EnvironmentObject var globalModel: GlobalViewModel
    
    var body: some View {
        VStack {
            LogoView()
                
            TabView {
                Tab("Accounts", systemImage: "building.columns") {
                    Text("Welcome \(JWTUtilities.decode(jwt: globalModel.idToken)["first_name"] ?? "")")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 24))
                        .padding(.horizontal)
                    
                    List(accounts) { account in
                        AccountView(account: account)
                    }
                        .listStyle(.plain)
                        .padding(.horizontal)
                        .refreshable {
                            await loadAccounts()
                        }
                }
                
                Tab("Wallet", systemImage: "wallet.pass.fill") {
//                    WalletView()
                    Text("TK")
                }
                
                Tab("Verify", systemImage: "person.badge.shield.checkmark.fill") {
                    VerifyView()
                }
                
                Tab("Profile", systemImage: "person.circle") {
                    ProfileView()
                }
                
            }
            .tint(Color(K.Colors.Primary))
            
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await loadAccounts()
        }
    }
    
    func loadAccounts() async {
        do {
            accounts = try await OpenBankingClient.getBalances(accessToken: globalModel.accessToken)
            
            print(accounts)
        } catch {
            print("Couldn't fetch accounts \(error.localizedDescription)")
        }
    }
}

#Preview {
    NavigationStack {
        DashboardScreen()
            .environmentObject(GlobalViewModel.preview)
    }
}
