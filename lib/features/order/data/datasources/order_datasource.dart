import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/features/order/data/datasources/local/order_local_datasource.dart';
import 'package:slice_of_heaven/features/order/data/datasources/remote/order_remote_datasource.dart';

final orderDatasourceProvider = Provider<OrderDatasource>((ref) {
  return OrderDatasource(
    local: ref.read(orderLocalDatasourceProvider),
    remote: ref.read(orderRemoteDatasourceProvider),
  );
});

class OrderDatasource {
  final OrderLocalDatasource local;
  final OrderRemoteDatasource remote;

  OrderDatasource({required this.local, required this.remote});
}