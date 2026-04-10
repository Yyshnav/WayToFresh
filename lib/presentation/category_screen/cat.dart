import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  final CartController controller = Get.find<CartController>();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _sidebarScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // ✅ Fix: Force update selected category from arguments every time screen opens
    // Use post-frame callback to prevent "setState() during build" error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null && Get.arguments is int) {
        controller.setCategory(Get.arguments);
      }
    });
    
    // Auto-scroll sidebar when categories load or index changes
    ever(controller.categories, (_) => _scrollToSelectedCategory());
    ever(controller.selectedIndex, (_) => _scrollToSelectedCategory());
    
    // Initial scroll attempt after a short delay to allow list to render
    Future.delayed(const Duration(milliseconds: 600), _scrollToSelectedCategory);
    
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _sidebarScrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedCategory() {
    if (_sidebarScrollController.hasClients && controller.categories.isNotEmpty) {
      // Approximate height of CategoryItem (padding + icon + text + margin)
      const double itemHeight = 114.0; 
      double scrollPosition = controller.selectedIndex.value * itemHeight;
      
      // Center the item in the sidebar if possible
      double viewportHeight = MediaQuery.of(context).size.height * 0.8; // Approx
      scrollPosition = scrollPosition - (viewportHeight / 3);

      double maxScroll = _sidebarScrollController.position.maxScrollExtent;
      scrollPosition = scrollPosition.clamp(0.0, maxScroll);
      
      _sidebarScrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
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
                          child: Obx(() => ListView.builder(
                            controller: _sidebarScrollController,
                            itemCount: controller.categories.length,
                            itemBuilder: (context, index) {
                              return CategoryItem(
                                index: index,
                                controller: controller,
                              );
                            },
                          )),
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
              Icon(CupertinoIcons.archivebox, size: 50, color: Colors.grey),
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
