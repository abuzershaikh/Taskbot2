// lib/phone_mockup/reset_mobile_network_settings_screen.dart
import 'package:flutter/material.dart';

class ResetMobileNetworkSettingsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const ResetMobileNetworkSettingsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: onBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reset Mobile\nNetwork Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This will reset all mobile network settings',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 32),
            Center( // Center the button horizontally
              child: ElevatedButton(
                onPressed: () {
                  print('Reset settings button tapped');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[50], // Light purple/blue color from image
                  foregroundColor: Colors.deepPurple[700],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Reset settings',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}