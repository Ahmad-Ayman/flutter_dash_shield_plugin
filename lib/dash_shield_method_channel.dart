import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dash_shield_platform_interface.dart';

/// An implementation of [DashShieldPlatform] that uses method channels to
/// communicate with native platform code for security features.
///
/// [MethodChannelDashShield] provides methods for preventing screenshots and
/// screen recording, interacting with platform-specific implementations through
/// method channels.
///
/// Example usage:
/// ```dart
/// MethodChannelDashShield().preventScreenshotsGlobally();
/// MethodChannelDashShield().preventScreenshotsAndRecording();
/// ```
class MethodChannelDashShield extends DashShieldPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dash_shield');

  /// Prevents screenshots globally across the app using native platform methods.
  ///
  /// This method invokes the `preventScreenshotsGlobally` method on the native
  /// platform to set security flags for the entire app, blocking screenshots
  /// and screen recording. If an error occurs, a [PlatformException] is thrown
  /// with a descriptive error message.
  @override
  Future<void> preventScreenshotsGlobally() async {
    try {
      await methodChannel.invokeMethod('preventScreenshotsGlobally');
    } on PlatformException catch (e) {
      throw 'Failed to globally prevent screenshots: ${e.message}';
    }
  }

  /// Allows screenshots globally across the app using native platform methods.
  ///
  /// This method invokes the `allowScreenshotsGlobally` method on the native
  /// platform to clear security flags across the entire app, enabling screenshots
  /// and screen recording. If an error occurs, a [PlatformException] is thrown
  /// with a descriptive error message.
  @override
  Future<void> allowScreenshotsGlobally() async {
    try {
      await methodChannel.invokeMethod('allowScreenshotsGlobally');
    } on PlatformException catch (e) {
      throw 'Failed to globally allow screenshots: ${e.message}';
    }
  }

  /// Prevents both screenshots and screen recording for specific screens using
  /// native platform methods.
  ///
  /// This method invokes the `preventScreenshots` method on the native
  /// platform. It is intended for restricting screenshots on specific
  /// screens rather than the entire app. If an error occurs, a [PlatformException]
  /// is thrown with a descriptive error message.
  @override
  Future<void> preventScreenshotsAndRecording() async {
    try {
      await methodChannel.invokeMethod('preventScreenshots');
    } on PlatformException catch (e) {
      throw 'Failed to prevent screenshots: ${e.message}';
    }
  }

  /// Allows screenshots for the current screen only using native platform methods.
  ///
  /// This method invokes the `allowScreenshots` method on the native platform,
  /// clearing security flags for the current screen. This enables screenshots
  /// and screen recording specifically on this screen, if previously restricted.
  /// If an error occurs, a [PlatformException] is thrown with a descriptive error message.
  @override
  Future<void> allowScreenshots() async {
    try {
      await methodChannel.invokeMethod('allowScreenshots');
    } on PlatformException catch (e) {
      throw 'Failed to allow screenshots on this screen: ${e.message}';
    }
  }
}
