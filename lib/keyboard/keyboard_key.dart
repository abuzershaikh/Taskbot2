import 'package:flutter/material.dart';

class KeyboardKey extends StatelessWidget {
  final dynamic label;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final double width;

  const KeyboardKey({
    super.key,
    required this.label,
    this.onTap,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    this.width = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8.0),
            child: SizedBox(
              height: 50,
              child: Center(
                child: label is String
                    ? Text(
                        label,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          color: foregroundColor,
                        ),
                      )
                    : Icon(
                        label as IconData,
                        color: foregroundColor,
                        size: 22,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}