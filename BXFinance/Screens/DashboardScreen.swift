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
                Tab(LocalizedStringKey("accounts"), systemImage: "building.columns") {
                    Text("\(String(localized: "dashboard.welcome")) \(JWTUtilities.decode(jwt: globalModel.idToken)["first_name"] ?? "")")
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
                            Text(LocalizedStringKey("accounts.sign_in"))
                            Button(LocalizedStringKey("sign_in")) {
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
                
                Tab(LocalizedStringKey("wallet"), systemImage: "wallet.pass.fill") {
                    WalletView()
                }
                
                Tab(LocalizedStringKey("verify"), systemImage: "person.badge.shield.checkmark.fill") {
                    VerifyView()
                }
                
                Tab(LocalizedStringKey("profile"), systemImage: "person.circle") {
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

#if DEBUG
struct DashboardScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DashboardScreen()
                .environmentObject(GlobalViewModel.preview)
                .environmentObject(RouterViewModel())
        }
    }
}
#endif
