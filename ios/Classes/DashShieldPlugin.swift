import Flutter
import UIKit

public class DashShieldPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "dash_shield", binaryMessenger: registrar.messenger())
    let instance = DashShieldPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  private var globalScreenshotPrevention: Bool = false

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "preventScreenshots":
      // Prevent screenshots for the specific screen if global prevention is not active
      if let window = UIApplication.shared.keyWindow {
        if !globalScreenshotPrevention {
          window.isSecure = true
        }
        result(nil)
      } else {
        result(FlutterError(code: "UNAVAILABLE", message: "Window not available", details: nil))
      }

    case "allowScreenshots":
      // Allow screenshots for the specific screen if global prevention is not active
      if let window = UIApplication.shared.keyWindow {
        if !globalScreenshotPrevention {
          window.isSecure = false
        }
        result(nil)
      } else {
        result(FlutterError(code: "UNAVAILABLE", message: "Window not available", details: nil))
      }

    case "preventScreenshotsGlobally":
      // Set global prevention of screenshots across the entire app
      if let window = UIApplication.shared.keyWindow {
        globalScreenshotPrevention = true
        window.isSecure = true
        result(nil)
      } else {
        result(FlutterError(code: "UNAVAILABLE", message: "Window not available", details: nil))
      }

    case "allowScreenshotsGlobally":
      // Remove global prevention, allowing screenshots across the entire app
      if let window = UIApplication.shared.keyWindow {
        globalScreenshotPrevention = false
        window.isSecure = false
        result(nil)
      } else {
        result(FlutterError(code: "UNAVAILABLE", message: "Window not available", details: nil))
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
