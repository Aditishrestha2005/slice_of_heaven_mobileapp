import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/services/hive/hive_service.dart';
import 'package:slice_of_heaven/features/cart/data/datasources/cart_data_source.dart';
import 'package:slice_of_heaven/features/cart/data/models/cart_item_hive_model.dart';

// Provider
final cartLocalDatasourceProvider = Provider<ICartLocalDataSource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return CartLocalDatasource(hiveService: hiveService);
});

class CartLocalDatasource implements ICartLocalDataSource {
  final HiveService _hiveService;

  CartLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<void> addToCart(CartItemHiveModel item) async {
    await _hiveService.addToCart(item);
  }

  @override
  Future<List<CartItemHiveModel>> getCartItems() async {
    return await _hiveService.getCartItems();
  }

  @override
  Future<void> updateQuantity(String pizzaId, int quantity) async {
    await _hiveService.updateCartQuantity(pizzaId, quantity);
  }

  @override
  Future<void> removeFromCart(String pizzaId) async {
    await _hiveService.removeFromCart(pizzaId);
  }

  @override
  Future<void> clearCart() async {
    await _hiveService.clearCart();
  }
}