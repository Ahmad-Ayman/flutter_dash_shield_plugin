# 🔥 Dash Shield

![Dash Shield](https://img.shields.io/badge/security-robust-brightgreen.svg) ![Flutter](https://img.shields.io/badge/flutter-v3.24.3-blue.svg)

![Dash Shield Logo](media/dash_shield.png)




**Dash Shield** is a comprehensive Flutter plugin built to enhance app security and streamline
development processes. It offers essential tools for protecting sensitive data, including screenshot
and screen recording prevention, SSL pinning for secure network connections, and flexible app
integrity checks. Additionally, Dash Shield provides utilities for managing `print` statements in
code, allowing you to quickly remove or wrap debug logs within `kDebugMode`. With Dash Shield,
safeguarding your app and optimizing your development workflow is simple and effective.

# 📌 Requirements

To use this plugin, make sure your project meets the following minimum SDK requirements:

- **Dart SDK**: `>=2.18.0 <4.0.0`
- **Flutter SDK**: `>=3.3.0`


# 📌 Platform Support
- This Flutter package supports the following platforms:

| Platform             | Support Status | Notes                                    |
|:---------------------|:---------------|:-----------------------------------------|
| Android              | ✅ Supported    | Requires Android Sdk **23** or **Newer** |
| iOS                  | ✅ Supported    | Requires iOS **12.0** or **Newer**       |
| Web                  | ⏳ Soon         | Will be supported soon.                  |

## 🚀 Features

- **Prevent Screenshots and Screen Recording**
  - Block screenshots and screen recording on specific screens or globally across the app.
  - Ensures sensitive information is kept secure, even in visual form.

- **SSL Pinning**
  - Enforce SSL pinning with custom certificates to prevent man-in-the-middle (MITM) attacks.
  - Compatible with `Dio` client for secure network communication.

- **Application Integrity Checks**
  - Perform real-time checks to detect app integrity issues, such as debugging, device binding,
    unauthorized hooks, and more.
  - Configurable actions for each integrity check for granular control over responses.

- **Print Removal and Debug Management**
  - Provides tools to remove all `print` statements or wrap them with `kDebugMode` for better
    debug log control.
  - Helps streamline production code by eliminating or isolating debugging logs in a simple,
    automated way.

## 🚀 Installation

Add `dash_shield` to your `pubspec.yaml`:

```yaml
dependencies:
  dash_shield: ^0.0.1
```

Then, run:

```bash
flutter pub get
```

## 🚀 Getting Started

### 1. Prevent Screenshots and Recording

You can prevent screenshots and screen recording in two ways:

#### a) Globally for the Entire App

To prevent screenshots and recording across the entire app, use the following:

```dart
import 'package:dash_shield/dash_shield.dart';

await DashShield.preventScreenshotsGlobally();
```

This will apply a global security setting, ensuring no screen in the app can be captured or
recorded, and for re-allowing this programmatically use the following :

```dart
import 'package:dash_shield/dash_shield.dart';

await DashShield.allowScreenshotsGlobally();
```

#### b) For Specific Screens

If you need to prevent screenshots and recording only on certain screens, Dash Shield provides a
targeted approach to apply security only where it’s needed. This is useful for protecting sensitive
screens while leaving others unaffected, and re-allowing it when leaving this screen.

```dart
class Step2 extends StatefulWidget {
  const Step2({super.key});

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  @override
  void initState() {
    super.initState();
    /// Prevent Screenshot for this screen.
    DashShield.preventScreenshotsAndRecording();
  }

  @override
  void dispose() {
    /// Allow screenshots when leaving this screen
    DashShield.allowScreenshots(); 
    super.dispose();
  }

  @override
  void deactivate() {
    /// Allow screenshots when leaving this screen
    DashShield.allowScreenshots(); 
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensitive Screen'),
      ),
      body: Center(
              child: Text(
                      'Content on this screen is secure from screenshots and recording.')),
    );
  }
}

```

In this example, calling DashShield.preventScreenshotsAndRecording() inside the build method of a
specific screen will restrict screenshots and recordings only for that screen. This targeted
restriction allows you to control the security of individual screens without affecting the rest of
the app.

> **Tip**: Place the `preventScreenshotsAndRecording()` call at the top of the `build` method for
> clarity, ensuring it activates as soon as the screen is rendered.

### 2. **Apply SSL Pinning**

Dash Shield allows you to secure network connections by enforcing SSL pinning with custom
certificates, preventing man-in-the-middle (MITM) attacks. This functionality is compatible with
the `Dio` client for now, other clients will be supported soon.

To apply SSL pinning:

```dart
import 'package:dash_shield/dash_shield.dart';

List<String> certificatePaths = [
  'assets/certificates/my_cert.pem',
  'assets/certificates/my_cert_2.crt'
];
await DashShield.applySSLPinning(certificatePaths, dioClient);
```

- **certificatePaths**: A list of paths to `.pem` or `.crt` certificate files located in your
  assets.
- **client**: The HTTP client (such as `Dio`) used for network requests.

> **Tip**: Make sure to include your certificate files in the project’s assets and reference them
> in `pubspec.yaml` to ensure they load correctly.

### 3. **App Integrity Checks**

Dash Shield offers configurable app integrity checks to detect security vulnerabilities such as
debugging, developer mode, emulation, and more. You can tailor these checks to suit your app’s
security needs.

#### a) Define a Security Configuration

To set up integrity checks, create a `SecurityConfig` instance with the necessary parameters:

```dart
import 'package:dash_shield/dash_shield.dart';

final securityConfig = SecurityConfig(
  androidSigningCertHashes: ['sha256hash1', 'sha256hash2'],
  androidPackageName: 'com.example.app',
  iosBundleIds: ['com.example.app.ios'],
  iosTeamId: 'TEAMID',
  watcherEmail: 'security@example.com',
  enableOnAndroid: true,
  enableOniOS: true,
);
```

- **androidSigningCertHashes**: List of SHA256 hashes for Android app signing.
- **androidPackageName**: Package name for the Android app.
- **iosBundleIds**: List of iOS bundle IDs.
- **iosTeamId**: Team ID for iOS app signing.
- **watcherEmail**: Email for receiving alerts when integrity issues are detected.
- **enableOnAndroid** and **enableOniOS**: Toggles to enable or disable checks for each platform.

#### b) Initialize Security Checks

After configuring, initialize the security checks with the following:

```dart
await DashShield.initSecurity(config:securityConfig);
```

This will activate the specified integrity checks to safeguard your app.

### Custom Actions for Integrity Checks

You can define custom actions to respond to specific integrity issues:

```dart

final securityConfig = SecurityConfig(
...
checksToEnable: [SecOnControlsToApply.appIntegrity, SecOnControlsToApply.debug],
generalAction: (issue) => print('General Action Triggered: $issue'),
specificActions: {
  SecOnControlsToApply.appIntegrity: (issue) => print('App integrity check failed: $issue'),
},
);
```

- **checksToEnable**: List of specific checks to enable.
- **generalAction**: Function to execute for any detected integrity issue if no specific action is
  set.
- **specificActions**: Map of individual actions for each check, allowing for tailored responses to
  different security concerns.

> **Tip**: Setting custom actions allows you to implement different responses, like logging or
> alerting, based on the type of integrity check that fails.

### 4. **Print Removal and Replacing**

Dash Shield includes a print management tool to help you clean up or control debugging logs in your
project. This feature allows you to remove all `print` statements from your code or wrap them
with `kDebugMode`, making it easy to manage debug output in production builds.

To access the print management tool, run the following command:

```bash
dart run dash_shield:main
```

You’ll see a command-line menu with the following options:

- **Remove All Prints**: Select this option to search through your Dart files and automatically
  remove all `print` statements. This ensures that no debug logs are left in your code, streamlining
  production builds and reducing unnecessary log output.

- **Wrap All Prints with kDebugMode**: Choose this option to wrap each `print` statement
  with `kDebugMode`, making them visible only in debug mode. This is a quick way to retain useful
  debug information without exposing it in production.

![example](media/dash_plugin_prints.gif)

> **Note**: Using these options helps ensure that sensitive or unnecessary logs are managed
> efficiently in production-ready code.

## 🚀 API Reference

### Methods

#### `preventScreenshotsGlobally()`

Prevents screenshots and screen recordings globally across the app.

#### `allowScreenshotsGlobally()`

Allow screenshots and screen recordings globally across the app.

#### `preventScreenshotsAndRecording()`

Prevents screenshots and screen recordings for specific screens.

#### `allowScreenshots()`

Allow screenshots and screen recordings for specific screens.

#### `applySSLPinning(List<String> certificatePaths, dynamic client)`

Attaches SSL certificates for secure network communication with the Dio client.

#### `initSecurity({required SecurityConfig config})`

Starts app integrity checks with specified configurations for a secure app environment.

### `SecurityConfig`

The `SecurityConfig` class allows you to configure parameters for different integrity checks, SSL
certificates, and app security options.

- **Properties**:

|             Datatype              |         Parameter          | Required On Android | Required On IOS | Default Value | Description                                                                                    |
|:---------------------------------:|:--------------------------:|:-------------------:|:---------------:|:-------------:|:-----------------------------------------------------------------------------------------------|
|         List`<`String`>`          | androidSigningSHA256Hashes |          ✅          |        ❌        |      --       | List of SHA256 hashes for Android app signing.                                                 |
|              String               |  androidPackageName        |          ✅          |        ❌        |      --       | Package name for the Android app.                                                              |
|         List`<`String`>`          |        iosBundleIds        |          ❌          |        ✅        |      --       | List of iOS bundle IDs.                                                                        |
|              String               |         iosTeamId          |          ❌          |        ✅        |      --       | Team ID for iOS app signing.                                                                   |
|              String               |        watcherEmail        |          ✅          |        ✅        |      --       | Email for receiving alerts when integrity issues are detected.                                 |
|               bool                |      enableOnAndroid       |          ✅          |        ❌        |      --       | Indicates if security checks should be enabled on Android.                                     |
|               bool                |        enableOniOS         |          ❌          |        ✅        |      --       | Indicates if security checks should be enabled on IOS.                                         |
|         List`<`String`>`          |      supportedStores       |    **Optional**     |  **Optional**   |      --       | Supported app stores.                                                                          |
|               bool                |        isProduction        |    **Optional**     |  **Optional**   |     true      | Indicates if the app is in production mode.                                                    |
|  List`<`SecOnControlsToApply`>`   |       checksToEnable       |    **Optional**     |  **Optional**   |      --       | List of security checks to enable . If `null`, all security checks will be enabled by default. |

## 🚀 Troubleshooting

If you encounter any issues, please ensure:

- The `Dio` client is correctly configured for SSL pinning.
- Your certificate files are included in the project’s asset bundle and referenced correctly
  in `pubspec.yaml`.


## 🚀 Contributing

Contributions are welcome! If you have suggestions, feel free to open an issue or submit a pull
request. This is the first version of Dash Shield, and enhancements, as well as new security
features, will be added soon to improve its functionality.

Special thanks to the current contributors:

<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="20%"><a href="https://github.com/Habebaya"><img src="https://github.com/Habebaya.png" width="120px;" alt="Habeba Yasser"/><br /><p><b>Habeba Yasser</b></p></a><br /><a href="https://www.linkedin.com/in/habeba-yasser-3994a41b1/" title="LinkedIn">🔗</a> </td>
      <td align="center" valign="top" width="20%"><a href="https://github.com/ADesoky"><img src="https://github.com/ADesoky.png" width="120px;" alt="Ahmed Desoky"/><br /><p><b>Ahmed Desoky</b></p></a><br /><a href="https://www.linkedin.com/in/ahmed-m-desoky/" title="LinkedIn">🔗</a></td>
    </tr>
  </tbody>
</table>

## 🧜 License

Dash Shield is released under the MIT License.
