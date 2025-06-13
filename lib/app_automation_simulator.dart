// lib/app_automation_simulator.dart
import 'dart:math'; // Import for Random
import 'package:flutter/material.dart';
import 'phone_mockup/phone_mockup_container.dart';
import 'phone_mockup/app_grid.dart';
import 'phone_mockup/settings_screen.dart';

class AppAutomationSimulator {
  final Random _random = Random(); // Instance of Random for generating random numbers
  final GlobalKey<PhoneMockupContainerState> phoneMockupKey;
  final GlobalKey<AppGridState> appGridKey;

  AppAutomationSimulator({
    required this.phoneMockupKey,
    required this.appGridKey,
  });

  /// A helper function to print the current step and add realistic delays.
  Future<void> _handleStep(String message, Future<void> Function() action) async {
    print(message);
    // Add a random delay before performing the action to simulate human thinking time.
    await Future.delayed(Duration(milliseconds: _random.nextInt(401) + 300));
    await action();
    // Add a random delay after the action to simulate reaction time/animation.
    await Future.delayed(Duration(milliseconds: _random.nextInt(501) + 500));
  }


  /// This is the main simulation method for the combined "clear data" and "reset network" flow.
  Future<bool> startClearDataAndResetNetworkSimulation(String appName) async {
    print("Starting expanded simulation for command: '$appName clear data'");

    final phoneMockupState = phoneMockupKey.currentState;
    final appGridState = appGridKey.currentState;

    if (phoneMockupState == null || appGridState == null) {
      print("Error: PhoneMockupContainerState or AppGridState is null. Cannot proceed.");
      return false;
    }

    // --- Part 1: Clear App Data ---
    print("--- Starting Part 1: Clear App Data for $appName ---");

    await _handleStep("Step 1.1: Scrolling to app '$appName'...", () async {
      await appGridState.scrollToApp(appName);
    });

    final appDetails = appGridState.getAppByName(appName);
    if (appDetails == null || appDetails.isEmpty) {
      print("Error: App '$appName' not found in grid.");
      return false;
    }

    await _handleStep("Step 1.2: Long pressing on '$appName'...", () async {
      final appOutlineKey = appGridState.getKeyForApp(appName);
      await appOutlineKey?.currentState?.triggerOutlineAndAction();
    });

    await _handleStep("Step 1.3: Selecting 'App info'...", () async {
      await phoneMockupState.triggerDialogAppInfoAction();
    });

    await _handleStep("Step 1.4: Waiting on App Info screen...", () async {
       await Future.delayed(Duration(milliseconds: _random.nextInt(2001) + 1000));
    });

    await _handleStep("Step 1.5: Tapping 'Storage & cache'...", () async {
      await phoneMockupState.triggerAppInfoStorageCacheAction();
    });

    await _handleStep("Step 1.6: Waiting on Storage screen...", () async {
       await Future.delayed(Duration(milliseconds: _random.nextInt(2001) + 1000));
    });

    await _handleStep("Step 1.7: Tapping 'Clear data'...", () async {
      await phoneMockupState.triggerClearDataButtonAction();
    });

    await _handleStep("Step 1.8: Confirming 'Delete'...", () async {
      await phoneMockupState.triggerDialogClearDataConfirmAction();
    });
    
    print("--- Part 1 Complete: Data cleared for $appName. ---");
    await Future.delayed(const Duration(seconds: 2));

    // --- Part 2: Reset Mobile Network Settings ---
    // Pass the already validated state objects to the next part of the simulation.
    await startResetNetworkSimulation(phoneMockupState, appGridState);

    return true;
  }

  /// New simulation method specifically for resetting network settings.
  /// It now accepts the state objects as parameters to avoid re-fetching them.
  Future<bool> startResetNetworkSimulation(PhoneMockupContainerState phoneMockupState, AppGridState appGridState) async {
    print("--- Starting Part 2: Reset Mobile Network Settings ---");
    // No need to fetch or check for nulls here, as we are receiving the state directly.

    await _handleStep("Step 2.1: Navigating to Home Screen...", () async {
        phoneMockupState.navigateHome();
    });

    await _handleStep("Step 2.2: Tapping 'Settings' app...", () async {
       final settingsAppDetails = appGridState.getAppByName('Settings');
       if (settingsAppDetails != null) {
         phoneMockupState.handleItemTap('Settings', itemDetails: settingsAppDetails);
       } else {
         print("Error: Could not find 'Settings' app details.");
         throw Exception("Settings app not found");
       }
    });
    
    await _handleStep("Step 2.3: Scrolling to bottom of Settings...", () async {
      await phoneMockupState.triggerSettingsScrollToEnd();
    });
    
    await _handleStep("Step 2.4: Waiting for 5 seconds...", () async {
      await Future.delayed(const Duration(seconds: 5));
    });

    await _handleStep("Step 2.5: Tapping 'System' in Settings...", () async {
       await phoneMockupState.triggerSystemSettingsAction();
    });

    await _handleStep("Step 2.6: Tapping 'Reset options'...", () async {
        await phoneMockupState.triggerResetOptionsAction();
    });

    await _handleStep("Step 2.7: Tapping 'Reset Mobile Network Settings'...", () async {
        await phoneMockupState.triggerResetMobileNetworkAction();
    });

    await _handleStep("Step 2.8: Tapping 'Reset settings' (first confirmation)...", () async {
        await phoneMockupState.triggerConfirmResetMobileNetworkAction();
    });
    
    await _handleStep("Step 2.9: Tapping 'Reset settings' (second confirmation)...", () async {
        await phoneMockupState.triggerConfirmResetMobileNetworkAction();
    });

    print("--- Part 2 Complete: Mobile network settings reset. ---");
    await Future.delayed(const Duration(seconds: 3)); // Wait for toast to disappear.

    // --- Finalization ---
    await _handleStep("Step 3: Returning to Home Screen...", () async {
      phoneMockupState.navigateHome();
    });
    
    print("All simulation actions complete.");

    return true;
  }
}
