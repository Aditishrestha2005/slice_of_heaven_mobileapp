import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/services/hive/hive_service.dart';
import 'package:slice_of_heaven/features/order/data/models/order_hive_model.dart';

final orderLocalDatasourceProvider = Provider<OrderLocalDatasource>((ref) {
  final hive = ref.read(hiveServiceProvider);
  return OrderLocalDatasource(hive);
});

class OrderLocalDatasource {
  final HiveService hive;

  OrderLocalDatasource(this.hive);

  Future<void> upsertOrder(OrderHiveModel order) => hive.upsertOrder(order);

  Future<List<OrderHiveModel>> getAllOrders() => hive.getAllOrders();

  Future<List<OrderHiveModel>> getUnsyncedOrders() => hive.getUnsyncedOrders();

  Future<void> clearOrders() => hive.clearOrders();
}