import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';

class OrderEntity extends Equatable {
  final String localId;       // always exists
  final String? serverOrderId; // mongo _id (null if offline)
  final bool isSynced;

  final DateTime createdAt;
  final double totalAmount;

  final String fullName;
  final String phone;
  final String address;
  final String? note;

  final List<OrderItemEntity> items;

  const OrderEntity({
    required this.localId,
    required this.serverOrderId,
    required this.isSynced,
    required this.createdAt,
    required this.totalAmount,
    required this.fullName,
    required this.phone,
    required this.address,
    this.note,
    required this.items,
  });

  @override
  List<Object?> get props => [
        localId,
        serverOrderId,
        isSynced,
        createdAt,
        totalAmount,
        fullName,
        phone,
        address,
        note,
        items,
      ];
}