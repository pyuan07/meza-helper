import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Keys for Hive
const String settingsBoxName = 'settingsBox';
const String keyLanguage = 'language';
const String keyRegion = 'region';
const String keyMaxBrightness = 'maxBrightness';

// Defaults
const String defaultLanguage = 'en';
const String defaultRegion = 'Singapore';
const double defaultMaxBrightness = 0.8;

class SettingsState {
  final String language;
  final String region;
  final double maxBrightness;

  SettingsState({
    required this.language,
    required this.region,
    required this.maxBrightness,
  });

  SettingsState copyWith({
    String? language,
    String? region,
    double? maxBrightness,
  }) {
    return SettingsState(
      language: language ?? this.language,
      region: region ?? this.region,
      maxBrightness: maxBrightness ?? this.maxBrightness,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final Box _box;

  SettingsNotifier(this._box)
      : super(SettingsState(
          language: _box.get(keyLanguage, defaultValue: defaultLanguage),
          region: _box.get(keyRegion, defaultValue: defaultRegion),
          maxBrightness:
              _box.get(keyMaxBrightness, defaultValue: defaultMaxBrightness),
        ));

  Future<void> setLanguage(String language) async {
    await _box.put(keyLanguage, language);
    state = state.copyWith(language: language);
  }

  Future<void> setRegion(String region) async {
    await _box.put(keyRegion, region);
    state = state.copyWith(region: region);
  }

  Future<void> setMaxBrightness(double brightness) async {
    await _box.put(keyMaxBrightness, brightness);
    state = state.copyWith(maxBrightness: brightness);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final box = Hive.box(settingsBoxName);
  return SettingsNotifier(box);
});
