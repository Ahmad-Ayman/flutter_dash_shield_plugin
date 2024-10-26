/// A custom exception for the Dash Shield plugin, providing detailed error
/// messages and optional stack trace information.
///
/// The [DashShieldException] is designed to handle and display specific
/// exception messages related to the security features in Dash Shield.
///
/// Example usage:
/// ```dart
/// throw DashShieldException('An error occurred in Dash Shield.');
/// ```
class DashShieldException implements Exception {
  /// The error message that describes the exception.
  final String message;

  /// An optional stack trace associated with the exception.
  final StackTrace? stackTrace;

  /// Creates a [DashShieldException] with the given [message] and an optional
  /// [stackTrace].
  ///
  /// The [message] provides a description of the exception.
  /// The optional [stackTrace] parameter can be used to pass a stack trace for
  /// debugging purposes.
  DashShieldException(this.message, [this.stackTrace]);

  /// Returns a string representation of the exception, including the
  /// message.
  @override
  String toString() => 'DashShieldException: $message';
}
