//
//  ApplicationUiHandler.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 10/4/24.
//

import Foundation
import UIKit

public class ApplicationUiHandler {
    
    public func showConfirmationAlert(title: String, message: String, positiveActionTitle: String, cancelActionTitle: String, actionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            let alertVc = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: positiveActionTitle, style: .default, handler: { _ in
                actionHandler(true)
                alertVc.dismiss(animated: false)
            }))
            alertVc.addAction(UIAlertAction(title: cancelActionTitle, style: .cancel, handler: { _ in
                actionHandler(false)
                alertVc.dismiss(animated: false)
            }))
            UIUtilities.getRootViewController()?.present(alertVc, animated: true)
        }
    }
    
    public func showErrorAlert(title: String, message: String, actionTitle: String?, actionHandler: (() -> Void)?) {
        DispatchQueue.main.async {
            let alertVc = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: actionTitle ?? String(localized: "okay"), style: .default, handler: { _ in
                actionHandler?()
                alertVc.dismiss(animated: false)
            }))
            UIUtilities.getRootViewController()?.present(alertVc, animated: true)
        }
    }
    
    @objc private static func hideView(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let sender = gestureRecognizer.view else {
            print("Failed to get the container view for the Gesture Recognizer")
            return
        }
        
        guard let window = UIUtilities.getKeyWindow() else {
            return
        }
        
        if (sender.isDescendant(of: window)) {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                sender.alpha = 0.0
            }, completion: {_ in
                sender.removeFromSuperview()
            })
        }
    }
    
    // Utils methods
    
    public static func pushViewControllerOnTopVc(_ viewController: UIViewController) {
        let topViewController = UIUtilities.getRootViewController()
        if let topNavController = topViewController as? UINavigationController {
            topNavController.pushViewController(viewController, animated: true)
        } else {
            topViewController?.present(viewController, animated: true)
        }
    }
    
    func openUrl(url: String, onComplete: @escaping (Bool, String) -> Void) {
        DispatchQueue.main.async {
            guard let redirectUri = URL(string: url),
                  UIApplication.shared.canOpenURL(redirectUri) else {
                onComplete(false, "Failed to process request")
                return
            }
            
            UIApplication.shared.open(redirectUri) { result in
                onComplete(result, result ? "Presentation request processed" : "Failed to process request")
            }
        }
    }
        
}
