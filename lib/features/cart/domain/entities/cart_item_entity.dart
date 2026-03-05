import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String? cartItemId;
  final String pizzaId;

  final String name;

  /// original image URL
  final String image;

  /// ✅ local stored image path (for offline use)
  final String? localImagePath;

  final double price;
  final int quantity;

  const CartItemEntity({
    this.cartItemId,
    required this.pizzaId,
    required this.name,
    required this.image,
    this.localImagePath,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;

  CartItemEntity copyWith({
    String? cartItemId,
    String? pizzaId,
    String? name,
    String? image,
    String? localImagePath,
    double? price,
    int? quantity,
  }) {
    return CartItemEntity(
      cartItemId: cartItemId ?? this.cartItemId,
      pizzaId: pizzaId ?? this.pizzaId,
      name: name ?? this.name,
      image: image ?? this.image,
      localImagePath: localImagePath ?? this.localImagePath,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
        cartItemId,
        pizzaId,
        name,
        image,
        localImagePath,
        price,
        quantity,
      ];
}