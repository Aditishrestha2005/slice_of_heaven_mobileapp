import 'package:equatable/equatable.dart';
import 'package:slice_of_heaven/features/home/domain/entities/pizza_entity.dart';

enum HomeStatus {
  initial,
  loading,
  loaded,
  error,
}

class HomeState extends Equatable {
  final HomeStatus status;
  final List<PizzaEntity> pizzas;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.pizzas = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<PizzaEntity>? pizzas,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      pizzas: pizzas ?? this.pizzas,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, pizzas, errorMessage];
}