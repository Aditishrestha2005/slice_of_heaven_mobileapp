import 'package:slice_of_heaven/features/home/domain/entities/pizza_entity.dart';
import 'package:slice_of_heaven/features/home/data/models/pizza_hive_model.dart';

class PizzaApiModel {
  final String? pizzaId;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PizzaApiModel({
    this.pizzaId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.createdAt,
    this.updatedAt,
  });

  /// JSON -> ApiModel
  factory PizzaApiModel.fromJson(Map<String, dynamic> json) {
    return PizzaApiModel(
      pizzaId: json['_id']?.toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      image: json['image'] ?? '',
      category: json['category'] ?? 'All',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  /// ApiModel -> Entity
  PizzaEntity toEntity() {
    return PizzaEntity(
      pizzaId: pizzaId,
      name: name,
      description: description,
      price: price,
      image: image,
      category: category,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// ApiModel -> HiveModel
  PizzaHiveModel toHiveModel() {
    return PizzaHiveModel(
      pizzaId: pizzaId,
      name: name,
      description: description,
      price: price,
      image: image,
      category: category,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}