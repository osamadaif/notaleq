import AppTrackingTransparency
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    registerTrackingConsentChannel()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func registerTrackingConsentChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }
    let channel = FlutterMethodChannel(
      name: "com.osama.daif.notaleq/tracking-consent",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { call, callback in
      guard call.method == "requestTrackingAuthorization" else {
        callback(FlutterMethodNotImplemented)
        return
      }
      guard #available(iOS 14, *) else {
        callback(nil)
        return
      }
      ATTrackingManager.requestTrackingAuthorization { _ in
        DispatchQueue.main.async { callback(nil) }
      }
    }
  }
}
