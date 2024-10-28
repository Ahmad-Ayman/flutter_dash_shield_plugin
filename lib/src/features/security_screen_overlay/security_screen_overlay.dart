import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DashShieldOverlay extends StatefulWidget {
  final Widget child;
  final Widget overlayWidget;

  const DashShieldOverlay({
    super.key,
    required this.child,
    required this.overlayWidget,
  });

  @override
  _SecurityOverlayState createState() => _SecurityOverlayState();
}

class _SecurityOverlayState extends State<DashShieldOverlay>
    with WidgetsBindingObserver {
  bool _isInBackground = false;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('initState');
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print('disposed');
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (kDebugMode) {
        print('didChangeAppLifecycleState -- ${state.name.toString()}');
      }
      _isInBackground = (state == AppLifecycleState.paused) ||
          (state == AppLifecycleState.inactive);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          widget.child,
          if (_isInBackground) Positioned.fill(child: widget.overlayWidget),
        ],
      ),
    );
  }
}
