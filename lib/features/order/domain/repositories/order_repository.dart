import 'package:dartz/dartz.dart';
import 'package:slice_of_heaven/core/error/failure.dart';

import 'package:slice_of_heaven/features/cart/domain/entities/cart_item_entity.dart';
import 'package:slice_of_heaven/features/order/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, void>> placeOrder({
    required String token,
    required String fullName,
    required String phone,
    required String address,
    String? note,
    required List<CartItemEntity> items,
  });

  Future<Either<Failure, List<OrderEntity>>> getLocalOrders();

  /// tries to upload unsynced local orders to backend
  Future<Either<Failure, void>> syncPendingOrders(String token);
}