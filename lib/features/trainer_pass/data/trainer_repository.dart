import '../../../models/trainer_model.dart';
import '../../../services/storage_service.dart';
import '../../../core/result.dart';

/// Repository interface for trainer operations
abstract class TrainerRepository {
  Future<Result<List<TrainerModel>>> getTrainers();
  Future<Result<void>> addTrainer(String name, String mezastarId);
  Future<Result<void>> updateTrainer(TrainerModel trainer);
  Future<Result<void>> deleteTrainer(String id);
  Future<Result<void>> reorderTrainers(List<TrainerModel> trainers);
}

/// Implementation of trainer repository using storage service
class TrainerRepositoryImpl implements TrainerRepository {
  final StorageService _storageService;

  TrainerRepositoryImpl(this._storageService);

  @override
  Future<Result<List<TrainerModel>>> getTrainers() async {
    try {
      final trainers = _storageService.getTrainers();
      trainers.sort((a, b) => (a.orderIndex ?? 0).compareTo(b.orderIndex ?? 0));
      return Success(trainers);
    } catch (e) {
      return Failure('Failed to load trainers', e);
    }
  }

  @override
  Future<Result<void>> addTrainer(String name, String mezastarId) async {
    try {
      final trainers = _storageService.getTrainers();
      final currentOrder = trainers.length;

      final trainer = TrainerModel.create(
        name: name,
        mezastarId: mezastarId,
        orderIndex: currentOrder,
      );

      await _storageService.saveTrainer(trainer);
      return const Success(null);
    } catch (e) {
      return Failure('Failed to add trainer', e);
    }
  }

  @override
  Future<Result<void>> updateTrainer(TrainerModel trainer) async {
    try {
      await _storageService.saveTrainer(trainer);
      return const Success(null);
    } catch (e) {
      return Failure('Failed to update trainer', e);
    }
  }

  @override
  Future<Result<void>> deleteTrainer(String id) async {
    try {
      await _storageService.deleteTrainer(id);
      return const Success(null);
    } catch (e) {
      return Failure('Failed to delete trainer', e);
    }
  }

  @override
  Future<Result<void>> reorderTrainers(List<TrainerModel> trainers) async {
    try {
      // Update indices
      for (int i = 0; i < trainers.length; i++) {
        if (trainers[i].orderIndex != i) {
          final updated = trainers[i].copyWith(orderIndex: i);
          await _storageService.saveTrainer(updated);
        }
      }
      return const Success(null);
    } catch (e) {
      return Failure('Failed to reorder trainers', e);
    }
  }
}
