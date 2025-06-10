// File: lib/phone_mockup/app_management_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';

class AppManagementScreen extends StatefulWidget {
  final VoidCallback onBack;
  final List<Map<String, String>> apps; // List of apps from AppGrid

  const AppManagementScreen({
    super.key,
    required this.onBack,
    required this.apps,
  });

  @override
  State<AppManagementScreen> createState() => _AppManagementScreenState();
}

class _AppManagementScreenState extends State<AppManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Add a listener to rebuild the widget when the search query changes,
    // so _getFilteredApps can re-evaluate.
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(() {
      setState(() {}); // Remove listener before disposing
    });
    _searchController.dispose();
    super.dispose();
  }

  // This method dynamically computes the filtered list based on the current
  // widget.apps (which is updated by PhoneMockupContainer) and the search query.
  List<Map<String, String>> _getFilteredApps() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      return widget.apps;
    } else {
      return widget.apps.where((app) {
        final appName = app['name']?.toLowerCase() ?? '';
        return appName.contains(query);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredApps = _getFilteredApps(); // Get the filtered list on each build

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text(
          "App management",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blueGrey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: widget.onBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search ${widget.apps.length} items', // Dynamic count based on total apps
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredApps.length,
              itemBuilder: (context, index) {
                final app = filteredApps[index];
                final appName = app['name']!;
                final iconPath = app['icon']!;

                Widget iconWidget;
                if (iconPath.startsWith('assets/')) {
                  iconWidget = Image.asset(
                    iconPath,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 40);
                    },
                  );
                } else {
                  iconWidget = Image.file(
                    File(iconPath),
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 40);
                    },
                  );
                }

                return Column(
                  children: [
                    ListTile(
                      leading: iconWidget,
                      title: Text(
                        appName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onTap: () {
                        // Handle app item tap, e.g., navigate to app info
                        print('Tapped on app: $appName');
                      },
                    ),
                    if (index < filteredApps.length - 1)
                      const Divider(
                        indent: 72, // Aligns with the title text
                        endIndent: 16,
                        height: 1,
                        color: Colors.black12,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
