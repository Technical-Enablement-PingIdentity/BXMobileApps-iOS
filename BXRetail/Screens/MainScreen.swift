//
//  HomeScreen.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 5/14/25.
//

import SwiftUI

struct MainScreen: View {
    enum RetailTab {
        case home
        case shop
        case deals
        case wallet
        case account
    }
    
    @State var selection: RetailTab = .home
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack {
            HStack {
                LogoView(assetName: K.Assets.LogoWhite)
            }
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding(.trailing)
                }
                

            TabView(selection: $selection) {
                Tab("home", systemImage: "house.fill", value: .home) {
                    ScrollView {
                        VStack {
                            if !userViewModel.isLoggedIn {
                                SignInCardView(note: "sign_in.experience".resource)
                                    .padding(.top)
                            } else {
                                ContinueShoppingView()
                                    .padding(.top)
                            }
                            
                            UnauthenticatedContentView()
                                .padding(.vertical)
                        }
                        .padding(.horizontal)
                    }
                    .tint(.blue)
                    .onAppear {
                        Task {
                            GoogleAnalytics.userViewedScreen(screenName: "home_tab")
                            await userViewModel.fetchUserInfo()
                        }
                    }
                }
                
                Tab("shop", systemImage: "storefront.fill", value: .shop) {
                    Text("shop")
                }
                
                Tab("deals", systemImage: "tag.fill", value: .deals) {
                    Text("deals")
                }

                Tab("wallet", systemImage: "wallet.pass.fill", value: .wallet) {
                    Text("wallet")
                }
                
                Tab("account", systemImage: "person.crop.circle.fill", value: .account) {
                    AccountView()
                        .onAppear {
                            GoogleAnalytics.userViewedScreen(screenName: "account_tab")
                        }
                        .tint(.blue)
                }
            }
            .tint(.white)
            .onAppear {
                let appearance = UITabBar.appearance()
                appearance.backgroundColor = UIColor(named: K.Colors.Primary)
                appearance.barTintColor = UIColor(named: K.Colors.Primary)
                appearance.unselectedItemTintColor = UIColor(named: K.Colors.PrimaryLight)
                Task {
                    await userViewModel.fetchUserInfo()
                }
            }
            .onChange(of: selection) { oldValue, newValue in
                if (newValue != .home && newValue != .account) {
                    selection = oldValue
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color(K.Colors.Primary))
        
    }
}

#Preview {
    MainScreen()
}
