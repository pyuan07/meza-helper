import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'tag_model.g.dart'; // For Hive generator

@HiveType(typeId: 2)
enum TagType {
  @HiveField(0)
  normal,
  @HiveField(1)
  fire,
  @HiveField(2)
  water,
  @HiveField(3)
  grass,
  @HiveField(4)
  electric,
  @HiveField(5)
  ice,
  @HiveField(6)
  fighting,
  @HiveField(7)
  poison,
  @HiveField(8)
  ground,
  @HiveField(9)
  flying,
  @HiveField(10)
  psychic,
  @HiveField(11)
  bug,
  @HiveField(12)
  rock,
  @HiveField(13)
  ghost,
  @HiveField(14)
  dragon,
  @HiveField(15)
  steel,
  @HiveField(16)
  dark,
  @HiveField(17)
  fairy,
}

extension TagTypeExtension on TagType {
  String get displayName => name[0].toUpperCase() + name.substring(1);

  String get iconPath => 'assets/icons/$name.svg';

  Color get color {
    switch (this) {
      case TagType.normal:
        return const Color(0xFFA8A77A);
      case TagType.fire:
        return Colors.deepOrange; // const Color(0xFFEE8130);
      case TagType.water:
        return Colors.blue; // const Color(0xFF6390F0);
      case TagType.electric:
        return const Color(0xFFF7D02C);
      case TagType.grass:
        return const Color(0xFF7AC74C);
      case TagType.ice:
        return Colors.cyan; // const Color(0xFF96D9D6);
      case TagType.fighting:
        return Colors.red; // const Color(0xFFC22E28);
      case TagType.poison:
        return const Color(0xFFA33EA1);
      case TagType.ground:
        return const Color(0xFFE2BF65);
      case TagType.flying:
        return const Color(0xFFA98FF3);
      case TagType.psychic:
        return Colors.pinkAccent; // const Color(0xFFF95587);
      case TagType.bug:
        return const Color(0xFFA6B91A);
      case TagType.rock:
        return const Color(0xFFB6A136);
      case TagType.ghost:
        return Colors.deepPurple; // const Color(0xFF735797);
      case TagType.dragon:
        return const Color(0xFF6F35FC);
      case TagType.steel:
        return Colors.blueGrey; // const Color(0xFFB7B7CE);
      case TagType.dark:
        return const Color(0xFF705746);
      case TagType.fairy:
        return const Color(0xFFD685AD);
    }
  }
}

@HiveType(typeId: 1)
enum Mechanic {
  @HiveField(0)
  none,
  @HiveField(1)
  zMove,
  @HiveField(2)
  mega,
  @HiveField(3)
  dynamax,
}

@HiveType(typeId: 0)
class TagModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String pokemonName;

  @HiveField(2)
  final TagType type;

  @HiveField(3)
  final Mechanic mechanic;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  bool isOwned;

  TagModel({
    required this.id,
    required this.pokemonName,
    required this.type,
    required this.mechanic,
    required this.imageUrl,
    this.isOwned = false,
  });

  TagModel copyWith({
    String? id,
    String? pokemonName,
    TagType? type,
    Mechanic? mechanic,
    String? imageUrl,
    bool? isOwned,
  }) {
    return TagModel(
      id: id ?? this.id,
      pokemonName: pokemonName ?? this.pokemonName,
      type: type ?? this.type,
      mechanic: mechanic ?? this.mechanic,
      imageUrl: imageUrl ?? this.imageUrl,
      isOwned: isOwned ?? this.isOwned,
    );
  }
}
