import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui'; // For BackdropFilter
import 'dart:async'; // For Timer (used in showInternalToast Future.delayed)

import 'app_grid.dart';
import 'settings_screen.dart';
import 'notification_drawer.dart';
import 'custom_app_action_dialog.dart';
import 'app_info_screen.dart';
import 'clear_data_screen.dart';
import 'custom_clear_data_dialog.dart'; // Ensured this import is clean
import 'clickable_outline.dart'; // Required for GlobalKey<ClickableOutlineState>
import 'connection_sharing_screen.dart';
import 'internal_toast.dart';
import 'apps1.dart'; // Import for Apps1Screen
import 'app_management_screen.dart'; // Import for AppManagementScreen

// Enum to manage the current view being displayed in the phone mockup
enum CurrentScreenView { appGrid, settings, appInfo, clearData, connectionSharing, apps1, appManagement }

typedef AppItemTapCallback = void Function(String itemName, {Map<String, String>? itemDetails});

class PhoneMockupContainer extends StatefulWidget {
  final GlobalKey<AppGridState> appGridKey; // Key for the AppGrid it will contain
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

  CurrentScreenView _currentScreenView = CurrentScreenView.appGrid;
  Map<String, String>? _currentAppDetails; // To store details of the app being interacted with
  Widget _currentAppScreenWidget = const SizedBox(); // Holds the actual widget to display

  bool _isBlurred = false;
  Widget? _activeDialog;

  // --- Toast State Variables ---
  String? _currentToastMessage;
  bool _isToastVisible = false;
  Duration _toastDuration = const Duration(seconds: 3);

  // --- AppInfoScreen Keys ---
  final GlobalKey<ClickableOutlineState> _appInfoBackButtonKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appInfoOpenButtonKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appInfoStorageCacheButtonKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appInfoMobileDataKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appInfoBatteryKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appInfoNotificationsKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appInfoPermissionsKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appInfoOpenByDefaultKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appInfoUninstallButtonKey = GlobalKey();

  // --- ClearDataScreen Keys ---
  final GlobalKey<ClickableOutlineState> _clearDataBackButtonKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _clearDataClearDataButtonKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _clearDataClearCacheButtonKey = GlobalKey();

  // --- CustomAppActionDialog Keys ---
  final GlobalKey<ClickableOutlineState> _appActionDialogAppInfoKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _appActionDialogUninstallKey = GlobalKey();
  // final GlobalKey<ClickableOutlineState> _appActionDialogForceStopKey = GlobalKey(); // Not implemented in dialog

  // --- CustomClearDataDialog Keys ---
  final GlobalKey<ClickableOutlineState> _clearDataDialogCancelKey = GlobalKey();
  final GlobalKey<ClickableOutlineState> _clearDataDialogConfirmKey = GlobalKey();
  
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


  void dismissDialog() {
    setState(() {
      _activeDialog = null;
      _isBlurred = false;
    });
  }

  void showSettingsScreen() {
    print("PhoneMockupContainerState: showSettingsScreen() called.");
    setState(() {
      _currentScreenView = CurrentScreenView.settings;
      print("PhoneMockupContainerState: _currentScreenView set to $_currentScreenView.");
      _currentAppDetails = null;
      _updateCurrentScreenWidget();
      print("PhoneMockupContainerState: _updateCurrentScreenWidget() called from showSettingsScreen.");
    });
  }

  void showInternalToast(String message, {Duration duration = const Duration(seconds: 3)}) {
    // Hides current toast immediately if one is visible, then shows new one after a brief delay.
    if (_isToastVisible) {
      setState(() {
        _isToastVisible = false;
      });
      // Allow old toast to be removed before showing the new one.
      // This prevents visual glitches if the message/key changes too quickly for AnimatedSwitcher/FadeTransition.
      Future.delayed(const Duration(milliseconds: 50), () {
        if (!mounted) return; // Guard against calling setState on unmounted widget
        setState(() {
          _currentToastMessage = message;
          _toastDuration = duration;
          _isToastVisible = true;
        });
      });
    } else {
      if (!mounted) return; // Guard against calling setState on unmounted widget
      setState(() {
        _currentToastMessage = message;
        _toastDuration = duration;
        _isToastVisible = true;
      });
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
        _currentAppDetails = null; // Settings screen doesn't represent a single app's details
        _updateCurrentScreenWidget();
      });
    } else if (_currentScreenView == CurrentScreenView.settings) {
      // If already on settings screen, handle settings item tap
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
      } else {
        // For other settings items, print for now or handle as needed
        print('Settings item tapped: $itemName');
      }
    } else if (itemDetails != null) {
      // This case is for app icons from the AppGrid
      navigateToAppInfo(appDetails: Map<String, String>.from(itemDetails));
    } else {
      // Fallback for items that are not 'Settings' and don't have details (e.g., from AppGrid but details missing)
      final appDetails = widget.appGridKey.currentState?.getAppByName(itemName);
      if (appDetails != null && appDetails.isNotEmpty) {
        navigateToAppInfo(appDetails: Map<String, String>.from(appDetails));
      } else {
        print("PhoneMockupContainer: Item '$itemName' details not found for tap.");
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
      _updateCurrentScreenWidget();
      setState(() {});
    }
  }

  void _updateCurrentScreenWidget() {
    switch (_currentScreenView) {
      case CurrentScreenView.appGrid:
        _currentAppScreenWidget = AppGrid(
          key: widget.appGridKey,
          phoneMockupKey: widget.key as GlobalKey<PhoneMockupContainerState>,
          wallpaperImage: widget.mockupWallpaperImage, // Corrected line
          onAppTap: handleItemTap,
        );
        break;
      case CurrentScreenView.settings:
        _currentAppScreenWidget = SettingsScreen(
          onBack: () {
            setState(() {
              _currentScreenView = CurrentScreenView.appGrid;
              _currentAppDetails = null;
              _updateCurrentScreenWidget();
            });
          },
          onSettingItemTap: handleItemTap,
        );
        break;
      case CurrentScreenView.appInfo:
        if (_currentAppDetails != null) {
          _currentAppScreenWidget = AppInfoScreen(
            app: _currentAppDetails!,
            onBack: () {
              setState(() {
                _currentScreenView = CurrentScreenView.appGrid;
                _currentAppDetails = null;
                _updateCurrentScreenWidget();
              });
            },
            onNavigateToClearData: (appData) {
              navigateToStorageUsage();
            },
            showDialog: _showDialog,
            dismissDialog: dismissDialog,
            // Pass all the keys to AppInfoScreen
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
          _currentScreenView = CurrentScreenView.appGrid;
          _updateCurrentScreenWidget();
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
            showDialog: _showDialog,
            dismissDialog: dismissDialog,
            onPerformClearData: () => _performActualDataClear(_currentAppDetails!['name']!),
            onPerformClearCache: () => _performActualCacheClear(_currentAppDetails!['name']!),
            backButtonKey: _clearDataBackButtonKey,
            clearDataButtonKey: _clearDataClearDataButtonKey,
            clearCacheButtonKey: _clearDataClearCacheButtonKey,
            // Pass dialog keys for CustomClearDataDialog shown by ClearDataScreen
            dialogCancelKey: _clearDataDialogCancelKey,
            dialogConfirmKey: _clearDataDialogConfirmKey,
          );
        } else {
          _currentScreenView = CurrentScreenView.appGrid;
          _updateCurrentScreenWidget();
        }
        break;
      case CurrentScreenView.connectionSharing:
        _currentAppScreenWidget = ConnectionSharingScreen(
          onBack: () {
            setState(() {
              _currentScreenView = CurrentScreenView.settings; // Navigate back to Settings
              _updateCurrentScreenWidget();
            });
          },
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
            apps: widget.appGridKey.currentState?.getAllApps() ?? []);
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
        // ignore: avoid_print
        print('PhoneMockupContainer: App for programmatic long press "$appName" not found.');
      }
    } else if (cmd.startsWith('tap ')) {
      final appName = cmd.substring('tap '.length).trim();
      _handleAppTap(appName);
    } else if (cmd.contains('back')) {
      // Prioritize programmatic back if available for the current screen
      if (_currentScreenView == CurrentScreenView.appInfo) {
        await triggerAppInfoBackButtonAction();
      } else if (_currentScreenView == CurrentScreenView.clearData) {
        await triggerClearDataBackButtonAction();
      } else if (_currentScreenView == CurrentScreenView.connectionSharing) {
        setState(() {
          _currentScreenView = CurrentScreenView.settings;
          _updateCurrentScreenWidget();
        });
      } else if (_currentScreenView == CurrentScreenView.settings) {
         setState(() { // Settings back is simpler, no key needed for it yet.
          _currentScreenView = CurrentScreenView.appGrid;
          _updateCurrentScreenWidget();
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Already on main screen or no back action defined')),
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
    // ignore: avoid_print
    print('PhoneMockupContainer: App tapped: $appName');
    // This method is now effectively replaced by handleItemTap, 
    // but might still be called by _handleCommand.
    // Consider refactoring _handleCommand to use handleItemTap directly.
    handleItemTap(appName); 
  }

  void handleAppLongPress(Map<String, String> app) {
    // ignore: avoid_print
    print('PhoneMockupContainer: User long press on app: ${app['name']}');
    _currentAppDetails = Map<String, String>.from(app);
    _showCustomAppActionDialog(_currentAppDetails!);
  }

  void _showCustomAppActionDialog(Map<String, String> appDetails) {
    setState(() {
      _isBlurred = true;
      _activeDialog = CustomAppActionDialog(
        app: appDetails,
        onActionSelected: (actionName, appDetailsFromDialog) {
          dismissDialog(); // This is important, dialog should be dismissed by its internal logic
          if (actionName == 'App info') {
            navigateToAppInfo(appDetails: appDetailsFromDialog);
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$actionName for ${appDetailsFromDialog['name'] ?? 'unknown app'}")),
              );
            }
          }
        },
        // Pass keys for dialog elements
        appInfoKey: _appActionDialogAppInfoKey,
        uninstallKey: _appActionDialogUninstallKey,
        // forceStopKey: _appActionDialogForceStopKey, // If it were implemented
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
        // ignore: avoid_print
        print("PhoneMockupContainer: Navigated to AppInfo for ${detailsToUse['name']}");
      });
    } else {
      // ignore: avoid_print
      print("PhoneMockupContainer: Error - AppDetails is null for navigateToAppInfo.");
    }
  }

  void navigateToStorageUsage() {
    if (_currentScreenView == CurrentScreenView.appInfo && _currentAppDetails != null) {
      setState(() {
        _currentScreenView = CurrentScreenView.clearData;
        _updateCurrentScreenWidget(); 
        // ignore: avoid_print
        print("PhoneMockupContainer: Navigated to ClearDataScreen for ${_currentAppDetails!['name']}");
      });
    } else {
      // ignore: avoid_print
      print("PhoneMockupContainer: Error - Not on AppInfo or _currentAppDetails is null for navigateToStorageUsage.");
    }
  }

  Future<void> _performActualDataClear(String appName) async {
    // ignore: avoid_print
    print("PhoneMockupContainer: Performing actual data clear for $appName");
    await widget.appGridKey.currentState?.updateAppDataSize(appName, '0 B', _currentAppDetails?['cacheSize'] ?? '0 B');

    if (_currentAppDetails != null && _currentAppDetails!['name'] == appName) {
      setState(() {
        _currentAppDetails!['dataSize'] = '0 B';
        double appSizeMB = double.tryParse(_currentAppDetails!['appSize']!.replaceAll(' MB', '')) ?? 0;
        double cacheSizeMB = double.tryParse(_currentAppDetails!['cacheSize']!.replaceAll(' MB', '')) ?? 0;
        _currentAppDetails!['totalSize'] = '${(appSizeMB + cacheSizeMB).toStringAsFixed(1)} MB';
        if (_currentScreenView == CurrentScreenView.clearData) _updateCurrentScreenWidget();
      });
    }
    if (mounted) {
      showInternalToast('Data cleared for $appName');
    }
  }

  Future<void> _performActualCacheClear(String appName) async {
    // ignore: avoid_print
    print("PhoneMockupContainer: Performing actual cache clear for $appName");
    await widget.appGridKey.currentState?.updateAppDataSize(appName, _currentAppDetails?['dataSize'] ?? '0 B', '0 B');

    if (_currentAppDetails != null && _currentAppDetails!['name'] == appName) {
      setState(() {
        _currentAppDetails!['cacheSize'] = '0 B';
        double appSizeMB = double.tryParse(_currentAppDetails!['appSize']!.replaceAll(' MB', '')) ?? 0;
        double dataSizeMB = double.tryParse(_currentAppDetails!['dataSize']!.replaceAll(' MB', '')) ?? 0;
        _currentAppDetails!['totalSize'] = '${(appSizeMB + dataSizeMB).toStringAsFixed(1)} MB';
        if (_currentScreenView == CurrentScreenView.clearData) _updateCurrentScreenWidget();
      });
    }
    if (mounted) {
      showInternalToast('Cache cleared for $appName');
    }
  }

  // --- Methods to trigger ClickableOutline actions ---
  Future<void> triggerAppInfoStorageCacheAction() async {
    await _appInfoStorageCacheButtonKey.currentState?.triggerOutlineAndAction();
  }

  Future<void> triggerAppInfoBackButtonAction() async {
    await _appInfoBackButtonKey.currentState?.triggerOutlineAndAction();
  }

  Future<void> triggerClearDataButtonAction() async {
    // This action in ClearDataScreen shows an AlertDialog, not CustomClearDataDialog.
    // The requirement is to add keys to CustomClearDataDialog.
    // So, this trigger is for the button on ClearDataScreen.
    await _clearDataClearDataButtonKey.currentState?.triggerOutlineAndAction();
  }

  Future<void> triggerClearCacheButtonAction() async {
    await _clearDataClearCacheButtonKey.currentState?.triggerOutlineAndAction();
  }

  Future<void> triggerClearDataBackButtonAction() async {
    await _clearDataBackButtonKey.currentState?.triggerOutlineAndAction();
  }

  // Methods for Dialogs
  Future<void> triggerDialogAppInfoAction() async {
    await _appActionDialogAppInfoKey.currentState?.triggerOutlineAndAction();
  }

  Future<void> triggerDialogUninstallAction() async {
    await _appActionDialogUninstallKey.currentState?.triggerOutlineAndAction();
  }

  // Force Stop is not in CustomAppActionDialog currently.
  // Future<void> triggerDialogForceStopAction() async {
  //   await _appActionDialogForceStopKey.currentState?.triggerOutlineAndAction();
  // }

  Future<void> triggerDialogClearDataConfirmAction() async {
    await _clearDataDialogConfirmKey.currentState?.triggerOutlineAndAction();
  }

  Future<void> triggerDialogClearDataCancelAction() async {
    await _clearDataDialogCancelKey.currentState?.triggerOutlineAndAction();
  }
  // --- End Trigger Methods ---


  void simulateClearDataClick() {
    // This method is supposed to simulate clicking the "Clear Data" button
    // which then shows a dialog. If the "Clear Data" button on ClearDataScreen
    // shows the CustomClearDataDialog, then this method should trigger that.
    // However, ClearDataScreen's "Clear Data" button shows a standard AlertDialog.
    // CustomClearDataDialog was only used in the old simulateClearDataClick.
    // For now, let's assume simulateClearDataClick is meant to show *CustomClearDataDialog*
    // and make it use the new keys.
    if (_currentAppDetails != null) { // No need to be on ClearData screen to simulate this.
      final String appName = _currentAppDetails!['name']!;
      // ignore: avoid_print
      print("PhoneMockupContainer: simulateClearDataClick for $appName - showing CustomClearDataDialog with keys.");
      _showDialog(
        CustomClearDataDialog(
          title: 'Clear app data?',
          content: 'This app\'s data, including files and settings, will be permanently deleted from this device.',
          confirmButtonText: 'Delete',
          confirmButtonColor: Colors.red,
          onConfirm: () {
            dismissDialog();
            _performActualDataClear(appName);
          },
          onCancel: dismissDialog,
          // Pass keys to CustomClearDataDialog
          cancelKey: _clearDataDialogCancelKey,
          confirmKey: _clearDataDialogConfirmKey,
        ),
      );
    } else {
      // ignore: avoid_print
      print("PhoneMockupContainer: Error - No app selected for simulateClearDataClick (CustomClearDataDialog).");
    }
  }


  void simulateConfirmDelete() {
    // This method is intended to confirm whatever dialog is currently active,
    // assuming it's a confirmation dialog for deletion.
    if (_activeDialog != null && _currentAppDetails != null) {
      // If the active dialog is our CustomClearDataDialog, we can trigger its confirm action.
      // Otherwise, this simulation might be too generic.
      // For now, assume it's for the CustomClearDataDialog if it's active.
      // ignore: avoid_print
      print("PhoneMockupContainer: Simulating confirm delete on active dialog.");
      // We don't call dismissDialog() here because the dialog's own action should handle it.
      triggerDialogClearDataConfirmAction();
    } else {
      // ignore: avoid_print
      print("PhoneMockupContainer: Error - No active dialog or no app details for simulateConfirmDelete.");
    }
  }

  void navigateHome() {
    setState(() {
      _currentScreenView = CurrentScreenView.appGrid;
      _currentAppDetails = null;
      dismissDialog();
      _updateCurrentScreenWidget();
      // ignore: avoid_print
      print("PhoneMockupContainer: Navigated to Home (AppGrid).");
    });
  }

  void _openNotificationDrawer() {
    _drawerKey.currentState?.openDrawer();
  }

  void _showDialog(Widget dialog) {
    setState(() {
      _activeDialog = dialog;
      _isBlurred = true;
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
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {},
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
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: const Divider(
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
                  transitionBuilder: (Widget child, Animation<double> animation) {
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
                  child: Container(
                    color: Colors.black.withOpacity(0.0),
                  ),
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
                        onTap: () {},
                        child: _activeDialog!,
                      ),
                    ),
                  ),
                ),
              ),
            
            // --- Display InternalToast ---
            if (_isToastVisible && _currentToastMessage != null)
              Positioned(
                bottom: 70.0, // Position from bottom, adjust as needed
                left: 20.0,   // Padding from left
                right: 20.0,  // Padding from right
                child: Align( // Use Align to ensure it doesn't stretch if InternalToast has fixed width
                  alignment: Alignment.bottomCenter,
                  child: InternalToast(
                    key: ValueKey<String?>(_currentToastMessage), // Ensures widget rebuilds on message change
                    message: _currentToastMessage!,
                    visibleDuration: _toastDuration,
                    onDismissed: () {
                      if (!mounted) return;
                      setState(() {
                        _isToastVisible = false;
                      });
                    },
                  ),
                ),
              ),

            NotificationDrawer(key: _drawerKey),
          ],
        ),
        ),
      ),
    );
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
              Icon(
                Icons.signal_cellular_alt,
                color: Colors.white,
                size: 18,
              ),
              SizedBox(width: 4),
              Icon(Icons.wifi, color: Colors.white, size: 18),
              SizedBox(width: 4),
              Text(
                "81%",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.battery_full,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}