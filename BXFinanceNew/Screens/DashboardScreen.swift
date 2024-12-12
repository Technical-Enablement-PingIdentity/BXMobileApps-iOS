//
//  DashboardView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/25/24.
//

import SwiftUI

struct DashboardScreen: View {
    
    let accessToken: String
    let idToken: String
    
    @State var accounts: [Account] = []
    
    @EnvironmentObject var router: RouterViewModel
    
    var body: some View {
        VStack {
            Image("BXFinanceLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                
            TabView {
                Tab("Accounts", systemImage: "building.columns") {
                    Text("Welcome \(JWTUtils.decode(jwt: idToken)["first_name"] ?? "")")
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
            accounts = try await OpenBankingClient.getBalances(accessToken: accessToken)
            
            print(accounts)
        } catch {
            print("Couldn't fetch accounts \(error.localizedDescription)")
        }
    }
}

#Preview {
    NavigationStack {
        DashboardScreen(accessToken: "eyJhbGciOiJSUzI1NiIsImtpZCI6ImNlcnQiLCJwaS5hdG0iOiJpN2dsIn0.eyJzY29wZSI6IiIsImNsaWVudF9pZCI6ImJ4RmluYW5jZU1vYmlsZSIsInN1YiI6ImV0ZXN0IiwicGkuc3JpIjoiSHhfTXhrbnlKNUk0OFlKVHNIZUVPX3RUS2lRLi5Xd1hLLnA5VmJHN0RvRXk1WElnWDBSZXljeFZvejUiLCJleHAiOjE3MzQwMjU3MDd9.UjR3FM2Y5lQjQ2Z46RCLWTWTEFwkqoAR7rjoyH5En9ycJbPhVtOIgAx41lamlxhOdrgu98POeFl2-FPPaE75xdFaejnsy5lpMBWifAwyxW-dBCtctSC8gADyJmluuPCNcc78nNOWtCOKgnuiJz8G9ym0CX0LEazWU_7wsSjdRdh9bg-GIwzhGK0IJHfGFuOis3Q6YRTMCObMvYPW-h-eKW4yzgy4xqD7aPV2Z7QLHEUOCZwk6dqRNbwIp_L7BpnuU9xWysUAyW4jMGh4P1K4JHql-v9FibQQKZLJUyydZyuNiErDpGEokqx2567A5gI0JFhIg9NxH_MRcXHIIZ2rtQ", idToken: "eyJhbGciOiJSUzI1NiIsImtpZCI6IjhNaktZNk5ZbVItU3pFU0xENnQzZVZhNDE1RV9SUzI1NiJ9.eyJzdWIiOiJldGVzdCIsImF1ZCI6ImJ4RmluYW5jZU1vYmlsZSIsImp0aSI6IktjS25FclRqcjhoa2tIR3diQ2hNUmIiLCJpc3MiOiJodHRwczovL2J4ZmluYW5jZS1kZWMtZWEucGluZy1kZXZvcHMuY29tIiwiaWF0IjoxNzM0MDI3NDc4LCJleHAiOjE3MzQwMjc3NzgsImF1dGhfdGltZSI6MTczNDAyNzQ3OCwibGFzdF9uYW1lIjoiQW5kZXJzb24iLCJmaXJzdF9uYW1lIjoiRXJpYyIsImVtYWlsIjoiZXJpY2FuZGVyc29uK2V0ZXN0QHBpbmdpZGVudGl0eS5jb20iLCJwaS5zcmkiOiJTckotNnMzSVFwb21nWWk0Sm5pOF94aWlSaG8uLld5alYueEs3dWM1QlhXeUdIYmtlSFY3VkhsYjQycCIsInNpZCI6IlNySi02czNJUXBvbWdZaTRKbmk4X3hpaVJoby4uV3lqVi54Szd1YzVCWFd5R0hia2VIVjdWSGxiNDJwIiwibm9uY2UiOiJ4eXoxMjM0MzQyIiwiYXRfaGFzaCI6IjhpVVZ0QXg0dWkxQ083TWdjUDkwRmcifQ.MRABAaTx_GD3ZXrVul2TweOMywlnZEYXe67DhGwuPVaSXCkWNox297cdaa1nhIuS7OeIT_1HEAHezuWYnFKTOypFT8cJgU0nPDy4DW5TR1R9i1-79PhtBTKV-pJ4C1fJTa_6mvPmYHI5a0ZJdYae3FI4uC3uTZDXXtkvCU2zVlhoJpTJBqeOdmlA2QNllVvX9_f1mxowkyZbCqBX3SnMCP5mtwruyBo0fuMNlthiRGj2awG3w7sZcXDtbOUXr97wMwttUAdN4FLUS3nVgS6okDjXJ-IvUlOTRslBdP36lw93z7EgxIiEb1m9zj-Ek98kCr6n_eGGfFDeJ_MPu-gfmg")
            .environmentObject(RouterViewModel())
    }
}
