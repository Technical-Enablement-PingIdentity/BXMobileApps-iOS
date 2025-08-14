//
//  SettingsView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 8/12/25.
//

import SwiftUI

struct SettingsView: View {
    
    let width = UIScreen.main.bounds.width - 50

    @Binding var updateView: Bool
    
    let closeTapped: () -> Void
    
    @State private var primaryColor: Color = .bxPrimary
    
    var body: some View {
        HStack {
            ZStack{
                Rectangle()
                    .fill(.white)
                    .frame(width: width)
                    .shadow(color: .purple.opacity(0.1), radius: 5, x: 0, y: 3)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("app_settings")
                            .font(.title)
                        Spacer()
                        Button("", systemImage: "xmark") {
                            closeTapped()
                        }
                        .padding(.top, 6)
                        .font(.title2)
                        .tint(.bxPrimary)
                    }
                    .padding(.top, 70)
                    .padding(.bottom)
                    
                    ColorPicker("Primary Color", selection: $primaryColor, supportsOpacity: false)
                        .onChange(of: primaryColor) { _, newValue in
                            do {
                                let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(newValue), requiringSecureCoding: false)
                                UserDefaults.standard.set(data, forKey: K.AppStorage.PrimaryColor)
                            } catch {
                                print("Could not save color \(error.localizedDescription)")
                            }
                            
                            updateView.toggle()
                        }
                    Spacer()
                }
                .padding(.horizontal)
                .frame(width: width)
                .background(.cardBackground)
            }
            
            Spacer()
        }
        .background(.clear)
    }
}

#Preview {
    @Previewable @State var update: Bool = false
    SettingsView(updateView: $update) {
        print("tapped")
    }
}
