import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slice_of_heaven/core/constants/hive_table_constant.dart';
import 'package:slice_of_heaven/features/auth/data/models/auth_hive_model.dart';
import 'package:slice_of_heaven/features/profile/data/models/profile_hive_model.dart';
import 'package:slice_of_heaven/features/home/data/models/pizza_hive_model.dart';

// ✅ Cart
import 'package:slice_of_heaven/features/cart/data/models/cart_item_hive_model.dart';

// ✅ Order
import 'package:slice_of_heaven/features/order/data/models/order_hive_model.dart';
import 'package:slice_of_heaven/features/order/data/models/order_item_hive_model.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  static bool _hiveInitDone = false;
  static Future<void>? _initFuture;

  Future<void> init() {
    // ✅ prevents multiple init calls at the same time
    _initFuture ??= _initInternal();
    return _initFuture!;
  }

  Future<void> _initInternal() async {
    if (!_hiveInitDone) {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
      _hiveInitDone = true;
    }

    _registerAdapters();
    await _openBoxes();
  }

  void _registerAdapters() {
    // AUTH
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }

    // PROFILE
    if (!Hive.isAdapterRegistered(HiveTableConstant.profileTypeId)) {
      Hive.registerAdapter(ProfileHiveModelAdapter());
    }

    // PIZZA
    if (!Hive.isAdapterRegistered(HiveTableConstant.pizzaTypeId)) {
      Hive.registerAdapter(PizzaHiveModelAdapter());
    }

    // CART
    if (!Hive.isAdapterRegistered(HiveTableConstant.cartItemTypeId)) {
      Hive.registerAdapter(CartItemHiveModelAdapter());
    }

    // ✅ ORDER (nested first)
    // IMPORTANT: use constants to avoid mismatch
    if (!Hive.isAdapterRegistered(HiveTableConstant.orderItemTypeId)) {
      Hive.registerAdapter(OrderItemHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.orderTypeId)) {
      Hive.registerAdapter(OrderHiveModelAdapter());
    }
  }

  Future<void> _openBoxes() async {
    if (!Hive.isBoxOpen(HiveTableConstant.authTable)) {
      await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    }
    if (!Hive.isBoxOpen(HiveTableConstant.profileTable)) {
      await Hive.openBox<ProfileHiveModel>(HiveTableConstant.profileTable);
    }
    if (!Hive.isBoxOpen(HiveTableConstant.pizzaTable)) {
      await Hive.openBox<PizzaHiveModel>(HiveTableConstant.pizzaTable);
    }
    if (!Hive.isBoxOpen(HiveTableConstant.cartTable)) {
      await Hive.openBox<CartItemHiveModel>(HiveTableConstant.cartTable);
    }
    if (!Hive.isBoxOpen(HiveTableConstant.orderTable)) {
      await Hive.openBox<OrderHiveModel>(HiveTableConstant.orderTable);
    }
  }

  // ================= AUTH =================
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  Future<AuthHiveModel> register(AuthHiveModel user) async {
    await init();
    await _authBox.put(user.authId, user);
    return user;
  }

  Future<AuthHiveModel?> login(String email, String password) async {
    await init();
    try {
      return _authBox.values.firstWhere(
        (user) =>
            user.email.trim().toLowerCase() == email.trim().toLowerCase() &&
            user.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  AuthHiveModel? getUserById(String authId) => _authBox.get(authId);

  Future<AuthHiveModel?> getUserByEmail(String email) async {
    await init();
    try {
      return _authBox.values.firstWhere(
        (user) => user.email.trim().toLowerCase() == email.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> updateUser(AuthHiveModel user) async {
    await init();
    await _authBox.put(user.authId, user);
    return true;
  }

  Future<void> deleteUser(String authId) async {
    await init();
    await _authBox.delete(authId);
  }

  // ================= PROFILE =================
  Box<ProfileHiveModel> get _profileBox =>
      Hive.box<ProfileHiveModel>(HiveTableConstant.profileTable);

  Future<ProfileHiveModel> saveProfile(ProfileHiveModel profile) async {
    await init();
    final key = profile.userId;
    if (key == null || key.isEmpty) {
      throw Exception("Profile userId is null/empty");
    }
    await _profileBox.put(key, profile);
    return profile;
  }

  ProfileHiveModel? getProfileById(String userId) => _profileBox.get(userId);

  ProfileHiveModel? getProfileByEmail(String email) {
    try {
      return _profileBox.values.firstWhere(
        (p) => p.email.trim().toLowerCase() == email.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> updateProfile(ProfileHiveModel profile) async {
    await init();
    final key = profile.userId;
    if (key == null || key.isEmpty) return false;

    await _profileBox.put(key, profile);
    return true;
  }

  Future<void> deleteProfile(String userId) async {
    await init();
    await _profileBox.delete(userId);
  }

  // ================= PIZZA =================
  Box<PizzaHiveModel> get _pizzaBox =>
      Hive.box<PizzaHiveModel>(HiveTableConstant.pizzaTable);

  Future<void> cachePizzas(List<PizzaHiveModel> pizzas) async {
    await init();
    await _pizzaBox.clear();

    for (final p in pizzas) {
      final key = p.pizzaId ?? p.key?.toString();
      if (key != null && key.isNotEmpty) {
        await _pizzaBox.put(key, p);
      }
    }
  }

  Future<List<PizzaHiveModel>> getCachedPizzas() async {
    await init();
    return _pizzaBox.values.toList();
  }

  // ================= CART =================
  Box<CartItemHiveModel> get _cartBox =>
      Hive.box<CartItemHiveModel>(HiveTableConstant.cartTable);

  Future<void> addToCart(CartItemHiveModel item) async {
    await init();

    final key = item.pizzaId;
    final existing = _cartBox.get(key);

    if (existing != null) {
      final updated = CartItemHiveModel(
        cartItemId: existing.cartItemId,
        pizzaId: existing.pizzaId,
        name: existing.name,
        image: existing.image,
        localImagePath: existing.localImagePath,
        price: existing.price,
        quantity: existing.quantity + item.quantity,
      );
      await _cartBox.put(key, updated);
      return;
    }

    await _cartBox.put(key, item);
  }

  Future<List<CartItemHiveModel>> getCartItems() async {
    await init();
    return _cartBox.values.toList();
  }

  Future<void> updateCartQuantity(String pizzaId, int quantity) async {
    await init();

    final existing = _cartBox.get(pizzaId);
    if (existing == null) return;

    if (quantity <= 0) {
      await _cartBox.delete(pizzaId);
      return;
    }

    final updated = CartItemHiveModel(
      cartItemId: existing.cartItemId,
      pizzaId: existing.pizzaId,
      name: existing.name,
      image: existing.image,
      localImagePath: existing.localImagePath,
      price: existing.price,
      quantity: quantity,
    );

    await _cartBox.put(pizzaId, updated);
  }

  Future<void> removeFromCart(String pizzaId) async {
    await init();
    await _cartBox.delete(pizzaId);
  }

  Future<void> clearCart() async {
    await init();
    await _cartBox.clear();
  }

  // ================= ORDER (ONLY FIXED PART) =================
  Box<OrderHiveModel> get _orderBox =>
      Hive.box<OrderHiveModel>(HiveTableConstant.orderTable);

  /// ✅ key = localId (offline-first)
  Future<void> upsertOrder(OrderHiveModel order) async {
    await init();
    await _orderBox.put(order.localId, order);
  }

  Future<List<OrderHiveModel>> getAllOrders() async {
    await init();
    final list = _orderBox.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<List<OrderHiveModel>> getUnsyncedOrders() async {
    await init();
    return _orderBox.values.where((o) => o.isSynced == false).toList();
  }

  Future<void> clearOrders() async {
    await init();
    await _orderBox.clear();
  }
}