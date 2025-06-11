// lib/phone_mockup/system_settings.dart

import 'package:flutter/material.dart';

class SystemSettingsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const SystemSettingsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    // Data based on the provided image
    final List<Map<String, dynamic>> systemSettingsItems = [
      {
        'icon': Icons.language,
        'title': 'Languages',
        'subtitle': 'System languages, app languages, speech'
      },
      {
        'icon': Icons.keyboard_outlined,
        'title': 'Keyboard',
        'subtitle': 'On-screen keyboard, tools'
      },
      {
        'icon': Icons.access_time,
        'title': 'Date & time',
        'subtitle': 'GMT+05:30' // Simplified subtitle
      },
      {
        'icon': Icons.people_outline,
        'title': 'Multiple users',
        'subtitle': 'Signed in as Owner'
      },
      {
        'icon': Icons.backup_outlined,
        'title': 'Backup',
        'subtitle': 'Last backup: 1 hour ago' // Example subtitle
      },
      {
        'icon': Icons.restart_alt,
        'title': 'Reset options',
        'subtitle': 'Erase data, reset Wi-Fi & Bluetooth' // Example subtitle
      },
      {
        'icon': Icons.speed_outlined,
        'title': 'Performance',
        'subtitle': 'Adaptive performance' // Example subtitle
      },
      {
        'icon': Icons.code,
        'title': 'Developer options',
        'subtitle': 'Options for development and debugging' // Example subtitle
      },
    ];

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text(
          "System",
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
        color: Colors.white, // White background for the list area
        child: ListView.separated(
          itemCount: systemSettingsItems.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            indent: 20, // Indent for the divider
            endIndent: 20,
            color: Colors.black12,
          ),
          itemBuilder: (context, index) {
            final item = systemSettingsItems[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0), // Padding for each item
              leading: Icon(
                item['icon'] as IconData,
                color: Colors.black54,
              ),
              title: Text(
                item['title'] as String,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                item['subtitle'] as String,
                maxLines: 2, // Allow up to 2 lines for subtitle
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              onTap: () {
                // Handle tap
                print('${item['title']} tapped');
              },
            );
          },
        ),
      ),
    );
  }
}