// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wheel_element.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WheelElementAdapter extends TypeAdapter<WheelElement> {
  @override
  final int typeId = 1;

  @override
  WheelElement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WheelElement(
      name: fields[0] as String,
      colorValue: fields[1] as int,
      id: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WheelElement obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.colorValue)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WheelElementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
