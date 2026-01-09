import 'package:flutter/material.dart';

/// Screen size categories for responsive design
enum ScreenSize { mobile, tablet, desktop }

/// Responsive design utilities with standardized breakpoints
class Responsive {
  // Breakpoint constants
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Get the current screen size category
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) return ScreenSize.mobile;
    if (width < tabletBreakpoint) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return getScreenSize(context) == ScreenSize.mobile;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    return getScreenSize(context) == ScreenSize.tablet;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return getScreenSize(context) == ScreenSize.desktop;
  }

  /// Get value based on screen size
  ///
  /// Example:
  /// ```dart
  /// final padding = Responsive.valueWhen(
  ///   context: context,
  ///   mobile: 8.0,
  ///   tablet: 16.0,
  ///   desktop: 24.0,
  /// );
  /// ```
  static T valueWhen<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Get responsive grid column count
  static int getGridColumnCount(
    BuildContext context, {
    int mobile = 3,
    int tablet = 5,
    int desktop = 7,
  }) {
    return valueWhen(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Get responsive font size scale
  static double getFontScale(BuildContext context) {
    return valueWhen(
      context: context,
      mobile: 1.0,
      tablet: 1.1,
      desktop: 1.15,
    );
  }

  /// Get responsive padding
  static EdgeInsets getPagePadding(BuildContext context) {
    return EdgeInsets.all(
      valueWhen(
        context: context,
        mobile: 16.0,
        tablet: 24.0,
        desktop: 32.0,
      ),
    );
  }
}
