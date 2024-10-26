import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dash_shield_method_channel.dart';

/// The platform interface for the Dash Shield plugin, defining methods for
/// preventing screenshots and screen recording across platforms.
///
/// [DashShieldPlatform] acts as an interface between the Flutter plugin and
/// platform-specific implementations, defaulting to [MethodChannelDashShield].
///
/// Example usage:
/// ```dart
/// DashShieldPlatform.instance.preventScreenshotsGlobally();
/// DashShieldPlatform.instance.preventScreenshotsAndRecording();
/// ```
abstract class DashShieldPlatform extends PlatformInterface {
  /// Constructs a [DashShieldPlatform] instance with a verification token.
  DashShieldPlatform() : super(token: _token);

  static final Object _token = Object();

  /// The default instance of [DashShieldPlatform], which uses
  /// [MethodChannelDashShield] by default.
  static DashShieldPlatform _instance = MethodChannelDashShield();

  /// Gets the current instance of [DashShieldPlatform].
  static DashShieldPlatform get instance => _instance;

  /// Sets a new instance of [DashShieldPlatform], allowing platform-specific
  /// implementations to replace the default.
  static set instance(DashShieldPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Prevents screenshots globally for the entire app.
  ///
  /// This method relies on the platform's native code to block screenshots
  /// and screen recording across all screens. Throws [UnimplementedError]
  /// if not implemented on a platform.
  Future<void> preventScreenshotsGlobally() {
    throw UnimplementedError(
        'preventScreenshotsGlobally() has not been implemented.');
  }

  /// Prevents screenshots and screen recording for specific screens.
  ///
  /// This method restricts screenshots and recording for sensitive screens
  /// without affecting the entire app. Throws [UnimplementedError]
  /// if not implemented on a platform.
  Future<void> preventScreenshotsAndRecording() {
    throw UnimplementedError(
        'preventScreenshotsAndRecording() has not been implemented.');
  }
}
