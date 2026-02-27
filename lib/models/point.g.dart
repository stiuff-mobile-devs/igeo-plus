// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PointAdapter extends TypeAdapter<Point> {
  @override
  final int typeId = 0;

  @override
  Point read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Point(
      id: fields[0] as String?,
      name: fields[1] as String?,
      lat: fields[2] as double?,
      long: fields[3] as double?,
      date: fields[4] as String?,
      time: fields[5] as String?,
      description: fields[6] as String?,
      user_id: fields[7] as int?,
      project_id: fields[8] as String?,
      isFavorite: fields[9] as bool,
      image: (fields[10] as List?)?.cast<String>(),
      isDirty: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Point obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.lat)
      ..writeByte(3)
      ..write(obj.long)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.time)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.user_id)
      ..writeByte(8)
      ..write(obj.project_id)
      ..writeByte(9)
      ..write(obj.isFavorite)
      ..writeByte(10)
      ..write(obj.image)
      ..writeByte(11)
      ..write(obj.isDirty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
