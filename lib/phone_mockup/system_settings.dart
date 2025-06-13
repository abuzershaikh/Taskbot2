// lib/phone_mockup/system_settings.dart

import 'package:flutter/material.dart';
import 'clickable_outline.dart'; // Added import

class SystemSettingsScreen extends StatefulWidget { // Changed
  final VoidCallback onBack;
  final VoidCallback onNavigateToResetOptions;

  const SystemSettingsScreen({
    super.key,
    required this.onBack,
    required this.onNavigateToResetOptions,
  });

  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState(); // Added
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> { // Added state class
  // Data moved here
  final List<Map<String, dynamic>> _systemSettingsItems = [
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
      'subtitle': 'GMT+05:30'
    },
    {
      'icon': Icons.people_outline,
      'title': 'Multiple users',
      'subtitle': 'Signed in as Owner'
    },
    {
      'icon': Icons.backup_outlined,
      'title': 'Backup',
      'subtitle': 'Last backup: 1 hour ago'
    },
    {
      'icon': Icons.restart_alt,
      'title': 'Reset options',
      'subtitle': 'Erase data, reset Wi-Fi & Bluetooth'
    },
    {
      'icon': Icons.speed_outlined,
      'title': 'Performance',
      'subtitle': 'Adaptive performance'
    },
    {
      'icon': Icons.code,
      'title': 'Developer options',
      'subtitle': 'Options for development and debugging'
    },
  ];

  final Map<String, GlobalKey<ClickableOutlineState>> _itemKeys = {};

  @override
  void initState() {
    super.initState();
    for (var item in _systemSettingsItems) {
      _itemKeys[item['title'] as String] = GlobalKey<ClickableOutlineState>();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: widget.onBack, // Use widget.onBack
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
          itemCount: _systemSettingsItems.length, // Use state variable
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
            color: Colors.black12,
          ),
          itemBuilder: (context, index) {
            final item = _systemSettingsItems[index]; // Use state variable
            final itemKey = _itemKeys[item['title'] as String];

            return ClickableOutline( // Wrap ListTile
              key: itemKey!,
              action: () async { // Define action
                if (item['title'] == 'Reset options') {
                  widget.onNavigateToResetOptions(); // Use widget.
                } else {
                  print('${item['title']} tapped');
                }
              },
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                onTap: () { // Modify onTap
                  itemKey.currentState?.triggerOutlineAndAction();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}