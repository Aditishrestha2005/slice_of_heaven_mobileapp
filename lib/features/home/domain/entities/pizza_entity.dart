import 'package:equatable/equatable.dart';

class PizzaEntity extends Equatable {
  final String? pizzaId;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PizzaEntity({
    this.pizzaId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        pizzaId,
        name,
        description,
        price,
        image,
        category,
        createdAt,
        updatedAt,
      ];
}