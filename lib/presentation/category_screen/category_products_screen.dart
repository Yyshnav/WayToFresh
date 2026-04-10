import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/network/dio_client.dart';
import 'package:waytofresh/presentation/homescreen/product_item_model.dart';
import 'package:waytofresh/Widgets/custom_image_view.dart';
import 'package:waytofresh/theme/theme_helper.dart';


class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({Key? key}) : super(key: key);

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final RxList<ProductItemModel> products = <ProductItemModel>[].obs;
  final RxBool isLoading = true.obs;
  late int categoryId;
  late String categoryName;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    categoryId = args['id'] ?? 0;
    categoryName = args['name'] ?? 'Products';
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      isLoading.value = true;
      final response = await DioClient().dio.get(
        'products/',
        queryParameters: {'category': categoryId},
      );
      if (response.statusCode == 200) {
        final data = response.data;
        final list = data['results'] as List? ?? data as List? ?? [];
        products.assignAll(list.map((p) => ProductItemModel.fromMap(p)).toList());
      }
    } catch (e) {
      // Keep empty
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: appTheme.primaryGradient),
        ),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              categoryName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Obx(() => Text(
              '${products.length} products',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            )),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: const Color(0xFF0F4485)),
          );
        }
        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 72, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No products in $categoryName yet',
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Check back soon!',
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ],
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: products.length,
          itemBuilder: (context, i) {
            final p = products[i];
            return _ProductCard(product: p);
          },
        );
      }),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductItemModel product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Obx(() => CustomImageView(
              imagePath: product.images.isNotEmpty ? product.images.first : '',
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                  product.title.value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                )),
                const SizedBox(height: 4),
                Obx(() => Text(
                  product.unit.value,
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                )),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                      '₹${product.price.value}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: const Color(0xFF0F4485),
                      ),
                    )),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F4485),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 20),
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
