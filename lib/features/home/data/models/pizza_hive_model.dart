import 'package:hive/hive.dart';
import 'package:slice_of_heaven/core/constants/hive_table_constant.dart';
import 'package:slice_of_heaven/features/home/domain/entities/pizza_entity.dart';

part 'pizza_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.pizzaTypeId)
class PizzaHiveModel extends HiveObject {
  @HiveField(0)
  final String? pizzaId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String image;

  @HiveField(5)
  final String category;

  @HiveField(6)
  final DateTime? createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  PizzaHiveModel({
    this.pizzaId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.createdAt,
    this.updatedAt,
  });

  /// Convert Hive -> Entity
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

  /// Convert Entity -> Hive
  factory PizzaHiveModel.fromEntity(PizzaEntity entity) {
    return PizzaHiveModel(
      pizzaId: entity.pizzaId,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      image: entity.image,
      category: entity.category,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert List
  static List<PizzaEntity> toEntityList(List<PizzaHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}