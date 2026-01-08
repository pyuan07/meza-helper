import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:permission_handler/permission_handler.dart'; // Unused in this file explicitly, but good to keep if needed later or removing if unused. Keeping imports as is essentially.

import '../../models/trainer_model.dart';
import '../../services/storage_service.dart';
import '../settings/settings_provider.dart';

class TrainerPassScreen extends ConsumerStatefulWidget {
  const TrainerPassScreen({super.key});

  @override
  ConsumerState<TrainerPassScreen> createState() => _TrainerPassScreenState();
}

class _TrainerPassScreenState extends ConsumerState<TrainerPassScreen> {
  late PageController _pageController;
  Timer? _brightnessTimer;

  @override
  void initState() {
    super.initState();
    // Smaller fraction to show side cards clearly (Spin effect)
    _pageController = PageController(viewportFraction: 0.65);

    // Add dummy data for testing if we have fewer than 3
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final trainers = ref.read(trainersProvider);
      if (trainers.length < 3) {
        if (!trainers.any((t) => t.name == "Ash Ketchum")) {
          ref
              .read(trainersProvider.notifier)
              .addTrainer("Ash Ketchum", "MEZA-1234-5678");
        }
        if (!trainers.any((t) => t.name == "Gary Oak")) {
          ref
              .read(trainersProvider.notifier)
              .addTrainer("Gary Oak", "MEZA-8765-4321");
        }
        if (!trainers.any((t) => t.name == "Cynthia")) {
          ref
              .read(trainersProvider.notifier)
              .addTrainer("Cynthia", "MEZA-9999-0000");
        }
      }
      // Removed auto-brightness on entry
      // _setBrightness(1.0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _brightnessTimer?.cancel();
    _resetBrightness();
    super.dispose();
  }

  Future<void> _setBrightness(double brightness) async {
    // ScreenBrightness not supported on Web in the way we use it/plugin limits
    if (kIsWeb) return;
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      debugPrint('Failed to set brightness: $e');
    }
  }

  Future<void> _resetBrightness() async {
    if (kIsWeb) return;
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      debugPrint('Failed to reset brightness: $e');
    }
  }

  void _temporarilyMaximizeBrightness() {
    _brightnessTimer?.cancel();
    final maxBrightness = ref.read(settingsProvider).maxBrightness;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Setting brightness to ${(maxBrightness * 100).toInt()}%'),
        duration: const Duration(milliseconds: 1000),
        behavior: SnackBarBehavior.floating,
      ),
    );

    _setBrightness(maxBrightness);
    // Reset after 5 seconds
    _brightnessTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        _resetBrightness();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final trainers = ref.watch(trainersProvider);

    return Scaffold(
      backgroundColor: Colors.transparent, // Let MainScaffold background show
      body: Stack(
        children: [
          // Remove local dark background so we don't block MainScaffold gradient if desired
          // But for QR contrast we might want a dark overlay behind just the carousel?
          // Let's keep a partial dark overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.8)),
          ),
          if (trainers.isEmpty)
            _buildEmptyState()
          else
            PageView.builder(
              controller: _pageController,
              itemCount: trainers.length,
              // No clip to allow overflowing shadows/glows
              clipBehavior: Clip.none,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double page = 0.0;
                    if (_pageController.position.haveDimensions) {
                      page = _pageController.page ?? 0.0;
                    }

                    double value = page - index;
                    value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);

                    final double blur = (1 - value) * 5;
                    final double scale = value;
                    final double opacity = value.clamp(0.5, 1.0);

                    return Center(
                      child: Transform.scale(
                        scale: scale,
                        child: Opacity(
                          opacity: opacity,
                          child: ImageFiltered(
                            imageFilter: ui.ImageFilter.blur(
                              sigmaX: blur,
                              sigmaY: blur,
                            ),
                            child: child,
                          ),
                        ),
                      ),
                    );
                  },
                  child: _TrainerCard(
                    trainer: trainers[index],
                    onBrightnessRequest: _temporarilyMaximizeBrightness,
                  ),
                );
              },
            ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0),
        child: FloatingActionButton(
          onPressed: _showAddTrainerOptions,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.badge, size: 80, color: Colors.grey[700]),
          const SizedBox(height: 20),
          const Text(
            'No Trainers Found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text('Add your Trainer ID to get started.'),
        ],
      ),
    );
  }

  void _showAddTrainerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.keyboard),
              title: const Text('Enter Manually'),
              onTap: () {
                Navigator.pop(context);
                _showManualEntryDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Import from Screenshot'),
              onTap: () {
                Navigator.pop(context);
                _pickImageAndScan();
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort),
              title: const Text('Reorder Trainers'),
              onTap: () {
                Navigator.pop(context);
                _showReorderSheet();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showManualEntryDialog() {
    final nameCtrl = TextEditingController();
    final idCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Trainer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Trainer Name'),
            ),
            TextField(
              controller: idCtrl,
              decoration: const InputDecoration(labelText: 'Mezastar ID'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && idCtrl.text.isNotEmpty) {
                ref.read(trainersProvider.notifier).addTrainer(
                      nameCtrl.text,
                      idCtrl.text,
                    );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showReorderSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Consumer(
            builder: (context, ref, child) {
              final trainers = ref.watch(trainersProvider);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Reorder Trainers',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: ReorderableListView.builder(
                      itemCount: trainers.length,
                      onReorder: (oldIndex, newIndex) {
                        ref
                            .read(trainersProvider.notifier)
                            .reorderTrainers(oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        final trainer = trainers[index];
                        return ListTile(
                          key: ValueKey(trainer.id),
                          title: Text(trainer.name),
                          subtitle: Text(trainer.mezastarId),
                          leading: const Icon(Icons.drag_handle),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _pickImageAndScan() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    // Check permissions if needed (usually handled by plugin, but good practice)
    // await Permission.photos.request();

    try {
      final MobileScannerController controller = MobileScannerController();
      final BarcodeCapture? capture = await controller.analyzeImage(image.path);

      if (capture != null && capture.barcodes.isNotEmpty) {
        final String? code = capture.barcodes.first.rawValue;
        if (code != null) {
          if (!mounted) return;
          _showConfirmImportDialog(code);
        } else {
          _showErrorSnackBar('No QR code found in image.');
        }
      } else {
        _showErrorSnackBar('No QR code found in image.');
      }
      controller.dispose();
    } catch (e) {
      _showErrorSnackBar('Error scanning image: $e');
    }
  }

  void _showConfirmImportDialog(String code) {
    // Attempt to parse name/id if the QR follows a format, otherwise just ask for name
    // For now, assume raw code is the ID
    final nameCtrl = TextEditingController(text: 'My Trainer');
    final idCtrl = TextEditingController(text: code);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Import Trainer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('QR Code detected!'),
            const SizedBox(height: 10),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Trainer Name'),
            ),
            TextField(
              controller: idCtrl,
              readOnly: true, // ID comes from QR
              decoration: const InputDecoration(labelText: 'Mezastar ID'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                ref.read(trainersProvider.notifier).addTrainer(
                      nameCtrl.text,
                      code,
                    );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

class _TrainerCard extends StatelessWidget {
  final TrainerModel trainer;
  final VoidCallback onBrightnessRequest;

  const _TrainerCard({
    required this.trainer,
    required this.onBrightnessRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // Glass effect
              borderRadius: BorderRadius.circular(24),
              border:
                  Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  trainer.name,
                  style: const TextStyle(
                    color: Colors.white, // White text for contrast on dark bg
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ID: ${trainer.mezastarId}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                    letterSpacing: 1.5,
                    fontFeatures: const [ui.FontFeature.tabularFigures()],
                    shadows: const [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(8), // Reduced padding from 12
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: QrImageView(
                    data: trainer.mezastarId,
                    version: QrVersions.auto,
                    size: 220.0,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(0), // Ensure no padding
                    gapless: false,
                  ),
                ),
                // Brightness Button
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: onBrightnessRequest,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.orange, Colors.orangeAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.brightness_7, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'MAX BRIGHTNESS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Scan at the Arcade Machine',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
