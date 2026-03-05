import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';

import 'package:slice_of_heaven/core/usecase/app_usecase.dart';
import 'package:slice_of_heaven/features/cart/data/repositories/cart_repository.dart';
import 'package:slice_of_heaven/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartQuantityParams {
  final String pizzaId;
  final int quantity;

  UpdateCartQuantityParams({
    required this.pizzaId,
    required this.quantity,
  });
}

final updateCartQuantityUsecaseProvider =
    Provider<UpdateCartQuantityUsecase>((ref) {
  final repo = ref.read(cartRepositoryProvider);
  return UpdateCartQuantityUsecase(cartRepository: repo);
});

class UpdateCartQuantityUsecase
    implements UsecaseWithParams<void, UpdateCartQuantityParams> {
  final ICartRepository _cartRepository;

  UpdateCartQuantityUsecase({required ICartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, void>> call(UpdateCartQuantityParams params) {
    return _cartRepository.updateQuantity(params.pizzaId, params.quantity);
  }
}