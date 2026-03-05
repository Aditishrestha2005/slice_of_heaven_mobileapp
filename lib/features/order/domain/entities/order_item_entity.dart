import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String pizzaId;
  final String name;
  final String image;
  final double price;
  final int quantity;

  const OrderItemEntity({
    required this.pizzaId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;

  @override
  List<Object?> get props => [pizzaId, name, image, price, quantity];
}