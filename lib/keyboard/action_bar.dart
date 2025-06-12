import 'package:flutter/material.dart';

class KeyboardActionBar extends StatelessWidget {
  const KeyboardActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.grid_view_rounded),
          const Text('GIF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Icon(Icons.settings_outlined),
          const Icon(Icons.palette_outlined),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(4)
            ),
            child: const Icon(Icons.camera_alt_outlined, size: 18,)
          ),
          const Icon(Icons.mic_none_outlined),
        ],
      ),
    );
  }
}