import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tag_model.dart';
import '../features/tag_dex/data/tag_repository.dart';
import '../features/tag_dex/data/datasources/tag_static_data_source.dart';
import '../features/tag_dex/data/datasources/tag_local_data_source.dart';
import 'storage_provider.dart';

/// Provider for the tag repository
final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return TagRepositoryImpl(
    const TagStaticDataSource(),
    TagLocalDataSource(storageService),
  );
});

/// Notifier to manage the list of tags and handle updates
class TagListNotifier extends StateNotifier<List<TagModel>> {
  final TagRepository _repository;

  TagListNotifier(this._repository) : super([]) {
    _loadTags();
  }

  void _loadTags() {
    state = _repository.getAllTags();
  }

  Future<void> toggleOwnership(String id, bool isOwned) async {
    await _repository.updateTagOwnership(id, isOwned);
    _loadTags(); // Reload to reflect changes
  }
}

/// Provider for the tag list state
final tagListProvider =
    StateNotifierProvider<TagListNotifier, List<TagModel>>((ref) {
  final repository = ref.watch(tagRepositoryProvider);
  return TagListNotifier(repository);
});

/// Computed Provider for tags by version
final tagsByVersionProvider =
    Provider.family<List<TagModel>, int>((ref, version) {
  final tags = ref.watch(tagListProvider);
  if (version == 0) return tags;
  return tags.where((t) => t.version == version).toList();
});

/// Computed Provider for tag by ID
/// Note: This searches in the current list state
final tagByIdProvider = Provider.family<TagModel?, String>((ref, id) {
  final tags = ref.watch(tagListProvider);
  try {
    return tags.firstWhere((t) => t.id == id);
  } catch (_) {
    return null;
  }
});

/// Provider for Owned Tags only (Filter)
final ownedTagsProvider = Provider<List<TagModel>>((ref) {
  final tags = ref.watch(tagListProvider);
  return tags.where((t) => t.isOwned).toList();
});
