import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:slice_of_heaven/core/api/api_endpoints.dart';
import 'package:slice_of_heaven/features/cart/domain/entities/cart_item_entity.dart';
import 'package:slice_of_heaven/features/cart/presentation/pages/checkout_screen.dart';
import 'package:slice_of_heaven/features/cart/presentation/view_model/cart_viewmodel.dart';
import 'package:slice_of_heaven/features/home/presentation/state/home_state.dart';
import 'package:slice_of_heaven/features/home/presentation/view_model/home_viewmodel.dart';
import 'package:slice_of_heaven/features/home/presentation/widget/category_chips.dart';
import 'package:slice_of_heaven/features/home/presentation/widget/home_search_bar.dart';
import 'package:slice_of_heaven/features/home/presentation/widget/pizza_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _didPrecache = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(homeViewModelProvider.notifier).loadPizzas();
    });
  }

  /// ✅ Pre-cache all pizza images so they show offline later
  Future<void> _precachePizzaImages(List pizzas) async {
    if (_didPrecache) return;
    _didPrecache = true;

    for (final pizza in pizzas) {
      final String img = pizza.image;
      if (img.isEmpty) continue;

      final String url =
          img.startsWith('http') ? img : "${ApiEndpoints.baseUrl}$img";

      try {
        await precacheImage(CachedNetworkImageProvider(url), context);
      } catch (_) {
        // ignore
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);
    final vm = ref.watch(homeViewModelProvider.notifier);
    final pizzas = vm.filteredPizzas;

    // ✅ when pizzas are loaded, cache images
    if (state.status == HomeStatus.loaded && pizzas.isNotEmpty) {
      Future.microtask(() => _precachePizzaImages(pizzas));
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _didPrecache = false;
          await vm.loadPizzas();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            HomeSearchBar(onChanged: vm.setSearchQuery),
            const SizedBox(height: 14),

            CategoryChips(
              selected: vm.selectedCategory,
              onSelected: vm.setCategory,
            ),
            const SizedBox(height: 16),

            if (state.status == HomeStatus.loading)
              const Padding(
                padding: EdgeInsets.only(top: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.status == HomeStatus.error)
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Center(
                  child: Text(
                    state.errorMessage ?? "Something went wrong",
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (pizzas.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 60),
                child: Center(child: Text("No pizzas found")),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pizzas.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final pizza = pizzas[index];

                  return PizzaCard(
                    pizza: pizza,

                    // ✅ Add to cart (normal cart flow)
                    onAddToCart: () async {
                      await ref
                          .read(cartViewModelProvider.notifier)
                          .addPizzaToCart(pizza);

                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${pizza.name} added to cart"),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },

                    // ✅ Order = Buy Now → checkout with ONLY this pizza
                    onOrder: () {
                      final buyNowItem = CartItemEntity(
                        pizzaId: pizza.pizzaId ?? pizza.name, // better if id exists
                        name: pizza.name,
                        image: pizza.image,
                        price: pizza.price,
                        quantity: 1,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutScreen(buyNowItem: buyNowItem),
                        ),
                      );
                    },
                  );
                },
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}