import 'package:flutter/material.dart';

class SecurityOverlay extends StatefulWidget {
  final Widget child;
  final String overlayText;
  final Color overlayColor;

  const SecurityOverlay({
    Key? key,
    required this.child,
    this.overlayText = 'App in Background',
    this.overlayColor = Colors.white,
  }) : super(key: key);

  @override
  _SecurityOverlayState createState() => _SecurityOverlayState();
}

class _SecurityOverlayState extends State<SecurityOverlay>
    with WidgetsBindingObserver {
  bool _isInBackground = false;

  @override
  void initState() {
    super.initState();
    print('initState');
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    print('disposed');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      print('didChangeAppLifecycleState -- ${state.name}');
      _isInBackground = (state == AppLifecycleState.paused) ||
          (state == AppLifecycleState.inactive);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isInBackground)
          Positioned.fill(
            child: Container(
              color: widget.overlayColor,
              child: Center(
                child: Text(
                  widget.overlayText,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
