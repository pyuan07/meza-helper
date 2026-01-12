import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure google_fonts is in pubspec, otherwise fallback
import '../../../models/tag_model.dart';
import '../../../providers/tag_provider.dart';

class TagDetailsModal extends ConsumerStatefulWidget {
  final TagModel tag;

  const TagDetailsModal({super.key, required this.tag});

  @override
  ConsumerState<TagDetailsModal> createState() => _TagDetailsModalState();
}

class _TagDetailsModalState extends ConsumerState<TagDetailsModal> {
  late Future<Map<String, dynamic>> _pokemonData;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _pokemonData = _fetchPokemonData();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _getApiName(TagModel tag) {
    switch (tag.id) {
      case '1-4-005':
        return 'calyrex-ice';
      case '1-4-006':
        return 'calyrex-shadow';
      case '1-4-008':
        return 'kyurem-white';
      case '1-4-009':
        return 'kyurem-black';
    }

    final name = tag.pokemonName.toLowerCase().trim();
    if (name == 'mimikyu') {
      return 'mimikyu-disguised';
    }

    return name.replaceAll(' ', '-');
  }

  Future<Map<String, dynamic>> _fetchPokemonData() async {
    final queryName = _getApiName(widget.tag);

    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$queryName');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List<dynamic> types = data['types'];
      final List<String> typeNames =
          types.map((t) => t['type']['name'].toString()).toList();

      final String cryUrl =
          data['cries']['latest'] ?? data['cries']['legacy'] ?? '';

      return {
        'types': typeNames,
        'cryUrl': cryUrl,
      };
    } else {
      return {
        'types': <String>[],
        'cryUrl': '',
      };
    }
  }

  Future<void> _playCry(String url) async {
    if (url.isNotEmpty) {
      await _audioPlayer.play(UrlSource(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the live tag state to get updates on ownership
    final liveTag = ref.watch(tagByIdProvider(widget.tag.id)) ?? widget.tag;

    final themeColor = liveTag.type.color;
    // Darker variant for text/borders
    final darkenColor = HSLColor.fromColor(themeColor)
        .withLightness(
            (HSLColor.fromColor(themeColor).lightness - 0.2).clamp(0.0, 1.0))
        .toColor();

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // 1. Blurred Background Overlay
            Positioned.fill(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),

            // 2. Main Content Center
            Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  constraints: const BoxConstraints(maxWidth: 420),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.95),
                        Colors.white.withOpacity(0.90),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withOpacity(0.5),
                        blurRadius: 60,
                        offset: const Offset(0, 20),
                        spreadRadius: -10,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.8),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- Image Section (Floating) ---
                      const SizedBox(height: 40),
                      Hero(
                        tag: 'tag_${liveTag.id}',
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Oval Shadow behind the image
                            Container(
                              width: 200,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeColor.withOpacity(0.6),
                                    blurRadius: 40,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                            ),
                            // The Image
                            SizedBox(
                              height: 240,
                              child: Image.asset(
                                liveTag.imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Icon(
                                    Icons.broken_image,
                                    size: 80,
                                    color: Colors.grey[400]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- Header Section ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            Text(
                              liveTag.pokemonName.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                                height: 1.0,
                                color: const Color(0xFF2D3142),
                                shadows: [
                                  Shadow(
                                    color: themeColor.withOpacity(0.3),
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: themeColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: themeColor.withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    liveTag.id,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: darkenColor,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Ownership Toggle
                                GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(tagListProvider.notifier)
                                        .toggleOwnership(
                                            liveTag.id, !liveTag.isOwned);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: liveTag.isOwned
                                          ? const Color(0xFF4CAF50)
                                              .withOpacity(0.15)
                                          : Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: liveTag.isOwned
                                            ? const Color(0xFF4CAF50)
                                            : Colors.grey.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          liveTag.isOwned
                                              ? Icons.check_circle_rounded
                                              : Icons.radio_button_unchecked,
                                          size: 16,
                                          color: liveTag.isOwned
                                              ? const Color(0xFF4CAF50)
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          liveTag.isOwned ? 'OWNED' : 'MISSING',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: liveTag.isOwned
                                                ? const Color(0xFF4CAF50)
                                                : Colors.grey[600],
                                            letterSpacing: 1.0,
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
                      ),

                      const SizedBox(height: 32),

                      // --- Stats Grid ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: FutureBuilder<Map<String, dynamic>>(
                          future: _pokemonData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                height: 100,
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: themeColor),
                                ),
                              );
                            }

                            final data = snapshot.data ?? {};
                            final typeNames =
                                (data['types'] as List<String>?) ?? [];
                            final cryUrl = (data['cryUrl'] as String?) ?? '';

                            return Column(
                              children: [
                                // Info Row
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Mezastar Move Card
                                      Expanded(
                                        flex: 3,
                                        child: _buildInfoCard(
                                          title: 'MEZASTAR MOVE',
                                          color: themeColor,
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  _buildTypeIcon(liveTag.type,
                                                      size: 24),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          liveTag.moveName
                                                                  .isEmpty
                                                              ? '-'
                                                              : liveTag
                                                                  .moveName,
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 16,
                                                            height: 1.2,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Text(
                                                          liveTag.moveCategory ==
                                                                  MoveCategory
                                                                      .physical
                                                              ? '(Physical)'
                                                              : '(Special)',
                                                          style: TextStyle(
                                                            color: liveTag
                                                                .moveCategory
                                                                .color,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Types Card
                                      Expanded(
                                        flex: 2,
                                        child: _buildInfoCard(
                                          title: 'TYPES',
                                          color: Colors.blueGrey,
                                          content: Center(
                                            child: typeNames.isEmpty
                                                ? const Text('-',
                                                    style: TextStyle(
                                                        color: Colors.grey))
                                                : Wrap(
                                                    alignment:
                                                        WrapAlignment.center,
                                                    spacing: 8,
                                                    runSpacing: 8,
                                                    children:
                                                        typeNames.map((t) {
                                                      final tagType =
                                                          TagTypeExtension
                                                              .parse(t);
                                                      return Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: tagType
                                                                  .color
                                                                  .withOpacity(
                                                                      0.3),
                                                              blurRadius: 8,
                                                              offset:
                                                                  const Offset(
                                                                      0, 2),
                                                            )
                                                          ],
                                                        ),
                                                        child: _buildTypeIcon(
                                                            tagType,
                                                            size: 22),
                                                      );
                                                    }).toList(),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 32),

                                // Action Button (Cry)
                                if (cryUrl.isNotEmpty)
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: themeColor.withOpacity(0.4),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () => _playCry(cryUrl),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: themeColor,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 18),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.volume_up_rounded,
                                              size: 26),
                                          SizedBox(width: 10),
                                          Text(
                                            'PLAY CRY',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 16,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  const SizedBox(height: 60),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Close Button (Floating)
            Positioned(
              top: 50,
              right: 24,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.close_rounded,
                        color: Colors.black87, size: 28),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required Color color,
    required Widget content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.grey[400],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: content),
        ],
      ),
    );
  }

  Widget _buildTypeIcon(TagType type, {double size = 24}) {
    return SvgPicture.asset(
      type.iconPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(type.color, BlendMode.srcIn),
      placeholderBuilder: (_) =>
          Icon(Icons.circle, color: type.color, size: size),
    );
  }
}
