// File: lib/phone_mockup/settings_screen.dart
import 'package:flutter/material.dart';
import 'clickable_outline.dart';
import 'phone_mockup_container.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onBack;
  final AppItemTapCallback? onSettingItemTap;
  const SettingsScreen({super.key, required this.onBack, this.onSettingItemTap});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();

  getSettingItemKey(String target) {}
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Map<String, GlobalKey<ClickableOutlineState>> _settingsKeys = {};

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
    return Material(
      color: Colors.blueGrey[50],
      child: Scaffold(
        backgroundColor: Colors.transparent, // Scaffold is now transparent, Material provides color
        appBar: AppBar(
          title: const Text(
            "Settings",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent, // AppBar is also transparent
          elevation: 0,
          leading: IconButton(
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
                ClickableOutline(
                  key: itemKey!,
                  action: () async {
                    if (widget.onSettingItemTap != null) {
                      Map<String, String> stringItemDetails = {};
                      item.forEach((key, value) {
                        // Only add values that are already Strings or can be converted safely.
                        // IconData should not be part of itemDetails if it expects String.
                        if (key != 'icon') { // Exclude 'icon' from stringItemDetails
                          stringItemDetails[key] = value.toString();
                        }
                      });
                      widget.onSettingItemTap!(itemTitle, itemDetails: stringItemDetails);
                    } else {
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
                          if (key != 'icon') { // Exclude 'icon' from stringItemDetails
                            stringItemDetails[key] = value.toString();
                          }
                        });
                        widget.onSettingItemTap!(itemTitle, itemDetails: stringItemDetails);
                      } else {
                        print('Tap action not configured for $itemTitle');
                      }
                    },
                  ),
                ),
                if (item != items.last)
                  const Divider(
                    indent: 72,
                    endIndent: 16,
                    height: 1,
                    color: Colors.black12,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}