import '../../../models/tag_model.dart';
import 'datasources/tag_static_data_source.dart';
import 'datasources/tag_local_data_source.dart';

/// Repository interface for tag operations
abstract class TagRepository {
  List<TagModel> getTagsByVersion(int version);
  TagModel getTagById(String id);
  List<TagModel> getAllTags();
  Future<void> updateTagOwnership(String id, bool isOwned);
}

/// Implementation of tag repository using Clean Architecture Data Sources
class TagRepositoryImpl implements TagRepository {
  final TagStaticDataSource _staticDataSource;
  final TagLocalDataSource _localDataSource;

  // In-memory cache of merged tags to avoid re-processing on every read
  List<TagModel>? _cachedTags;

  TagRepositoryImpl(this._staticDataSource, this._localDataSource);

  void _invalidateCache() {
    _cachedTags = null;
  }

  List<TagModel> _getMergedTags() {
    if (_cachedTags != null) return _cachedTags!;

    final allStaticTags = _staticDataSource.getAllTags();
    final ownedIds = _localDataSource.getOwnedTagIds();

    _cachedTags = allStaticTags.map((tag) {
      if (ownedIds.contains(tag.id)) {
        return tag.copyWith(isOwned: true);
      }
      return tag;
    }).toList();

    return _cachedTags!;
  }

  @override
  List<TagModel> getTagsByVersion(int version) {
    if (version == 0) return getAllTags();
    return _getMergedTags().where((t) => t.version == version).toList();
  }

  @override
  TagModel getTagById(String id) {
    // We look up in our merged list to ensure ownership status is correct
    return _getMergedTags().firstWhere(
      (t) => t.id == id,
      orElse: () => TagModel(
        id: id,
        pokemonName: 'Unknown',
        type: TagType.normal,
        mechanic: Mechanic.none,
        imageUrl: '',
        version: 0,
      ),
    );
  }

  @override
  List<TagModel> getAllTags() {
    return _getMergedTags();
  }

  @override
  Future<void> updateTagOwnership(String id, bool isOwned) async {
    // 1. Get the current tag to save (we need full object for StorageService)
    final tag = getTagById(id);
    if (tag.pokemonName == 'Unknown') return; // Don't save unknown tags

    final updatedTag = tag.copyWith(isOwned: isOwned);

    // 2. Persist
    await _localDataSource.saveTag(updatedTag);

    // 3. Invalidate cache so next read gets fresh data
    _invalidateCache();
  }
}
