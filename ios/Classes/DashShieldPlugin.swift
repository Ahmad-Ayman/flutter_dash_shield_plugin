import Flutter
import UIKit

public class DashShieldPlugin: NSObject, FlutterPlugin {
  private var channel: FlutterMethodChannel?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "dash_shield", binaryMessenger: registrar.messenger())
    let instance = DashShieldPlugin()
    instance.channel = channel
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "secureApp", "secureScreen":
      // Start listening for screen capture notifications
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(screenCaptureChanged),
        name: UIScreen.capturedDidChangeNotification,
        object: nil
      )
      result(nil)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Function triggered when screen capture status changes
  @objc private func screenCaptureChanged() {
    if UIScreen.main.isCaptured {
      // Notify Flutter that screen capture was detected
      channel?.invokeMethod("onScreenCaptureDetected", arguments: nil)
    }
  }

  deinit {
    // Clean up the notification observer when the plugin is deallocated
    NotificationCenter.default.removeObserver(self, name: UIScreen.capturedDidChangeNotification, object: nil)
  }
}
