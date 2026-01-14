import 'package:flutter/material.dart';
import '../../../models/tag_model.dart';

enum ZMoveDirection { left, right }

class ZMoveData {
  final String label; // Type name or Pokemon name
  final Color color;
  final List<ZMoveDirection> sequence;
  final TagType? relatedType; // Null for special pokemon moves

  const ZMoveData({
    required this.label,
    required this.color,
    required this.sequence,
    this.relatedType,
  });
}

class ZMoveRepository {
  static final List<ZMoveData> _allMoves = [
    // --- Special Pokemon Moves ---
    const ZMoveData(
      label: 'Pikachu',
      color: Color(0xFFF7D02C), // Electric-ish yellow
      sequence: [
        ZMoveDirection.left,
        ZMoveDirection.left,
        ZMoveDirection.right,
        ZMoveDirection.right
      ],
      relatedType: null,
    ),
    const ZMoveData(
      label: 'Mimikyu',
      color: Color(0xFF9E868E), // Ghostly/Fairy muted pink-grey
      sequence: [
        ZMoveDirection.left,
        ZMoveDirection.right,
        ZMoveDirection.right,
        ZMoveDirection.right
      ],
      relatedType: null,
    ),

    // --- Type-based Moves ---
    const ZMoveData(
      label: 'Fighting',
      color: Color(0xFFE40011),
      sequence: [
        ZMoveDirection.right,
        ZMoveDirection.left,
        ZMoveDirection.right,
        ZMoveDirection.left
      ],
      relatedType: TagType.fighting,
    ),
    const ZMoveData(
      label: 'Water',
      color: Color(0xFF008AD5),
      sequence: [
        ZMoveDirection.right,
        ZMoveDirection.right,
        ZMoveDirection.right,
        ZMoveDirection.left
      ],
      relatedType: TagType.water,
    ),
    const ZMoveData(
      label: 'Ground',
      color: Color(0xFFE3A754),
      sequence: [
        ZMoveDirection.right,
        ZMoveDirection.left,
        ZMoveDirection.left,
        ZMoveDirection.right
      ],
      relatedType: TagType.ground,
    ),
    const ZMoveData(
      label: 'Grass',
      color: Color(0xFF8DC31C),
      sequence: [
        ZMoveDirection.right,
        ZMoveDirection.left,
        ZMoveDirection.right,
        ZMoveDirection.right
      ],
      relatedType: TagType.grass,
    ),
    const ZMoveData(
      label: 'Flying',
      color: Color(0xFFA98FF3),
      sequence: [
        ZMoveDirection.left,
        ZMoveDirection.left,
        ZMoveDirection.left,
        ZMoveDirection.right
      ],
      relatedType: TagType.flying,
    ),
    const ZMoveData(
      label: 'Ice',
      color: Color(0xFF54C2F0),
      sequence: [
        ZMoveDirection.left,
        ZMoveDirection.right,
        ZMoveDirection.left,
        ZMoveDirection.left
      ],
      relatedType: TagType.ice,
    ),
    const ZMoveData(
      label: 'Rock',
      color: Color(0xFFB6A136),
      sequence: [
        ZMoveDirection.right,
        ZMoveDirection.right,
        ZMoveDirection.left,
        ZMoveDirection.right
      ],
      relatedType: TagType.rock,
    ),
    const ZMoveData(
      label: 'Dragon',
      color: Color(
          0xFFF4D128), // NOTE: Standard dragon color is usually purple/blue in Pokemon, but Mezastar might differ. Keeping user's previous color or standardized.
      // Reverting to previous file's color for Dragon? Previous was Indigo. TagType.dragon is F4D128 (Yellowish).
      // Let's use the TagType color for consistency if possible, or override.
      // User's previous file had: Dragon -> Indigo.
      // TagType.dragon -> 0xFFF4D128 (Yellow).
      // I will use TagType colors for consistency where possible, but hardcode if needed.
      // Let's stick to the values I saw in the previous file for Type consistency, OR use TagType colors.
      // The previous file had specific colors. I will try to use TagType extension colors where they match, but manual where they don't.
      // Actually, safest is to just copy the previous list and add the specials at the top.
      sequence: [
        ZMoveDirection.left,
        ZMoveDirection.right,
        ZMoveDirection.left,
        ZMoveDirection.left
      ],
      relatedType: TagType.dragon,
    ),
    const ZMoveData(
      label: 'Fairy',
      color: Color(0xFFE95F9D),
      sequence: [
        ZMoveDirection.left,
        ZMoveDirection.right,
        ZMoveDirection.right,
        ZMoveDirection.right
      ],
      relatedType: TagType.fairy,
    ),
    const ZMoveData(
      label: 'Psychic',
      color: Color(0xFFEF92B9),
      sequence: [
        ZMoveDirection.right,
        ZMoveDirection.left,
        ZMoveDirection.left,
        ZMoveDirection.right
      ],
      relatedType: TagType.psychic,
    ),
    const ZMoveData(
      label: 'Ghost',
      color: Color(0xFF413684),
      sequence: [
        ZMoveDirection.left,
        ZMoveDirection.left,
        ZMoveDirection.right,
        ZMoveDirection.left
      ],
      relatedType: TagType.ghost,
    ),
    const ZMoveData(
      label: 'Dark',
      color: Color(0xFF4B4847),
      sequence: [
        ZMoveDirection.left,
        ZMoveDirection.right,
        ZMoveDirection.left,
        ZMoveDirection.right
      ],
      relatedType: TagType.dark,
    ),
    const ZMoveData(
      label: 'Steel',
      color: Color(0xFFAFCED3),
      sequence: [
        ZMoveDirection.left,
        ZMoveDirection.right,
        ZMoveDirection.right,
        ZMoveDirection.left
      ],
      relatedType: TagType.steel,
    ),
    const ZMoveData(
      label: 'Fire',
      color: Color(0xFFF29700),
      sequence: [
        ZMoveDirection.left,
        ZMoveDirection.left,
        ZMoveDirection.right,
        ZMoveDirection.left
      ],
      relatedType: TagType.fire,
    ),
    const ZMoveData(
      label: 'Electric',
      color: Color(0xFFFDCF00), // TagType.electric
      sequence: [
        ZMoveDirection.right,
        ZMoveDirection.left,
        ZMoveDirection.right,
        ZMoveDirection.left
      ],
      relatedType: TagType.electric,
    ),
  ];

  static List<ZMoveData> getAllMoves() => _allMoves;

  static ZMoveData? getMoveForTag(TagModel tag) {
    if (tag.mechanic != Mechanic.zMove) return null;

    // 1. Check for Special Pokemon Moves
    try {
      return _allMoves.firstWhere((move) =>
          move.relatedType == null &&
          move.label.toLowerCase() == tag.pokemonName.toLowerCase());
    } catch (_) {}

    // 2. Fallback to Type-based Moves
    try {
      return _allMoves.firstWhere((move) => move.relatedType == tag.type);
    } catch (_) {}

    return null;
  }
}
