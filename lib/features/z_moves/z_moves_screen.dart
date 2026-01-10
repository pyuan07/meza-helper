import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme.dart';

class ZMovesScreen extends ConsumerWidget {
  const ZMovesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _zMoves.length,
                  itemBuilder: (context, index) {
                    return _ZMoveCard(move: _zMoves[index]);
                  },
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
            child: SvgPicture.asset(
              'assets/icons/${move.type.toLowerCase()}.svg',
              width: 32,
              height: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              move.type,
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

enum ZMoveDirection { left, right }

class ZMoveData {
  final String type;
  final Color color;
  final List<ZMoveDirection> sequence;

  const ZMoveData({
    required this.type,
    required this.color,
    required this.sequence,
  });
}

// Data matching the provided image
final List<ZMoveData> _zMoves = [
  const ZMoveData(
    type: 'Fighting',
    color: Colors.red,
    sequence: [
      ZMoveDirection.right,
      ZMoveDirection.left,
      ZMoveDirection.right,
      ZMoveDirection.left
    ],
  ),
  const ZMoveData(
    type: 'Water',
    color: Colors.blue,
    sequence: [
      ZMoveDirection.right,
      ZMoveDirection.right,
      ZMoveDirection.right,
      ZMoveDirection.left
    ],
  ),
  const ZMoveData(
    type: 'Ground',
    color: Colors.brown,
    sequence: [
      ZMoveDirection.right,
      ZMoveDirection.left,
      ZMoveDirection.left,
      ZMoveDirection.right
    ],
  ),
  const ZMoveData(
    type: 'Grass',
    color: Colors.green,
    sequence: [
      ZMoveDirection.right,
      ZMoveDirection.left,
      ZMoveDirection.right,
      ZMoveDirection.right
    ],
  ),
  const ZMoveData(
    type: 'Flying',
    color: Colors.lightBlueAccent,
    sequence: [
      ZMoveDirection.left,
      ZMoveDirection.left,
      ZMoveDirection.left,
      ZMoveDirection.right
    ],
  ),
  const ZMoveData(
    type: 'Ice',
    color: Colors.cyan,
    sequence: [
      ZMoveDirection.left,
      ZMoveDirection.right,
      ZMoveDirection.left,
      ZMoveDirection.left
    ],
  ),
  ZMoveData(
    type: 'Rock',
    color: Colors.brown.shade300,
    sequence: [
      ZMoveDirection.right,
      ZMoveDirection.right,
      ZMoveDirection.left,
      ZMoveDirection.right
    ],
  ),
  const ZMoveData(
    type: 'Dragon',
    color: Colors.indigo,
    sequence: [
      ZMoveDirection.left,
      ZMoveDirection.right,
      ZMoveDirection.left,
      ZMoveDirection.left
    ],
  ),
  const ZMoveData(
    type: 'Fairy',
    color: Colors.pinkAccent,
    sequence: [
      ZMoveDirection.left,
      ZMoveDirection.right,
      ZMoveDirection.right,
      ZMoveDirection.right
    ],
  ),
  const ZMoveData(
    type: 'Psychic',
    color: Colors.purpleAccent,
    sequence: [
      ZMoveDirection.right,
      ZMoveDirection.left,
      ZMoveDirection.left,
      ZMoveDirection.right
    ],
  ),
  const ZMoveData(
    type: 'Ghost',
    color: Colors.deepPurple,
    sequence: [
      ZMoveDirection.left,
      ZMoveDirection.left,
      ZMoveDirection.right,
      ZMoveDirection.left
    ],
  ),
  ZMoveData(
    type: 'Dark',
    color: Colors.grey.shade800,
    sequence: [
      ZMoveDirection.left,
      ZMoveDirection.right,
      ZMoveDirection.left,
      ZMoveDirection.right
    ],
  ),
  const ZMoveData(
    type: 'Steel',
    color: Colors.blueGrey,
    sequence: [
      ZMoveDirection.left,
      ZMoveDirection.right,
      ZMoveDirection.right,
      ZMoveDirection.left
    ],
  ),
  const ZMoveData(
    type: 'Fire',
    color: Colors.deepOrange,
    sequence: [
      ZMoveDirection.left,
      ZMoveDirection.left,
      ZMoveDirection.right,
      ZMoveDirection.left
    ],
  ),
  const ZMoveData(
    type: 'Electric',
    color: Colors.amber,
    sequence: [
      ZMoveDirection.right,
      ZMoveDirection.left,
      ZMoveDirection.right,
      ZMoveDirection.left
    ],
  ),
];
