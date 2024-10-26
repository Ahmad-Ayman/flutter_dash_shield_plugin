import 'package:dash_shield/dash_shield.dart';
import 'package:dash_shield_example/step2.dart';
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
  getAllDio() async {
    //https://cat-fact.herokuapp.com/facts
    //https://fakestoreapi.com/products
    final respo = await ApiService.getInstance()
        .get('https://cat-fact.herokuapp.com/facts');
    print(respo.data);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dash Shield Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    DashShield.allowScreenshotsGlobally();
                  },
                  child: const Text('Press to allow screenshot')),
              ElevatedButton(
                  onPressed: () {
                    DashShield.preventScreenshotsGlobally();
                  },
                  child: const Text('Press to disable screenshot')),
              ElevatedButton(
                  onPressed: getAllDio, child: const Text('Test SSL Pinning')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Step2()));
                  },
                  child: const Text('Test prevent screenshot for single page')),
            ],
          ),
        ),
      ),
    );
  }
}
