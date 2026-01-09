import 'package:hive_flutter/hive_flutter.dart';
import '../models/tag_model.dart';
import '../models/trainer_model.dart';

class StorageService {
  late Box<TrainerModel> _trainersBox;
  late Box<TagModel> _tagsBox;

  Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(TagModelAdapter());
    Hive.registerAdapter(TagTypeAdapter());
    Hive.registerAdapter(MechanicAdapter());
    Hive.registerAdapter(MoveCategoryAdapter());
    Hive.registerAdapter(TrainerModelAdapter());

    // Open Boxes
    _trainersBox = await Hive.openBox<TrainerModel>('trainers');
    _tagsBox = await Hive.openBox<TagModel>('tags');
  }

  // Trainer Operations
  List<TrainerModel> getTrainers() => _trainersBox.values.toList();

  Future<void> saveTrainer(TrainerModel trainer) async {
    await _trainersBox.put(trainer.id, trainer);
  }

  Future<void> deleteTrainer(String id) async {
    await _trainersBox.delete(id);
  }

  // Tag Operations
  List<TagModel> getTags() => _tagsBox.values.toList();

  Future<void> saveTag(TagModel tag) async {
    await _tagsBox.put(tag.id, tag);
  }
}
