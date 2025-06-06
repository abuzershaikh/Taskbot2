// TODO Implement this library.
import 'package:flutter/material.dart';

class ConnectionSharingScreen extends StatelessWidget {
  final VoidCallback onBack;

  const ConnectionSharingScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text(
          "Connection & sharing",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blueGrey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: onBack,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsCard(context, [
            _buildToggleItem(Icons.airplanemode_on, 'Aeroplane mode', false),
            _buildTrailingIconItem(Icons.wifi_tethering, 'Personal hotspot'),
            _buildTrailingIconItem(Icons.vpn_key, 'VPN'),
            _buildTrailingIconItem(Icons.dns, 'Private DNS'),
            _buildTrailingIconItem(Icons.directions_car, 'Android Auto',
                subtitle: 'Use apps on your car display.'),
          ]),
          const SizedBox(height: 16),
          _buildSettingsCard(context, [
            _buildTrailingIconItem(Icons.screen_share, 'Screencast'),
            _buildTrailingIconItem(Icons.print, 'Print', subtitle: 'On'),
            _buildToggleItem(
                Icons.devices_other, 'Quick device connect', true,
                subtitle: 'Discover and connect to nearby devices quickly.'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(
      BuildContext context, List<Widget> items) {
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
            return Column(
              children: [
                item,
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

  Widget _buildToggleItem(IconData icon, String title, bool initialValue,
      {String? subtitle}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.blue[700]),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            )
          : null,
      trailing: Switch(
        value: initialValue,
        onChanged: (bool value) {
          // Handle toggle state change (for now, just print)
          // print('$title toggled to $value');
        },
        activeColor: Colors.blue[700],
      ),
      onTap: () {
        // Handle tap for the list tile itself
        // print('$title tapped!');
      },
    );
  }

  Widget _buildTrailingIconItem(IconData icon, String title,
      {String? subtitle}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.blue[700]),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            )
          : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        // Handle tap for navigation
        // print('$title tapped!');
      },
    );
  }
}