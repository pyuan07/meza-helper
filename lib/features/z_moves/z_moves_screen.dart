import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme.dart';
import 'data/z_move_data.dart';

class ZMovesScreen extends ConsumerWidget {
  const ZMovesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zMoves = ZMoveRepository.getAllMoves();

    return Stack(
      children: [
        // Background Gradient
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.background, Color(0xFF1A1A2E)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // Content
        SafeArea(
          child: Column(
            children: [
              // Custom Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Z-Moves Guide',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                ),
              ),

              // List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Standard Moves
                    ...zMoves
                        .where((m) => m.relatedType != null)
                        .map((m) => _ZMoveCard(move: m)),

                    // Special Moves Section
                    if (zMoves.any((m) => m.relatedType == null)) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Row(
                          children: [
                            Expanded(child: Divider(color: Colors.white24)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'SPECIAL MOVES',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.white24)),
                          ],
                        ),
                      ),
                      ...zMoves
                          .where((m) => m.relatedType == null)
                          .map((m) => _ZMoveCard(move: m)),
                    ],
                    const SizedBox(height: 80), // Bottom padding
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ZMoveCard extends StatelessWidget {
  final ZMoveData move;

  const _ZMoveCard({required this.move});

  @override
  Widget build(BuildContext context) {
    final isSpecial = move.relatedType == null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: move.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: move.color.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: move.color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon and Name Section
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: isSpecial
                ? const Icon(Icons.star_rounded, color: Colors.white, size: 32)
                : SvgPicture.asset(
                    'assets/icons/${move.label.toLowerCase()}.svg',
                    width: 32,
                    height: 32,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isSpecial)
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'SPECIAL',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Text(
                  move.label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: move.color,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Arrow Sequence Section
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: move.sequence.map((dir) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    dir == ZMoveDirection.left
                        ? Icons.arrow_back_ios_new_rounded
                        : Icons.arrow_forward_ios_rounded,
                    color: dir == ZMoveDirection.left
                        ? Colors.cyanAccent
                        : Colors.orangeAccent,
                    size: 26,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
