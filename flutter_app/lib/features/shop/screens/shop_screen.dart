import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/models/product.dart';
import '../../../shared/widgets/loading_overlay.dart';

final _productsProvider = FutureProvider<List<Product>>((ref) async {
  final api = ref.read(apiClientProvider);
  final res = await api.get<List<dynamic>>('/api/products');
  return (res.data as List)
      .map((j) => Product.fromJson(j as Map<String, dynamic>))
      .toList();
});

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(_productsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Shop')),
      body: asyncProducts.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (products) {
          if (products.isEmpty) {
            return const Center(
              child: Text('No products available yet.',
                  style: TextStyle(color: Colors.grey)),
            );
          }

          final categories =
              products.map((p) => p.category).toSet().toList()..sort();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, ci) {
              final cat = categories[ci];
              final catProducts =
                  products.where((p) => p.category == cat).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 12),
                    child: Text(
                      cat,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: catProducts.length,
                    itemBuilder: (_, i) =>
                        _ProductCard(product: catProducts[i]),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final p = product;
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Expanded(
            child: Container(
              color: const Color(0xFFF3F4F6),
              width: double.infinity,
              child: p.imageUrl != null
                  ? Image.network(p.imageUrl!, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.sports, size: 48, color: Colors.grey))
                  : const Icon(Icons.sports, size: 48, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${p.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Color(0xFF4F46E5),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      p.inStock ? '${p.stock} left' : 'Out of stock',
                      style: TextStyle(
                          fontSize: 11,
                          color: p.inStock
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444)),
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
