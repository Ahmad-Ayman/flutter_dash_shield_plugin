# Dash Shield

![Dash Shield](https://img.shields.io/badge/security-robust-brightgreen.svg) ![Flutter](https://img.shields.io/badge/flutter-v3.24.3-blue.svg) ![Platform](https://img.shields.io/badge/platform-Android%20|%20IOS-green.svg)

**Dash Shield** is a powerful Flutter plugin designed to enhance the security of your mobile applications. It provides a suite of robust tools to prevent unauthorized screenshots, screen recording, and ensure secure network communication with SSL pinning. With Dash Shield, you can easily integrate essential security measures to protect sensitive data and reinforce application integrity.

## Features

- **Prevent Screenshots and Screen Recording**
   - Block screenshots and screen recording on specific screens or globally across the app.
   - Ensures sensitive information is kept secure, even in visual form.

- **SSL Pinning**
   - Enforce SSL pinning with custom certificates to prevent man-in-the-middle (MITM) attacks.
   - Compatible with `Dio` client for secure network communication.

- **Application Integrity Checks**
   - Perform real-time checks to detect app integrity issues, such as debugging, device binding, unauthorized hooks, and more.
   - Configurable actions for each integrity check for granular control over responses.

## Installation

Add `dash_shield` to your `pubspec.yaml`:

```yaml
dependencies:
  dash_shield: ^1.0.0
```
Then, run:
```bash
flutter pub get
```

## Getting Started
### 1. Prevent Screenshots and Recording
You can prevent screenshots and screen recording in two ways:

### a) Globally for the Entire App
```dart
import 'package:dash_shield/dash_shield.dart';

await DashShield.preventScreenshotsGlobally();
```
### b) For Specific Screens
```dart
import 'package:dash_shield/dash_shield.dart';

await DashShield.preventScreenshotsAndRecording();
```