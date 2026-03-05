import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';

import 'package:slice_of_heaven/core/usecase/app_usecase.dart';
import 'package:slice_of_heaven/features/cart/data/repositories/cart_repository.dart';
import 'package:slice_of_heaven/features/cart/domain/entities/cart_item_entity.dart';
import 'package:slice_of_heaven/features/cart/domain/repositories/cart_repository.dart';

class AddToCartParams {
  final CartItemEntity item;
  AddToCartParams({required this.item});
}

final addToCartUsecaseProvider = Provider<AddToCartUsecase>((ref) {
  final repo = ref.read(cartRepositoryProvider);
  return AddToCartUsecase(cartRepository: repo);
});

class AddToCartUsecase implements UsecaseWithParams<void, AddToCartParams> {
  final ICartRepository _cartRepository;

  AddToCartUsecase({required ICartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, void>> call(AddToCartParams params) {
    return _cartRepository.addToCart(params.item);
  }
}