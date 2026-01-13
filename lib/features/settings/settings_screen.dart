import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1E1E2E),
                Color(0xFF101018),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Language Section
                  _buildSectionHeader('Language'),
                  const SizedBox(height: 16),
                  _buildSettingsCard(
                    child: Column(
                      children: [
                        _buildRadioOption(
                          title: 'English',
                          value: 'en',
                          groupValue: settings.language,
                          onChanged: notifier.setLanguage,
                        ),
                        _buildDivider(),
                        _buildRadioOption(
                          title: '中文 (Chinese)',
                          value: 'zh',
                          groupValue: settings.language,
                          onChanged: notifier.setLanguage,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Region Section
                  _buildSectionHeader('Region'),
                  const SizedBox(height: 16),
                  _buildSettingsCard(
                    child: Column(
                      children: [
                        _buildRadioOption(
                          title: 'Singapore 🇸🇬',
                          value: 'Singapore',
                          groupValue: settings.region,
                          onChanged: notifier.setRegion,
                        ),
                        _buildDivider(),
                        _buildRadioOption(
                          title: 'Malaysia 🇲🇾',
                          value: 'Malaysia',
                          groupValue: settings.region,
                          onChanged: notifier.setRegion,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Max Brightness Section
                  _buildSectionHeader('Screen Brightness (QR Scan)'),
                  const SizedBox(height: 16),
                  _buildSettingsCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.brightness_6,
                                  color: Colors.white70),
                              Text(
                                '${(settings.maxBrightness * 100).toInt()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: const Color(0xFF6C63FF),
                              inactiveTrackColor: Colors.white24,
                              thumbColor: Colors.white,
                              overlayColor:
                                  const Color(0xFF6C63FF).withOpacity(0.2),
                              trackHeight: 4,
                            ),
                            child: Slider(
                              value: settings.maxBrightness,
                              min: 0.1, // Don't allow 0 brightness
                              max: 1.0,
                              onChanged: (value) =>
                                  notifier.setMaxBrightness(value),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sets the maximum screen brightness when displaying QR codes for scanning.',
                            style:
                                TextStyle(color: Colors.white38, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildVersionInfo(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
            child: Text(
              'Version ${snapshot.data!.version} (Build ${snapshot.data!.buildNumber})',
              style: const TextStyle(
                color: Colors.white30,
                fontSize: 12,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildSettingsCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A35),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRadioOption({
    required String title,
    required String value,
    required String groupValue,
    required Function(String) onChanged,
  }) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF6C63FF), // Primary accent color
                size: 24,
              )
            else
              const Icon(
                Icons.radio_button_unchecked,
                color: Colors.white24,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.white.withOpacity(0.05),
      indent: 20,
      endIndent: 20,
    );
  }
}
