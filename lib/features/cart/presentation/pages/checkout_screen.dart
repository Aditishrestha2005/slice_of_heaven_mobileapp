import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/services/storage/user_session_service.dart';
import 'package:slice_of_heaven/features/cart/domain/entities/cart_item_entity.dart';
import 'package:slice_of_heaven/features/cart/presentation/view_model/cart_viewmodel.dart';
import 'package:slice_of_heaven/features/order/domain/usecases/place_order_usecase.dart';
import 'package:slice_of_heaven/features/order/presentation/view_model/order_viewmodel.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  /// ✅ If not null => Buy Now mode (only this item)
  final CartItemEntity? buyNowItem;

  const CheckoutScreen({super.key, this.buyNowItem});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();

  bool _placing = false;

  @override
  void initState() {
    super.initState();

    // ✅ Only load cart if NOT buy-now
    if (widget.buyNowItem == null) {
      Future.microtask(() {
        ref.read(cartViewModelProvider.notifier).loadCart();
      });
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartViewModelProvider);
    final cartVm = ref.read(cartViewModelProvider.notifier);

    final session = ref.read(userSessionServiceProvider);

    final fullName = session.getCurrentUserFullName() ?? "Unknown";
    final phone = session.getCurrentUserPhoneNumber() ?? "Not set";
    final email = session.getCurrentUserEmail(); // optional

    final token = session.getToken(); // ✅ added earlier

    // ✅ items to checkout
    final items = widget.buyNowItem != null ? [widget.buyNowItem!] : cartState.items;
    final totalAmount = items.fold<double>(0, (sum, e) => sum + e.total);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.buyNowItem != null ? "Buy Now" : "Checkout"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CardBox(
            title: "Customer",
            child: Column(
              children: [
                _InfoRow(icon: Icons.person_outline, label: "Name", value: fullName),
                const SizedBox(height: 10),
                _InfoRow(icon: Icons.phone_outlined, label: "Phone", value: phone),
                if (email != null && email.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _InfoRow(icon: Icons.email_outlined, label: "Email", value: email),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          _CardBox(
            title: "Delivery",
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _addressController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Delivery Address",
                      hintText: "House no, street, area, landmark...",
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? "Enter delivery address" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _noteController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "Note (optional)",
                      hintText: "Extra spicy / call on arrival...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          _CardBox(
            title: "Order Summary",
            child: Column(
              children: [
                if (items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text("No items to checkout."),
                  )
                else
                  ...items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${item.name}  x${item.quantity}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Text(
                            "Rs ${item.total.toStringAsFixed(0)}",
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    );
                  }),
                const Divider(height: 22),
                Row(
                  children: [
                    const Text("Total",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Text(
                      "Rs ${totalAmount.toStringAsFixed(0)}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: (items.isEmpty || _placing)
                  ? null
                  : () async {
                      if (!_formKey.currentState!.validate()) return;

                      // ✅ Must have token to send to backend
                      // But offline still works (will save locally, sync later)
                      final safeToken = token?.trim() ?? "";

                      setState(() => _placing = true);

                      final placeOrder = ref.read(placeOrderUsecaseProvider);

                      final res = await placeOrder.call(
                        PlaceOrderParams(
                          token: safeToken,
                          fullName: fullName,
                          phone: phone,
                          address: _addressController.text.trim(),
                          note: _noteController.text.trim().isEmpty
                              ? null
                              : _noteController.text.trim(),
                          items: items,
                        ),
                      );

                      // ✅ if cart checkout => clear cart
                      if (widget.buyNowItem == null) {
                        await cartVm.clear();
                      }

                      // ✅ refresh orders list immediately
                      await ref.read(orderViewModelProvider.notifier).syncAndRefresh();

                      if (!context.mounted) return;

                      res.fold(
                        (l) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l.message)),
                          );
                        },
                        (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Order placed ✅")),
                          );
                          Navigator.pop(context);
                        },
                      );

                      if (mounted) setState(() => _placing = false);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                _placing
                    ? "Placing..."
                    : "Place Order (Rs ${totalAmount.toStringAsFixed(0)})",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// UI helpers (same as your style)
class _CardBox extends StatelessWidget {
  final String title;
  final Widget child;

  const _CardBox({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 10),
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}