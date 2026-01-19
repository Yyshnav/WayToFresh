import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/cart_controller.dart';
import 'widgets/category_item.dart';
import 'widgets/product_card.dart';
import 'widgets/category_app_bar.dart';
import 'widgets/section_header.dart';
import 'widgets/cart_summary.dart';
import 'widgets/shimmer_product_card.dart';
import 'widgets/animated_background.dart';
import '../../routes/app_routes.dart';

class CatScreen extends StatefulWidget {
  const CatScreen({super.key});

  @override
  State<CatScreen> createState() => _CatScreenState();
}

class _CatScreenState extends State<CatScreen> {
  final CartController controller = Get.put(CartController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // ✅ Fix: Force update selected category from arguments every time screen opens
    if (Get.arguments != null && Get.arguments is int) {
      controller.setCategory(Get.arguments);
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!controller.isLoadingMore.value) {
        controller.loadMoreProducts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // Allow body to go behind app bar area if we move app bar
      body: Stack(
        children: [
          // 1. Dynamic Background
          AnimatedBackground(controller: controller),

          // 2. Main Content with Glassmorphism
          SafeArea(
            child: Column(
              children: [
                CategoryAppBar(controller: controller),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Side Category Bar with Glass Effect & Animation
                      TweenAnimationBuilder(
                        tween: Tween<Offset>(
                          begin: const Offset(-0.2, 0),
                          end: Offset.zero,
                        ),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, Offset offset, child) {
                          return Transform.translate(
                            offset: Offset(
                              offset.dx * MediaQuery.of(context).size.width,
                              offset.dy,
                            ),
                            child: Opacity(
                              opacity:
                                  1 -
                                  (offset.dx.abs() * 5).clamp(
                                    0.0,
                                    1.0,
                                  ), // Simple fade based on slide
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.22,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                              0.7,
                            ), // Semi-transparent
                            border: Border(
                              right: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                          child: ListView.builder(
                            itemCount: controller.categories.length,
                            itemBuilder: (context, index) {
                              return CategoryItem(
                                index: index,
                                controller: controller,
                              );
                            },
                          ),
                        ),
                      ),

                      // Products Area & Animation
                      Expanded(
                        child: TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 600),
                          builder: (context, double value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 50 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.white.withOpacity(
                              0.5,
                            ), // Semi-transparent content area
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    SectionHeader(controller: controller),
                                    Expanded(
                                      child: _buildProductGrid(controller),
                                    ),
                                  ],
                                ),
                                Obx(() {
                                  if (controller.totalCartItems > 0) {
                                    return Positioned(
                                      bottom: 16,
                                      left: 16,
                                      right: 16,
                                      child: CartSummary(
                                        controller: controller,
                                        onTap: () => Get.toNamed(
                                          AppRoutes.checkoutScreen,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(CartController controller) {
    return Obx(() {
      if (controller.isFirstLoad.value) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 0.65,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: 8,
          itemBuilder: (context, index) => const ProductCardShimmer(),
        );
      }

      final products = controller.filteredProducts;

      if (products.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined, size: 50, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                "No products available",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshProducts,
        color: controller.currentTheme.primaryColor,
        child: GridView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 0.65,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: products.length + (controller.isLoadingMore.value ? 2 : 0),
          itemBuilder: (context, index) {
            if (index >= products.length) {
              return const ProductCardShimmer();
            }
            final product = products[index];
            final productIndex = controller.allProducts.indexOf(product);
            return ProductCard(
              product: product,
              productIndex: productIndex,
              controller: controller,
            );
          },
        ),
      );
    });
  }
}
