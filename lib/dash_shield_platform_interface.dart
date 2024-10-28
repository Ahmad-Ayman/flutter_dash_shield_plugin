import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'dash_shield_method_channel.dart';

abstract class DashShieldPlatform extends PlatformInterface {
  DashShieldPlatform() : super(token: _token);

  static final Object _token = Object();
  static DashShieldPlatform _instance = MethodChannelDashShield();

  static DashShieldPlatform get instance => _instance;

  static set instance(DashShieldPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void initialize(BuildContext context);

  Future<void> secureApp({Widget? customWidget});
  Future<void> secureScreen(String screenName, {Widget? customWidget});
}
