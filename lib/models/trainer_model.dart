import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'trainer_model.g.dart';

@HiveType(typeId: 1)
class TrainerModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String mezastarId; // The ID string to encode in QR

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(5)
  final int? orderIndex;

  TrainerModel({
    required this.id,
    required this.name,
    required this.mezastarId,
    required this.createdAt,
    this.orderIndex = 0,
  });

  factory TrainerModel.create(
      {required String name, required String mezastarId, int orderIndex = 0}) {
    return TrainerModel(
      id: const Uuid().v4(),
      name: name,
      mezastarId: mezastarId,
      createdAt: DateTime.now(),
      orderIndex: orderIndex,
    );
  }

  TrainerModel copyWith({
    String? name,
    String? mezastarId,
    int? orderIndex,
  }) {
    return TrainerModel(
      id: id,
      name: name ?? this.name,
      mezastarId: mezastarId ?? this.mezastarId,
      createdAt: createdAt,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
