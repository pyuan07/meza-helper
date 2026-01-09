import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// Platform detection and feature availability utilities
class PlatformUtils {
  /// Check if running on web platform
  static bool get isWeb => kIsWeb;

  /// Check if running on mobile (Android or iOS)
  static bool get isMobile {
    if (isWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Check if running on desktop (Windows, macOS, or Linux)
  static bool get isDesktop {
    if (isWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// Check if running on Android
  static bool get isAndroid {
    if (isWeb) return false;
    return Platform.isAndroid;
  }

  /// Check if running on iOS
  static bool get isIOS {
    if (isWeb) return false;
    return Platform.isIOS;
  }

  /// Check if running on Windows
  static bool get isWindows {
    if (isWeb) return false;
    return Platform.isWindows;
  }

  /// Check if running on macOS
  static bool get isMacOS {
    if (isWeb) return false;
    return Platform.isMacOS;
  }

  /// Check if running on Linux
  static bool get isLinux {
    if (isWeb) return false;
    return Platform.isLinux;
  }

  /// Features availability

  /// Check if camera is available on this platform
  static bool get hasCameraSupport => isMobile;

  /// Check if screen brightness control is available
  static bool get hasBrightnessControl => isMobile;

  /// Check if file picker is available
  static bool get hasFilePicker => !isWeb;

  /// Check if QR scanner (camera-based) is available
  static bool get hasQRScanner => isMobile;

  /// Check if image picker is available
  static bool get hasImagePicker => true; // Available on all platforms

  /// Check if local notifications are supported
  static bool get hasNotificationSupport => isMobile || isDesktop;

  /// Platform-specific feature message
  static String getFeatureUnavailableMessage(String feature) {
    if (isWeb) {
      return '$feature is not available on web browsers.';
    }
    return '$feature is not available on this platform.';
  }

  /// Get platform name for display
  static String get platformName {
    if (isWeb) return 'Web';
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    if (isWindows) return 'Windows';
    if (isMacOS) return 'macOS';
    if (isLinux) return 'Linux';
    return 'Unknown';
  }
}
