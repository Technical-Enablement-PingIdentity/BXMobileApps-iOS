//
//  DashboardView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/25/24.
//

import SwiftUI

struct DashboardScreen: View {
    
    @State var loadingAccounts = false
    @State var accounts: [Account] = []
    
    @EnvironmentObject var globalModel: GlobalViewModel
    @EnvironmentObject var router: RouterViewModel
    
    var body: some View {
        VStack {
            LogoView()
                
            TabView {
                Tab("Accounts", systemImage: "building.columns") {
                    Text("Welcome \(JWTUtilities.decode(jwt: globalModel.idToken)["first_name"] ?? "")")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 24))
                        .padding(.horizontal)
                    
                    if loadingAccounts {
                        Spacer()
                        ProgressView()
                            .tint(Color.gray)
                        Spacer()
                    } else {
                        if accounts.count == 0 {
                            Spacer()
                            Text("Please sign in to view your accounts")
                            Button(K.Strings.Login.Login) {
                                router.popToRoot()
                            }
                            Spacer()
                        } else {
                            List(accounts) { account in
                                AccountView(account: account)
                            }
                            .listStyle(.plain)
                            .padding(.horizontal)
                            .refreshable {
                                await loadAccounts()
                            }
                        }
                    }
                }
                
                Tab("Wallet", systemImage: "wallet.pass.fill") {
                    WalletView()
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
        if !globalModel.accessToken.isEmpty {
            do {
                defer { loadingAccounts = false }
                loadingAccounts = true
                accounts = try await OpenBankingClient.getBalances(accessToken: globalModel.accessToken)
            } catch {
                print("Couldn't fetch accounts \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        DashboardScreen()
            .environmentObject(GlobalViewModel.preview)
            .environmentObject(RouterViewModel())
    }
}
