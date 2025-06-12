import 'package:flutter/material.dart';
import 'package:taskbot2/keyboard/keyboard_view.dart';

class KeyboardScreen extends StatefulWidget {
  const KeyboardScreen({super.key});

  @override
  State<KeyboardScreen> createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends State<KeyboardScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keyboard UI Demo"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: TextField(
                  focusNode: _focusNode,
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tap here to use keyboard',
                  ),
                ),
              ),
            ),
          ),
          // This is where the keyboard is displayed
          KeyboardView(
            focusNode: _focusNode,
            textEditingController: _textEditingController,
          ),
        ],
      ),
    );
  }
}