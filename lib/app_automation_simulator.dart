// File: app_automation_simulator.dart
import 'dart:math'; // Import for Random
import 'package:flutter/material.dart';
import 'phone_mockup/phone_mockup_container.dart';
import 'phone_mockup/app_grid.dart';

class AppAutomationSimulator {
  final Random _random = Random(); // Instance of Random for generating random numbers
  final GlobalKey<PhoneMockupContainerState> phoneMockupKey;
  final GlobalKey<AppGridState> appGridKey;

  AppAutomationSimulator({
    required this.phoneMockupKey,
    required this.appGridKey,
  });

  Future<bool> startClearDataSimulation(String appName) async {
    print("Starting 'clear data' simulation for app: $appName");

    // Ensure we have access to the PhoneMockupContainerState
    final phoneMockupState = phoneMockupKey.currentState;
    if (phoneMockupState == null) {
      print("Error: PhoneMockupContainerState is null. Cannot proceed.");
      return false;
    }

    // Step 1: Simulate scrolling/searching for app
    // The extended scrolling/searching is now handled by scrollToApp
    // print("Simulating scrolling/searching for $appName...");
    // await Future.delayed(const Duration(seconds: 1)); // This delay is removed

    final appGridState = appGridKey.currentState;
    if (appGridState == null) {
      print("Error: AppGridState is null. Cannot proceed.");
      return false;
    }

    await appGridState.scrollToApp(appName); // Ensure scrollToApp is awaited
    print("App grid scrolling to $appName finished. Pausing briefly.");
    await Future.delayed(const Duration(milliseconds: 300)); // Short pause after scrolling

    final appDetails = appGridState.getAppByName(appName);
    if (appDetails == null || appDetails.isEmpty) {
      print("App '$appName' not found in grid after scrolling.");
      return false;
    }

    print("App '$appName' found: $appDetails");
    await Future.delayed(const Duration(milliseconds: 500)); // Reduced delay

    // Step 2: Simulate long press on the app icon using ClickableOutline
    print("Simulating long press on $appName via ClickableOutline.");
    final appOutlineKey = appGridState.getKeyForApp(appName);
    if (appOutlineKey == null) {
      print("Error: Could not find ClickableOutline key for app $appName.");
      return false;
    }
    if (appOutlineKey.currentState == null) {
      print("Error: ClickableOutline key for $appName has no current state.");
      return false;
    }
    await Future.delayed(Duration(milliseconds: _random.nextInt(401) + 100)); // 100ms to 500ms
    await appOutlineKey.currentState!.triggerOutlineAndAction();
    // The 5-second delay is now part of triggerOutlineAndAction.
    // The action itself (handleAppLongPress) shows the dialog.
    print("Long press action triggered for $appName. Waiting for dialog.");
    await Future.delayed(const Duration(milliseconds: 700)); // Wait for dialog to build/appear after action.

    // Step 3: Simulate selecting "App info" in the dialog using ClickableOutline
    print("Simulating selection of 'App info' in dialog via ClickableOutline.");
    if (!phoneMockupState.mounted) {
      print("Error: PhoneMockupContainerState is not mounted. Cannot trigger dialog action.");
      return false;
    }
    await Future.delayed(Duration(milliseconds: _random.nextInt(401) + 100)); // 100ms to 500ms
    await phoneMockupState.triggerDialogAppInfoAction();
    // triggerDialogAppInfoAction includes the outline delay and performs navigation.
    print("'App info' action triggered. Waiting for navigation to App Info screen.");
    await Future.delayed(const Duration(milliseconds: 300)); // Short delay for screen transition.

    // Step 4: Wait on App Info screen (user thinking time)
    final dauertStep4 = _random.nextInt(3001) + 2000; // Random delay between 2000ms (2s) and 5000ms (5s)
    print("Simulating user scrolling/reading on App Info screen for ${dauertStep4 / 1000} seconds.");
    await Future.delayed(Duration(milliseconds: dauertStep4));

    // Step 5: Click "Storage & cache" using ClickableOutline
    print("Simulating click on 'Storage & cache' via ClickableOutline.");
    if (!phoneMockupState.mounted) {
      print("Error: PhoneMockupContainerState is not mounted. Cannot trigger 'Storage & cache' action.");
      return false;
    }
    await Future.delayed(Duration(milliseconds: _random.nextInt(401) + 100)); // 100ms to 500ms
    await phoneMockupState.triggerAppInfoStorageCacheAction();
    // triggerAppInfoStorageCacheAction includes outline delay and navigates to ClearDataScreen.
    print("'Storage & cache' action triggered. Waiting for navigation to Clear Data screen.");
    await Future.delayed(const Duration(milliseconds: 300)); // Short delay for screen transition.

    // Step 6: Wait on storage screen (user thinking time)
    final dauertStep6 = _random.nextInt(3001) + 2000; // Random delay between 2000ms (2s) and 5000ms (5s)
    print("Simulating user scrolling/reading on Storage & cache screen for ${dauertStep6 / 1000} seconds.");
    await Future.delayed(Duration(milliseconds: dauertStep6));

    // Step 7: Click "Clear Data" using ClickableOutline
    print("Simulating click on 'Clear Data' via ClickableOutline.");
    if (!phoneMockupState.mounted) {
      print("Error: PhoneMockupContainerState is not mounted. Cannot trigger 'Clear Data' action.");
      return false;
    }
    await Future.delayed(Duration(milliseconds: _random.nextInt(401) + 100)); // 100ms to 500ms
    await phoneMockupState.triggerClearDataButtonAction();
    // triggerClearDataButtonAction includes outline delay and its action shows the confirmation dialog.
    print("'Clear Data' action triggered. Waiting for confirmation dialog.");
    await Future.delayed(const Duration(milliseconds: 700)); // Wait for dialog to build/appear.

    // Step 8: Confirm "Delete" in Clear Data Dialog using ClickableOutline
    print("Simulating click on 'Delete' in confirmation dialog via ClickableOutline.");
    if (!phoneMockupState.mounted) {
      print("Error: PhoneMockupContainerState is not mounted. Cannot trigger dialog 'Delete' action.");
      return false;
    }
    await Future.delayed(Duration(milliseconds: _random.nextInt(401) + 100)); // 100ms to 500ms
    await phoneMockupState.triggerDialogClearDataConfirmAction();
    // triggerDialogClearDataConfirmAction includes outline delay and performs data clear + dialog dismissal.
    print("'Delete' action triggered. Waiting for dialog dismissal and data clear operation.");
    await Future.delayed(const Duration(milliseconds: 500)); // Short delay for action to complete.

    // New delay: Wait for 9-10 seconds after data clear confirmation
    final postClearDelayMillis = _random.nextInt(1001) + 9000; // 9000ms to 10000ms
    print("Data cleared. Pausing for ${postClearDelayMillis / 1000} seconds on the current screen (likely App Info or where Clear Data dialog was shown).");
    await Future.delayed(Duration(milliseconds: postClearDelayMillis));

    // Step 9: Return home
    print("Simulation actions complete. Returning to home screen.");
    await Future.delayed(const Duration(seconds: 1)); // User pause before final navigation.
    if (phoneMockupState.mounted) {
      phoneMockupState.navigateHome();
      print("Returned to home screen."); // Changed print statement

      // Perform slow random scroll on the app grid
      if (appGridState.mounted) {
        final int slowScrollTotalSeconds = _random.nextInt(9) + 7; // 7 to 15 seconds
        print("Now performing slow random scroll on app grid for $slowScrollTotalSeconds seconds.");
        await appGridState.performSlowRandomScroll(Duration(seconds: slowScrollTotalSeconds));
        print("Slow random scroll on app grid finished.");
      } else {
        print("Error: AppGridState not available for slow random scroll after returning home.");
      }
      
      print("All simulation actions, including post-clear scrolling, are complete."); // Final adjusted print
    } else {
      print("Error: PhoneMockupContainerState is not mounted. Cannot return home or perform post-scroll.");
      return false;
    }

    return true;
  }
}