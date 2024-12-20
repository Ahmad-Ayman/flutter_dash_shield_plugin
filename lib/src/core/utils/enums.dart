/// Defines the various security controls that can be applied in the Dash Shield plugin.
///
/// The [SecOnControlsToApply] enum represents different security checks and controls
/// that Dash Shield can enforce to enhance application security.
///
/// Each option corresponds to a specific security control, allowing developers
/// to select and apply various security measures.
///
/// Available options:
/// - [appIntegrity]: Checks the app's integrity.
/// - [obfuscationIssues]: Detects potential obfuscation-related issues.
/// - [debug]: Detects if the app is running in debug mode.
/// - [deviceBinding]: Enforces device binding for enhanced security.
/// - [hooks]: Detects the presence of unauthorized hooks.
/// - [onPasscode]: Checks for passcode or device lock security.
/// - [privilegedAccess]: Detects privileged or root access.
/// - [secureHardwareNotAvailable]: Checks if secure hardware is unavailable.
/// - [simulator]: Detects if the app is running on a simulator.
/// - [systemVPN]: Detects the use of system VPN.
/// - [devMode]: Detects if the device is in developer mode.
/// - [unofficialStore]: Detects if the app is installed from an unofficial store.
enum SecOnControlsToApply {
  appIntegrity,
  obfuscationIssues,
  debug,
  deviceBinding,
  hooks,
  onPasscode,
  privilegedAccess,
  secureHardwareNotAvailable,
  simulator,
  systemVPN,
  devMode,
  onADBEnabled,
  unofficialStore,
}
