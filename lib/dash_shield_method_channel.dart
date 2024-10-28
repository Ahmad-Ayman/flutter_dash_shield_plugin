import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dash_shield_platform_interface.dart';

class MethodChannelDashShield extends DashShieldPlatform {
  static const methodChannel = MethodChannel('dash_shield');
  static OverlayEntry? _overlayEntry;
  BuildContext? _context;

  MethodChannelDashShield();

  @override
  void initialize(BuildContext context) {
    _context = context;
    methodChannel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "onScreenCaptureDetected") {
        if (_context != null) {
          _showSecurityOverlay(_context!);
        }
      }
    });
  }

  static void _showSecurityOverlay(BuildContext context,
      {Widget? customWidget}) {
    if (_overlayEntry != null) return; // Prevent multiple overlays

    _overlayEntry = OverlayEntry(
      builder: (context) => ScreenCaptureOverlay(customWidget: customWidget),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  static void removeSecurityOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Future<void> secureApp({Widget? customWidget}) async {
    await methodChannel.invokeMethod('secureApp', {
      'customWidget': customWidget != null,
    });
  }

  @override
  Future<void> secureScreen(String screenName, {Widget? customWidget}) async {
    await methodChannel.invokeMethod('secureScreen', {
      'screenName': screenName,
      'customWidget': customWidget != null,
    });
  }
}

/// Overlay widget displayed during screen capture attempts
class ScreenCaptureOverlay extends StatelessWidget {
  final Widget? customWidget;

  ScreenCaptureOverlay({this.customWidget});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: customWidget ?? DefaultSecurityWidget(),
      ),
    );
  }
}

/// Default widget shown if no custom widget is provided
class DefaultSecurityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Screen capture restricted",
      style: TextStyle(color: Colors.white, fontSize: 24),
      textAlign: TextAlign.center,
    );
  }
}
