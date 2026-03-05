import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/features/home/domain/entities/pizza_entity.dart';
import 'package:slice_of_heaven/features/home/domain/usecases/get_all_pizzas_usecase.dart';
import 'package:slice_of_heaven/features/home/presentation/state/home_state.dart';

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(
  HomeViewModel.new,
);

class HomeViewModel extends Notifier<HomeState> {
  late final GetAllPizzasUsecase _getAllPizzasUsecase;

  // UI filters (kept here, not in state)
  String _selectedCategory = 'All'; // All | Veg | Non-Veg
  String _searchQuery = '';

  @override
  HomeState build() {
    _getAllPizzasUsecase = ref.read(getAllPizzasUsecaseProvider);
    return const HomeState();
  }

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  // filtered list for UI
  List<PizzaEntity> get filteredPizzas {
    final q = _searchQuery.trim().toLowerCase();

    return state.pizzas.where((p) {
      final matchesCategory =
          (_selectedCategory == 'All') ? true : p.category == _selectedCategory;

      final matchesSearch = q.isEmpty
          ? true
          : (p.name.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q));

      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> loadPizzas() async {
    state = state.copyWith(status: HomeStatus.loading);

    final result = await _getAllPizzasUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: HomeStatus.error,
        errorMessage: failure.message,
      ),
      (pizzas) => state = state.copyWith(
        status: HomeStatus.loaded,
        pizzas: pizzas,
        errorMessage: null,
      ),
    );
  }

  void setCategory(String category) {
    _selectedCategory = category;
    // no state change needed; UI will rebuild if it watches notifier
    state = state.copyWith(); // triggers rebuild safely
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    state = state.copyWith(); // triggers rebuild safely
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}