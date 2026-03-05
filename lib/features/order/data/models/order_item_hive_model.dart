import 'package:hive/hive.dart';
import 'package:slice_of_heaven/core/constants/hive_table_constant.dart';
import 'package:slice_of_heaven/features/order/domain/entities/order_item_entity.dart';

part 'order_item_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.orderItemTypeId)
class OrderItemHiveModel extends HiveObject {
  @HiveField(0)
  final String pizzaId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final int quantity;

  OrderItemHiveModel({
    required this.pizzaId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  OrderItemEntity toEntity() => OrderItemEntity(
        pizzaId: pizzaId,
        name: name,
        image: image,
        price: price,
        quantity: quantity,
      );

  factory OrderItemHiveModel.fromEntity(OrderItemEntity e) => OrderItemHiveModel(
        pizzaId: e.pizzaId,
        name: e.name,
        image: e.image,
        price: e.price,
        quantity: e.quantity,
      );
}