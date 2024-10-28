import 'package:dash_shield/dash_shield_method_channel.dart';
import 'package:dash_shield/dash_shield_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDashShieldPlatform
    with MockPlatformInterfaceMixin
    implements DashShieldPlatform {
  @override
  Future<void> preventScreenshotsAndRecording() {
    // TODO: implement preventScreenshotsAndRecording
    throw UnimplementedError();
  }

  @override
  Future<void> preventScreenshotsGlobally() {
    // TODO: implement preventScreenshotsGlobally
    throw UnimplementedError();
  }

  @override
  Future<void> allowScreenshots() {
    // TODO: implement allowScreenshots
    throw UnimplementedError();
  }

  @override
  Future<void> allowScreenshotsGlobally() {
    // TODO: implement allowScreenshotsGlobally
    throw UnimplementedError();
  }
}

void main() {
  final DashShieldPlatform initialPlatform = DashShieldPlatform.instance;

  test('$MethodChannelDashShield is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDashShield>());
  });
}
