// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemoModelAdapter extends TypeAdapter<MemoModel> {
  @override
  final int typeId = 0;

  @override
  MemoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemoModel(
      writerData: fields[5] as UserModel,
      uid: fields[0] as String,
      content: fields[1] as String,
      time: fields[2] as DateTime,
      myComment: fields[3] as bool,
      locked: fields[4] as bool,
      reply: (fields[6] as List).cast<MemoModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, MemoModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.myComment)
      ..writeByte(4)
      ..write(obj.locked)
      ..writeByte(5)
      ..write(obj.writerData)
      ..writeByte(6)
      ..write(obj.reply);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
