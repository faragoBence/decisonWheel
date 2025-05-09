// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wheel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WheelAdapter extends TypeAdapter<Wheel> {
  @override
  final int typeId = 0;

  @override
  Wheel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Wheel(
      name: fields[0] as String,
      wheelElements: (fields[2] as List).cast<WheelElement>(),
      imageIndex: fields[3] as int,
      id: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Wheel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.wheelElements)
      ..writeByte(3)
      ..write(obj.imageIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WheelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
