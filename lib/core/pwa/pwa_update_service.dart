import 'dart:async';
import 'dart:js_interop';
import 'package:flutter/foundation.dart';

@JS('window.pwaUpdateAvailable')
external bool get _jsIsUpdateAvailable;

@JS('window.onPwaUpdateCallback')
external set _jsOnPwaUpdateCallback(JSFunction f);

@JS('window.pwaUnregisterAndReload')
external void _jsPwaUnregisterAndReload();

class PwaUpdateService {
  static final PwaUpdateService _instance = PwaUpdateService._internal();
  factory PwaUpdateService() => _instance;
  PwaUpdateService._internal();

  final _updateController = StreamController<bool>.broadcast();
  Stream<bool> get updateStream => _updateController.stream;

  bool _initialized = false;
  bool _isUpdateAvailable = false;

  bool get isUpdateAvailable => _isUpdateAvailable;

  void init() {
    if (!kIsWeb || _initialized) return;
    _initialized = true;

    // Check if update flag was set before Dart loaded
    if (_jsIsUpdateAvailable) {
      _isUpdateAvailable = true;
      _updateController.add(true);
    }

    // Register callback for future updates
    _jsOnPwaUpdateCallback = (() {
      _isUpdateAvailable = true;
      _updateController.add(true);
    }.toJS);
  }

  void triggerUpdate() {
    if (!kIsWeb) return;
    _jsPwaUnregisterAndReload();
  }
}
