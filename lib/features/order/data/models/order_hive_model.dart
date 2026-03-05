import 'package:hive/hive.dart';
import 'package:slice_of_heaven/core/constants/hive_table_constant.dart';
import 'package:slice_of_heaven/features/order/data/models/order_item_hive_model.dart';
import 'package:slice_of_heaven/features/order/domain/entities/order_entity.dart';

part 'order_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.orderTypeId)
class OrderHiveModel extends HiveObject {
  @HiveField(0)
  final String localId;

  @HiveField(1)
  final String? serverOrderId;

  @HiveField(2)
  final bool isSynced;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final double totalAmount;

  @HiveField(5)
  final String fullName;

  @HiveField(6)
  final String phone;

  @HiveField(7)
  final String address;

  @HiveField(8)
  final String? note;

  @HiveField(9)
  final List<OrderItemHiveModel> items;

  OrderHiveModel({
    required this.localId,
    required this.serverOrderId,
    required this.isSynced,
    required this.createdAt,
    required this.totalAmount,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.note,
    required this.items,
  });

  OrderEntity toEntity() => OrderEntity(
        localId: localId,
        serverOrderId: serverOrderId,
        isSynced: isSynced,
        createdAt: createdAt,
        totalAmount: totalAmount,
        fullName: fullName,
        phone: phone,
        address: address,
        note: note,
        items: items.map((e) => e.toEntity()).toList(),
      );

  factory OrderHiveModel.fromEntity(OrderEntity e) => OrderHiveModel(
        localId: e.localId,
        serverOrderId: e.serverOrderId,
        isSynced: e.isSynced,
        createdAt: e.createdAt,
        totalAmount: e.totalAmount,
        fullName: e.fullName,
        phone: e.phone,
        address: e.address,
        note: e.note,
        items: e.items.map(OrderItemHiveModel.fromEntity).toList(),
      );

  OrderHiveModel copyWith({
    String? localId,
    String? serverOrderId,
    bool? isSynced,
    DateTime? createdAt,
    double? totalAmount,
    String? fullName,
    String? phone,
    String? address,
    String? note,
    List<OrderItemHiveModel>? items,
  }) {
    return OrderHiveModel(
      localId: localId ?? this.localId,
      serverOrderId: serverOrderId ?? this.serverOrderId,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      totalAmount: totalAmount ?? this.totalAmount,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      note: note ?? this.note,
      items: items ?? this.items,
    );
  }
}