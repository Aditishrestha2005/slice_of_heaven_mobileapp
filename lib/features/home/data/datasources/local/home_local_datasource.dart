import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/services/hive/hive_service.dart';
import 'package:slice_of_heaven/features/home/data/datasources/home_data_source.dart';

import 'package:slice_of_heaven/features/home/data/models/pizza_hive_model.dart';

// Provider
final homeLocalDatasourceProvider =
    Provider<HomeLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return HomeLocalDatasource(hiveService: hiveService);
});

class HomeLocalDatasource implements IHomeLocalDataSource {
  final HiveService _hiveService;

  HomeLocalDatasource({
    required HiveService hiveService,
  }) : _hiveService = hiveService;

  @override
  Future<void> cachePizzas(List<PizzaHiveModel> pizzas) async {
    try {
      await _hiveService.cachePizzas(pizzas);
    } catch (_) {
      // ignore for now (repository handles failure)
    }
  }

  @override
  Future<List<PizzaHiveModel>> getCachedPizzas() async {
    try {
      return await _hiveService.getCachedPizzas();
    } catch (_) {
      return [];
    }
  }
}