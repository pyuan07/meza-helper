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
        return const Color(0xFFBFBF95);
      case TagType.fire:
        return const Color(0xFFF29700);
      case TagType.water:
        return const Color(0xFF008AD5);
      case TagType.electric:
        return const Color(0xFFFDCF00);
      case TagType.grass:
        return const Color(0xFF8DC31C);
      case TagType.ice:
        return const Color(0xFF54C2F0);
      case TagType.fighting:
        return const Color(0xFFE40011);
      case TagType.poison:
        return const Color(0xFFA573AF);
      case TagType.ground:
        return const Color(0xFFE3A754);
      case TagType.flying:
        return const Color(0xFFA98FF3);
      case TagType.psychic:
        return const Color(0xFFEF92B9);
      case TagType.bug:
        return const Color(0xFFDADE00);
      case TagType.rock:
        return const Color(0xFFB6A136);
      case TagType.ghost:
        return const Color(0xFF413684);
      case TagType.dragon:
        return const Color(0xFFF4D128);
      case TagType.steel:
        return const Color(0xFFAFCED3);
      case TagType.dark:
        return const Color(0xFF4B4847);
      case TagType.fairy:
        return const Color(0xFFE95F9D);
    }
  }

  static TagType parse(String value) {
    return TagType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => TagType.normal,
    );
  }
}

@HiveType(typeId: 3)
enum Mechanic {
  @HiveField(0)
  none,
  @HiveField(1)
  zMove,
  @HiveField(2)
  mega,
  @HiveField(3)
  dynamax,
  @HiveField(4)
  tera,
}

extension MechanicExtension on Mechanic {
  String get displayName {
    switch (this) {
      case Mechanic.none:
        return 'None';
      case Mechanic.zMove:
        return 'Z-Move';
      case Mechanic.mega:
        return 'Mega Evolution';
      case Mechanic.dynamax:
        return 'Dynamax';
      case Mechanic.tera:
        return 'Terastal';
    }
  }

  Color get color {
    switch (this) {
      case Mechanic.none:
        return Colors.transparent;
      case Mechanic.zMove:
        return const Color(0xFFFDB901);
      case Mechanic.mega:
        return const Color(0xFF8B2FC9);
      case Mechanic.dynamax:
        return const Color(0xFFFF0055);
      case Mechanic.tera:
        return const Color(0xFF00FFE1);
    }
  }
}

@HiveType(typeId: 4)
enum MoveCategory {
  @HiveField(0)
  physical,
  @HiveField(1)
  special,
}

extension MoveCategoryExtension on MoveCategory {
  String get displayName {
    switch (this) {
      case MoveCategory.physical:
        return 'Physical';
      case MoveCategory.special:
        return 'Special';
    }
  }

  Color get color {
    switch (this) {
      case MoveCategory.physical:
        return const Color(0xFFE84F35); // Or a specific detailed color
      case MoveCategory.special:
        return const Color(0xFF263957); // Or a specific detailed color
    }
  }
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

  @HiveField(7)
  final MoveCategory moveCategory;

  @HiveField(8)
  final String moveName;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  bool isOwned;

  @HiveField(6)
  final int version;

  TagModel({
    required this.id,
    required this.pokemonName,
    required this.type,
    required this.mechanic,
    this.moveCategory = MoveCategory.physical,
    this.moveName = '',
    required this.imageUrl,
    this.isOwned = false,
    this.version = 0,
  });

  TagModel copyWith({
    String? id,
    String? pokemonName,
    TagType? type,
    Mechanic? mechanic,
    MoveCategory? moveCategory,
    String? moveName,
    String? imageUrl,
    bool? isOwned,
    int? version,
  }) {
    return TagModel(
      id: id ?? this.id,
      pokemonName: pokemonName ?? this.pokemonName,
      type: type ?? this.type,
      mechanic: mechanic ?? this.mechanic,
      moveCategory: moveCategory ?? this.moveCategory,
      moveName: moveName ?? this.moveName,
      imageUrl: imageUrl ?? this.imageUrl,
      isOwned: isOwned ?? this.isOwned,
      version: version ?? this.version,
    );
  }
}
