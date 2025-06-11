// lib/phone_mockup/reset_option.dart
import 'package:flutter/material.dart';

class ResetOptionScreen extends StatelessWidget {
  final VoidCallback onBack;

  const ResetOptionScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final List<String> resetOptions = [
      'Reset Mobile Network Settings',
      'Reset Bluetooth & Wi-Fi',
      'Reset app preferences',
      'Erase all data (factory reset)',
    ];

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text(
          "Reset options",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.blueGrey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: onBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView.separated(
          itemCount: resetOptions.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
            color: Colors.black12,
          ),
          itemBuilder: (context, index) {
            final option = resetOptions[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              title: Text(
                option,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                print('$option tapped');
              },
            );
          },
        ),
      ),
    );
  }
}