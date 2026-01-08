import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:meza_helper/models/tag_model.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    Hive.registerAdapter(TagModelAdapter());
    Hive.registerAdapter(TagTypeAdapter());
    Hive.registerAdapter(MechanicAdapter());
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('TagModel serialization test', () async {
    final box = await Hive.openBox<TagModel>('tags');

    final tag = TagModel(
      id: '1',
      pokemonName: 'Charizard',
      type: TagType.fire,
      mechanic: Mechanic.mega,
      imageUrl: 'charizard.png',
      isOwned: true,
    );

    await box.put('1', tag);

    final retrievedTag = box.get('1');

    expect(retrievedTag, isNotNull);
    expect(retrievedTag!.id, '1');
    expect(retrievedTag.pokemonName, 'Charizard');
    expect(retrievedTag.type, TagType.fire);
    expect(retrievedTag.mechanic, Mechanic.mega);
    expect(retrievedTag.isOwned, true);
  });
}
