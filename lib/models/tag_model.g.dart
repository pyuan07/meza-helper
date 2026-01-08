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
      type: fields[2] as String,
      mechanic: fields[3] as Mechanic,
      imageUrl: fields[4] as String,
      isOwned: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TagModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pokemonName)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.mechanic)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.isOwned);
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
