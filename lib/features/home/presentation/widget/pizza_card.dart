import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:slice_of_heaven/core/api/api_endpoints.dart';
import 'package:slice_of_heaven/features/home/domain/entities/pizza_entity.dart';

class PizzaCard extends StatelessWidget {
  final PizzaEntity pizza;
  final VoidCallback? onAddToCart;
  final VoidCallback? onOrder;

  const PizzaCard({
    super.key,
    required this.pizza,
    this.onAddToCart,
    this.onOrder,
  });

  String get imageUrl {
    if (pizza.image.startsWith('http')) return pizza.image;
    return "${ApiEndpoints.baseUrl}${pizza.image}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
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
          // IMAGE
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: AspectRatio(
                  aspectRatio: 1.35,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,

                    // ✅ IMPORTANT: if image was cached before, keep showing it
                    // even if network is off / URL refreshes
                    useOldImageOnUrlChange: true,

                    // ✅ smoother when scrolling (avoids flicker)
                    fadeInDuration: const Duration(milliseconds: 120),
                    fadeOutDuration: const Duration(milliseconds: 120),

                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade100,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),

                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
              ),

              // Cart icon
              Positioned(
                top: 10,
                right: 10,
                child: Material(
                  color: Colors.white.withOpacity(0.9),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onAddToCart,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pizza.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    pizza.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade700,
                      height: 1.25,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Text(
                        "Rs ${pizza.price.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 34,
                        child: ElevatedButton(
                          onPressed: onOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Order",
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}