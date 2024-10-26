import 'package:dash_shield/src/features/integrity_checks/integrity_checks_service.dart';
import 'package:dash_shield/src/features/integrity_checks/security_config.dart';
import 'package:dio/dio.dart';

import 'dash_shield_platform_interface.dart';
import 'src/features/ssl_pinning/ssl_security_service.dart';

export 'src/core/utils/enums.dart';
export 'src/features/integrity_checks/security_config.dart';

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
  /// This method uses platform-specific implementations to block screenshots.
  static Future<void> preventScreenshotsGlobally() {
    return DashShieldPlatform.instance.preventScreenshotsGlobally();
  }

  /// Prevents both screenshots and screen recording across the app.
  ///
  /// This method uses platform-specific implementations to block both
  /// screenshots and screen recording, ensuring sensitive data cannot
  /// be captured.
  static Future<void> preventScreenshotsAndRecording() {
    return DashShieldPlatform.instance.preventScreenshotsAndRecording();
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
    if (client is Dio) {
      await SSLSecurityService.attachSSLCertificate(
          certificateAssetPath, client);
    } else {
      return await SSLSecurityService.attachSSLCertificate(
          certificateAssetPath, client);
    }
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
