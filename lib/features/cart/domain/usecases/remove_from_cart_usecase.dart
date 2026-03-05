import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';

import 'package:slice_of_heaven/core/usecase/app_usecase.dart';
import 'package:slice_of_heaven/features/cart/data/repositories/cart_repository.dart';
import 'package:slice_of_heaven/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCartParams {
  final String pizzaId;
  RemoveFromCartParams({required this.pizzaId});
}

final removeFromCartUsecaseProvider = Provider<RemoveFromCartUsecase>((ref) {
  final repo = ref.read(cartRepositoryProvider);
  return RemoveFromCartUsecase(cartRepository: repo);
});

class RemoveFromCartUsecase
    implements UsecaseWithParams<void, RemoveFromCartParams> {
  final ICartRepository _cartRepository;

  RemoveFromCartUsecase({required ICartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, void>> call(RemoveFromCartParams params) {
    return _cartRepository.removeFromCart(params.pizzaId);
  }
}