import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Centralized error handling for consistent user experience
class ErrorHandler {
  /// Handle error with user-friendly message and optional logging
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await someOperation();
  /// } catch (e) {
  ///   ErrorHandler.handle(
  ///     context,
  ///     e,
  ///     userMessage: 'Failed to save data',
  ///   );
  /// }
  /// ```
  static void handle(
    BuildContext context,
    Object error, {
    String? userMessage,
    bool showSnackBar = true,
    StackTrace? stackTrace,
  }) {
    // Log error for debugging
    _logError(error, userMessage, stackTrace);

    if (showSnackBar && context.mounted) {
      final message = userMessage ?? _getDefaultErrorMessage(error);
      _showErrorSnackBar(context, message);
    }
  }

  /// Show error dialog for critical errors
  static void showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onRetry,
  }) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onRetry();
              },
              child: const Text('Retry'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show error snackbar
  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Log error for debugging
  static void _logError(
      Object error, String? userMessage, StackTrace? stackTrace) {
    if (kDebugMode) {
      debugPrint('═══ Error Handler ═══');
      if (userMessage != null) {
        debugPrint('User Message: $userMessage');
      }
      debugPrint('Error: $error');
      if (stackTrace != null) {
        debugPrint('Stack Trace:\n$stackTrace');
      }
      debugPrint('═══════════════════');
    }

    // TODO: In production, send to analytics/crashlytics
    // Example: FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: userMessage);
  }

  /// Get default error message based on error type
  static String _getDefaultErrorMessage(Object error) {
    if (error is Exception) {
      return 'An error occurred. Please try again.';
    }
    return 'Something went wrong. Please try again.';
  }

  /// Show success snackbar
  static void showSuccess(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show info snackbar
  static void showInfo(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
