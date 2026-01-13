import 'package:flutter/material.dart';
import 'pwa_update_service.dart';

class PwaUpdateListener extends StatefulWidget {
  final Widget child;

  const PwaUpdateListener({
    super.key,
    required this.child,
  });

  @override
  State<PwaUpdateListener> createState() => _PwaUpdateListenerState();
}

class _PwaUpdateListenerState extends State<PwaUpdateListener> {
  @override
  void initState() {
    super.initState();
    final service = PwaUpdateService();
    service.init();

    // Check immediately and listen
    if (service.isUpdateAvailable) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showUpdateSnackBar();
      });
    }

    service.updateStream.listen((isAvailable) {
      if (isAvailable && mounted) {
        _showUpdateSnackBar();
      }
    });
  }

  void _showUpdateSnackBar() {
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
                  Text('Tap Update to load the latest version.'),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade900,
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(days: 365), // Persistent
        action: SnackBarAction(
          label: 'UPDATE',
          textColor: Colors.amberAccent,
          onPressed: () {
            PwaUpdateService().triggerUpdate();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
