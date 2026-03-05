// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pizza_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PizzaHiveModelAdapter extends TypeAdapter<PizzaHiveModel> {
  @override
  final int typeId = 4;

  @override
  PizzaHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PizzaHiveModel(
      pizzaId: fields[0] as String?,
      name: fields[1] as String,
      description: fields[2] as String,
      price: fields[3] as double,
      image: fields[4] as String,
      category: fields[5] as String,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PizzaHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.pizzaId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PizzaHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
