import AVFoundation
import UIKit

public struct CameraAccess {
    @MainActor
    public static func checkCameraAccess(
        applicationUiHandler: ApplicationUiHandler,
        onAuthorized: (() -> Void)? = nil
    ) async {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized {
            onAuthorized?()
        } else if status == .denied {
            applicationUiHandler.showConfirmationAlert(
                title: "camera_access_denied_title".resource,
                message: "camera_access_denied_message".resource,
                positiveActionTitle: "go_to_settings".resource,
                cancelActionTitle: "cancel".resource,
                actionHandler: { confirmed in
                    if confirmed, let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            )
        } else if status == .notDetermined {
            let _ = await AVCaptureDevice.requestAccess(for: .video)
        }
    }
}
