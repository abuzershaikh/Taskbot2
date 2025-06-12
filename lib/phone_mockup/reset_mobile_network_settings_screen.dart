// lib/phone_mockup/reset_mobile_network_settings_screen.dart
import 'package:flutter/material.dart';

class ResetMobileNetworkSettingsScreen extends StatefulWidget {
  final VoidCallback onBack;
  final void Function(String message, {Duration duration}) showInternalToast;

  const ResetMobileNetworkSettingsScreen({
    super.key,
    required this.onBack,
    required this.showInternalToast,
  });

  @override
  State<ResetMobileNetworkSettingsScreen> createState() =>
      _ResetMobileNetworkSettingsScreenState();
}

class _ResetMobileNetworkSettingsScreenState
    extends State<ResetMobileNetworkSettingsScreen> {
  bool _isConfirmationStep = false;

  void _handleReset() {
    if (!_isConfirmationStep) {
      // First tap: move to confirmation step
      setState(() {
        _isConfirmationStep = true;
      });
    } else {
      // Second tap: perform reset, show toast, and navigate back
      widget.showInternalToast(
        'Network settings have been reset',
        duration: const Duration(seconds: 2),
      );
      // Wait for the SnackBar to be visible before navigating back
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          widget.onBack();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: widget.onBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title is always visible
            const Text(
              'Reset Mobile\nNetwork Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Conditional description text
            if (!_isConfirmationStep)
              const Text(
                'This will reset all mobile network settings',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

            if (_isConfirmationStep)
              const Text(
                "Reset all network settings? You can't undo this action.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _handleReset,
                style: ElevatedButton.styleFrom(
                  // Change button color for confirmation step to match screenshot
                  backgroundColor: _isConfirmationStep
                      ? Colors.amber[300]
                      : Colors.deepPurple[50],
                  foregroundColor: _isConfirmationStep
                      ? Colors.black87
                      : Colors.deepPurple[700],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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