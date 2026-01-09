import '../../../models/tag_model.dart';

class _TagEntry {
  final String name;
  final TagType type;
  final Mechanic mechanic;
  final MoveCategory moveCategory;
  final String moveName;

  const _TagEntry({
    required this.name,
    required this.type,
    this.mechanic = Mechanic.none,
    this.moveCategory = MoveCategory.physical,
    this.moveName = '',
  });
}

class TagRepository {
  static final Map<String, _TagEntry> _tagData = {
    // Version 1
    '1-1-001': const _TagEntry(
        name: 'Mewtwo',
        type: TagType.psychic,
        moveCategory: MoveCategory.special,
        moveName: 'Psystrike'),
    '1-1-002': const _TagEntry(
        name: 'Mew',
        type: TagType.psychic,
        moveCategory: MoveCategory.special,
        moveName: 'Psychic'),
    '1-1-003': const _TagEntry(
        name: 'Zacian',
        type: TagType.steel,
        moveCategory: MoveCategory.physical,
        moveName: 'Behemoth Blade'),
    '1-1-004': const _TagEntry(
        name: 'Zamazenta',
        type: TagType.steel,
        moveCategory: MoveCategory.physical,
        moveName: 'Behemoth Bash'),
    '1-1-005': const _TagEntry(
      name: 'Tyranitar',
      type: TagType.rock,
      mechanic: Mechanic.mega,
      moveCategory: MoveCategory.physical,
      moveName: 'Stone Edge',
    ),
    '1-1-006': const _TagEntry(
      name: 'Metagross',
      type: TagType.steel,
      mechanic: Mechanic.mega,
      moveCategory: MoveCategory.physical,
      moveName: 'Meteor Mash',
    ),
    '1-1-007': const _TagEntry(
        name: 'Miraidon',
        type: TagType.electric,
        moveCategory: MoveCategory.special,
        moveName: 'Electro Drift'),
    '1-1-008': const _TagEntry(
      name: 'Venusaur',
      type: TagType.grass,
      mechanic: Mechanic.mega,
      moveCategory: MoveCategory.special,
      moveName: 'Leaf Storm',
    ),
    '1-1-009': const _TagEntry(
      name: 'Charizard',
      type: TagType.fire,
      mechanic: Mechanic.mega,
      moveCategory: MoveCategory.special,
      moveName: 'Flamethrower',
    ),
    '1-1-010': const _TagEntry(
      name: 'Blastoise',
      type: TagType.water,
      mechanic: Mechanic.mega,
      moveCategory: MoveCategory.special,
      moveName: 'Hydro Pump',
    ),

    // Version 2
    '1-2-001': const _TagEntry(
        name: 'Kyogre',
        type: TagType.water,
        moveCategory: MoveCategory.special,
        moveName: 'Hydro Pump'),
    '1-2-002': const _TagEntry(
        name: 'Groudon',
        type: TagType.ground,
        moveCategory: MoveCategory.physical,
        moveName: 'Earthquake'),
    '1-2-003': const _TagEntry(
        name: 'Koraidon',
        type: TagType.fighting,
        moveCategory: MoveCategory.physical,
        moveName: 'Collision Course'),
    '1-2-004': const _TagEntry(
      name: 'Pikachu',
      type: TagType.electric,
      mechanic: Mechanic.zMove,
      moveCategory: MoveCategory.special,
      moveName: 'Thunderbolt',
    ),
    '1-2-005': const _TagEntry(
      name: 'Snorlax',
      type: TagType.normal,
      mechanic: Mechanic.dynamax,
      moveCategory: MoveCategory.physical,
      moveName: 'Giga Impact',
    ),
    '1-2-006': const _TagEntry(
      name: 'Kommo-o',
      type: TagType.fighting,
      mechanic: Mechanic.dynamax,
      moveCategory: MoveCategory.physical,
      moveName: 'Foxus Blast',
    ),
    '1-2-007': const _TagEntry(
        name: 'Gardevoir',
        type: TagType.psychic,
        moveCategory: MoveCategory.special,
        moveName: 'Psychic'),
    '1-2-008': const _TagEntry(
        name: 'Reshiram',
        type: TagType.fire,
        moveCategory: MoveCategory.special,
        moveName: 'Fusion Flare'),
    '1-2-009': const _TagEntry(
        name: 'Zekrom',
        type: TagType.electric,
        moveCategory: MoveCategory.physical,
        moveName: 'Dusion Bolt'),
    '1-2-010': const _TagEntry(
      name: 'Kyurem',
      type: TagType.ice, // dragon/ice
      moveCategory: MoveCategory.special,
      moveName: 'Glaciate',
    ),

    // Version 3
    '1-3-001': const _TagEntry(
      name: 'Lugia',
      type: TagType.flying, // psychic/flying
      moveCategory: MoveCategory.special,
      moveName: 'Aeroblast',
    ),
    '1-3-002': const _TagEntry(
      name: 'Ho-Oh',
      type: TagType.fire, // fire/flying
      moveCategory: MoveCategory.physical,
      moveName: 'Sacred Fire',
    ),
    '1-3-003': const _TagEntry(
      name: 'Solgaleo',
      type: TagType.steel, // psychic/steel
      moveCategory: MoveCategory.physical,
      moveName: 'Sunsteel Strike',
    ),
    '1-3-004': const _TagEntry(
      name: 'Lunala',
      type: TagType.ghost, // psychic/ghost
      moveCategory: MoveCategory.special,
      moveName: 'Moongeist Beam',
    ),
    '1-3-005': const _TagEntry(
      name: 'Greninja',
      type: TagType.dark,
      mechanic: Mechanic.zMove, // water/dark
      moveCategory: MoveCategory.special,
      moveName: 'Dark Pulse',
    ),
    '1-3-006': const _TagEntry(
      name: 'Zeraora',
      type: TagType.electric,
      mechanic: Mechanic.zMove,
      moveCategory: MoveCategory.physical,
      moveName: 'Plasma Fists',
    ),
    '1-3-007': const _TagEntry(
      name: 'Eternatus',
      type: TagType.poison,
      moveCategory: MoveCategory.special,
      moveName: 'Eternabeam',
    ),
    '1-3-008': const _TagEntry(
      name: 'Keldeo',
      type: TagType.fighting,
      mechanic: Mechanic.dynamax, // water/fighting
      moveCategory: MoveCategory.special,
      moveName: 'Secret Sword',
    ),
    '1-3-009': const _TagEntry(
      name: 'Grimmsnarl',
      type: TagType.fairy,
      mechanic: Mechanic.dynamax, // dark/fairy
      moveCategory: MoveCategory.physical,
      moveName: 'Spirit Break',
    ),
    '1-3-010': const _TagEntry(
      name: 'Zygarde',
      type: TagType.ground, // dragon/ground
      moveCategory: MoveCategory.physical,
      moveName: 'Land\'s Wrath',
    ),

    // Version 4
    '1-4-001': const _TagEntry(
      name: 'Dialga',
      type: TagType.dragon, // steel/dragon
      moveCategory: MoveCategory.special,
      moveName: 'Roar of Time',
    ),
    '1-4-002': const _TagEntry(
      name: 'Palkia',
      type: TagType.dragon, // water/dragon
      moveCategory: MoveCategory.special,
      moveName: 'Spacial Rend',
    ),
    '1-4-003': const _TagEntry(
      name: 'Xerneas',
      type: TagType.fairy,
      mechanic: Mechanic.dynamax,
      moveCategory: MoveCategory.special,
      moveName: 'Moonblast',
    ),
    '1-4-004': const _TagEntry(
      name: 'Yveltal',
      type: TagType.dark,
      mechanic: Mechanic.dynamax, // dark/flying
      moveCategory: MoveCategory.special,
      moveName: 'Dark Pulse',
    ),
    '1-4-005': const _TagEntry(
      name: 'Calyrex',
      type: TagType.ice,
      mechanic: Mechanic.dynamax, // ice rider
      moveCategory: MoveCategory.physical,
      moveName: 'Glacial Lance',
    ),
    '1-4-006': const _TagEntry(
      name: 'Calyrex',
      type: TagType.ghost,
      mechanic: Mechanic.dynamax, // shadow rider
      moveCategory: MoveCategory.special,
      moveName: 'Astral Barrage',
    ),
    '1-4-007': const _TagEntry(
      name: 'Mimikyu',
      type: TagType.fairy,
      mechanic: Mechanic.zMove, // ghost/fairy
      moveCategory: MoveCategory.physical,
      moveName: 'Play Rough',
    ),
    '1-4-008': const _TagEntry(
      name: 'Kyurem',
      type: TagType.fire, // white?
      moveCategory: MoveCategory.special,
      moveName: 'Fusion Flare',
    ),
    '1-4-009': const _TagEntry(
      name: 'Kyurem',
      type: TagType.electric, // black?
      moveCategory: MoveCategory.physical,
      moveName: 'Fusion Bolt',
    ),
    '1-4-010': const _TagEntry(
      name: 'Rayquaza',
      type: TagType.dragon, // dragon/flying
      moveCategory: MoveCategory.special,
      moveName: 'Draco Meteor',
    ),
  };

  static List<TagModel> getTagsByVersion(int version) {
    if (version < 1 || version > 4) return [];

    // Generate tags 001 to 010 for the given version
    return List.generate(10, (index) {
      final number = (index + 1).toString().padLeft(3, '0');
      // Format: pm_en_1-{ver}-{num}_f.jpg/png
      final id = '1-$version-$number';

      // Version 1 uses PNG, others use JPG based on user input
      final ext = version == 1 ? 'png' : 'jpg';
      final fileName = 'pm_en_$id' '_f.$ext';

      final entry = _tagData[id] ??
          const _TagEntry(name: 'Unknown', type: TagType.normal);

      return TagModel(
        id: id,
        pokemonName: entry.name,
        type: entry.type,
        mechanic: entry.mechanic,
        moveCategory: entry.moveCategory,
        moveName: entry.moveName,
        imageUrl: 'assets/images/tags/ver$version/$fileName',
        version: version,
      );
    });
  }

  static TagModel getTagById(String id) {
    // ID format: 1-{ver}-{num}
    final parts = id.split('-');
    if (parts.length != 3) {
      return TagModel(
          id: id,
          pokemonName: 'Unknown',
          type: TagType.normal,
          mechanic: Mechanic.none,
          imageUrl: '',
          version: 0);
    }
    final version = int.tryParse(parts[1]) ?? 0;

    // Version 1 uses PNG, others use JPG based on user input
    final ext = version == 1 ? 'png' : 'jpg';
    final fileName = 'pm_en_$id' '_f.$ext';

    final entry =
        _tagData[id] ?? const _TagEntry(name: 'Unknown', type: TagType.normal);

    return TagModel(
      id: id,
      pokemonName: entry.name,
      type: entry.type,
      mechanic: entry.mechanic,
      moveCategory: entry.moveCategory,
      moveName: entry.moveName,
      imageUrl: 'assets/images/tags/ver$version/$fileName',
      version: version,
    );
  }

  static List<TagModel> getAllTags() {
    return [
      ...getTagsByVersion(4),
      ...getTagsByVersion(3),
      ...getTagsByVersion(2),
      ...getTagsByVersion(1),
    ];
  }
}
