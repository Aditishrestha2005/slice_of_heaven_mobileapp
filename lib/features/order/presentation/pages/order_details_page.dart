import 'package:flutter/material.dart';
import 'package:slice_of_heaven/features/order/domain/entities/order_entity.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailsPage({super.key, required this.order});

  String _two(int n) => n.toString().padLeft(2, '0');

  String _formatDate(DateTime d) {
    return "${d.year}-${_two(d.month)}-${_two(d.day)}  ${_two(d.hour)}:${_two(d.minute)}";
  }

  @override
  Widget build(BuildContext context) {
    final date = _formatDate(order.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Box(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rs ${order.totalAmount.toStringAsFixed(0)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Synced",
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Icon(
                      order.isSynced ? Icons.cloud_done : Icons.cloud_off,
                      size: 18,
                      color: order.isSynced ? Colors.green : Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _Box(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Delivery",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                _InfoRow(label: "Name", value: order.fullName),
                const SizedBox(height: 6),
                _InfoRow(label: "Phone", value: order.phone),
                const SizedBox(height: 6),
                _InfoRow(label: "Address", value: order.address),
                if (order.note != null && order.note!.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _InfoRow(label: "Note", value: order.note!),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          _Box(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Items",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                ...order.items.map((i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${i.name}  x${i.quantity}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        Text(
                          "Rs ${i.total.toStringAsFixed(0)}",
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(height: 22),
                Row(
                  children: [
                    const Text("Total", style: TextStyle(fontWeight: FontWeight.w900)),
                    const Spacer(),
                    Text(
                      "Rs ${order.totalAmount.toStringAsFixed(0)}",
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final Widget child;
  const _Box({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w700),
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 3,
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