import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tag_model.dart';
import '../features/tag_dex/data/tag_repository.dart';
import 'storage_provider.dart';

/// Provider for the tag repository
final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return TagRepositoryImpl(storageService);
});

/// Provider for all tags
final allTagsProvider = Provider<List<TagModel>>((ref) {
  final repository = ref.watch(tagRepositoryProvider);
  return repository.getAllTags();
});

/// Provider for tags by version
final tagsByVersionProvider =
    Provider.family<List<TagModel>, int>((ref, version) {
  final repository = ref.watch(tagRepositoryProvider);
  return repository.getTagsByVersion(version);
});

/// Provider for tag by ID
final tagByIdProvider = Provider.family<TagModel, String>((ref, id) {
  final repository = ref.watch(tagRepositoryProvider);
  return repository.getTagById(id);
});
