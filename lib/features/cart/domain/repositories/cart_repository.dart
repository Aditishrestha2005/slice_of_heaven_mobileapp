import 'package:dartz/dartz.dart';
import 'package:slice_of_heaven/core/error/failure.dart';

import 'package:slice_of_heaven/features/cart/domain/entities/cart_item_entity.dart';

abstract interface class ICartRepository {
  Future<Either<Failure, void>> addToCart(CartItemEntity item);

  Future<Either<Failure, List<CartItemEntity>>> getCartItems();

  Future<Either<Failure, void>> updateQuantity(
    String pizzaId,
    int quantity,
  );

  Future<Either<Failure, void>> removeFromCart(String pizzaId);

  Future<Either<Failure, void>> clearCart();
}