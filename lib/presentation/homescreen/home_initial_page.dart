import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'package:shimmer/shimmer.dart';
import 'package:waytofresh/Widgets/product_item_widget.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/core/utils/image_constants.dart';
import 'package:waytofresh/presentation/homescreen/homecontroller.dart';
import 'package:waytofresh/presentation/homescreen/product_item_model.dart';

import '../../widgets/custom_blinkit_app_bar.dart';
import '../../widgets/custom_image_view.dart';
import './widgets/category_item_widget.dart';
import './widgets/grocery_category_item_widget.dart';
import './widgets/home_carousel.dart';
import './widgets/home_product_list.dart';
import './widgets/promo_banner_widget.dart';
import './widgets/green_promo_banner_widget.dart';
import '../../routes/app_routes.dart';
import '../category_screen/controller/cart_controller.dart';
import '../checkout_screen/controller/address_controller.dart';
import '../checkout_screen/widgets/address_bottom_sheet.dart';
import '../profile_screen/binding/profile_binding.dart';
import '../profile_screen/profile_screen.dart';

class HomeInitialPage extends StatefulWidget {
  final ScrollController scrollController;

  const HomeInitialPage({Key? key, required this.scrollController})
    : super(key: key);

  @override
  State<HomeInitialPage> createState() => _HomeInitialPageState();
}

class _HomeInitialPageState extends State<HomeInitialPage> {
  final HomeController controller = Get.put(HomeController());
  bool isLoading = true; // ✅ Added for testing redacted
  bool isLoadingMore = false; // Pagination state
  int _paginationCount = 0; // Limit pagination to 2 loads

  @override
  void initState() {
    super.initState();
    // ✅ Simulate 2 seconds loading
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => isLoading = false);
    });

    // ✅ Auto-show Address Bottom Sheet on first visit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasShownAddressSheet) {
        controller.hasShownAddressSheet = true;
        // Delay slightly to let UI build or wait for loading if needed,
        // but typically can show immediately or after a short delay for better UX
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.bottomSheet(
            const AddressBottomSheet(),
            isScrollControlled: true,
            enableDrag:
                false, // Force selection or explicit close if desired, usually true is better UX
            isDismissible: true,
          );
        });
      }
    });

    // ✅ Add Scroll Listener for Pagination
    widget.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent - 100) {
      if (!isLoadingMore && _paginationCount < 2) {
        _loadMoreData();
      }
    }
  }

  Future<void> _loadMoreData() async {
    setState(() {
      isLoadingMore = true;
    });

    // Simulate loading delay (e.g., fetching next page)
    await Future.delayed(const Duration(seconds: 2));

    // Add mock data
    if (mounted) {
      final baseIndex = controller.moreProducts.length;
      controller.moreProducts.addAll([
        ProductItemModel(
          title: "Spicy Lays ${baseIndex + 1}",
          images: [ImageConstant.lays, ImageConstant.kurukure],
          deliveryTime: "15 MINS",
          price: 20,
        ),
        ProductItemModel(
          title: "Coca Cola ${baseIndex + 2}",
          images: [ImageConstant.coke, ImageConstant.lays],
          deliveryTime: "10 MINS",
          price: 40,
        ),
        ProductItemModel(
          title: "Dairy Milk ${baseIndex + 3}",
          images: [ImageConstant.diarymilk, ImageConstant.milkybar],
          deliveryTime: "5 MINS",
          price: 80,
        ),
        ProductItemModel(
          title: "Fresh Milk ${baseIndex + 4}",
          images: [ImageConstant.milk1, ImageConstant.milk2],
          deliveryTime: "10 MINS",
          price: 32,
        ),
      ]);

      setState(() {
        isLoadingMore = false;
        _paginationCount++;
      });
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
    });
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildShimmer(Widget child) {
    if (!isLoading) return child;
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: isLoading,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              // ✅ Animated Header (Hides on scroll)
              // ✅ Static Header
              if (isLoading) _buildShimmer(_buildHeader()) else _buildHeader(),

              // ✅ Scrollable Body with RefreshIndicator
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: const Color(0xFF07575B),
                  child: SingleChildScrollView(
                    controller: widget.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isLoading
                            ? _buildShimmer(_buildMegaSaleBanner(context))
                            : _buildMegaSaleBanner(context),
                        const SizedBox(height: 22),

                        // Best Seller (Frequently Bought) - Moved Up
                        isLoading
                            ? _buildShimmer(_buildFrequentlyBoughtSection())
                            : _buildFrequentlyBoughtSection(),
                        const SizedBox(height: 22),

                        // Daily Essentials
                        HomeProductList(
                          title: "Daily Essentials",
                          products: controller.dailyEssentials,
                        ),
                        const SizedBox(height: 22),

                        // Carousel
                        HomeCarousel(images: controller.bannerImages),
                        const SizedBox(height: 22),

                        // Promo Banner
                        const PromoBannerWidget(),
                        const SizedBox(height: 22),

                        // Trending Now
                        HomeProductList(
                          title: "Trending Now",
                          products: controller.trendingProducts,
                        ),
                        const SizedBox(height: 22),

                        // Grocery Section
                        isLoading
                            ? _buildShimmer(_buildGrocerySection())
                            : _buildGrocerySection(),
                        const SizedBox(height: 22),

                        // Green Promo Banner
                        const GreenPromoBannerWidget(),

                        // Paginated Items Grid
                        Obx(
                          () => controller.moreProducts.isEmpty
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "More For You",
                                        style: TextStyleHelper
                                            .instance
                                            .body14BoldPoppins,
                                      ),
                                      const SizedBox(height: 10),
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            controller.moreProducts.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                              childAspectRatio: 0.83,
                                            ),
                                        itemBuilder: (context, index) {
                                          return ProductItemWidget(
                                            product:
                                                controller.moreProducts[index],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                        ),

                        if (isLoadingMore)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF07575B),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 100,
                        ), // Extra space for floating button
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Floating Cart Button
          _buildFloatingCartButton(),
        ],
      ),
    );
  }

  Widget _buildFloatingCartButton() {
    final CartController cartController = Get.find<CartController>();
    return Positioned(
      bottom: 90,
      left: 70, // Increased margin for smaller width
      right: 70,
      child: Obx(() {
        if (cartController.totalCartItems == 0) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.checkoutScreen);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32), // Green
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Item Icon Circle
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    // Using a generic icon or could use the first item's image if available
                    Icons.shopping_cart,
                    size: 18,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(width: 12),

                // Text Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "View cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "${cartController.totalCartItems} ITEM",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 14,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.only(left: 14.h, right: 14.h, bottom: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 26.h, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10.h),
        border: Border.all(color: appTheme.gray_400, width: 1.h),
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgSearchinterfacesymbol1,
            height: 14.h,
            width: 14.h,
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: TextFormField(
              controller: controller.searchController,
              style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              decoration: InputDecoration(
                hintText: "Search \"ice-cream\"",
                hintStyle: TextStyleHelper.instance.body12RegularPoppins,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => controller.onSearchChanged(value),
            ),
          ),
          SizedBox(width: 12.h),
          CustomImageView(
            imagePath: ImageConstant.imgMic1,
            height: 14.h,
            width: 14.h,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 8.h, bottom: 0.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFA1D6E0), Color(0xFF1995AD), Color(0xFF07575B)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              final addressController = Get.find<AddressController>();
              return CustomBlinkitAppBar(
                locationLabel: "Home",
                address: addressController.currentAddress.value.isNotEmpty
                    ? addressController.currentAddress.value
                    : "Select Location",
                onActionPressed: () {
                  Get.to(
                    () => const ProfileScreen(),
                    binding: ProfileBinding(),
                  );
                },
                isDarkTheme: true, // Added for visibility on gradient
                onLocationPressed: () {
                  Get.bottomSheet(
                    const AddressBottomSheet(),
                    isScrollControlled: true,
                  );
                },
              );
            }),
            SizedBox(height: 6.h),
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMegaSaleBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFA1D6E0), Color(0xFF1995AD), Color(0xFF07575B)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSideImages(context, left: true),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Buy Fresh, Eat Fresh',
                    textAlign: TextAlign.center,
                    style: TextStyleHelper.instance.title20BoldPTSerif.copyWith(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                    ),
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              _buildSideImages(context, left: false),
            ],
          ),
          SizedBox(height: 10.h),
          _buildCategoryTiles(),
        ],
      ),
    );
  }

  Widget _buildSideImages(BuildContext context, {required bool left}) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageBlockWidth = screenWidth * 0.22;
    double imageBlockHeight = screenWidth * 0.14;
    double innerImageWidth = imageBlockWidth * 0.6;
    double innerImageHeight = imageBlockHeight * 0.8;

    return SizedBox(
      width: imageBlockWidth,
      height: imageBlockHeight,
      child: Stack(
        children: [
          Positioned(
            left: left ? 0 : null,
            right: left ? null : 0,
            bottom: 0,
            child: CustomImageView(
              imagePath: ImageConstant.imgImage55,
              height: innerImageHeight,
              width: innerImageWidth,
            ),
          ),
          Positioned(
            right: left ? 0 : null,
            left: left ? null : 0,
            top: 0,
            child: CustomImageView(
              imagePath: ImageConstant.imgImage60,
              height: innerImageHeight * 1.1,
              width: innerImageWidth,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTiles() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          spacing: 8.h,
          children: controller.categoryItems.map((category) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10.h),
                splashColor: appTheme.teal_200.withOpacity(0.5),
                highlightColor: appTheme.teal_100.withOpacity(0.3),
                onTap: () {
                  // Determine index based on category title
                  int index = 0;
                  String title = category.title.value.toLowerCase();
                  if (title.contains("vegetables"))
                    index = 0;
                  else if (title.contains("chips"))
                    index = 1;
                  else if (title.contains("bakery"))
                    index = 2;
                  else if (title.contains("dairy") || title.contains("diary"))
                    index = 3;
                  else if (title.contains("drinks"))
                    index = 4;
                  else if (title.contains("sweets"))
                    index = 5;
                  else
                    index = 0; // Default

                  Get.toNamed(AppRoutes.categoryScreen, arguments: index);
                },
                child: CategoryItemWidget(category: category),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildProductsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.h),
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.productItems.map((product) {
              return Padding(
                padding: EdgeInsets.only(right: 8.h),
                child: ProductItemWidget(product: product),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFrequentlyBoughtSection() {
    final categories = [
      _CategoryItem(
        title: "Vegetables & Fruits",
        images: [
          ImageConstant.imgImage19,
          ImageConstant.imgImage18,
          ImageConstant.imgImage20,
          ImageConstant.imgImage20,
        ],
        moreCount: 19,
      ),
      _CategoryItem(
        title: "Chips & Namkeen",
        images: [
          ImageConstant.lays,
          ImageConstant.kurukure,
          ImageConstant.kurukure,
          ImageConstant.lays,
        ],
        moreCount: 44,
      ),
      _CategoryItem(
        title: "Bakery & Snacks",
        images: [
          ImageConstant.biscut1,
          ImageConstant.biscut2,
          ImageConstant.biscut3,
          ImageConstant.biscut1,
        ],
        moreCount: 19,
      ),
      _CategoryItem(
        title: "Dairy, Bread & eggs",
        images: [
          ImageConstant.milk1,
          ImageConstant.milk2,
          ImageConstant.milk3,
          ImageConstant.milk1,
        ],
        moreCount: 8,
      ),
      _CategoryItem(
        title: "Drinks & Juices",
        images: [
          ImageConstant.coke,
          ImageConstant.sevenup,
          ImageConstant.mirinda,
          ImageConstant.drink1,
        ],
        moreCount: 19,
      ),
      _CategoryItem(
        title: "Sweets and Chocolates",
        images: [
          ImageConstant.diarymilk,
          ImageConstant.milkybar,
          ImageConstant.milkybar,
          ImageConstant.diarymilk,
        ],
        moreCount: 15,
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Best Seller",
            style: TextStyleHelper.instance.body14BoldPoppins,
          ),
          SizedBox(height: 10.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.h,
              mainAxisSpacing: 10.h,
              childAspectRatio: 0.62, // Adjusted for responsiveness
            ),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return LayoutBuilder(
                builder: (context, constraints) {
                  final imageGridHeight = constraints.maxHeight * 0.55;
                  return GestureDetector(
                    onTap: () {
                      int targetIndex = 0;
                      if (cat.title.contains("Vegetables"))
                        targetIndex = 0;
                      else if (cat.title.contains("Chips"))
                        targetIndex = 1;
                      else if (cat.title.contains("Bakery"))
                        targetIndex = 2;
                      else if (cat.title.contains("Dairy"))
                        targetIndex = 3;
                      else if (cat.title.contains("Drinks"))
                        targetIndex = 4;
                      else if (cat.title.contains("Sweets"))
                        targetIndex = 5;

                      Get.toNamed(
                        AppRoutes.categoryScreen,
                        arguments: targetIndex,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16.h),
                      ),
                      padding: EdgeInsets.all(8.h),
                      child: Column(
                        children: [
                          SizedBox(
                            height: imageGridHeight,
                            width: double.infinity,
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    childAspectRatio: 1.1,
                                  ),
                              itemCount: cat.images.length,
                              itemBuilder: (context, i) => ClipRRect(
                                borderRadius: BorderRadius.circular(6.h),
                                child: CustomImageView(
                                  imagePath: cat.images[i],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "+${cat.moreCount} more",
                            style: TextStyle(
                              fontSize: 10.fSize,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            cat.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.fSize,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGrocerySection() {
    return Padding(
      padding: EdgeInsets.only(left: 14.h, bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6.h,
        children: [
          Text(
            'Grocery & Kitchen',
            style: TextStyleHelper.instance.body14BoldPoppins,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(
              () => Row(
                spacing: 10.h,
                children: controller.groceryCategories.map((category) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10.h),
                      splashColor: appTheme.teal_200.withOpacity(0.5),
                      highlightColor: appTheme.teal_100.withOpacity(0.3),
                      onTap: () {
                        int index = 0;
                        String title = category.title.toLowerCase();
                        if (title.contains("vegetables"))
                          index = 0;
                        else if (title.contains("chips"))
                          index = 1; // Assuming chips are mapped or we default
                        else if (title.contains("atta"))
                          index =
                              0; // Map Atta to vegetables or relevant category if exists, defaulting to 0 for now as requested "vegetables" opens vegetables
                        else if (title.contains("oil"))
                          index = 0;
                        else if (title.contains("dairy"))
                          index = 3;
                        else if (title.contains("biscuits"))
                          index = 2;

                        Get.toNamed(AppRoutes.categoryScreen, arguments: index);
                      },
                      child: GroceryCategoryItemWidget(category: category),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem {
  final String title;
  final List<String> images;
  final int moreCount;

  _CategoryItem({
    required this.title,
    required this.images,
    required this.moreCount,
  });
}
