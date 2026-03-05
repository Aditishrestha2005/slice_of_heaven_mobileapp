import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';

import 'package:slice_of_heaven/core/usecase/app_usecase.dart';
import 'package:slice_of_heaven/features/cart/data/repositories/cart_repository.dart';
import 'package:slice_of_heaven/features/cart/domain/repositories/cart_repository.dart';

final clearCartUsecaseProvider = Provider<ClearCartUsecase>((ref) {
  final repo = ref.read(cartRepositoryProvider);
  return ClearCartUsecase(cartRepository: repo);
});

class ClearCartUsecase implements UsecaseWithoutParams<void> {
  final ICartRepository _cartRepository;

  ClearCartUsecase({required ICartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, void>> call() {
    return _cartRepository.clearCart();
  }
}