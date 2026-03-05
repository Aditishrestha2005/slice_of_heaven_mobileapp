import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';
import 'package:uuid/uuid.dart';
import 'package:slice_of_heaven/features/cart/domain/entities/cart_item_entity.dart';
import 'package:slice_of_heaven/features/order/data/datasources/local/order_local_datasource.dart';
import 'package:slice_of_heaven/features/order/data/datasources/remote/order_remote_datasource.dart';
import 'package:slice_of_heaven/features/order/data/models/order_hive_model.dart';
import 'package:slice_of_heaven/features/order/data/models/order_item_hive_model.dart';
import 'package:slice_of_heaven/features/order/domain/entities/order_entity.dart';
import 'package:slice_of_heaven/features/order/domain/repositories/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final local = ref.read(orderLocalDatasourceProvider);
  final remote = ref.read(orderRemoteDatasourceProvider);
  return OrderRepositoryImpl(local: local, remote: remote);
});

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDatasource local;
  final OrderRemoteDatasource remote;

  OrderRepositoryImpl({
    required this.local,
    required this.remote,
  });

  @override
  Future<Either<Failure, void>> placeOrder({
    required String token,
    required String fullName,
    required String phone,
    required String address,
    String? note,
    required List<CartItemEntity> items,
  }) async {
    try {
      // 1) create local order and save immediately
      final localId = const Uuid().v4();

      final hiveItems = items
          .map((e) => OrderItemHiveModel(
                pizzaId: e.pizzaId,
                name: e.name,
                image: e.image,
                price: e.price,
                quantity: e.quantity,
              ))
          .toList();

      final totalAmount =
          hiveItems.fold<double>(0, (sum, i) => sum + (i.price * i.quantity));

      var localOrder = OrderHiveModel(
        localId: localId,
        serverOrderId: null,
        isSynced: false,
        createdAt: DateTime.now(),
        totalAmount: totalAmount,
        fullName: fullName,
        phone: phone,
        address: address,
        note: note,
        items: hiveItems,
      );

      await local.upsertOrder(localOrder);

      // 2) try remote create (if fails, keep local unsynced)
      try {
        final apiItems = items
            .map((e) => {
                  "pizzaId": e.pizzaId,
                  "name": e.name,
                  "price": e.price,
                  "image": e.image,
                  "quantity": e.quantity,
                })
            .toList();

        final created = await remote.createOrder(
          token: token,
          items: apiItems,
          fullName: fullName,
          phone: phone,
          address: address,
          note: note,
        );

        localOrder = localOrder.copyWith(
          serverOrderId: created["_id"].toString(),
          isSynced: true,
          createdAt: DateTime.parse(created["createdAt"].toString()),
          totalAmount: (created["totalAmount"] as num).toDouble(),
        );

        await local.upsertOrder(localOrder);
      } catch (_) {
        // offline or server down: ignore
      }

      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getLocalOrders() async {
    try {
      final list = await local.getAllOrders();
      return Right(list.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncPendingOrders(String token) async {
    try {
      final pending = await local.getUnsyncedOrders();
      for (final o in pending) {
        try {
          final apiItems = o.items
              .map((e) => {
                    "pizzaId": e.pizzaId,
                    "name": e.name,
                    "price": e.price,
                    "image": e.image,
                    "quantity": e.quantity,
                  })
              .toList();

          final created = await remote.createOrder(
            token: token,
            items: apiItems,
            fullName: o.fullName,
            phone: o.phone,
            address: o.address,
            note: o.note,
          );

          final updated = o.copyWith(
            serverOrderId: created["_id"].toString(),
            isSynced: true,
            createdAt: DateTime.parse(created["createdAt"].toString()),
            totalAmount: (created["totalAmount"] as num).toDouble(),
          );

          await local.upsertOrder(updated);
        } catch (_) {
          // still offline -> skip
        }
      }
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}