import 'package:hive/hive.dart';

part 'tag_model.g.dart'; // For Hive generator

enum Mechanic {
  none,
  zMove,
  mega,
  dynamax,
}

@HiveType(typeId: 0)
class TagModel {
  @HiveField(0)
  final String id; // e.g., "4-001"

  @HiveField(1)
  final String pokemonName;

  @HiveField(2)
  final String type; // e.g., Fire, Water

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
    String? type,
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
