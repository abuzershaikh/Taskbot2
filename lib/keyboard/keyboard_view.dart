import 'package:flutter/material.dart';
import 'package:taskbot2/keyboard/widgets/action_bar.dart';
import 'package:taskbot2/keyboard/widgets/keyboard_key.dart';

class KeyboardView extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final VoidCallback? onSearchPressed;

  const KeyboardView({
    super.key,
    required this.focusNode,
    required this.textEditingController,
    this.onSearchPressed, TextEditingController? controller,
  });

  @override
  Widget build(BuildContext context) {
    const keyBackgroundColor = Color(0xFFF2F3F7);
    const specialKeyBackgroundColor = Color(0xFFE4E5E9);

    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const KeyboardActionBar(),
          const SizedBox(height: 8),
          _buildKeyboardRow(['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'], keyBackgroundColor),
          _buildKeyboardRow(['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'], keyBackgroundColor),
          _buildKeyboardRow([Icons.arrow_upward, 'z', 'x', 'c', 'v', 'b', 'n', 'm', Icons.backspace], specialKeyBackgroundColor),
          _buildBottomRow(specialKeyBackgroundColor),
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(List<dynamic> keys, Color keyColor) {
    return Row(
      children: keys.map((key) {
        if (key is IconData) {
          if (key == Icons.backspace) {
            return KeyboardKey(
              label: key,
              backgroundColor: keyColor,
              onTap: () {
                if (textEditingController.text.isNotEmpty) {
                  final currentText = textEditingController.text;
                  textEditingController.text =
                      currentText.substring(0, currentText.length - 1);
                }
                focusNode.requestFocus();
              },
            );
          }
          // For other IconData keys like shift
          return KeyboardKey(label: key, backgroundColor: keyColor, onTap: () {}); // Placeholder onTap
        }
        return KeyboardKey(
          label: key.toString(),
          backgroundColor: keyColor,
          onTap: () {
            textEditingController.text += key.toString();
            focusNode.requestFocus();
          },
        );
      }).toList(),
    );
  }

  Widget _buildBottomRow(Color keyColor) {
    return Row(
      children: [
        Flexible(
            flex: 2,
            child: KeyboardKey(label: '?123', backgroundColor: keyColor, onTap: () {})), // Placeholder onTap
        Flexible(
            flex: 1,
            child: KeyboardKey(
                label: Icons.sentiment_satisfied_alt_outlined,
                backgroundColor: keyColor,
                onTap: () {})), // Placeholder onTap
        Flexible(
            flex: 1,
            child: KeyboardKey(label: Icons.language, backgroundColor: keyColor, onTap: () {})), // Placeholder onTap
        Flexible(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8.0),
                    child: const SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          "English",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  )),
            )),
        Flexible(
            flex: 1,
            child: KeyboardKey(
              label: '.',
              backgroundColor: keyColor,
              onTap: () {
                textEditingController.text += '.';
                focusNode.requestFocus();
              },
            )),
        Flexible(
            flex: 2,
            child: KeyboardKey(
                label: Icons.search,
                backgroundColor: keyColor,
                onTap: onSearchPressed, // Call the callback
                )),
      ],
    );
  }
}