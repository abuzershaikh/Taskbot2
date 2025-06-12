// lib/phone_mockup/phone_mockup_container.dart
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui'; // For BackdropFilter
import 'dart:async'; // For Timer (used in showInternalToast Future.delayed)

import 'app_grid.dart';
import 'settings_screen.dart';
import 'system_settings.dart'; // Added import
import 'reset_option.dart'; // Added import
import 'reset_mobile_network_settings_screen.dart'; // Import screen
import 'notification_drawer.dart';
import 'custom_app_action_dialog.dart';
import 'app_info_screen.dart';
import 'clear_data_screen.dart';
import 'custom_clear_data_dialog.dart';
import 'clickable_outline.dart';
import 'connection_sharing_screen.dart';
import 'internal_toast.dart';
import 'apps1.dart';
import 'app_management_screen.dart';
import 'system_app_screen.dart'; // Import the system apps screen
import 'package:taskbot2/keyboard/keyboard_view.dart';

// Enum to manage the current view being displayed in the phone mockup
enum CurrentScreenView {
  appGrid,
  settings,
  appInfo,
  clearData,
  connectionSharing,
  apps1,
  appManagement,
  systemApps, // Add new screen view
  systemSettings, // Added for system settings screen
  resetOptions,   // New
  resetMobileNetworkSettings, // New value
}

typedef AppItemTapCallback = void Function(String itemName,
    {Map<String, String>? itemDetails});

class PhoneMockupContainer extends StatefulWidget {
  final GlobalKey<AppGridState>
      appGridKey; // Key for the AppGrid it will contain
  final File? mockupWallpaperImage; // Added mockup wallpaper image

  const PhoneMockupContainer({
    super.key, // This is the key for PhoneMockupContainer itself
    required this.appGridKey,
    this.mockupWallpaperImage, // Added new parameter
  });

  // Static key and method - assuming these are intended to remain, cleaned from markers.
  static final GlobalKey<PhoneMockupContainerState> globalKey =
      GlobalKey<PhoneMockupContainerState>();

  static void executeCommand(String command) {
    globalKey.currentState?._handleCommand(command);
  }

  @override
  State<PhoneMockupContainer> createState() => PhoneMockupContainerState();
}

class PhoneMockupContainerState extends State<PhoneMockupContainer> {
  final GlobalKey<NotificationDrawerState> _drawerKey =
      GlobalKey<NotificationDrawerState>();

  // Keyboard visibility state
  bool _isKeyboardVisible = false;
  TextEditingController? _keyboardTextController;
  VoidCallback? _currentSearchCallback; // Added for search callback

  CurrentScreenView _currentScreenView = CurrentScreenView.appGrid;
  Map<String, String>?
      _currentAppDetails; // To store details of the app being interacted with
  Widget _currentAppScreenWidget =
      const SizedBox(); // Holds the actual widget to display

  bool _isBlurred = false;
  Widget? _activeDialog;

  // --- Toast State Variables ---
  String? _currentToastMessage;
  bool _isToastVisible = false;
  Duration _toastDuration = const Duration(seconds: 3);

  // --- AppInfoScreen Keys ---
  final GlobalKey<ClickableOutlineState> _appInfoBackButtonKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appInfoOpenButtonKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appInfoStorageCacheButtonKey =
      GlobalKey();
  final GlobalKey<ClickableOutlineState> _appInfoMobileDataKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appInfoBatteryKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appInfoNotificationsKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appInfoPermissionsKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appInfoOpenByDefaultKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appInfoUninstallButtonKey =
      GlobalKey();

  // --- ClearDataScreen Keys ---
  final GlobalKey<ClickableOutlineState> _clearDataBackButtonKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _clearDataClearDataButtonKey =
      GlobalKey();
  final GlobalKey<ClickableOutlineState> _clearDataClearCacheButtonKey =
      GlobalKey();

  // --- CustomAppActionDialog Keys ---
  final GlobalKey<ClickableOutlineState> _appActionDialogAppInfoKey =
      GlobalKey();
  final GlobalKey<ClickableOutlineState> _appActionDialogUninstallKey =
      GlobalKey();

  // --- CustomClearDataDialog Keys ---
  final GlobalKey<ClickableOutlineState> _clearDataDialogCancelKey =
      GlobalKey();
  final GlobalKey<ClickableOutlineState> _clearDataDialogConfirmKey =
      GlobalKey();

  // --- Apps1Screen Keys ---
  final GlobalKey<ClickableOutlineState> _apps1BackButtonKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appManagementKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _defaultAppsKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _disabledAppsKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _recoverSystemAppsKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _autoLaunchKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _specialAppAccessKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appLockKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _dualAppsKey = GlobalKey();

  // --- SystemSettingsScreen Keys ---
  final GlobalKey<ClickableOutlineState> _systemSettingsResetOptionsKey = GlobalKey();

  // --- ResetOptionScreen Keys ---
  final GlobalKey<ClickableOutlineState> _resetMobileNetworkKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _resetBluetoothWifiKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _resetAppPreferencesKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _eraseAllDataKey = GlobalKey();


  void dismissDialog() {
    setState(() {
      _activeDialog = null;
      _isBlurred = false;
    });
  }

  void showSettingsScreen() {
    setState(() {
      _currentScreenView = CurrentScreenView.settings;
      _currentAppDetails = null;
      _updateCurrentScreenWidget();
    });
  }

  // Method to show the system apps screen
  void showSystemAppsScreen() {
    setState(() {
      _currentScreenView = CurrentScreenView.systemApps;
      _updateCurrentScreenWidget();
    });
  }

  void showInternalToast(String message,
      {Duration duration = const Duration(seconds: 3)}) {
    if (_isToastVisible) {
      setState(() => _isToastVisible = false);
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          setState(() {
            _currentToastMessage = message;
            _toastDuration = duration;
            _isToastVisible = true;
          });
        }
      });
    } else {
      if (mounted) {
        setState(() {
          _currentToastMessage = message;
          _toastDuration = duration;
          _isToastVisible = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _updateCurrentScreenWidget(); // Initialize with AppGrid
  }

  void handleItemTap(String itemName, {Map<String, String>? itemDetails}) {
    print('PhoneMockupContainer: Item tapped: $itemName');
    if (itemName == 'Settings') {
      setState(() {
        _currentScreenView = CurrentScreenView.settings;
        _currentAppDetails = null;
        _updateCurrentScreenWidget();
      });
    } else if (_currentScreenView == CurrentScreenView.settings) {
      if (itemName == 'Apps') {
        setState(() {
          _currentScreenView = CurrentScreenView.apps1;
          _updateCurrentScreenWidget();
        });
      } else if (itemName == 'Connection & sharing') {
        setState(() {
          _currentScreenView = CurrentScreenView.connectionSharing;
          _updateCurrentScreenWidget();
        });
      } else if (itemName == 'System') { // New condition for System
        setState(() {
          _currentScreenView = CurrentScreenView.systemSettings;
          _updateCurrentScreenWidget();
        });
      } else {
        print('Settings item tapped: $itemName');
      }
    } else if (itemDetails != null) {
      navigateToAppInfo(appDetails: Map<String, String>.from(itemDetails));
    } else {
      final appDetails = widget.appGridKey.currentState?.getAppByName(itemName);
      if (appDetails != null && appDetails.isNotEmpty) {
        navigateToAppInfo(appDetails: Map<String, String>.from(appDetails));
      } else {
        print(
            "PhoneMockupContainer: Item '$itemName' details not found for tap.");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Item '$itemName' details not found.")),
          );
        }
      }
    }
  }

  @override
  void didUpdateWidget(PhoneMockupContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mockupWallpaperImage != oldWidget.mockupWallpaperImage &&
        _currentScreenView == CurrentScreenView.appGrid) {
      setState(() {
        _updateCurrentScreenWidget();
      });
    }
  }

  void _updateCurrentScreenWidget() {
    switch (_currentScreenView) {
      case CurrentScreenView.appGrid:
        _currentAppScreenWidget = AppGrid(
          key: widget.appGridKey,
          phoneMockupKey: widget.key as GlobalKey<PhoneMockupContainerState>,
          wallpaperImage: widget.mockupWallpaperImage,
          onAppTap: handleItemTap,
        );
        break;
      case CurrentScreenView.settings:
        _currentAppScreenWidget = SettingsScreen(
          onBack: () => navigateHome(),
          onSettingItemTap: handleItemTap,
        );
        break;
      case CurrentScreenView.appInfo:
        if (_currentAppDetails != null) {
          _currentAppScreenWidget = AppInfoScreen(
            app: _currentAppDetails!,
            onBack: () => navigateHome(),
            onNavigateToClearData: (appData) => navigateToStorageUsage(),
            showDialog: (Widget dialogWidget) => _showDialog(context, dialogWidget),
            dismissDialog: dismissDialog,
            backButtonKey: _appInfoBackButtonKey,
            openButtonKey: _appInfoOpenButtonKey,
            storageCacheButtonKey: _appInfoStorageCacheButtonKey,
            mobileDataKey: _appInfoMobileDataKey,
            batteryKey: _appInfoBatteryKey,
            notificationsKey: _appInfoNotificationsKey,
            permissionsKey: _appInfoPermissionsKey,
            openByDefaultKey: _appInfoOpenByDefaultKey,
            uninstallButtonKey: _appInfoUninstallButtonKey,
          );
        } else {
          navigateHome();
        }
        break;
      case CurrentScreenView.clearData:
        if (_currentAppDetails != null) {
          _currentAppScreenWidget = ClearDataScreen(
            appName: _currentAppDetails!['name']!,
            appVersion: _currentAppDetails!['version'] ?? 'N/A',
            appIconPath: _currentAppDetails!['icon']!,
            initialTotalSize: _currentAppDetails!['totalSize'] ?? '0 B',
            initialAppSize: _currentAppDetails!['appSize'] ?? '0 B',
            initialDataSize: _currentAppDetails!['dataSize'] ?? '0 B',
            initialCacheSize: _currentAppDetails!['cacheSize'] ?? '0 B',
            onBack: () {
              setState(() {
                _currentScreenView = CurrentScreenView.appInfo;
                _updateCurrentScreenWidget();
              });
            },
            showDialog: (Widget dialogWidget) => _showDialog(context, dialogWidget),
            dismissDialog: dismissDialog,
            onPerformClearData: () =>
                _performActualDataClear(_currentAppDetails!['name']!),
            onPerformClearCache: () =>
                _performActualCacheClear(_currentAppDetails!['name']!),
            backButtonKey: _clearDataBackButtonKey,
            clearDataButtonKey: _clearDataClearDataButtonKey,
            clearCacheButtonKey: _clearDataClearCacheButtonKey,
            dialogCancelKey: _clearDataDialogCancelKey,
            dialogConfirmKey: _clearDataDialogConfirmKey,
          );
        } else {
          navigateHome();
        }
        break;
      case CurrentScreenView.connectionSharing:
        _currentAppScreenWidget = ConnectionSharingScreen(
          onBack: () {
            setState(() {
              _currentScreenView = CurrentScreenView.settings;
              _updateCurrentScreenWidget();
            });
          },
          showInternalToast: showInternalToast, 
        );
        break;
      case CurrentScreenView.apps1:
        _currentAppScreenWidget = Apps1Screen(
          onBack: () {
            setState(() {
              _currentScreenView = CurrentScreenView.settings;
              _updateCurrentScreenWidget();
            });
          },
          onAppManagementTap: () {
            setState(() {
              _currentScreenView = CurrentScreenView.appManagement;
              _updateCurrentScreenWidget();
            });
          },
          backButtonKey: _apps1BackButtonKey,
          appManagementKey: _appManagementKey,
          defaultAppsKey: _defaultAppsKey,
          disabledAppsKey: _disabledAppsKey,
          recoverSystemAppsKey: _recoverSystemAppsKey,
          autoLaunchKey: _autoLaunchKey,
          specialAppAccessKey: _specialAppAccessKey,
          appLockKey: _appLockKey,
          dualAppsKey: _dualAppsKey,
        );
        break;
      case CurrentScreenView.appManagement:
        _currentAppScreenWidget = AppManagementScreen(
            onBack: () {
              setState(() {
                _currentScreenView = CurrentScreenView.apps1;
                _updateCurrentScreenWidget();
              });
            },
            onNavigateToSystemApps: showSystemAppsScreen, onAppSelected: (Map<String, String> app) => navigateToAppInfo(appDetails: app),);
        break;
      // Case for the new system apps screen
      case CurrentScreenView.systemApps:
        _currentAppScreenWidget = SystemAppScreen(
          onBack: () {
            setState(() {
              _currentScreenView = CurrentScreenView.appManagement;
              _updateCurrentScreenWidget();
            });
          }, onAppSelected: (Map<String, String> app) => navigateToAppInfo(appDetails: app),
        );
        break;
      case CurrentScreenView.systemSettings: // New case for SystemSettingsScreen
        _currentAppScreenWidget = SystemSettingsScreen(
          onBack: () {
            setState(() {
              _currentScreenView = CurrentScreenView.settings;
              _updateCurrentScreenWidget();
            });
          },
          onNavigateToResetOptions: () { // Actual navigation
            setState(() {
              _currentScreenView = CurrentScreenView.resetOptions;
              _updateCurrentScreenWidget();
            });
          },
          resetOptionsKey: _systemSettingsResetOptionsKey,
        );
        break;
      case CurrentScreenView.resetOptions: // New case for ResetOptionScreen
        _currentAppScreenWidget = ResetOptionScreen(
          onBack: () {
            setState(() {
              _currentScreenView = CurrentScreenView.systemSettings; // Back to System Settings
              _updateCurrentScreenWidget();
            });
          },
          onNavigateToResetMobileNetwork: () {
            setState(() {
              _currentScreenView = CurrentScreenView.resetMobileNetworkSettings;
              _updateCurrentScreenWidget();
            });
          },
          showMockupDialog: _showDialog, // Pass the _showDialog method
          showMockupToast: showInternalToast, // Pass the showInternalToast method
          dismissMockupDialog: dismissDialog, // Pass the dismissDialog method
          resetMobileNetworkKey: _resetMobileNetworkKey,
          resetBluetoothWifiKey: _resetBluetoothWifiKey,
          resetAppPreferencesKey: _resetAppPreferencesKey,
          eraseAllDataKey: _eraseAllDataKey,
        );
        break;
      case CurrentScreenView.resetMobileNetworkSettings: // New case
        _currentAppScreenWidget = ResetMobileNetworkSettingsScreen(
          onBack: () {
            setState(() {
              _currentScreenView = CurrentScreenView.resetOptions; // Navigate back to ResetOptionScreen
              _updateCurrentScreenWidget();
            });
          },
          showInternalToast: showInternalToast,
        );
        break;
    }
  }

  Future<void> _handleCommand(String command) async {
    final cmd = command.toLowerCase().trim();
    if (cmd.contains('settings')) {
      _handleAppTap('Settings');
    } else if (cmd.startsWith('long press ')) {
      final appName = cmd.substring('long press '.length).trim();
      final appDetails = widget.appGridKey.currentState?.getAppByName(appName);
      if (appDetails != null && appDetails.isNotEmpty) {
        handleAppLongPress(appDetails);
      } else {
        print(
            'PhoneMockupContainer: App for programmatic long press "$appName" not found.');
      }
    } else if (cmd.startsWith('tap ')) {
      final itemName = cmd.substring('tap '.length).trim();
      // Check if it's a settings item first
      if (_currentScreenView == CurrentScreenView.systemSettings && itemName == 'reset options') {
        triggerSystemResetOptionsOutline();
      } else if (_currentScreenView == CurrentScreenView.resetOptions) {
        if (itemName == 'reset mobile network settings') {
          triggerResetMobileNetworkOutline();
        } else if (itemName == 'reset bluetooth & wi-fi') {
          triggerResetBluetoothWifiOutline();
        } else if (itemName == 'reset app preferences') {
          triggerResetAppPreferencesOutline();
        } else if (itemName == 'erase all data (factory reset)') {
          triggerEraseAllDataOutline();
        } else {
          _handleAppTap(itemName); // Fallback to app tap if not a specific settings item
        }
      } else {
        _handleAppTap(itemName); // General app tap
      }
    } else if (cmd.contains('back')) {
      // Prioritize programmatic back if available for the current screen
      if (_currentScreenView == CurrentScreenView.appInfo) {
        triggerAppInfoBackButtonAction();
      } else if (_currentScreenView == CurrentScreenView.clearData) {
        triggerClearDataBackButtonAction();
      } else if (_currentScreenView == CurrentScreenView.connectionSharing ||
          _currentScreenView == CurrentScreenView.apps1) {
        setState(() {
          _currentScreenView = CurrentScreenView.settings;
          _updateCurrentScreenWidget();
        });
      } else if (_currentScreenView == CurrentScreenView.appManagement) {
        setState(() {
          _currentScreenView = CurrentScreenView.apps1;
          _updateCurrentScreenWidget();
        });
      } else if (_currentScreenView == CurrentScreenView.systemApps) {
        setState(() {
          _currentScreenView = CurrentScreenView.appManagement;
          _updateCurrentScreenWidget();
        });
      } else if (_currentScreenView == CurrentScreenView.settings) {
        navigateHome();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Already on main screen or no back action defined')),
          );
        }
      }
    } else if (cmd.contains('notification')) {
      _openNotificationDrawer();
    } else if (cmd.startsWith('scroll to')) {
      final appName = cmd.substring('scroll to'.length).trim();
      if (widget.appGridKey.currentState != null) {
        widget.appGridKey.currentState?.scrollToApp(appName);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('AppGrid not ready to scroll.')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unknown command: $command')),
        );
      }
    }
  }

  void _handleAppTap(String appName) {
    handleItemTap(appName);
  }

  void handleAppLongPress(Map<String, String> app) {
    _currentAppDetails = Map<String, String>.from(app);
    _showCustomAppActionDialog(_currentAppDetails!);
  }

  void _showCustomAppActionDialog(Map<String, String> appDetails) {
    setState(() {
      _isBlurred = true;
      _activeDialog = CustomAppActionDialog(
        app: appDetails,
        onActionSelected: (actionName, appDetailsFromDialog) {
          dismissDialog();
          if (actionName == 'App info') {
            navigateToAppInfo(appDetails: appDetailsFromDialog);
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        "$actionName for ${appDetailsFromDialog['name'] ?? 'unknown app'}")),
              );
            }
          }
        },
        appInfoKey: _appActionDialogAppInfoKey,
        uninstallKey: _appActionDialogUninstallKey,
      );
    });
  }

  void navigateToAppInfo({Map<String, String>? appDetails}) {
    final detailsToUse = appDetails ?? _currentAppDetails;
    if (detailsToUse != null) {
      if (_currentAppDetails != detailsToUse) {
        _currentAppDetails = detailsToUse;
      }
      setState(() {
        _currentScreenView = CurrentScreenView.appInfo;
        _updateCurrentScreenWidget();
      });
    } else {
      print(
          "PhoneMockupContainer: Error - AppDetails is null for navigateToAppInfo.");
    }
  }

  void navigateToStorageUsage() {
    if (_currentScreenView == CurrentScreenView.appInfo &&
        _currentAppDetails != null) {
      setState(() {
        _currentScreenView = CurrentScreenView.clearData;
        _updateCurrentScreenWidget();
      });
    } else {
      print(
          "PhoneMockupContainer: Error - Not on AppInfo or _currentAppDetails is null for navigateToStorageUsage.");
    }
  }

  Future<void> _performActualDataClear(String appName) async {
    await widget.appGridKey.currentState?.updateAppDataSize(
        appName, '0 B', _currentAppDetails?['cacheSize'] ?? '0 B');
    if (_currentAppDetails != null && _currentAppDetails!['name'] == appName) {
      setState(() {
        _currentAppDetails!['dataSize'] = '0 B';
        double appSizeMB = double.tryParse(
                _currentAppDetails!['appSize']!.replaceAll(' MB', '')) ??
            0;
        double cacheSizeMB = double.tryParse(
                _currentAppDetails!['cacheSize']!.replaceAll(' MB', '')) ??
            0;
        _currentAppDetails!['totalSize'] =
            '${(appSizeMB + cacheSizeMB).toStringAsFixed(1)} MB';
        if (_currentScreenView == CurrentScreenView.clearData) {
          _updateCurrentScreenWidget();
        }
      });
    }
    if (mounted) {
      showInternalToast('Data cleared for $appName');
    }
  }

  Future<void> _performActualCacheClear(String appName) async {
    await widget.appGridKey.currentState?.updateAppDataSize(
        appName, _currentAppDetails?['dataSize'] ?? '0 B', '0 B');

    if (_currentAppDetails != null && _currentAppDetails!['name'] == appName) {
      setState(() {
        _currentAppDetails!['cacheSize'] = '0 B';
        double appSizeMB = double.tryParse(
                _currentAppDetails!['appSize']!.replaceAll(' MB', '')) ??
            0;
        double dataSizeMB = double.tryParse(
                _currentAppDetails!['dataSize']!.replaceAll(' MB', '')) ??
            0;
        _currentAppDetails!['totalSize'] =
            '${(appSizeMB + dataSizeMB).toStringAsFixed(1)} MB';
        if (_currentScreenView == CurrentScreenView.clearData) {
          _updateCurrentScreenWidget();
        }
      });
    }
    if (mounted) {
      showInternalToast('Cache cleared for $appName');
    }
  }

  void triggerAppInfoStorageCacheAction() =>
      _appInfoStorageCacheButtonKey.currentState?.triggerOutlineAndAction();
  void triggerAppInfoBackButtonAction() =>
      _appInfoBackButtonKey.currentState?.triggerOutlineAndAction();
  void triggerClearDataButtonAction() =>
      _clearDataClearDataButtonKey.currentState?.triggerOutlineAndAction();
  void triggerClearCacheButtonAction() =>
      _clearDataClearCacheButtonKey.currentState?.triggerOutlineAndAction();
  void triggerClearDataBackButtonAction() =>
      _clearDataBackButtonKey.currentState?.triggerOutlineAndAction();
  void triggerDialogAppInfoAction() =>
      _appActionDialogAppInfoKey.currentState?.triggerOutlineAndAction();
  void triggerDialogUninstallAction() =>
      _appActionDialogUninstallKey.currentState?.triggerOutlineAndAction();
  void triggerDialogClearDataConfirmAction() =>
      _clearDataDialogConfirmKey.currentState?.triggerOutlineAndAction();
  void triggerDialogClearDataCancelAction() =>
      _clearDataDialogCancelKey.currentState?.triggerOutlineAndAction();

  // --- Methods to trigger outlines for SystemSettingsScreen and ResetOptionScreen ---
  void triggerSystemResetOptionsOutline() =>
      _systemSettingsResetOptionsKey.currentState?.triggerOutlineAndAction();
  void triggerResetMobileNetworkOutline() =>
      _resetMobileNetworkKey.currentState?.triggerOutlineAndAction();
  void triggerResetBluetoothWifiOutline() =>
      _resetBluetoothWifiKey.currentState?.triggerOutlineAndAction();
  void triggerResetAppPreferencesOutline() =>
      _resetAppPreferencesKey.currentState?.triggerOutlineAndAction();
  void triggerEraseAllDataOutline() =>
      _eraseAllDataKey.currentState?.triggerOutlineAndAction();

  // --- Stubs for Settings/Reset Actions ---

  Future<void> triggerSettingsSystemAction() async {
    print("PhoneMockupContainerState: triggerSettingsSystemAction called.");
    setState(() {
      // This action should navigate from the main Settings screen to the "System" sub-screen.
      _currentScreenView = CurrentScreenView.systemSettings;
      _updateCurrentScreenWidget(); // Ensure the UI updates to show the System settings screen
    });
    await Future.delayed(const Duration(milliseconds: 200)); // Simulate transition
    print("PhoneMockupContainerState: Navigated to System Settings screen.");
  }

  Future<void> triggerSystemResetOptionsAction() async {
    print("PhoneMockupContainerState: triggerSystemResetOptionsAction called.");
    setState(() {
      // This action should navigate from "System" settings to "Reset options".
      _currentScreenView = CurrentScreenView.resetOptions;
      _updateCurrentScreenWidget(); // Ensure UI updates
    });
    await Future.delayed(const Duration(milliseconds: 200)); // Simulate transition
    print("PhoneMockupContainerState: Navigated to Reset Options screen.");
  }

  Future<void> triggerResetMobileNetworkSettingsAction() async {
    print("PhoneMockupContainerState: triggerResetMobileNetworkSettingsAction called.");
    setState(() {
      // This action should navigate from "Reset options" to "Reset mobile network settings".
      _currentScreenView = CurrentScreenView.resetMobileNetworkSettings;
      _updateCurrentScreenWidget(); // Ensure UI updates
    });
    await Future.delayed(const Duration(milliseconds: 250)); // Simulate transition/dialog appearance
    print("PhoneMockupContainerState: Navigated to Reset Mobile Network Settings screen/dialog.");
  }

  Future<void> triggerConfirmResetNetworkAction() async {
    print("PhoneMockupContainerState: triggerConfirmResetNetworkAction called (first confirmation).");
    // This might show another confirmation dialog or just proceed.
    // For now, just log and delay. If it shows a dialog, a real implementation would set _activeDialog.
    setState(() {
      // Potentially update a state variable if the UI changes, e.g., to show a spinner or second dialog
      print("PhoneMockupContainerState: First network reset confirmation processed.");
    });
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate action
  }

  Future<void> triggerFinalConfirmResetNetworkAction() async {
    print("PhoneMockupContainerState: triggerFinalConfirmResetNetworkAction called (final confirmation).");
    // This is the final step. It would perform the reset and likely navigate away or show a toast.
    setState(() {
      // After reset, it might navigate back to a general settings screen or show a toast.
      // For now, we'll just log the action completion.
      // A real implementation might call showInternalToast("Network settings have been reset.");
      // And potentially navigate: _currentScreenView = CurrentScreenView.settings; _updateCurrentScreenWidget();
      print("PhoneMockupContainerState: Final network reset confirmation processed. Network should be 'reset'.");
    });
    await Future.delayed(const Duration(milliseconds: 1000)); // Simulate longer action for reset
    // After reset, the actual OS often returns to a general settings page or the specific reset options page.
    // Let's simulate returning to Reset Options for now, as the simulator will navigate away after this.
    // setState(() {
    //   _currentScreenView = CurrentScreenView.resetOptions;
    //  _updateCurrentScreenWidget();
    // });
  }

  void simulateClearDataClick() {
    if (_currentAppDetails != null) {
      final String appName = _currentAppDetails!['name']!;
      _showDialog(
        context, // Pass context here
        CustomClearDataDialog(
          title: 'Clear app data?',
          content:
              'This app\'s data, including files and settings, will be permanently deleted from this device.',
          confirmButtonText: 'Delete',
          confirmButtonColor: Colors.red,
          onConfirm: () {
            dismissDialog();
            _performActualDataClear(appName);
          },
          onCancel: dismissDialog,
          cancelKey: _clearDataDialogCancelKey,
          confirmKey: _clearDataDialogConfirmKey,
        ),
      );
    } else {
      print(
          "PhoneMockupContainer: Error - No app selected for simulateClearDataClick.");
    }
  }

  void simulateConfirmDelete() {
    if (_activeDialog != null && _currentAppDetails != null) {
      triggerDialogClearDataConfirmAction();
    } else {
      print(
          "PhoneMockupContainer: Error - No active dialog or no app details for simulateConfirmDelete.");
    }
  }

  void navigateHome() {
    setState(() {
      _currentScreenView = CurrentScreenView.appGrid;
      _currentAppDetails = null;
      dismissDialog();
      _updateCurrentScreenWidget();
    });
  }

  void _openNotificationDrawer() {
    _drawerKey.currentState?.openDrawer();
  }

  // Modified to accept BuildContext, though not directly used by this implementation
  // This is to match the required signature for the callback.
  void _showDialog(BuildContext context, Widget dialogContent) {
    setState(() {
      _activeDialog = dialogContent;
      _isBlurred = true;
    });
  }

  // Method to show the keyboard
  void showKeyboard(TextEditingController controller, {VoidCallback? onSearch}) {
    setState(() {
      _keyboardTextController = controller;
      _currentSearchCallback = onSearch; // Store the search callback
      _isKeyboardVisible = true;
    });
  }

  // Method to hide the keyboard
  void hideKeyboard() {
    setState(() {
      _keyboardTextController = null;
      _currentSearchCallback = null; // Clear the search callback
      _isKeyboardVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 600,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0.0),
          child: Stack(
            children: [
              Positioned(
                top: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _openNotificationDrawer,
                child: _buildStatusBar(),
              ),
            ),
            const Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Divider(
                height: 1,
                color: Colors.white30,
              ),
            ),
            Positioned.fill(
              top: 31,
              child: Material(
                type: MaterialType.transparency,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: KeyedSubtree(
                    key: ValueKey<CurrentScreenView>(_currentScreenView),
                    child: _currentAppScreenWidget,
                  ),
                ),
              ),
            ),
            if (_isBlurred)
              Positioned.fill(
                top: 31,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(color: Colors.black.withOpacity(0.0)),
                ),
              ),
            if (_activeDialog != null)
              Positioned.fill(
                top: 31,
                child: GestureDetector(
                  onTap: dismissDialog,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: GestureDetector(
                        onTap:
                            () {}, // To prevent inner taps from closing the dialog
                        child: _activeDialog!,
                      ),
                    ),
                  ),
                ),
              ),
            if (_isToastVisible && _currentToastMessage != null)
              Positioned(
                bottom: 70.0,
                left: 20.0,
                right: 20.0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InternalToast(
                    key: ValueKey<String?>(_currentToastMessage),
                    message: _currentToastMessage!,
                    visibleDuration: _toastDuration,
                    onDismissed: () {
                      if (mounted) {
                        setState(() => _isToastVisible = false);
                      }
                    },
                  ),
                ),
              ),
            NotificationDrawer(key: _drawerKey),

            // Add Keyboard conditionally
            if (_isKeyboardVisible)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Material( // Wrap KeyboardView in Material for theming and correct rendering
                  type: MaterialType.transparency, // Or specific color if needed
                  child: KeyboardView(
                    textEditingController: _keyboardTextController ?? TextEditingController(),
                    focusNode: FocusNode(),
                    onSearchPressed: _currentSearchCallback, // Pass the stored callback
                  ),
                ),
              ),
          ],
        ),
      ),
    ),);
  }

  Widget _buildStatusBar() {
    String formattedTime = DateFormat('h:mm a').format(DateTime.now());
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            formattedTime,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Row(
            children: const [
              Icon(Icons.signal_cellular_alt, color: Colors.white, size: 18),
              SizedBox(width: 4),
              Icon(Icons.wifi, color: Colors.white, size: 18),
              SizedBox(width: 4),
              Text("81%", style: TextStyle(color: Colors.white, fontSize: 12)),
              SizedBox(width: 4),
              Icon(Icons.battery_full, color: Colors.white, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}
