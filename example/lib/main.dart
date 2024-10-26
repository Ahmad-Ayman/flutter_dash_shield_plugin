import 'package:dash_shield/dash_shield.dart';
import 'package:flutter/material.dart';

import 'api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await applySecurityControlsExample();
  runApp(const MyApp());
}

applySecurityControlsExample() async {
  final securityConfig = SecurityConfig(
    androidSigningSHA256Hashes: ['sha256hash1', 'sha256hash2'],
    androidPackageName: 'com.example.app',
    iosBundleIds: ['com.example.app.ios'],
    iosTeamId: 'TEAMID',
    watcherEmail: 'security@example.com',
    enableOnAndroid: true,
    enableOniOS: true,
    checksToEnable: [
      SecOnControlsToApply.appIntegrity,
      SecOnControlsToApply.debug
    ],
    generalAction: (issue) => print('General Action Triggered: $issue'),
    specificActions: {
      SecOnControlsToApply.appIntegrity: (issue) =>
          print('App integrity check failed: $issue'),
    },
  );
  await DashShield.initSecurity(config: securityConfig);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  sslPinningExample() async {
    final respo = await ApiService.getInstance().get('https://www.example.com');
    print('response: ${respo.data}');
  }

  preventScreenshotGloballyExample() async {
    await DashShield.preventScreenshotsGlobally();
  }

  preventScreenshotForScreenExample() async {
    await DashShield.preventScreenshotsAndRecording();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: sslPinningExample,
                  child: const Text('SSL Pinning')),
              ElevatedButton(
                  onPressed: preventScreenshotGloballyExample,
                  child: const Text('Prevent Screen Globally')),
              ElevatedButton(
                  onPressed: preventScreenshotForScreenExample,
                  child: const Text('Prevent Screen Specific')),
            ],
          ),
        ),
      ),
    );
  }
}
