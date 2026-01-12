import '../../../../models/tag_model.dart';

/// One-stop shop for all static Tag Definitions (The Catalog)
class TagStaticDataSource {
  const TagStaticDataSource();

  List<TagModel> getAllTags() {
    return [
      ..._ver1,
      ..._ver2,
      ..._ver3,
      ..._ver4,
    ];
  }

  // --- Version 1 ---
  static final List<TagModel> _ver1 = [
    _create(
      version: 1,
      number: '001',
      name: 'Mewtwo',
      type: TagType.psychic,
      cat: MoveCategory.special,
      move: 'Psystrike',
    ),
    _create(
      version: 1,
      number: '002',
      name: 'Mew',
      type: TagType.psychic,
      cat: MoveCategory.special,
      move: 'Psychic',
    ),
    _create(
      version: 1,
      number: '003',
      name: 'Zacian',
      type: TagType.steel,
      cat: MoveCategory.physical,
      move: 'Behemoth Blade',
    ),
    _create(
      version: 1,
      number: '004',
      name: 'Zamazenta',
      type: TagType.steel,
      cat: MoveCategory.physical,
      move: 'Behemoth Bash',
    ),
    _create(
      version: 1,
      number: '005',
      name: 'Tyranitar',
      type: TagType.rock,
      mechanic: Mechanic.mega,
      cat: MoveCategory.physical,
      move: 'Stone Edge',
    ),
    _create(
      version: 1,
      number: '006',
      name: 'Metagross',
      type: TagType.steel,
      mechanic: Mechanic.mega,
      cat: MoveCategory.physical,
      move: 'Meteor Mash',
    ),
    _create(
      version: 1,
      number: '007',
      name: 'Miraidon',
      type: TagType.electric,
      cat: MoveCategory.special,
      move: 'Electro Drift',
    ),
    _create(
      version: 1,
      number: '008',
      name: 'Venusaur',
      type: TagType.grass,
      mechanic: Mechanic.mega,
      cat: MoveCategory.special,
      move: 'Leaf Storm',
    ),
    _create(
      version: 1,
      number: '009',
      name: 'Charizard',
      type: TagType.fire,
      mechanic: Mechanic.mega,
      cat: MoveCategory.special,
      move: 'Flamethrower',
    ),
    _create(
      version: 1,
      number: '010',
      name: 'Blastoise',
      type: TagType.water,
      mechanic: Mechanic.mega,
      cat: MoveCategory.special,
      move: 'Hydro Pump',
    ),
  ];

  // --- Version 2 ---
  static final List<TagModel> _ver2 = [
    _create(
      version: 2,
      number: '001',
      name: 'Kyogre',
      type: TagType.water,
      cat: MoveCategory.special,
      move: 'Hydro Pump',
    ),
    _create(
      version: 2,
      number: '002',
      name: 'Groudon',
      type: TagType.ground,
      cat: MoveCategory.physical,
      move: 'Earthquake',
    ),
    _create(
      version: 2,
      number: '003',
      name: 'Koraidon',
      type: TagType.fighting,
      cat: MoveCategory.physical,
      move: 'Collision Course',
    ),
    _create(
      version: 2,
      number: '004',
      name: 'Pikachu',
      type: TagType.electric,
      mechanic: Mechanic.zMove,
      cat: MoveCategory.special,
      move: 'Thunderbolt',
    ),
    _create(
      version: 2,
      number: '005',
      name: 'Snorlax',
      type: TagType.normal,
      mechanic: Mechanic.dynamax,
      cat: MoveCategory.physical,
      move: 'Giga Impact',
    ),
    _create(
      version: 2,
      number: '006',
      name: 'Kommo-o',
      type: TagType.fighting,
      mechanic: Mechanic.dynamax,
      cat: MoveCategory.physical,
      move: 'Foxus Blast',
    ),
    _create(
      version: 2,
      number: '007',
      name: 'Gardevoir',
      type: TagType.psychic,
      cat: MoveCategory.special,
      move: 'Psychic',
    ),
    _create(
      version: 2,
      number: '008',
      name: 'Reshiram',
      type: TagType.fire,
      cat: MoveCategory.special,
      move: 'Fusion Flare',
    ),
    _create(
      version: 2,
      number: '009',
      name: 'Zekrom',
      type: TagType.electric,
      cat: MoveCategory.physical,
      move: 'Fusion Bolt',
    ),
    _create(
      version: 2,
      number: '010',
      name: 'Kyurem',
      type: TagType.ice,
      cat: MoveCategory.special,
      move: 'Glaciate',
    ),
  ];

  // --- Version 3 ---
  static final List<TagModel> _ver3 = [
    _create(
        version: 3,
        number: '001',
        name: 'Lugia',
        type: TagType.flying,
        cat: MoveCategory.special,
        move: 'Aeroblast'),
    _create(
        version: 3,
        number: '002',
        name: 'Ho-Oh',
        type: TagType.fire,
        cat: MoveCategory.physical,
        move: 'Sacred Fire'),
    _create(
        version: 3,
        number: '003',
        name: 'Solgaleo',
        type: TagType.steel,
        cat: MoveCategory.physical,
        move: 'Sunsteel Strike'),
    _create(
        version: 3,
        number: '004',
        name: 'Lunala',
        type: TagType.ghost,
        cat: MoveCategory.special,
        move: 'Moongeist Beam'),
    _create(
        version: 3,
        number: '005',
        name: 'Greninja',
        type: TagType.dark,
        mechanic: Mechanic.zMove,
        cat: MoveCategory.special,
        move: 'Dark Pulse'),
    _create(
        version: 3,
        number: '006',
        name: 'Zeraora',
        type: TagType.electric,
        mechanic: Mechanic.zMove,
        cat: MoveCategory.physical,
        move: 'Plasma Fists'),
    _create(
        version: 3,
        number: '007',
        name: 'Eternatus',
        type: TagType.poison,
        cat: MoveCategory.special,
        move: 'Eternabeam'),
    _create(
        version: 3,
        number: '008',
        name: 'Keldeo',
        type: TagType.fighting,
        mechanic: Mechanic.dynamax,
        cat: MoveCategory.special,
        move: 'Secret Sword'),
    _create(
        version: 3,
        number: '009',
        name: 'Grimmsnarl',
        type: TagType.fairy,
        mechanic: Mechanic.dynamax,
        cat: MoveCategory.physical,
        move: 'Spirit Break'),
    _create(
        version: 3,
        number: '010',
        name: 'Zygarde',
        type: TagType.ground,
        cat: MoveCategory.physical,
        move: 'Land\'s Wrath'),
  ];

  // --- Version 4 ---
  static final List<TagModel> _ver4 = [
    _create(
        version: 4,
        number: '001',
        name: 'Dialga',
        type: TagType.dragon,
        cat: MoveCategory.special,
        move: 'Roar of Time'),
    _create(
        version: 4,
        number: '002',
        name: 'Palkia',
        type: TagType.dragon,
        cat: MoveCategory.special,
        move: 'Spacial Rend'),
    _create(
        version: 4,
        number: '003',
        name: 'Xerneas',
        type: TagType.fairy,
        mechanic: Mechanic.dynamax,
        cat: MoveCategory.special,
        move: 'Moonblast'),
    _create(
        version: 4,
        number: '004',
        name: 'Yveltal',
        type: TagType.dark,
        mechanic: Mechanic.dynamax,
        cat: MoveCategory.special,
        move: 'Dark Pulse'),
    _create(
        version: 4,
        number: '005',
        name: 'Calyrex',
        type: TagType.ice,
        mechanic: Mechanic.dynamax,
        cat: MoveCategory.physical,
        move: 'Glacial Lance'),
    _create(
        version: 4,
        number: '006',
        name: 'Calyrex',
        type: TagType.ghost,
        mechanic: Mechanic.dynamax,
        cat: MoveCategory.special,
        move: 'Astral Barrage'),
    _create(
        version: 4,
        number: '007',
        name: 'Mimikyu',
        type: TagType.fairy,
        mechanic: Mechanic.zMove,
        cat: MoveCategory.physical,
        move: 'Play Rough'),
    _create(
        version: 4,
        number: '008',
        name: 'Kyurem',
        type: TagType.fire,
        cat: MoveCategory.special,
        move: 'Fusion Flare'),
    _create(
        version: 4,
        number: '009',
        name: 'Kyurem',
        type: TagType.electric,
        cat: MoveCategory.physical,
        move: 'Fusion Bolt'),
    _create(
        version: 4,
        number: '010',
        name: 'Rayquaza',
        type: TagType.dragon,
        cat: MoveCategory.special,
        move: 'Draco Meteor'),
  ];

  // Helper to construct consistent TagModels
  static TagModel _create({
    required int version,
    required String number,
    required String name,
    required TagType type,
    Mechanic mechanic = Mechanic.none,
    MoveCategory cat = MoveCategory.physical,
    String move = '',
  }) {
    final id = '1-$version-$number';
    final ext = version == 1 ? 'png' : 'jpg';
    final fileName = 'pm_en_$id' '_f.$ext';

    return TagModel(
      id: id,
      pokemonName: name,
      type: type,
      mechanic: mechanic,
      moveCategory: cat,
      moveName: move,
      imageUrl: 'assets/images/tags/ver$version/$fileName',
      version: version,
      isOwned: false, // Default
    );
  }
}
