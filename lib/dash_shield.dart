import 'dart:io';

import 'package:dash_shield/src/features/integrity_checks/integrity_checks_service.dart';
import 'package:dash_shield/src/features/integrity_checks/security_config.dart';
import 'package:screen_protector/screen_protector.dart';

import 'dash_shield_platform_interface.dart';
import 'src/core/exceptions/configuration_exception.dart';
import 'src/features/ssl_pinning/ssl_security_service.dart';

export 'src/core/utils/enums.dart';
export 'src/features/integrity_checks/security_config.dart';
export 'src/features/security_screen_overlay/security_screen_overlay.dart';

/// The main entry point for Dash Shield security features, providing
/// methods for screenshot prevention, screen recording prevention, SSL pinning,
/// and app integrity checks.
///
/// [DashShield] simplifies the application of security features for Flutter
/// applications, allowing for easy setup and configuration of security best
/// practices.
///
/// Example usage:
/// ```dart
/// DashShield.preventScreenshotsGlobally();
/// DashShield.applySSLPinning(['assets/certs/my_cert.pem'], dioClient);
/// DashShield.initSecurity(config: securityConfig);
/// ```
class DashShield {
  /// Prevents screenshots globally across the app.
  ///
  /// This method uses platform-specific implementations to block screenshots
  /// across the entire app, ensuring sensitive data cannot be captured via
  /// screenshots on both Android and iOS devices. Not supported on other platforms.
  static Future<void> preventScreenshotsGlobally() async {
    if (Platform.isAndroid) {
      return DashShieldPlatform.instance.preventScreenshotsGlobally();
    } else if (Platform.isIOS) {
      return await ScreenProtector.preventScreenshotOn();
    } else {
      throw ConfigurationException('Platform Not Supported');
    }
  }

  /// Allows screenshots globally across the app.
  ///
  /// This method reverses the screenshot prevention setting across all screens,
  /// allowing screenshots and screen recording throughout the app on Android
  /// and iOS devices. Not supported on other platforms.
  static Future<void> allowScreenshotsGlobally() async {
    if (Platform.isAndroid) {
      return DashShieldPlatform.instance.allowScreenshotsGlobally();
    } else if (Platform.isIOS) {
      return await ScreenProtector.preventScreenshotOff();
    } else {
      throw ConfigurationException('Platform Not Supported');
    }
  }

  /// Prevents both screenshots and screen recording for the current screen.
  ///
  /// This method uses platform-specific implementations to block both screenshots
  /// and screen recording, ensuring sensitive data on this screen cannot be captured.
  /// This method is currently only supported on Android.
  static Future<void> preventScreenshotsAndRecordingForThisScreen() {
    if (Platform.isAndroid) {
      return DashShieldPlatform.instance.preventScreenshotsAndRecording();
    } else {
      throw ConfigurationException('Platform Not Supported');
    }
  }

  /// Allows screenshots and screen recording for the current screen only.
  ///
  /// This method reverses the screenshot prevention setting for the current screen,
  /// enabling screenshots and screen recording for this screen on supported platforms.
  /// This method is currently only supported on Android.
  static Future<void> allowScreenshotsAndRecordingForThisScreen() {
    if (Platform.isAndroid) {
      return DashShieldPlatform.instance.allowScreenshots();
    } else {
      throw ConfigurationException('Platform Not Supported');
    }
  }

  /// Applies SSL pinning using the provided [certificateAssetPath] for secure
  /// communication.
  ///
  /// - [certificateAssetPath]: List of certificate asset paths to pin.
  /// - [client]: The HTTP client (e.g., Dio) to which the SSL certificates will
  ///   be attached.
  ///
  /// This method ensures only connections with trusted certificates proceed.
  /// Currently, only the Dio client is fully supported.
  static Future<dynamic> applySSLPinning(
      List<String> certificateAssetPath, dynamic client) async {
    await SSLSecurityService.attachSSLCertificate(certificateAssetPath, client);
  }

  /// Initializes app security checks with the given [config].
  ///
  /// This method sets up and starts various integrity checks and security
  /// controls based on the specified [SecurityConfig], helping ensure the app’s
  /// environment meets security standards.
  ///
  /// Example:
  /// ```dart
  /// DashShield.initSecurity(config: mySecurityConfig);
  /// ```
  static Future<void> initSecurity({required SecurityConfig config}) async {
    await IntegrityChecksService.startIntegrityChecks(config: config);
  }
}
