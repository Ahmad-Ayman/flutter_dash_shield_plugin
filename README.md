# Dash Shield

![Dash Shield](https://img.shields.io/badge/security-robust-brightgreen.svg) ![Flutter](https://img.shields.io/badge/flutter-v3.24.3-blue.svg) ![Platform](https://img.shields.io/badge/platform-Android%20|%20IOS-green.svg)

**Dash Shield** is a comprehensive Flutter plugin built to enhance app security and streamline development processes. It offers essential tools for protecting sensitive data, including screenshot and screen recording prevention, SSL pinning for secure network connections, and flexible app integrity checks. Additionally, Dash Shield provides utilities for managing `print` statements in code, allowing you to quickly remove or wrap debug logs within `kDebugMode`. With Dash Shield, safeguarding your app and optimizing your development workflow is simple and effective.

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

- **Print Removal and Debug Management**
  - Provides tools to remove all `print` statements or wrap them with `kDebugMode` for better debug log control.
  - Helps streamline production code by eliminating or isolating debugging logs in a simple, automated way.

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

#### a) Globally for the Entire App
To prevent screenshots and recording across the entire app, use the following:

```dart
import 'package:dash_shield/dash_shield.dart';

await DashShield.preventScreenshotsGlobally();
```
This will apply a global security setting, ensuring no screen in the app can be captured or recorded.

#### b) For Specific Screens

If you need to prevent screenshots and recording only on certain screens, Dash Shield provides a targeted approach to apply security only where it’s needed. This is useful for protecting sensitive screens while leaving others unaffected.

```dart
import 'package:dash_shield/dash_shield.dart';

class SensitiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Prevent screenshots and recording when this screen is displayed
    DashShield.preventScreenshotsAndRecording();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sensitive Screen'),
      ),
      body: Center(
        child: Text('Content on this screen is secure from screenshots and recording.'),
      ),
    );
  }
}
```
In this example, calling DashShield.preventScreenshotsAndRecording() inside the build method of a specific screen will restrict screenshots and recordings only for that screen. This targeted restriction allows you to control the security of individual screens without affecting the rest of the app.

> **Tip**: Place the `preventScreenshotsAndRecording()` call at the top of the `build` method for clarity, ensuring it activates as soon as the screen is rendered.

### 2. **Apply SSL Pinning**

Dash Shield allows you to secure network connections by enforcing SSL pinning with custom certificates, preventing man-in-the-middle (MITM) attacks. This functionality is compatible with the `Dio` client for now, other clients will be supported soon.

To apply SSL pinning:

```dart
import 'package:dash_shield/dash_shield.dart';

List<String> certificatePaths = ['assets/certificates/my_cert.pem','assets/certificates/my_cert_2.crt'];
await DashShield.applySSLPinning(certificatePaths, dioClient);
```
- **certificatePaths**: A list of paths to `.pem` or `.crt` certificate files located in your assets.
- **client**: The HTTP client (such as `Dio`) used for network requests.

> **Tip**: Make sure to include your certificate files in the project’s assets and reference them in `pubspec.yaml` to ensure they load correctly.
