import 'package:slice_of_heaven/features/order/domain/entities/order_entity.dart';

class OrderState {
  final bool isLoading;
  final List<OrderEntity> orders;
  final String? error;

  const OrderState({
    required this.isLoading,
    required this.orders,
    required this.error,
  });

  factory OrderState.initial() {
    return const OrderState(
      isLoading: false,
      orders: [],
      error: null,
    );
  }

  OrderState copyWith({
    bool? isLoading,
    List<OrderEntity>? orders,
    String? error,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      error: error,
    );
  }
}