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

  Future<void> simulateInitialHomeScreenScrolling() async {
    print('Starting initial home screen scrolling...');
    final random = Random();
    // Generate a random duration between 10 and 17 seconds
    final scrollDurationInSeconds = 10 + random.nextInt(8);
    final scrollDuration = Duration(seconds: scrollDurationInSeconds);
    print('Scrolling for $scrollDurationInSeconds seconds...');
    await appGridKey.currentState?.performSlowRandomScroll(scrollDuration);
    print('Initial home screen scrolling finished.');
  }

  Future<bool> locateAndOpenAppInfo(String appName) async {
    print("Starting 'locate and open App Info' for app: $appName");

    final phoneMockupState = phoneMockupKey.currentState;
    if (phoneMockupState == null) {
      print("Error: PhoneMockupContainerState is null. Cannot proceed.");
      return false;
    }

    final appGridState = appGridKey.currentState;
    if (appGridState == null) {
      print("Error: AppGridState is null. Cannot proceed.");
      return false;
    }

    // Step 1: Scroll to the app
    print("Scrolling to app: $appName...");
    await appGridState.scrollToApp(appName);
    print("App grid scrolling to $appName finished. Pausing briefly.");
    await Future.delayed(const Duration(milliseconds: 300)); // Short pause after scrolling

    // Step 2: Get app details and check if found
    final appDetails = appGridState.getAppByName(appName);
    if (appDetails == null || appDetails.isEmpty) {
      print("App '$appName' not found in grid after scrolling.");
      return false;
    }
    print("App '$appName' found: $appDetails");

    // Step 3: Get ClickableOutline key for the app
    final appOutlineKey = appGridState.getKeyForApp(appName);
    if (appOutlineKey == null) {
      print("Error: Could not find ClickableOutline key for app $appName.");
      return false;
    }
    if (appOutlineKey.currentState == null) {
      print("Error: ClickableOutline key for $appName has no current state.");
      return false;
    }

    // Step 4: Simulate long press on the app icon
    final preLongPressDelay = Duration(milliseconds: _random.nextInt(401) + 100); // 100ms to 500ms
    print("Waiting for ${preLongPressDelay.inMilliseconds}ms before long press.");
    await Future.delayed(preLongPressDelay);

    print("Simulating long press on $appName via ClickableOutline.");
    await appOutlineKey.currentState!.triggerOutlineAndAction(); // This includes a 5-second outline display

    // Step 5: Implement additional wait to meet 5-8 seconds total after long press trigger
    // triggerOutlineAndAction has a 5-second delay. We need 0-3 seconds more.
    final additionalWaitMillis = _random.nextInt(3001); // 0ms to 3000ms
    final totalWaitDuration = Duration(seconds: 5) + Duration(milliseconds: additionalWaitMillis);
    print("Long press action triggered. Internal outline delay is 5s. Adding ${additionalWaitMillis}ms. Total wait: ${totalWaitDuration.inMilliseconds}ms.");
    await Future.delayed(Duration(milliseconds: additionalWaitMillis)); 
    print("Finished waiting after long press. Dialog should be visible.");

    // Step 6: Simulate selecting "App info" in the dialog
    final preAppInfoTapDelay = Duration(milliseconds: _random.nextInt(401) + 100); // 100ms to 500ms
    print("Waiting for ${preAppInfoTapDelay.inMilliseconds}ms before tapping 'App info'.");
    await Future.delayed(preAppInfoTapDelay);
    
    print("Simulating selection of 'App info' in dialog via ClickableOutline.");
    if (!phoneMockupState.mounted) {
      print("Error: PhoneMockupContainerState is not mounted. Cannot trigger dialog action.");
      return false;
    }
    await phoneMockupState.triggerDialogAppInfoAction();
    print("'App info' action triggered. Waiting for navigation to App Info screen.");
    await Future.delayed(const Duration(milliseconds: 300)); // Short delay for screen transition.

    print("Successfully navigated to App Info screen for $appName.");
    return true;
  }

  Future<bool> navigateToStorageAndClearData() async {
    print("Starting 'navigate to Storage & Cache and clear data' process...");

    final phoneMockupState = phoneMockupKey.currentState;
    if (phoneMockupState == null) {
      print("Error: PhoneMockupContainerState is null. Cannot proceed with clearing data.");
      return false;
    }

    // Step 1: Wait on App Info screen (user thinking/reading time)
    final appInfoWaitSeconds = 7 + _random.nextInt(2); // 7 to 8 seconds
    print("Waiting on App Info screen for $appInfoWaitSeconds seconds (simulating user reading).");
    await Future.delayed(Duration(seconds: appInfoWaitSeconds));

    // TODO: Implement actual scrolling on the App Info screen.
    // This might require a specific key or method in PhoneMockupContainerState
    // for the App Info screen's scrollable content.
    final appInfoScrollSimulationMillis = 1000 + _random.nextInt(1001); // 1-2 seconds
    print("Simulating scrolling on App Info screen for ${appInfoScrollSimulationMillis}ms (placeholder).");
    await Future.delayed(Duration(milliseconds: appInfoScrollSimulationMillis));

    // Step 2: Click "Storage & cache"
    final preStorageTapDelay = Duration(milliseconds: _random.nextInt(401) + 100); // 100ms to 500ms
    print("Waiting for ${preStorageTapDelay.inMilliseconds}ms before tapping 'Storage & cache'.");
    await Future.delayed(preStorageTapDelay);

    print("Simulating click on 'Storage & cache' via ClickableOutline.");
    if (!phoneMockupState.mounted) {
      print("Error: PhoneMockupContainerState is not mounted. Cannot trigger 'Storage & cache' action.");
      return false;
    }
    await phoneMockupState.triggerAppInfoStorageCacheAction();
    print("'Storage & cache' action triggered. Waiting for navigation to Clear Data screen.");
    await Future.delayed(const Duration(milliseconds: 300)); // Short delay for screen transition.

    // Step 3: Wait on Storage screen (user thinking/reading time)
    final storageScreenWaitSeconds = 8 + _random.nextInt(8); // 8 to 15 seconds
    print("Waiting on Storage & cache screen for $storageScreenWaitSeconds seconds.");
    await Future.delayed(Duration(seconds: storageScreenWaitSeconds));

    // Step 4: Click "Clear Data"
    final preClearDataTapDelay = Duration(milliseconds: _random.nextInt(401) + 100); // 100ms to 500ms
    print("Waiting for ${preClearDataTapDelay.inMilliseconds}ms before tapping 'Clear Data'.");
    await Future.delayed(preClearDataTapDelay);

    print("Simulating click on 'Clear Data' via ClickableOutline.");
    if (!phoneMockupState.mounted) {
      print("Error: PhoneMockupContainerState is not mounted. Cannot trigger 'Clear Data' action.");
      return false;
    }
    await phoneMockupState.triggerClearDataButtonAction();
    print("'Clear Data' action triggered. Waiting for confirmation dialog.");
    await Future.delayed(const Duration(milliseconds: 700)); // Wait for dialog to build/appear.

    // Step 5: Confirm "Delete" in Clear Data Dialog
    final preDeleteTapDelay = Duration(milliseconds: _random.nextInt(401) + 100); // 100ms to 500ms
    print("Waiting for ${preDeleteTapDelay.inMilliseconds}ms before tapping 'Delete' in confirmation dialog.");
    await Future.delayed(preDeleteTapDelay);

    print("Simulating click on 'Delete' in confirmation dialog via ClickableOutline.");
    if (!phoneMockupState.mounted) {
      print("Error: PhoneMockupContainerState is not mounted. Cannot trigger dialog 'Delete' action.");
      return false;
    }
    await phoneMockupState.triggerDialogClearDataConfirmAction();
    print("'Delete' action triggered. Waiting for dialog dismissal and data clear operation.");
    await Future.delayed(const Duration(milliseconds: 500)); // Short delay for action to complete.

    // Step 6: Final Wait after clearing data
    final finalWaitSeconds = 5 + _random.nextInt(11); // 5 to 15 seconds
    print("Data cleared. Pausing for $finalWaitSeconds seconds on the current screen.");
    await Future.delayed(Duration(seconds: finalWaitSeconds));

    print("Navigate to Storage & Cache and clear data process finished.");
    return true;
  }

  Future<bool> navigateToResetOptions() async {
    print("Starting 'navigate to Reset options' process...");

    final phoneMockupState = phoneMockupKey.currentState;
    if (phoneMockupState == null) {
      print("Error: PhoneMockupContainerState is null. Cannot proceed.");
      return false;
    }
    // appGridState is not directly used here for actions but good to have for context if needed later
    final appGridState = appGridKey.currentState;
    if (appGridState == null) {
      print("Error: AppGridState is null. Minimal check, though not directly used for navigation actions here.");
      // Depending on strictness, could return false or just log.
      // For now, we'll allow proceeding as primary actions depend on phoneMockupState.
    }

    // Step 1: Return to Home Screen
    print("Returning to home screen...");
    if (!phoneMockupState.mounted) {
        print("Error: PhoneMockupContainerState is not mounted. Cannot navigate home.");
        return false;
    }
    phoneMockupState.navigateHome();
    final postHomeDelay = 500 + _random.nextInt(501); // 500ms to 1s
    print("Waiting for ${postHomeDelay}ms after returning home.");
    await Future.delayed(Duration(milliseconds: postHomeDelay));

    // Step 2: Open "Settings" App
    final preSettingsDelay = 500 + _random.nextInt(501); // 500ms to 1s
    print("Waiting for ${preSettingsDelay}ms before opening Settings.");
    await Future.delayed(Duration(milliseconds: preSettingsDelay));

    print("Simulating opening 'Settings' app...");
    if (!phoneMockupState.mounted) {
        print("Error: PhoneMockupContainerState is not mounted. Cannot show settings screen.");
        return false;
    }
    phoneMockupState.showSettingsScreen(); // Assuming this method internally handles showing the screen
    print("'Settings' app opened. Waiting for screen transition.");
    await Future.delayed(const Duration(milliseconds: 500)); // Screen transition delay

    // Step 3: Scroll in Settings to find "System"
    final lookForSystemDelay = 1000 + _random.nextInt(1001); // 1s to 2s
    print("Simulating user looking for 'System' in Settings for ${lookForSystemDelay}ms.");
    await Future.delayed(Duration(milliseconds: lookForSystemDelay));

    // TODO: Implement actual scrolling in Settings to find "System".
    // This will require a mechanism within PhoneMockupContainerState or the Settings screen widget.
    final settingsScrollSimulationMillis = 1000 + _random.nextInt(1001); // 1-2 seconds
    print("Simulating scrolling in Settings for ${settingsScrollSimulationMillis}ms (placeholder).");
    await Future.delayed(Duration(milliseconds: settingsScrollSimulationMillis));

    // Step 4: Tap "System"
    final preSystemTapDelay = Duration(milliseconds: _random.nextInt(401) + 100); // 100ms to 500ms
    print("Waiting for ${preSystemTapDelay.inMilliseconds}ms before tapping 'System'.");
    await Future.delayed(preSystemTapDelay);

    print("Simulating tap on 'System' in Settings.");
    if (!phoneMockupState.mounted) {
        print("Error: PhoneMockupContainerState is not mounted. Cannot trigger System action.");
        return false;
    }
    // Assuming triggerSettingsSystemAction() exists and handles the tap + navigation
    await phoneMockupState.triggerSettingsSystemAction(); 
    print("'System' tapped. Waiting for screen transition.");
    await Future.delayed(const Duration(milliseconds: 300)); // Screen transition delay

    // Step 5: Scroll in System screen to find "Reset Options"
    final lookForResetDelay = 500 + _random.nextInt(501); // 500ms to 1s
    print("Simulating user looking for 'Reset options' in System screen for ${lookForResetDelay}ms.");
    await Future.delayed(Duration(milliseconds: lookForResetDelay));

    // TODO: Implement actual scrolling in System screen to find "Reset options".
    final systemScrollSimulationMillis = 500 + _random.nextInt(501); // 500ms to 1s
    print("Simulating scrolling in System screen for ${systemScrollSimulationMillis}ms (placeholder).");
    await Future.delayed(Duration(milliseconds: systemScrollSimulationMillis));
    
    // Step 6: Tap "Reset Options"
    final preResetOptionsTapDelay = Duration(milliseconds: _random.nextInt(401) + 100); // 100ms to 500ms
    print("Waiting for ${preResetOptionsTapDelay.inMilliseconds}ms before tapping 'Reset options'.");
    await Future.delayed(preResetOptionsTapDelay);

    print("Simulating tap on 'Reset options'.");
    if (!phoneMockupState.mounted) {
        print("Error: PhoneMockupContainerState is not mounted. Cannot trigger Reset options action.");
        return false;
    }
    // Assuming triggerSystemResetOptionsAction() exists and handles the tap + navigation
    await phoneMockupState.triggerSystemResetOptionsAction();
    print("'Reset options' tapped. Waiting for screen transition.");
    await Future.delayed(const Duration(milliseconds: 300)); // Screen transition delay

    print("Successfully navigated to Reset options screen.");
    return true;
  }

  Future<bool> performNetworkReset() async {
    print("Starting 'perform network reset' process...");

    final phoneMockupState = phoneMockupKey.currentState;
    if (phoneMockupState == null) {
      print("Error: PhoneMockupContainerState is null. Cannot proceed with network reset.");
      return false;
    }
    if (!phoneMockupState.mounted) {
      print("Error: PhoneMockupContainerState is not mounted. Cannot proceed with network reset.");
      return false;
    }

    // Step 1: Wait on Reset Options Screen
    final resetOptionsWaitSeconds = 10 + _random.nextInt(6); // 10 to 15 seconds
    print("Waiting on Reset Options screen for $resetOptionsWaitSeconds seconds.");
    await Future.delayed(Duration(seconds: resetOptionsWaitSeconds));

    // Step 2: Tap "Reset Mobile Network Settings"
    final preTapResetMobileDelay = Duration(milliseconds: _random.nextInt(401) + 100); // 100ms to 500ms
    print("Waiting for ${preTapResetMobileDelay.inMilliseconds}ms before tapping 'Reset Mobile Network Settings'.");
    await Future.delayed(preTapResetMobileDelay);

    print("Simulating tap on 'Reset Mobile Network Settings'.");
    // Assuming triggerResetMobileNetworkSettingsAction() exists
    await phoneMockupState.triggerResetMobileNetworkSettingsAction(); 
    print("'Reset Mobile Network Settings' tapped. Waiting for screen/dialog transition.");
    await Future.delayed(const Duration(milliseconds: 500)); // Screen/dialog transition

    // Step 3: Wait on Confirmation Screen (e.g., screen showing "Reset mobile network settings?")
    final confirmScreenWaitSeconds = 8 + _random.nextInt(8); // 8 to 15 seconds
    print("Waiting on confirmation screen for $confirmScreenWaitSeconds seconds.");
    await Future.delayed(Duration(seconds: confirmScreenWaitSeconds));
    
    // Step 4: Tap "Reset Settings" (First Confirmation)
    final preTapFirstConfirmDelay = Duration(milliseconds: _random.nextInt(401) + 100); // 100ms to 500ms
    print("Waiting for ${preTapFirstConfirmDelay.inMilliseconds}ms before tapping first 'Reset Settings'.");
    await Future.delayed(preTapFirstConfirmDelay);

    print("Simulating tap on 'Reset Settings' (first confirmation).");
    // Assuming triggerConfirmResetNetworkAction() exists
    await phoneMockupState.triggerConfirmResetNetworkAction();
    print("First 'Reset Settings' tapped. Waiting for action processing.");
    await Future.delayed(const Duration(milliseconds: 500)); // Action processing

    // Step 5: Wait Before Final Confirmation (e.g., another dialog or prompt might appear)
    final preFinalConfirmWaitSeconds = 7 + _random.nextInt(6); // 7 to 12 seconds
    print("Waiting for $preFinalConfirmWaitSeconds seconds before final confirmation.");
    await Future.delayed(Duration(seconds: preFinalConfirmWaitSeconds));

    // Step 6: Tap "Reset Settings" (Final Confirmation)
    final preTapFinalConfirmDelay = Duration(milliseconds: _random.nextInt(401) + 100); // 100ms to 500ms
    print("Waiting for ${preTapFinalConfirmDelay.inMilliseconds}ms before tapping final 'Reset Settings'.");
    await Future.delayed(preTapFinalConfirmDelay);
    
    print("Simulating tap on 'Reset Settings' (final confirmation).");
    // Assuming triggerFinalConfirmResetNetworkAction() exists
    await phoneMockupState.triggerFinalConfirmResetNetworkAction();
    print("Final 'Reset Settings' tapped. Network reset processing...");
    await Future.delayed(const Duration(seconds: 1)); // Action processing (might take longer)

    print("Network reset process completed.");

    // Step 7: Navigate Back to Settings Home Screen
    print("Navigating back to Settings home screen...");
    await Future.delayed(const Duration(milliseconds: 500)); // Short delay before navigation
    if (!phoneMockupState.mounted) {
        print("Error: PhoneMockupContainerState is not mounted. Cannot show settings screen.");
        // If this happens after reset, it's an issue, but we might not want to fail the whole operation.
        // For now, let's try to proceed if possible or just log.
        // Depending on how the UI reacts to network reset, this might be expected or an error.
    } else {
        phoneMockupState.showSettingsScreen();
        print("Returned to Settings home screen. Waiting for screen transition.");
        await Future.delayed(const Duration(milliseconds: 300));
    }
    
    print("Perform network reset sequence finished.");
    return true;
  }

  Future<void> simulateFinalHomeScreenScrolling() async {
    print("Starting final home screen scrolling simulation...");

    final phoneMockupState = phoneMockupKey.currentState;
    if (phoneMockupState == null) {
      print("Error: PhoneMockupContainerState is null. Cannot proceed with final scrolling.");
      return;
    }
    if (!phoneMockupState.mounted) {
      print("Error: PhoneMockupContainerState is not mounted. Cannot proceed with final scrolling.");
      return;
    }

    final appGridState = appGridKey.currentState;
    if (appGridState == null) {
      print("Error: AppGridState is null. Cannot perform final home screen scrolling.");
      return;
    }
    if (!appGridState.mounted) {
      print("Error: AppGridState is not mounted. Cannot perform final home screen scrolling.");
      return;
    }

    // Step 1: Return to Home Screen
    print("Returning to home screen for final scroll...");
    phoneMockupState.navigateHome();
    final postHomeDelay = 500 + _random.nextInt(501); // 500ms to 1s
    print("Waiting for ${postHomeDelay}ms after returning home.");
    await Future.delayed(Duration(milliseconds: postHomeDelay));

    // Step 2: Simulate Scrolling on Home Screen
    final scrollDurationInSeconds = 14 + _random.nextInt(12); // 14 to 25 seconds (14 + 0 to 11)
    final scrollDuration = Duration(seconds: scrollDurationInSeconds);
    
    print("Starting final slow random scroll on app grid for $scrollDurationInSeconds seconds.");
    await appGridState.performSlowRandomScroll(scrollDuration);
    print("Final slow random scroll on app grid finished.");
    
    print("Final home screen scrolling simulation finished.");
  }

  Future<bool> startFullResetSimulation(String appName) async {
    print("====== STARTING FULL RESET SIMULATION for $appName ======");

    await simulateInitialHomeScreenScrolling(); // This is a Future<void>

    print("--- Step 1: Initial Home Screen Scrolling completed ---");

    bool success = await locateAndOpenAppInfo(appName);
    if (!success) {
      print("Error: Failed to locate and open App Info for $appName. Aborting full reset simulation.");
      print("====== FULL RESET SIMULATION FAILED for $appName ======");
      return false;
    }
    print("--- Step 2: Locate and Open App Info for $appName completed successfully ---");

    success = await navigateToStorageAndClearData();
    if (!success) {
      print("Error: Failed to navigate to storage and clear data for $appName. Aborting full reset simulation.");
      print("====== FULL RESET SIMULATION FAILED for $appName ======");
      return false;
    }
    print("--- Step 3: Navigate to Storage and Clear Data for $appName completed successfully ---");

    success = await navigateToResetOptions();
    if (!success) {
      print("Error: Failed to navigate to Reset Options. Aborting full reset simulation.");
      print("====== FULL RESET SIMULATION FAILED for $appName ======");
      return false;
    }
    print("--- Step 4: Navigate to Reset Options completed successfully ---");

    success = await performNetworkReset();
    if (!success) {
      print("Error: Failed to perform network reset. Aborting full reset simulation.");
      print("====== FULL RESET SIMULATION FAILED for $appName ======");
      return false;
    }
    print("--- Step 5: Perform Network Reset completed successfully ---");

    await simulateFinalHomeScreenScrolling(); // This is a Future<void>
    print("--- Step 6: Final Home Screen Scrolling completed ---");

    print("====== FULL RESET SIMULATION COMPLETED SUCCESSFULLY for $appName ======");
    return true;
  }
}