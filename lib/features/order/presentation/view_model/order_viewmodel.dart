import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/services/storage/user_session_service.dart';
import 'package:slice_of_heaven/features/order/domain/usecases/get_orders_usecase.dart';
import 'package:slice_of_heaven/features/order/domain/usecases/sync_orders_usecase.dart';
import 'package:slice_of_heaven/features/order/presentation/state/order_state.dart';

final orderViewModelProvider =
    StateNotifierProvider<OrderViewModel, OrderState>((ref) {
  final getOrders = ref.read(getOrdersUsecaseProvider);
  final syncOrders = ref.read(syncOrdersUsecaseProvider);
  final session = ref.read(userSessionServiceProvider);

  return OrderViewModel(
    getOrdersUsecase: getOrders,
    syncOrdersUsecase: syncOrders,
    session: session,
  );
});

class OrderViewModel extends StateNotifier<OrderState> {
  final GetOrdersUsecase getOrdersUsecase;
  final SyncOrdersUsecase syncOrdersUsecase;
  final UserSessionService session;

  OrderViewModel({
    required this.getOrdersUsecase,
    required this.syncOrdersUsecase,
    required this.session,
  }) : super(OrderState.initial());

  /// ✅ Load local orders
  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true, error: null);

    final res = await getOrdersUsecase.call();
    res.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.message),
      (orders) => state = state.copyWith(isLoading: false, orders: orders),
    );
  }

  /// ✅ Sync pending orders then refresh local list
  Future<void> syncAndRefresh() async {
    final token = session.getToken();

    // ✅ FIX: correct empty check
    if (token == null || token.trim().isEmpty) {
      await loadOrders();
      return;
    }

    // ✅ Try sync (even if it fails, we still show local orders)
    await syncOrdersUsecase.call(token.trim());

    // ✅ Reload local after sync
    await loadOrders();
  }

  Future<void> refresh() => syncAndRefresh();
}