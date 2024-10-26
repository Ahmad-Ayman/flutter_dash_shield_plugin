import 'dart:io';

/// A service for modifying `print` statements within Dart files in a Flutter project.
///
/// The [PrintModificationService] class provides functionality to remove `print`
/// statements or wrap them with `kDebugMode` checks, allowing you to control
/// logging in development versus production environments.
///
/// Example usage:
/// ```dart
/// await PrintModificationService.removePrints();
/// await PrintModificationService.wrapPrintsWithDebugModeChecker();
/// ```
class PrintModificationService {
  /// Import statement for `kDebugMode`, added if not present in files that
  /// need `print` statements wrapped.
  static const String importStatement =
      "import 'package:flutter/foundation.dart';";

  /// Removes all `print` statements from Dart files within the `lib` directory.
  ///
  /// This method scans all `.dart` files recursively in the `lib` directory
  /// and removes lines that contain `print` statements. It is useful for
  /// cleaning up debug logs in production-ready code.
  static Future<void> removePrints() async {
    RegExp regExp =
        RegExp(r"^print\([^)]*\);", multiLine: true, caseSensitive: true);
    const String pathToLib = 'lib';
    Directory dir = Directory(pathToLib);
    List<FileSystemEntity> contents = dir.listSync(recursive: true);
    List<String> dartFiles = [];

    // Collect all Dart file paths in the lib directory
    for (FileSystemEntity fileSystemEntity in contents) {
      if (fileSystemEntity.path.endsWith('.dart')) {
        dartFiles.add(fileSystemEntity.path);
      }
    }

    // Process each Dart file, removing `print` statements
    for (String fileName in dartFiles) {
      File file = File(fileName);
      String fileContent = await file.readAsString();
      List<String> lines = fileContent.split('\n');

      for (int i = 0; i < lines.length; i++) {
        if (regExp.hasMatch(lines[i].trim())) {
          lines.removeAt(i); // Remove the print statement
        }
      }

      file.writeAsStringSync(lines.join('\n'));
    }
  }

  /// Wraps all `print` statements with a `kDebugMode` check in Dart files
  /// within the `lib` directory.
  ///
  /// This method scans all `.dart` files recursively in the `lib` directory
  /// and wraps any standalone `print` statements with an `if (kDebugMode)` block,
  /// ensuring they only execute in debug mode. It also adds the required
  /// `import 'package:flutter/foundation.dart';` if missing.
  static Future<void> wrapPrintsWithDebugModeChecker() async {
    RegExp regExp =
        RegExp(r"^print\([^)]*\);", multiLine: true, caseSensitive: true);
    RegExp kDebugModeRegExp = RegExp(
        r"if\s*\(kDebugMode\)\s*\{"); // Regex for detecting if (kDebugMode) block

    const String pathToLib = 'lib';
    Directory dir = Directory(pathToLib);
    List<FileSystemEntity> contents = dir.listSync(recursive: true);
    List<String> dartFiles = [];

    // Collect all Dart file paths in the lib directory
    for (FileSystemEntity fileSystemEntity in contents) {
      if (fileSystemEntity.path.endsWith('.dart')) {
        dartFiles.add(fileSystemEntity.path);
      }
    }

    // Process each Dart file, wrapping `print` statements
    for (String fileName in dartFiles) {
      File file = File(fileName);
      String fileContent = await file.readAsString();
      List<String> lines = fileContent.split('\n');
      int counterForPrints = 0;
      bool insideDebugModeBlock = false;

      for (int i = 0; i < lines.length; i++) {
        String line = lines[i].trim();

        if (kDebugModeRegExp.hasMatch(line)) {
          // Entering an `if (kDebugMode)` block
          insideDebugModeBlock = true;
        } else if (insideDebugModeBlock && line == '}') {
          // Exiting an `if (kDebugMode)` block
          insideDebugModeBlock = false;
        }

        if (regExp.hasMatch(lines[i].trim()) && !insideDebugModeBlock) {
          counterForPrints++;

          // Wrap the print statement in an if (kDebugMode) block
          String printStatement = lines[i].trim();
          lines[i] = 'if (kDebugMode) {\n  $printStatement\n}';
        }
      }

      // Add the import statement if any print statements were wrapped and the import is missing
      if (counterForPrints > 0 && !fileContent.contains(importStatement)) {
        lines.insert(0, importStatement);
      }

      file.writeAsStringSync(lines.join('\n'));
    }
  }
}
