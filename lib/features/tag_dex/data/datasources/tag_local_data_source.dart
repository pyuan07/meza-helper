import '../../../../services/storage_service.dart';
import '../../../../models/tag_model.dart';

class TagLocalDataSource {
  final StorageService _storageService;

  const TagLocalDataSource(this._storageService);

  /// Returns a Set of IDs for tags that are owned
  Set<String> getOwnedTagIds() {
    try {
      final tags = _storageService.getTags();
      return tags.where((t) => t.isOwned).map((t) => t.id).toSet();
    } catch (_) {
      return {};
    }
  }

  // Better approach: Exposed method to save a fully formed TagModel (which Repository will provide)
  Future<void> saveTag(TagModel tag) async {
    await _storageService.saveTag(tag);
  }
}
