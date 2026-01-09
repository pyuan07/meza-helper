import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/tag_model.dart';
import '../models/trainer_model.dart';

// Provider for the storage service
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// Providers for data streams
final trainersProvider =
    StateNotifierProvider<TrainersNotifier, List<TrainerModel>>((ref) {
  final service = ref.watch(storageServiceProvider);
  return TrainersNotifier(service);
});

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

class TrainersNotifier extends StateNotifier<List<TrainerModel>> {
  final StorageService _service;

  TrainersNotifier(this._service) : super([]) {
    _loadTrainers();
  }

  void _loadTrainers() {
    final trainers = _service.getTrainers();
    trainers.sort((a, b) => (a.orderIndex ?? 0).compareTo(b.orderIndex ?? 0));
    state = trainers;
  }

  Future<void> addTrainer(String name, String mezastarId) async {
    final currentOrder = state.length;
    final trainer = TrainerModel.create(
      name: name,
      mezastarId: mezastarId,
      orderIndex: currentOrder,
    );
    await _service.saveTrainer(trainer);
    _loadTrainers();
  }

  Future<void> updateTrainer(TrainerModel trainer) async {
    await _service.saveTrainer(trainer);
    _loadTrainers();
  }

  Future<void> deleteTrainer(String id) async {
    await _service.deleteTrainer(id);
    _loadTrainers();
  }

  Future<void> reorderTrainers(int oldIndex, int newIndex) async {
    final currentList = List<TrainerModel>.from(state);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = currentList.removeAt(oldIndex);
    currentList.insert(newIndex, item);

    // Update indices
    for (int i = 0; i < currentList.length; i++) {
      if (currentList[i].orderIndex != i) {
        final updated = currentList[i].copyWith(orderIndex: i);
        await _service.saveTrainer(updated);
      }
    }
    _loadTrainers();
  }
}
