import '../../core/utils/enums.dart';
import '../../core/utils/toaster_helper.dart';

/// A configuration class for setting up security options within the Dash Shield plugin.
///
/// The [SecurityConfig] class defines settings for various security checks, supported
/// platforms, and response actions. It ensures that required parameters are set
/// according to the platform being used, providing flexibility for both Android
/// and iOS configurations.
///
/// Example usage:
/// ```dart
/// SecurityConfig(
///   androidSigningSHA256Hashes: ['sha256hash1', 'sha256hash2'],
///   androidPackageName: 'com.example.app',
///   iosBundleIds: ['com.example.app.ios'],
///   iosTeamId: 'TEAMID',
///   watcherEmail: 'security@example.com',
///   enableOnAndroid: true,
///   enableOniOS: true,
/// );
/// ```
class SecurityConfig {
  /// SHA256 hashes for Android app signing certificates (required for Android).
  final List<String>? androidSigningSHA256Hashes;

  /// Package name for Android (required for Android).
  final String? androidPackageName;

  /// iOS Bundle IDs (required for iOS).
  final List<String>? iosBundleIds;

  /// Team ID for iOS (required for iOS).
  final String? iosTeamId;

  /// Supported app stores (optional).
  final List<String>? supportedStores;

  /// Email address for receiving security alerts (required).
  final String watcherEmail;

  /// Indicates if the app is in production mode; defaults to `true`.
  final bool isProduction;

  /// List of security checks to enable (optional).
  ///
  /// If `null`, all security checks will be enabled by default.
  final List<SecOnControlsToApply>? checksToEnable;

  /// The general action to take when a security issue is detected.
  ///
  /// This function is invoked for any issues unless a more specific action is
  /// specified.
  final void Function(String)? generalAction;

  /// A map of specific actions to take for each security check.
  ///
  /// If `null`, the general action will be applied for all checks.
  final Map<SecOnControlsToApply, void Function(String)>? specificActions;

  /// Indicates if security checks should be enabled on Android.
  final bool enableOnAndroid;

  /// Indicates if security checks should be enabled on iOS.
  final bool enableOniOS;

  /// Constructs a [SecurityConfig] instance with specified options and validates required fields.
  ///
  /// The constructor uses asserts to ensure platform-specific fields are provided
  /// based on the selected platforms. For Android, [androidPackageName] and
  /// [androidSigningSHA256Hash] are required if [enableOnAndroid] is true. For
  /// iOS, [iosTeamId] and [iosBundleIds] are required if [enableOniOS] is true.
  ///
  /// Additionally, [watcherEmail] must not be empty, and at least one platform
  /// must be enabled.
  SecurityConfig({
    this.androidSigningSHA256Hashes,
    this.androidPackageName,
    this.iosBundleIds,
    this.iosTeamId,
    this.supportedStores,
    required this.watcherEmail,
    this.isProduction = true,
    this.checksToEnable,
    this.generalAction,
    this.specificActions,
    required this.enableOnAndroid,
    required this.enableOniOS,
  }) {
    // Assert validations based on platform requirements
    assert(
      enableOnAndroid
          ? androidPackageName != null &&
              androidSigningSHA256Hashes != null &&
              androidSigningSHA256Hashes!.isNotEmpty
          : true,
      'Android package name and signing certificate hashes are required when Android checks are enabled.',
    );

    assert(
      enableOniOS
          ? iosTeamId != null &&
              iosBundleIds != null &&
              iosBundleIds!.isNotEmpty
          : true,
      'iOS team ID and bundle IDs are required when iOS checks are enabled.',
    );

    assert(
      enableOnAndroid || enableOniOS,
      'At least one platform (Android or iOS) must be enabled for checks.',
    );
    assert(watcherEmail.isNotEmpty, "Can't leave watcher email empty");
  }

  /// Retrieves the list of enabled security checks.
  ///
  /// If [checksToEnable] is `null`, all available checks will be returned.
  List<SecOnControlsToApply> getEnabledChecks() {
    return checksToEnable ?? SecOnControlsToApply.values;
  }

  /// Determines the appropriate action for a specified security [check].
  ///
  /// - If a specific action is mapped to [check] in [specificActions], it is returned.
  /// - If no specific action is found, the [generalAction] is used.
  /// - If neither is provided, a default toast message is shown using [AppToast.showToastWithoutContext].
  void Function(String issue) getActionForCheck(SecOnControlsToApply check) {
    return specificActions?[check] ??
        (generalAction ?? (issue) => AppToast.showToastWithoutContext(issue));
  }
}
