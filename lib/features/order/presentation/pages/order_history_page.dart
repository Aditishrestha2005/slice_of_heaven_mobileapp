import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/features/order/presentation/view_model/order_viewmodel.dart';
import 'package:slice_of_heaven/features/order/presentation/pages/order_details_page.dart';

class OrderHistoryPage extends ConsumerStatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  ConsumerState<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends ConsumerState<OrderHistoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(orderViewModelProvider.notifier).syncAndRefresh();
    });
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  String _formatDate(DateTime d) {
    // example: 2026-03-03 06:21
    return "${d.year}-${_two(d.month)}-${_two(d.day)}  ${_two(d.hour)}:${_two(d.minute)}";
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderViewModelProvider);
    final vm = ref.read(orderViewModelProvider.notifier);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: vm.refresh,
        child: state.isLoading && state.orders.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : state.orders.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 140),
                      Icon(Icons.receipt_long, size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          "No orders yet",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: state.orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final o = state.orders[index];
                      final date = _formatDate(o.createdAt);

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderDetailsPage(order: o),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                                color: Colors.black.withOpacity(0.06),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.shopping_bag_outlined, size: 26),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Order • Rs ${o.totalAmount.toStringAsFixed(0)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      date,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "${o.items.length} item(s)",
                                      style: const TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (!o.isSynced)
                                const Icon(Icons.cloud_off, size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}