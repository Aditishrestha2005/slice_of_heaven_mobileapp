import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';
import 'package:slice_of_heaven/core/usecase/app_usecase.dart';
import 'package:slice_of_heaven/features/order/domain/entities/order_entity.dart';
import 'package:slice_of_heaven/features/order/domain/repositories/order_repository.dart';
import 'package:slice_of_heaven/features/order/data/repositories/order_repository_impl.dart';

final getOrdersUsecaseProvider = Provider<GetOrdersUsecase>((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return GetOrdersUsecase(repo);
});

class GetOrdersUsecase
    implements UsecaseWithoutParams<List<OrderEntity>> {
  final OrderRepository repository;

  GetOrdersUsecase(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call() {
    return repository.getLocalOrders();
  }
}