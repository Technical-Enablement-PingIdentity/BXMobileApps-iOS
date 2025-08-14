//
//  RouterView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/11/24.
//

import SwiftUI

struct RouterView<Content: View>: View {
    @StateObject var router = RouterViewModel()
    
    private let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: RouterViewModel.Route.self) { route in
                router.view(for: route)
            }
        }
        .environmentObject(router)
        .tint(Color(K.Colors.Primary))
    }
}

class RouterViewModel: ObservableObject {
    enum Route: Hashable {
        case welcome
        case login
        case dashboard
        case profileInformation
        case protect(String)
        case wallet
        case sendLogs
        case pairDevice
    }
    
    @Published var path = NavigationPath()
    
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .welcome:
            WelcomeScreen()
        case .login:
            LoginScreen()
        case .dashboard:
            DashboardScreen()
        case .profileInformation:
            ProfileInformationScreen()
        case .protect(let username):
            ProtectScreen(username: username)
        case .wallet:
            ConfigureWalletScreen()
        case .sendLogs:
            SendLogsScreen()
        case .pairDevice:
            PairDeviceScreen()
        }
    }
    
    // Used by views to navigate to another view
    func navigateTo(_ appRoute: Route) {
        path.append(appRoute)
    }
    
    // Used to go back to the previous screen
    func navigateBack() {
        path.removeLast()
    }
    
    // Pop to the root screen in our hierarchy
    func popToRoot() {
        path.removeLast(path.count)
    }
}

#Preview {
    RouterView {
        Text("Router")
    }
    .environmentObject(RouterViewModel())
}
