import 'package:flutter/material.dart';

class ClickableOutline extends StatefulWidget {
  final Widget child;
  final VoidCallback action;

  const ClickableOutline({
    Key? key,
    required this.child,
    required this.action,
  }) : super(key: key);

  @override
  ClickableOutlineState createState() => ClickableOutlineState();
}

class ClickableOutlineState extends State<ClickableOutline> {
  bool _isOutlined = false;

  void triggerOutlineAndAction() {
    setState(() {
      _isOutlined = true;
    });
    widget.action();
    // Automatically dismiss the outline after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isOutlined = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.action,
      child: Stack(
        children: [
          widget.child,
          if (_isOutlined)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(4.0), // Optional: for rounded corners
                ),
              ),
            ),
        ],
      ),
    );
  }
}
