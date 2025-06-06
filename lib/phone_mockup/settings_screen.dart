import 'package:flutter/material.dart';
import 'clickable_outline.dart'; // Added import
// ignore: unused_import
import 'phone_mockup/connection_sharing_screen.dart'; // Import the new screen
import 'phone_mockup_container.dart'; // For AppItemTapCallback

class SettingsScreen extends StatefulWidget { // Changed to StatefulWidget
  final VoidCallback onBack;
  final AppItemTapCallback? onSettingItemTap;
  const SettingsScreen({super.key, required this.onBack, this.onSettingItemTap});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> { // New State class
  // Define GlobalKeys for each interactive ListTile
  final Map<String, GlobalKey<ClickableOutlineState>> _settingsKeys = {};

  // Data for settings items - moved here to be accessible for key initialization
  final List<Map<String, dynamic>> primarySettingsData = [
    {'icon': Icons.wifi, 'title': 'Wi-Fi', 'trailing': 'Off', 'isToggle': false},
    {'icon': Icons.swap_vert, 'title': 'Mobile network', 'trailing': null},
    {'icon': Icons.bluetooth, 'title': 'Bluetooth', 'trailing': 'Off'},
    {'icon': Icons.share, 'title': 'Connection & sharing', 'trailing': null},
  ];

  final List<Map<String, dynamic>> displaySettingsData = [
    {'icon': Icons.palette_outlined, 'title': 'Wallpapers & style', 'trailing': null},
    {'icon': Icons.apps, 'title': 'Home screen & Lock screen', 'trailing': null},
    {'icon': Icons.wb_sunny_outlined, 'title': 'Display & brightness', 'trailing': null},
    {'icon': Icons.volume_up_outlined, 'title': 'Sound & vibration', 'trailing': null},
    {'icon': Icons.notifications_none, 'title': 'Notification & status bar', 'trailing': null},
  ];

  final List<Map<String, dynamic>> appSecuritySettingsData = [
    {'icon': Icons.apps, 'title': 'Apps', 'trailing': null},
    {'icon': Icons.security_outlined, 'title': 'Password & security', 'trailing': null},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize keys
    for (var item in primarySettingsData) {
      _settingsKeys[item['title'] as String] = GlobalKey<ClickableOutlineState>();
    }
    for (var item in displaySettingsData) {
      _settingsKeys[item['title'] as String] = GlobalKey<ClickableOutlineState>();
    }
    for (var item in appSecuritySettingsData) {
      _settingsKeys[item['title'] as String] = GlobalKey<ClickableOutlineState>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blueGrey[50],
        elevation: 0,
        leading: IconButton( // Back button remains IconButton
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: widget.onBack,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsCard(context, primarySettingsData),
          const SizedBox(height: 16),
          _buildSettingsCard(context, displaySettingsData),
          const SizedBox(height: 16),
          _buildSettingsCard(context, appSecuritySettingsData),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Map<String, dynamic>> items) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: items.map((item) {
            final itemTitle = item['title'] as String;
            final itemKey = _settingsKeys[itemTitle];

            return Column(
              children: [
                ClickableOutline( // Wrap ListTile with ClickableOutline
                  key: itemKey!, // Use the non-nullable key here
                  action: () async { // Make action async
                    if (widget.onSettingItemTap != null) {
                      Map<String, String> stringItemDetails = {};
                      item.forEach((key, value) {
                        stringItemDetails[key] = value.toString();
                      });
                      // Pass the item's title and potentially other details if needed
                      widget.onSettingItemTap!(itemTitle, itemDetails: stringItemDetails);
                    } else {
                      // Fallback or error message if the callback isn't provided
                      print('Tap action not configured for $itemTitle');
                    }
                  },
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item['icon'] as IconData, color: Colors.blue[700]),
                    ),
                    title: Text(
                      itemTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: item['trailing'] != null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item['trailing'] as String,
                                style: const TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                            ],
                          )
                        : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      if (widget.onSettingItemTap != null) {
                        Map<String, String> stringItemDetails = {};
                        item.forEach((key, value) {
                          stringItemDetails[key] = value.toString();
                        });
                        // Pass the item's title and potentially other details if needed
                        widget.onSettingItemTap!(itemTitle, itemDetails: stringItemDetails);
                      } else {
                        // Fallback or error message if the callback isn't provided
                        print('Tap action not configured for $itemTitle');
                      }
                      // The existing customAction logic was primarily for 'Connection & sharing'.
                      // The new onSettingItemTap callback, when implemented in PhoneMockupContainer's handleItemTap,
                      // should now handle the navigation for 'Connection & sharing'.
                      // So, the direct call to customAction here might be redundant if handleItemTap covers it.
                      // For now, we'll rely on onSettingItemTap to handle the action.
                      // If specific UI changes within SettingsScreen itself were needed for customAction,
                      // that would require a different approach.
                    },
                  ),
                ),
                if (item != items.last)
                  const Divider(
                    indent: 72, // Standard indent for Material list tiles
                    endIndent: 16, // Standard end indent
                    height: 1, // Standard height for divider
                    color: Colors.black12, // Standard color for divider
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}