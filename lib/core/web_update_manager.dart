import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:js_interop';

@JS('window.onUpdateAvailable')
external set _onUpdateAvailable(JSFunction f);

@JS('window.triggerUpdate')
external void _triggerUpdate();

class WebUpdateManager {
  static final WebUpdateManager _instance = WebUpdateManager._internal();
  factory WebUpdateManager() => _instance;
  WebUpdateManager._internal();

  bool _initialized = false;

  void init(BuildContext context) {
    if (!kIsWeb || _initialized) return;
    _initialized = true;

    // Register the callback that JS will call when an update is found
    _onUpdateAvailable = ((JSString message) {
      _showUpdateSnackBar(context);
    }.toJS);

    // Check initially if we missed the event (optional, handled by JS side logic usually)
  }

  void _showUpdateSnackBar(BuildContext context) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.system_update, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Version Available!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('A new version is available. Update now?'),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade900,
        behavior: SnackBarBehavior.fixed, // Stick to bottom
        duration: const Duration(days: 365), // Don't dismiss automatically
        action: SnackBarAction(
          label: 'UPDATE',
          textColor: Colors.amberAccent,
          onPressed: () {
            _triggerUpdate();
          },
        ),
      ),
    );
  }
}
