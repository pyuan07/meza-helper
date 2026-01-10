import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../models/tag_model.dart';
import '../settings/settings_provider.dart';
import '../../core/platform_utils.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  // Local state removed in favor of global settings

  final List<SupportTicketData> _allTickets = [
    SupportTicketData(
      name: 'Gengar',
      moveName: 'Shadow Ball (Special)',
      moveType: TagType.ghost,
      qrData: '',
      qrImagePath: 'assets/images/qr_codes/gengar_qr.png',
      imagePath: 'assets/images/gengar.png',
      availableInMalaysia: true,
    ),
    SupportTicketData(
      name: 'Lapras',
      moveName: 'Ice Beam (Special)',
      moveType: TagType.ice,
      qrData: '',
      qrImagePath: 'assets/images/qr_codes/lapras_qr.png',
      imagePath: 'assets/images/lapras.png',
      availableInMalaysia: true,
    ),
    SupportTicketData(
      name: 'Mimikyu',
      moveName: 'Shadow Claw (Physical)',
      moveType: TagType.ghost,
      qrData: '',
      qrImagePath: 'assets/images/qr_codes/mimikyu_qr.png',
      imagePath: 'assets/images/mimikyu.png',
      availableInMalaysia: true,
    ),
    SupportTicketData(
      name: 'Duraludon',
      moveName: 'Flash Cannon (Special)',
      moveType: TagType.steel,
      qrData: '',
      qrImagePath: 'assets/images/qr_codes/duraludon_qr.png',
      imagePath: 'assets/images/duraludon.png',
      availableInMalaysia: true,
    ),
    SupportTicketData(
      name: 'Blastoise',
      moveName: 'Hydro Pump (Special)',
      moveType: TagType.water,
      qrData: '',
      qrImagePath: 'assets/images/qr_codes/blastoise_qr.png',
      imagePath: 'assets/images/blastoise.png',
      availableInMalaysia: false,
    ),
    SupportTicketData(
      name: 'Keldeo',
      moveName: 'Secret Sword (Special)',
      moveType: TagType.fighting,
      qrData: '',
      qrImagePath: 'assets/images/qr_codes/keldeo_qr.png',
      imagePath: 'assets/images/keldeo.png',
      availableInMalaysia: false,
    ),
    SupportTicketData(
      name: 'Mega Charizard X',
      moveName: 'Flamethrower (Special)',
      moveType: TagType.fire,
      qrData: '',
      qrImagePath: 'assets/images/qr_codes/mega_charizardX_qr.png',
      imagePath: 'assets/images/charizard_x.png',
      availableInMalaysia: false,
    ),
    SupportTicketData(
      name: 'Mega Gardevoir',
      moveName: 'Psychic (Special)',
      moveType: TagType.psychic,
      qrData: '',
      qrImagePath: 'assets/images/qr_codes/mega_gardevoir_qr.png',
      imagePath: 'assets/images/gardevoir_mega.png',
      availableInMalaysia: false,
    ),
    SupportTicketData(
      name: 'Lucario',
      moveName: 'Aura Sphere (Special)',
      moveType: TagType.fighting,
      qrData: '',
      qrImagePath: 'assets/images/qr_codes/lucario_qr.png',
      imagePath: 'assets/images/lucario.png',
      availableInMalaysia: false,
    ),
    SupportTicketData(
      name: 'Sirfetch\'d',
      moveName: 'Meteor Assault (Physical)',
      moveType: TagType.fighting,
      qrData: '',
      qrImagePath: 'assets/images/qr_codes/sirfetch\'d_qr.png',
      imagePath: 'assets/images/sirfetchd.png',
      availableInMalaysia: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final displayedTickets = settings.region == 'Malaysia'
        ? _allTickets.where((t) => t.availableInMalaysia).toList()
        : _allTickets;

    return Stack(
      children: [
        // Background Gradient
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.background,
                  Color(0xFF2E1A2E)
                ], // Purple tint
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        Column(
          children: [
            // Filter Bar
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top +
                    8, // Top padding for Status Bar
                16,
                8,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                border: const Border(
                  bottom: BorderSide(color: Colors.white10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Region:',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: const Color(0xFF1A1A2E),
                        value: ref.watch(settingsProvider).region,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        items: ['Singapore', 'Malaysia'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(value),
                                const SizedBox(width: 8),
                                Text(
                                  value == 'Malaysia' ? '🇲🇾' : '🇸🇬',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            ref
                                .read(settingsProvider.notifier)
                                .setRegion(newValue);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Ticket List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: displayedTickets.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final ticket = displayedTickets[index];
                  return _SupportTicketCard(
                    name: ticket.name,
                    moveName: ticket.moveName,
                    moveType: ticket.moveType,
                    qrData: ticket.qrData,
                    qrImagePath: ticket.qrImagePath,
                    imagePath: ticket.imagePath,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SupportTicketData {
  final String name;
  final String moveName;
  final TagType moveType;
  final String qrData;
  final String? qrImagePath;
  final String imagePath;
  // typeColor and typeIcon are removed as they are derived from moveType
  final bool availableInMalaysia;

  SupportTicketData({
    required this.name,
    required this.moveName,
    required this.moveType,
    required this.qrData,
    this.qrImagePath,
    required this.imagePath,
    required this.availableInMalaysia,
  });
}

class _SupportTicketCard extends ConsumerWidget {
  final String name;
  final String moveName;
  final TagType moveType;
  final String qrData;
  final String? qrImagePath;
  final String imagePath;

  const _SupportTicketCard({
    required this.name,
    required this.moveName,
    required this.moveType,
    required this.qrData,
    this.qrImagePath,
    required this.imagePath,
  });

  void _showQrDialog(
      BuildContext context, WidgetRef ref, Color typeColor) async {
    // Maximize brightness
    final maxBrightness = ref.read(settingsProvider).maxBrightness;

    // Debug feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Setting brightness to ${(maxBrightness * 100).toInt()}%'),
        duration: const Duration(milliseconds: 1000),
        behavior: SnackBarBehavior.floating,
      ),
    );

    try {
      await ScreenBrightness().setScreenBrightness(maxBrightness);
      // Reset after 5 seconds
      Future.delayed(const Duration(seconds: 5), () async {
        try {
          await ScreenBrightness().resetScreenBrightness();
        } catch (_) {}
      });
    } catch (e) {
      debugPrint("Failed to set brightness: $e");
    }

    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (context) => _FullScreenQRDialog(
        name: name,
        qrData: qrData,
        qrImagePath: qrImagePath,
        color: typeColor,
      ),
    );

    // Reset brightness when dialog closes (safe redundancy)
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      debugPrint("Failed to reset brightness: $e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typeColor = moveType.color;

    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.black, // Fallback
        borderRadius: BorderRadius.circular(24),
        // Glassmorph effect
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            typeColor.withOpacity(0.15),
            typeColor.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: typeColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: typeColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Decor (Circle)
          Positioned(
            right: -30,
            bottom: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: typeColor.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: typeColor.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),

          Row(
            children: [
              // Left: Pokemon Image (Hero-like)
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                  child: Hero(
                    tag: 'pokemon_$name',
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
              ),

              // Right: Info & Actions
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Name
                      Text(
                        name,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Move Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              moveType.iconPath,
                              height: 16,
                              width: 16,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                moveName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Action Button (Scan QR)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _showQrDialog(context, ref, typeColor),
                          icon: const Icon(Icons.qr_code_scanner, size: 20),
                          label: const Text('SCAN TICKET'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: typeColor, // Text color
                            elevation: 4,
                            shadowColor: typeColor.withOpacity(0.5),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FullScreenQRDialog extends StatelessWidget {
  final String name;
  final String qrData;
  final String? qrImagePath;
  final Color color;

  const _FullScreenQRDialog({
    required this.name,
    required this.qrData,
    this.qrImagePath,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blur Background
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
        ),

        // Dialog Content
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'pokemon_$name',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Hero(
                tag: 'qr_$name', // Unique tag if we animated the QR
                child: Container(
                  width: 200,
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: color, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.8),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: qrImagePath != null
                      ? Image.asset(qrImagePath!, fit: BoxFit.contain)
                      : QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 180,
                          errorCorrectionLevel: QrErrorCorrectLevel.H,
                        ),
                ),
              ),
              if (!PlatformUtils.hasBrightnessControl) ...[
                const SizedBox(height: 24),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.brightness_6, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Please maximize brightness manually',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
