import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';
import 'package:slice_of_heaven/core/usecase/app_usecase.dart';
import 'package:slice_of_heaven/features/cart/domain/entities/cart_item_entity.dart';
import 'package:slice_of_heaven/features/order/domain/repositories/order_repository.dart';
import 'package:slice_of_heaven/features/order/data/repositories/order_repository_impl.dart';

final placeOrderUsecaseProvider = Provider<PlaceOrderUsecase>((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return PlaceOrderUsecase(repo);
});

class PlaceOrderParams {
  final String token;
  final String fullName;
  final String phone;
  final String address;
  final String? note;
  final List<CartItemEntity> items;

  PlaceOrderParams({
    required this.token,
    required this.fullName,
    required this.phone,
    required this.address,
    this.note,
    required this.items,
  });
}

class PlaceOrderUsecase implements UsecaseWithParams<void, PlaceOrderParams> {
  final OrderRepository repository;

  PlaceOrderUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(PlaceOrderParams params) {
    return repository.placeOrder(
      token: params.token,
      fullName: params.fullName,
      phone: params.phone,
      address: params.address,
      note: params.note,
      items: params.items,
    );
  }
}