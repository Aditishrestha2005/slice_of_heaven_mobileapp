import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slice_of_heaven/core/api/api_endpoints.dart';
import 'package:slice_of_heaven/features/cart/domain/entities/cart_item_entity.dart';
import 'package:slice_of_heaven/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:slice_of_heaven/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:slice_of_heaven/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:slice_of_heaven/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:slice_of_heaven/features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import 'package:slice_of_heaven/features/cart/presentation/state/cart_state.dart';
import 'package:slice_of_heaven/features/home/domain/entities/pizza_entity.dart';

final cartViewModelProvider =
    NotifierProvider<CartViewModel, CartState>(CartViewModel.new);

class CartViewModel extends Notifier<CartState> {
  late final AddToCartUsecase _addToCart;
  late final GetCartItemsUsecase _getCartItems;
  late final UpdateCartQuantityUsecase _updateQty;
  late final RemoveFromCartUsecase _removeFromCart;
  late final ClearCartUsecase _clearCart;

  @override
  CartState build() {
    _addToCart = ref.read(addToCartUsecaseProvider);
    _getCartItems = ref.read(getCartItemsUsecaseProvider);
    _updateQty = ref.read(updateCartQuantityUsecaseProvider);
    _removeFromCart = ref.read(removeFromCartUsecaseProvider);
    _clearCart = ref.read(clearCartUsecaseProvider);
    return const CartState();
  }

  Future<void> loadCart() async {
    state = state.copyWith(status: CartStatus.loading);

    final result = await _getCartItems();
    result.fold(
      (failure) => state = state.copyWith(
        status: CartStatus.error,
        errorMessage: failure.message,
      ),
      (items) => state = state.copyWith(
        status: CartStatus.loaded,
        items: items,
        errorMessage: null,
      ),
    );
  }

  // ===========================
  // ✅ IMAGE OFFLINE HELPERS
  // ===========================

  String _buildImageUrl(String image) {
    if (image.startsWith("http")) return image;
    return "${ApiEndpoints.baseUrl}$image";
  }

  String _guessExtensionFromUrl(String url) {
    final lower = url.toLowerCase();
    if (lower.contains(".png")) return "png";
    if (lower.contains(".webp")) return "webp";
    if (lower.contains(".jpeg")) return "jpeg";
    return "jpg";
  }

  Future<String?> _downloadAndSaveImage({
    required String pizzaId,
    required String imageUrl,
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory("${dir.path}/slice_of_heaven_images");
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final ext = _guessExtensionFromUrl(imageUrl);
      final filePath = "${imagesDir.path}/pizza_$pizzaId.$ext";
      final file = File(filePath);

      // ✅ If already downloaded earlier, reuse it
      if (await file.exists() && await file.length() > 0) {
        return filePath;
      }

      final dio = Dio();
      final response = await dio.get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) return null;

      await file.writeAsBytes(bytes, flush: true);
      return filePath;
    } catch (_) {
      // If download fails, we still allow cart add (online image will work when connected)
      return null;
    }
  }

  /// ✅ called from PizzaCard
  Future<void> addPizzaToCart(PizzaEntity pizza) async {
    final id = pizza.pizzaId;
    if (id == null || id.isEmpty) {
      state = state.copyWith(
        status: CartStatus.error,
        errorMessage: "Pizza id missing. Fix PizzaApiModel mapping.",
      );
      return;
    }

    // ✅ Try to save image offline
    final imageUrl = _buildImageUrl(pizza.image);
    final localPath = await _downloadAndSaveImage(
      pizzaId: id,
      imageUrl: imageUrl,
    );

    final item = CartItemEntity(
      pizzaId: id,
      name: pizza.name,
      image: pizza.image, // keep original (relative or full)
      localImagePath: localPath, // ✅ IMPORTANT
      price: pizza.price,
      quantity: 1,
    );

    final result = await _addToCart(AddToCartParams(item: item));

    await result.fold(
      (failure) async {
        state = state.copyWith(
          status: CartStatus.error,
          errorMessage: failure.message,
        );
      },
      (_) async {
        await loadCart();
      },
    );
  }

  Future<void> increment(String pizzaId) async {
    final current = state.items.firstWhere((e) => e.pizzaId == pizzaId);
    await _updateQty(
      UpdateCartQuantityParams(
        pizzaId: pizzaId,
        quantity: current.quantity + 1,
      ),
    );
    await loadCart();
  }

  Future<void> decrement(String pizzaId) async {
    final current = state.items.firstWhere((e) => e.pizzaId == pizzaId);

    final nextQty = current.quantity - 1;

    // ✅ if quantity becomes 0, remove item
    if (nextQty <= 0) {
      await _removeFromCart(RemoveFromCartParams(pizzaId: pizzaId));
      await loadCart();
      return;
    }

    await _updateQty(
      UpdateCartQuantityParams(
        pizzaId: pizzaId,
        quantity: nextQty,
      ),
    );
    await loadCart();
  }

  Future<void> remove(String pizzaId) async {
    await _removeFromCart(RemoveFromCartParams(pizzaId: pizzaId));
    await loadCart();
  }

  Future<void> clear() async {
    await _clearCart();
    await loadCart();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}