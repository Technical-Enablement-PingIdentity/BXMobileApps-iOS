//
//  ToastView.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/13/24.
//

import SwiftUI

struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 5
    var width: Double = .infinity
}

enum ToastStyle {
    case success
    case warning
    case error
    case info
}

extension ToastStyle {
    var themeColor: Color {
        switch self {
        case .error: return Color.red
        case .warning: return Color.orange
        case .info: return Color.blue
        case .success: return Color.green
        }
    }

    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
}

struct ToastView: View {

    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: style.iconFileName)
                .foregroundColor(style.themeColor)
                .frame(width: 24, height: 24)

            Text(message)
                .font(Font.caption)
                .foregroundColor(Color("ToastForeground"))
            Spacer()
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(Color("ToastBackground"))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(style.themeColor, lineWidth: 1)
                .opacity(0.6)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    Button("Success toast") {
        ToastPresenter.show(style: .success, toast: "An example Success Toast")
    }
}

struct ToastPresenter {
    static func show(style: ToastStyle, toast: String) {
        DispatchQueue.main.async {
            guard
                let scene = UIApplication.shared.connectedScenes.first
                    as? UIWindowScene
            else { return }
            let toastWindow = UIWindow(windowScene: scene)
            toastWindow.backgroundColor = .clear

            // Start with the window off-screen at the top
            toastWindow.frame = CGRect(x: 50, y: -100, width: 300, height: 200)

            let view = ToastView(style: style, message: toast)

            toastWindow.rootViewController = UIHostingController(rootView: view)
            toastWindow.rootViewController?.view.backgroundColor = .clear
            toastWindow.makeKeyAndVisible()

            // Animate the window sliding down
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    toastWindow.frame = CGRect(
                        x: 50, y: 0, width: 300, height: 200)
                })

            // Hide the toast automatically after 2 seconds with slide up animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                UIView.animate(
                    withDuration: 0.5,
                    animations: {
                        toastWindow.frame = CGRect(
                            x: 50, y: -200, width: 300, height: 200)
                    }
                ) { _ in
                    toastWindow.isHidden = true
                }
            }
        }

    }
}
