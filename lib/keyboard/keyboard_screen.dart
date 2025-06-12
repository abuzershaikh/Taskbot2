import 'package:flutter/material.dart';
import 'package:taskbot2/keyboard/keyboard_view.dart';

class KeyboardScreen extends StatelessWidget {
  const KeyboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keyboard UI Demo"),
      ),
      body: Column(
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tap here to use keyboard',
                  ),
                ),
              ),
            ),
          ),
          // This is where the keyboard is displayed
          const KeyboardView(),
        ],
      ),
    );
  }
}