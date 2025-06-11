import 'package:flutter/material.dart';

class ResetOptionScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNavigateToResetMobileNetwork;

  const ResetOptionScreen({
    super.key,
    required this.onBack,
    required this.onNavigateToResetMobileNetwork,
  });

  // Function to show the reset dialog
  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Reset Bluetooth & Wi-Fi'),
          content: const Text(
            "This will reset all Wi-Fi & Bluetooth settings. You can't undo this action.",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'CANCEL',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text(
                'RESET',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
                // Show a toast (SnackBar) message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Wi-Fi & Bluetooth settings have been reset.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                print('Resetting Bluetooth & Wi-Fi settings...');
                // Add actual reset logic here if needed
              },
            ),
          ],
        );
      },
    );
  }

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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              title: Text(
                option,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                if (option == 'Reset Mobile Network Settings') {
                  onNavigateToResetMobileNetwork();
                } else if (option == 'Reset Bluetooth & Wi-Fi') {
                  // Show the dialog for this option
                  _showResetDialog(context);
                } else {
                  print('$option tapped');
                  // Potentially handle other options here
                }
              },
            );
          },
        ),
      ),
    );
  }
}
