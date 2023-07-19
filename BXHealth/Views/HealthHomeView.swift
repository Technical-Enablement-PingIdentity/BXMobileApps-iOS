//
//  HealthRootView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 7/13/23.
//

import SwiftUI

struct HealthHomeView: View {
    
    @State var selectedTab = "home"
    @State var lastActiveTab = "home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            VStack {
                AddDeviceView(issuer: K.issuer, redirectUri: K.redirectUri, clientId: K.clientId)
                    .padding(.top, 48)
                Spacer()
            }
            .background(TabViewTransparentBackground())
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            .tag("home")
            
            VStack {
                Text("Nothing to see here")
            }
            .background(TabViewTransparentBackground())
            .tabItem {
                Image(systemName: "pill")
                Text("Medications")
            }
            .tag("medications")
            
            VStack {
                Text("Nothing to see here")
            }
            .background(TabViewTransparentBackground())
            .tabItem {
                Image(systemName: "testtube.2")
                Text("Test Results")
            }
            .tag("results")
            
            VStack {
                Text("Nothing to see here")
            }
            .background(TabViewTransparentBackground())
            .tabItem {
                Image(systemName: "message")
                Text("Messages")
            }
            .tag("messages")
            
            VStack {
                Text("Protect data TK")
            }
            .background(TabViewTransparentBackground())
            .tabItem {
                Image(systemName: "stethoscope")
                Text("Find a Doctor")
            }
            .tag("doctor")
        }
        .onAppear() {
            UITabBar.appearance().unselectedItemTintColor = UIColor(.secondaryColor)
        }
        .accentColor(Color.primaryColor)
        .onChange(of: selectedTab) { newValue in
            let activeTabs = ["home"]
            if activeTabs.contains(newValue) {
                selectedTab = newValue
                lastActiveTab = newValue
            } else {
                selectedTab = lastActiveTab
            }
        }
    }
}

struct HealthHomeView_Previews: PreviewProvider {
    static var previews: some View {
        HealthHomeView()
    }
}
