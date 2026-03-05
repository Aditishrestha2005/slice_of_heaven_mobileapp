// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderItemHiveModelAdapter extends TypeAdapter<OrderItemHiveModel> {
  @override
  final int typeId = 6;

  @override
  OrderItemHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderItemHiveModel(
      pizzaId: fields[0] as String,
      name: fields[1] as String,
      image: fields[2] as String,
      price: fields[3] as double,
      quantity: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, OrderItemHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.pizzaId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
