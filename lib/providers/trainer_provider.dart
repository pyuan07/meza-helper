import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trainer_model.dart';
import '../features/trainer_pass/data/trainer_repository.dart';
import 'storage_provider.dart';

/// Provider for the trainer repository
final trainerRepositoryProvider = Provider<TrainerRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return TrainerRepositoryImpl(storageService);
});

/// State provider for trainers with loading and error states
final trainersProvider =
    StateNotifierProvider<TrainersNotifier, AsyncValue<List<TrainerModel>>>(
        (ref) {
  final repository = ref.watch(trainerRepositoryProvider);
  return TrainersNotifier(repository);
});

/// Trainer state notifier with AsyncValue for loading/error states
class TrainersNotifier extends StateNotifier<AsyncValue<List<TrainerModel>>> {
  final TrainerRepository _repository;

  TrainersNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadTrainers();
  }

  /// Load trainers from repository
  Future<void> _loadTrainers() async {
    state = const AsyncValue.loading();

    final result = await _repository.getTrainers();
    state = result.when(
      success: (trainers) => AsyncValue.data(trainers),
      failure: (message, error) =>
          AsyncValue.error(message, StackTrace.current),
    );
  }

  /// Add a new trainer
  Future<void> addTrainer(String name, String mezastarId) async {
    final result = await _repository.addTrainer(name, mezastarId);

    result.when(
      success: (_) => _loadTrainers(),
      failure: (message, error) {
        state = AsyncValue.error(message, StackTrace.current);
      },
    );
  }

  /// Update existing trainer
  Future<void> updateTrainer(TrainerModel trainer) async {
    final result = await _repository.updateTrainer(trainer);

    result.when(
      success: (_) => _loadTrainers(),
      failure: (message, error) {
        state = AsyncValue.error(message, StackTrace.current);
      },
    );
  }

  /// Delete trainer
  Future<void> deleteTrainer(String id) async {
    final result = await _repository.deleteTrainer(id);

    result.when(
      success: (_) => _loadTrainers(),
      failure: (message, error) {
        state = AsyncValue.error(message, StackTrace.current);
      },
    );
  }

  /// Reorder trainers
  Future<void> reorderTrainers(int oldIndex, int newIndex) async {
    final currentState = state;

    // Optimistic update
    if (currentState is AsyncData<List<TrainerModel>>) {
      final trainers = List<TrainerModel>.from(currentState.value);

      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = trainers.removeAt(oldIndex);
      trainers.insert(newIndex, item);

      state = AsyncValue.data(trainers);

      // Update in repository
      final result = await _repository.reorderTrainers(trainers);
      result.when(
        success: (_) => _loadTrainers(),
        failure: (message, error) {
          // Revert on error
          state = currentState;
        },
      );
    }
  }

  /// Refresh trainers
  void refresh() => _loadTrainers();
}
