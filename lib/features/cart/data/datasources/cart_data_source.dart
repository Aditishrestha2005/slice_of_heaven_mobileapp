import 'package:slice_of_heaven/features/cart/data/models/cart_item_hive_model.dart';

abstract interface class ICartLocalDataSource {
  Future<void> addToCart(CartItemHiveModel item);
  Future<List<CartItemHiveModel>> getCartItems();
  Future<void> updateQuantity(String pizzaId, int quantity);
  Future<void> removeFromCart(String pizzaId);
  Future<void> clearCart();
}