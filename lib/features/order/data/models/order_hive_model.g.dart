// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderHiveModelAdapter extends TypeAdapter<OrderHiveModel> {
  @override
  final int typeId = 5;

  @override
  OrderHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderHiveModel(
      localId: fields[0] as String,
      serverOrderId: fields[1] as String?,
      isSynced: fields[2] as bool,
      createdAt: fields[3] as DateTime,
      totalAmount: fields[4] as double,
      fullName: fields[5] as String,
      phone: fields[6] as String,
      address: fields[7] as String,
      note: fields[8] as String?,
      items: (fields[9] as List).cast<OrderItemHiveModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.localId)
      ..writeByte(1)
      ..write(obj.serverOrderId)
      ..writeByte(2)
      ..write(obj.isSynced)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.totalAmount)
      ..writeByte(5)
      ..write(obj.fullName)
      ..writeByte(6)
      ..write(obj.phone)
      ..writeByte(7)
      ..write(obj.address)
      ..writeByte(8)
      ..write(obj.note)
      ..writeByte(9)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
