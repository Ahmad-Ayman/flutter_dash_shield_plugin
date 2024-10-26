import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// A utility class for displaying toast notifications in the Dash Shield plugin.
///
/// The [AppToast] class provides a simple way to show toast messages without
/// requiring a `BuildContext`, making it convenient for displaying quick
/// notifications or error messages.
///
/// Example usage:
/// ```dart
/// AppToast.showToastWithoutContext('This is a toast message');
/// ```
class AppToast {
  /// Displays a toast notification at the bottom of the screen with the given [message].
  ///
  /// - [message]: The text to display in the toast.
  ///
  /// The toast has a red background color, white text color, and appears at
  /// the bottom of the screen for a long duration.
  static showToastWithoutContext(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}
