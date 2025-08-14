//
//  ContentView.swift
//  BXWallet
//
//  Created by Eric Anderson on 8/11/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State var presentSideMenu = false
    @State var updateView = false
    
    private func hideSideMenu() {
        presentSideMenu = false
    }
    
    private func checkCameraAccess() async {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        if status == .notDetermined {
            await AVCaptureDevice.requestAccess(for: .video)
        }
    }
    
    var body: some View {
        ZStack {
            HomeWalletView(presentSideMenu: $presentSideMenu)
            SideMenuView(isShowing: $presentSideMenu, content: AnyView(SettingsView(updateView: $updateView, closeTapped: hideSideMenu)))
        }
        .task {
            await checkCameraAccess()
        }
        .id(updateView)
    }
}

#Preview {
    ContentView()
}
