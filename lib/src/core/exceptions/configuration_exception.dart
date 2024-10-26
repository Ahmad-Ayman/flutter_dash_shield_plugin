import 'dash_shield_exception.dart';

/// An exception for handling configuration errors in the Dash Shield plugin.
///
/// The [ConfigurationException] is thrown when there are issues with the
/// configuration or setup within Dash Shield, allowing for clear debugging
/// of configuration-related problems.
///
/// Example usage:
/// ```dart
/// throw ConfigurationException('Invalid configuration detected.');
/// ```
class ConfigurationException extends DashShieldException {
  /// Creates a [ConfigurationException] with the given [message] and an
  /// optional [stackTrace].
  ///
  /// The [message] provides details about the configuration error, and the
  /// optional [stackTrace] can assist in debugging.
  ConfigurationException(super.message, [super.stackTrace]);

  /// Returns a string representation of the exception, including the message.
  @override
  String toString() => 'ConfigurationException: $message';
}
