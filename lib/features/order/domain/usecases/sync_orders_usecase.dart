import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';
import 'package:slice_of_heaven/core/usecase/app_usecase.dart';
import 'package:slice_of_heaven/features/order/domain/repositories/order_repository.dart';
import 'package:slice_of_heaven/features/order/data/repositories/order_repository_impl.dart';

final syncOrdersUsecaseProvider = Provider<SyncOrdersUsecase>((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return SyncOrdersUsecase(repo);
});

class SyncOrdersUsecase implements UsecaseWithParams<void, String> {
  final OrderRepository repository;

  SyncOrdersUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(String token) {
    return repository.syncPendingOrders(token);
  }
}