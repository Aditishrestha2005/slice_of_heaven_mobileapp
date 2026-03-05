import 'package:equatable/equatable.dart';
import 'package:slice_of_heaven/features/cart/domain/entities/cart_item_entity.dart';

enum CartStatus { initial, loading, loaded, error }

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItemEntity> items;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  double get totalAmount =>
      items.fold(0, (sum, item) => sum + item.total);

  int get totalItems =>
      items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    CartStatus? status,
    List<CartItemEntity>? items,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}