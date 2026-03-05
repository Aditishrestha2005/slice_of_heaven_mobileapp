import 'package:hive/hive.dart';
import 'package:slice_of_heaven/core/constants/hive_table_constant.dart';
import 'package:slice_of_heaven/features/cart/domain/entities/cart_item_entity.dart';
import 'package:uuid/uuid.dart';

part 'cart_item_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.cartItemTypeId)
class CartItemHiveModel extends HiveObject {
  @HiveField(0)
  final String cartItemId;

  @HiveField(1)
  final String pizzaId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String image;

  // ✅ keep old indexes same
  @HiveField(4)
  final double price;

  @HiveField(5)
  final int quantity;

  // ✅ NEW field MUST be at the end (do not shift old indexes)
  @HiveField(6)
  final String? localImagePath;

  CartItemHiveModel({
    String? cartItemId,
    required this.pizzaId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    this.localImagePath,
  }) : cartItemId = cartItemId ?? const Uuid().v4();

  CartItemEntity toEntity() {
    return CartItemEntity(
      cartItemId: cartItemId,
      pizzaId: pizzaId,
      name: name,
      image: image,
      localImagePath: localImagePath,
      price: price,
      quantity: quantity,
    );
  }

  factory CartItemHiveModel.fromEntity(CartItemEntity entity) {
    return CartItemHiveModel(
      cartItemId: entity.cartItemId,
      pizzaId: entity.pizzaId,
      name: entity.name,
      image: entity.image,
      price: entity.price,
      quantity: entity.quantity,
      localImagePath: entity.localImagePath,
    );
  }

  static List<CartItemEntity> toEntityList(List<CartItemHiveModel> models) {
    return models.map((m) => m.toEntity()).toList();
  }
}