import 'dash_shield_exception.dart';

/// An exception for handling SSL-related errors in the Dash Shield plugin.
///
/// The [SSLException] extends [DashShieldException] and is used to capture
/// errors specifically related to SSL (Secure Sockets Layer) operations
/// within Dash Shield.
///
/// Example usage:
/// ```dart
/// throw SSLException('SSL certificate validation failed.');
/// ```
class SSLException extends DashShieldException {
  /// Creates an [SSLException] with the given [message] and an optional
  /// [stackTrace].
  ///
  /// The [message] provides details about the SSL-related error, and the
  /// optional [stackTrace] assists in debugging.
  SSLException(super.message, [super.stackTrace]);

  /// Returns a string representation of the exception, including the message.
  @override
  String toString() => 'SSLException: $message';
}
