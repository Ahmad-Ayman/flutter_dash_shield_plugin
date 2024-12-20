import 'package:freerasp/freerasp.dart';

import '../../core/exceptions/dash_shield_exception.dart';
import '../../core/utils/enums.dart';
import 'security_config.dart';

/// A service responsible for initiating and managing integrity checks for
/// the Dash Shield plugin.
///
/// The [IntegrityChecksService] leverages Talsec's security configurations to
/// monitor and respond to various app integrity threats, providing a flexible
/// callback mechanism for handling potential security issues.
///
/// Example usage:
/// ```dart
/// await IntegrityChecksService.startIntegrityChecks(config: securityConfig);
/// ```
class IntegrityChecksService {
  /// Starts the integrity checks based on the provided [config].
  ///
  /// This method initializes the Talsec configuration with platform-specific
  /// details from [config], attaches threat listeners, and starts the integrity
  /// monitoring.
  ///
  /// Throws a [DashShieldException] if the integrity check fails to start.
  static Future<void> startIntegrityChecks({
    required SecurityConfig config,
  }) async {
    try {
      // Retrieve the enabled security checks from the configuration
      final enabledChecks = config.getEnabledChecks();
      List<String> base64Hashes = [];
      if (config.androidSigningSHA256Hashes != null &&
          config.androidSigningSHA256Hashes!.isNotEmpty) {
        for (var hash in config.androidSigningSHA256Hashes!) {
          base64Hashes.add(hashConverter.fromSha256toBase64(hash));
        }
      }
      // Configure Talsec based on platform and security requirements
      final talsecConfig = TalsecConfig(
        androidConfig: config.enableOnAndroid
            ? AndroidConfig(
                packageName: config.androidPackageName!,
                signingCertHashes: base64Hashes,
                supportedStores: config.supportedStores ?? [],
              )
            : null,
        iosConfig: config.enableOniOS
            ? IOSConfig(
                bundleIds: config.iosBundleIds!,
                teamId: config.iosTeamId!,
              )
            : null,
        watcherMail: config.watcherEmail,
        isProd: config.isProduction,

      );

      // Set up threat detection callbacks
      final callback = _buildThreatCallback(config, enabledChecks);

      // Attach the callback and start integrity monitoring
      Talsec.instance.attachListener(callback);
      await Talsec.instance.start(talsecConfig);
    } catch (e) {
      throw DashShieldException(
        'IntegrityChecksService Error: Failed to start integrity checks: ${e.toString()}',
      );
    }
  }

  /// Builds a callback function to handle detected threats based on enabled checks.
  ///
  /// [config] specifies the security configuration, while [enabledChecks]
  /// determines which checks are active and what actions to take for each.
  static ThreatCallback _buildThreatCallback(
      SecurityConfig config, List<SecOnControlsToApply> enabledChecks) {
    return ThreatCallback(
      onAppIntegrity: () => _handleCheck(config, enabledChecks,
          SecOnControlsToApply.appIntegrity, 'App Integrity'),
      onObfuscationIssues: () => _handleCheck(config, enabledChecks,
          SecOnControlsToApply.obfuscationIssues, 'Obfuscation issues'),
      onDebug: () => _handleCheck(
          config, enabledChecks, SecOnControlsToApply.debug, 'Debugging'),
      onDeviceBinding: () => _handleCheck(config, enabledChecks,
          SecOnControlsToApply.deviceBinding, 'Device binding'),
      onHooks: () => _handleCheck(
          config, enabledChecks, SecOnControlsToApply.hooks, 'Hooks'),
      onPasscode: () => _handleCheck(config, enabledChecks,
          SecOnControlsToApply.onPasscode, 'Passcode not set'),
      onPrivilegedAccess: () => _handleCheck(config, enabledChecks,
          SecOnControlsToApply.privilegedAccess, 'Privileged access'),
      onSecureHardwareNotAvailable: () => _handleCheck(
          config,
          enabledChecks,
          SecOnControlsToApply.secureHardwareNotAvailable,
          'Secure hardware not available'),
      onSimulator: () => _handleCheck(config, enabledChecks,
          SecOnControlsToApply.simulator, 'Simulator/Emulator Detected'),
      onSystemVPN: () => _handleCheck(
          config, enabledChecks, SecOnControlsToApply.systemVPN, 'System VPN'),
      onDevMode: () => _handleCheck(config, enabledChecks,
          SecOnControlsToApply.devMode, 'Developer mode'),
      onUnofficialStore: () => _handleCheck(config, enabledChecks,
          SecOnControlsToApply.unofficialStore, 'Unofficial store'),
      onADBEnabled: ()=> _handleCheck(config, enabledChecks,
          SecOnControlsToApply.onADBEnabled, 'USB debugging enabled'),

    );
  }

  /// Executes the action associated with a specific security check [check].
  ///
  /// [config] provides the configuration details for determining the action,
  /// [enabledChecks] specifies which checks are enabled, and [issue] is a
  /// description of the detected threat.
  ///
  /// Throws a [DashShieldException] if there is an error executing the action.
  static void _handleCheck(
      SecurityConfig config,
      List<SecOnControlsToApply> enabledChecks,
      SecOnControlsToApply check,
      String issue) {
    try {
      // Check if this specific security check is enabled
      if (enabledChecks.contains(check)) {
        // Get the action for this check or fallback to the general action
        final action = config.getActionForCheck(check);
        action(issue); // Execute the action
      }
    } catch (e) {
      throw DashShieldException(
        'IntegrityChecksService Error: Failed to execute action for check $check: ${e.toString()}',
      );
    }
  }
}
