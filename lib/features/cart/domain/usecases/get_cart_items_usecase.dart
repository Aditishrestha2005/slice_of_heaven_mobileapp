import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';

import 'package:slice_of_heaven/core/usecase/app_usecase.dart';
import 'package:slice_of_heaven/features/cart/data/repositories/cart_repository.dart';
import 'package:slice_of_heaven/features/cart/domain/entities/cart_item_entity.dart';
import 'package:slice_of_heaven/features/cart/domain/repositories/cart_repository.dart';

final getCartItemsUsecaseProvider = Provider<GetCartItemsUsecase>((ref) {
  final repo = ref.read(cartRepositoryProvider);
  return GetCartItemsUsecase(cartRepository: repo);
});

class GetCartItemsUsecase
    implements UsecaseWithoutParams<List<CartItemEntity>> {
  final ICartRepository _cartRepository;

  GetCartItemsUsecase({required ICartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, List<CartItemEntity>>> call() {
    return _cartRepository.getCartItems();
  }
}