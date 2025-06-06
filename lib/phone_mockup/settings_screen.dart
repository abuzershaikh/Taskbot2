import 'package:flutter/material.dart';
import 'clickable_outline.dart'; // Added import
import 'connection_sharing_screen.dart'; // Import the new screen

class SettingsScreen extends StatefulWidget { // Changed to StatefulWidget
  final VoidCallback onBack;
  const SettingsScreen({super.key, required this.onBack});

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

            // Determine the action based on the item title
            VoidCallback? customAction;
            if (itemTitle == 'Connection & sharing') {
              customAction = () {
                // print('Navigating to Connection & sharing screen');
                // Use a direct callback from PhoneMockupContainer to change screen
                // This requires a function passed down from PhoneMockupContainer
                // For now, we'll assume direct navigation will be handled by PhoneMockupContainer
                // via a command or a direct function call passed from the parent.
                // We'll add this to PhoneMockupContainer's _handleCommand method.
                if (itemTitle == 'Connection & sharing') {
                  // This will be called from the PhoneMockupContainer via a command.
                  // The actual navigation state change happens in PhoneMockupContainer.
                  // For now, this onTap serves as a placeholder.
                  // print('$itemTitle tapped, should navigate to Connection & sharing screen');
                }
              };
            }

            return Column(
              children: [
                ClickableOutline( // Wrap ListTile with ClickableOutline
                  key: itemKey!, // Use the non-nullable key here
                  action: () async { // Make action async
                    if (customAction != null) {
                      customAction();
                    } else {
                      // print('$itemTitle tapped!');
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
                    onTap: customAction, // Use customAction for onTap
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