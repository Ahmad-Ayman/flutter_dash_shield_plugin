import 'dart:io';

import '../exceptions/configuration_exception.dart';
import '../exceptions/dash_shield_exception.dart';
import '../exceptions/ssl_exception.dart';

/// A centralized exception handler for managing various types of errors in
/// the Dash Shield plugin.
///
/// The [ExceptionHandler] provides a standardized method to handle
/// exceptions, transforming them into more specific [DashShieldException] types
/// when appropriate.
///
/// Example usage:
/// ```dart
/// try {
///   // Code that may throw an exception
/// } catch (e, stackTrace) {
///   ExceptionHandler.handleError(e, stackTrace);
/// }
/// ```
class ExceptionHandler {
  /// Handles an error [e] with an optional [stackTrace] and rethrows it as a
  /// more specific exception.
  ///
  /// - If the error is an [IOException], it throws an [SSLException] with a
  ///   descriptive message.
  /// - If the error is a [DashShieldException], it rethrows the exception
  ///   as is.
  /// - For any other error, it throws a [ConfigurationException] with a
  ///   message indicating an unknown error.
  static void handleError(dynamic e, [StackTrace? stackTrace]) {
    if (e is IOException) {
      throw SSLException(
          'An SSL or IO error occurred: ${e.toString()}', stackTrace);
    } else if (e is DashShieldException) {
      throw e;
    } else {
      throw ConfigurationException(
          'An unknown error occurred: ${e.toString()}', stackTrace);
    }
  }
}
