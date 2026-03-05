import 'package:slice_of_heaven/features/home/data/models/pizza_api_model.dart';
import 'package:slice_of_heaven/features/home/data/models/pizza_hive_model.dart';

abstract interface class IHomeLocalDataSource {
  Future<void> cachePizzas(List<PizzaHiveModel> pizzas);
  Future<List<PizzaHiveModel>> getCachedPizzas();
}

abstract interface class IHomeRemoteDataSource {
  Future<List<PizzaApiModel>> getAllPizzas();
}