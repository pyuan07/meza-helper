// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TagModelAdapter extends TypeAdapter<TagModel> {
  @override
  final int typeId = 0;

  @override
  TagModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TagModel(
      id: fields[0] as String,
      pokemonName: fields[1] as String,
      type: fields[2] as TagType,
      mechanic: fields[3] as Mechanic,
      moveCategory: fields[7] as MoveCategory,
      moveName: fields[8] as String,
      imageUrl: fields[4] as String,
      isOwned: fields[5] as bool,
      version: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TagModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pokemonName)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.mechanic)
      ..writeByte(7)
      ..write(obj.moveCategory)
      ..writeByte(8)
      ..write(obj.moveName)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.isOwned)
      ..writeByte(6)
      ..write(obj.version);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TagTypeAdapter extends TypeAdapter<TagType> {
  @override
  final int typeId = 2;

  @override
  TagType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TagType.normal;
      case 1:
        return TagType.fire;
      case 2:
        return TagType.water;
      case 3:
        return TagType.grass;
      case 4:
        return TagType.electric;
      case 5:
        return TagType.ice;
      case 6:
        return TagType.fighting;
      case 7:
        return TagType.poison;
      case 8:
        return TagType.ground;
      case 9:
        return TagType.flying;
      case 10:
        return TagType.psychic;
      case 11:
        return TagType.bug;
      case 12:
        return TagType.rock;
      case 13:
        return TagType.ghost;
      case 14:
        return TagType.dragon;
      case 15:
        return TagType.steel;
      case 16:
        return TagType.dark;
      case 17:
        return TagType.fairy;
      default:
        return TagType.normal;
    }
  }

  @override
  void write(BinaryWriter writer, TagType obj) {
    switch (obj) {
      case TagType.normal:
        writer.writeByte(0);
        break;
      case TagType.fire:
        writer.writeByte(1);
        break;
      case TagType.water:
        writer.writeByte(2);
        break;
      case TagType.grass:
        writer.writeByte(3);
        break;
      case TagType.electric:
        writer.writeByte(4);
        break;
      case TagType.ice:
        writer.writeByte(5);
        break;
      case TagType.fighting:
        writer.writeByte(6);
        break;
      case TagType.poison:
        writer.writeByte(7);
        break;
      case TagType.ground:
        writer.writeByte(8);
        break;
      case TagType.flying:
        writer.writeByte(9);
        break;
      case TagType.psychic:
        writer.writeByte(10);
        break;
      case TagType.bug:
        writer.writeByte(11);
        break;
      case TagType.rock:
        writer.writeByte(12);
        break;
      case TagType.ghost:
        writer.writeByte(13);
        break;
      case TagType.dragon:
        writer.writeByte(14);
        break;
      case TagType.steel:
        writer.writeByte(15);
        break;
      case TagType.dark:
        writer.writeByte(16);
        break;
      case TagType.fairy:
        writer.writeByte(17);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MechanicAdapter extends TypeAdapter<Mechanic> {
  @override
  final int typeId = 3;

  @override
  Mechanic read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Mechanic.none;
      case 1:
        return Mechanic.zMove;
      case 2:
        return Mechanic.mega;
      case 3:
        return Mechanic.dynamax;
      case 4:
        return Mechanic.tera;
      default:
        return Mechanic.none;
    }
  }

  @override
  void write(BinaryWriter writer, Mechanic obj) {
    switch (obj) {
      case Mechanic.none:
        writer.writeByte(0);
        break;
      case Mechanic.zMove:
        writer.writeByte(1);
        break;
      case Mechanic.mega:
        writer.writeByte(2);
        break;
      case Mechanic.dynamax:
        writer.writeByte(3);
        break;
      case Mechanic.tera:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MechanicAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MoveCategoryAdapter extends TypeAdapter<MoveCategory> {
  @override
  final int typeId = 4;

  @override
  MoveCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MoveCategory.physical;
      case 1:
        return MoveCategory.special;
      default:
        return MoveCategory.physical;
    }
  }

  @override
  void write(BinaryWriter writer, MoveCategory obj) {
    switch (obj) {
      case MoveCategory.physical:
        writer.writeByte(0);
        break;
      case MoveCategory.special:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoveCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
