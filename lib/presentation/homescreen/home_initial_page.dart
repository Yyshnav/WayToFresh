import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:waytofresh/Widgets/product_item_widget.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/core/utils/image_constants.dart';
import 'package:waytofresh/presentation/homescreen/homecontroller.dart';
import 'package:waytofresh/presentation/homescreen/widgets/active_order_banner.dart';
import 'package:waytofresh/presentation/checkout_screen/controller/order_controller.dart';
import 'package:waytofresh/presentation/homescreen/product_item_model.dart';
import '../../widgets/custom_blinkit_app_bar.dart';
import '../../widgets/custom_image_view.dart';
import './widgets/category_item_widget.dart';
import './widgets/grocery_category_item_widget.dart';
import './widgets/voice_search_bottom_sheet.dart';
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
import '../../Widgets/animate_fade_slide.dart';
import '../../Widgets/custom_loading_indicator.dart';
import '../search_screen/search_screen.dart';
import '../search_screen/binding/search_binding.dart';
import '../order_tracking_screen/controller/order_tracking_controller.dart';

class HomeInitialPage extends StatefulWidget {
  final ScrollController scrollController;

  const HomeInitialPage({Key? key, required this.scrollController})
    : super(key: key);

  @override
  State<HomeInitialPage> createState() => _HomeInitialPageState();
}

class _HomeInitialPageState extends State<HomeInitialPage> {
  final HomeController controller = Get.put(HomeController());
  final OrderTrackingController trackingController = Get.isRegistered<OrderTrackingController>() 
      ? Get.find<OrderTrackingController>() 
      : Get.put(OrderTrackingController(), permanent: true);
      
  bool isLoading = true; // ✅ State held in State class for simple UI toggles here
  bool isLoadingMore = false; // Pagination state
  int _paginationCount = 0; // Limit pagination to 2 loads

  // ✅ Banner Carousel State
  final PageController _bannerPageController = PageController();
  final RxInt _currentBannerIndex = 0.obs;
  Timer? _bannerAutoScrollTimer;
  int _lastBannerCount = 0;

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
    _bannerAutoScrollTimer?.cancel();
    _bannerPageController.dispose();
    super.dispose();
  }

  void _manageBannerAutoScroll(int count) {
    if (count == _lastBannerCount) return;
    _lastBannerCount = count;
    
    _bannerAutoScrollTimer?.cancel();
    if (count > 1) {
      _bannerAutoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (_bannerPageController.hasClients) {
          int nextRow = (_currentBannerIndex.value + 1) % count;
          _bannerPageController.animateToPage(
            nextRow,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
    });
    // Trigger actual data fetch instead of mocking
    try {
      await controller.initializeData();
    } catch (_) {}
    
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
                        // Inverted Container effectively overlapping the Mega Sale Banner
                        Transform.translate(
                          offset: const Offset(0, -20),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),

                                // 🥩 Meat Mode Banner — shown prominently here
                                // _buildMeatModeBanner(context),
                                const SizedBox(height: 20),

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
                        AnimateFadeSlide(
                          delay: const Duration(milliseconds: 400),
                          child: HomeCarousel(images: controller.bannerImages),
                        ),

                        // Promo Banner
                        AnimateFadeSlide(
                          delay: const Duration(milliseconds: 500),
                          child: const PromoBannerWidget(),
                        ),
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
                                              childAspectRatio: 0.98,
                                            ),
                                        itemBuilder: (context, index) {
                                          return ProductItemWidget(
                                            product:
                                                controller.moreProducts[index],
                                            delay: Duration(
                                              milliseconds: (index % 6) * 100,
                                            ),
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
                              child: CustomLoadingIndicator(width: 40, height: 40),
                            ),
                          ),
                        // Footer
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/logoway.png',
                                height: 48,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Proudly Made in India",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100), // Extra space for floating button

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Bottom Banner Area (Cart & Ongoing Orders)
          _buildBottomBannerArea(),
        ],
      ),
    );
  }




  Widget _buildBottomBannerArea() {
    final CartController cartController = Get.find<CartController>();
    final OrderController orderController = Get.find<OrderController>();

    return Positioned(
      bottom: 90,
      left: 0,
      right: 0,
      child: Obx(() {
        final List<Widget> banners = [];

        // 1. View Cart Banner
        if (cartController.totalCartItems > 0) {
          banners.add(_buildCartBanner(cartController));
        }

        // 2. Active Order Banner
        if (orderController.activeOrder.value != null) {
          banners.add(ActiveOrderBanner(order: orderController.activeOrder.value!));
        }

        if (banners.isEmpty) {
          _manageBannerAutoScroll(0);
          return const SizedBox.shrink();
        }

        if (banners.length == 1) {
          _manageBannerAutoScroll(1);
          return banners[0];
        }

        // Manage auto-scroll for multiple banners
        _manageBannerAutoScroll(banners.length);

        // 3. Carousel View (PageView)
        return SizedBox(
          height: 80.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: PageView(
                  controller: _bannerPageController,
                  onPageChanged: (index) => _currentBannerIndex.value = index,
                  children: banners,
                ),
              ),
              SizedBox(height: 6.h),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(banners.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 3.h),
                    width: _currentBannerIndex.value == index ? 10.h : 5.h,
                    height: 2.5.h,
                    decoration: BoxDecoration(
                      color: _currentBannerIndex.value == index ? const Color(0xFF2E7D32) : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(1.25.h),
                    ),
                  );
                }),
              )),
            ],
          ),
        );
      }),
    );
  }

    Widget _buildCartBanner(CartController cartController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 60.h), // Restored to 60.h for compact look
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.checkoutScreen);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Reduced from 16 to match active order banner
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32), // Green
            borderRadius: BorderRadius.circular(25),
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
              Obx(() {
                final items = cartController.cartItems.keys.toList();
                final displayItems = items.take(3).toList();
                
                return SizedBox(
                  width: 32 + (displayItems.length > 1 ? (displayItems.length - 1) * 12.0 : 0),
                  height: 32,
                  child: Stack(
                    children: List.generate(displayItems.length, (index) {
                      int productId = displayItems[index];
                      String imagePath = "";
                      var prod = cartController.allProducts.firstWhereOrNull((p) => p["id"] == productId) ?? 
                                 cartController.cachedProducts[productId];
                      if (prod != null) imagePath = prod['image'] ?? "";

                      return Positioned(
                        left: index * 12.0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: CustomImageView(
                              imagePath: imagePath.isNotEmpty ? imagePath : ImageConstant.imgSearchinterfacesymbol1,
                              height: 26,
                              width: 26,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
              const SizedBox(width: 8),

              // Text Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                CupertinoIcons.chevron_right,
                color: Colors.white,
                size: 14,
              ),
            ],
          ),
        ),
      ),
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
              readOnly: true, // Navigate to full search screen on tap
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
              onTap: () => Get.to(
                () => const SearchScreen(),
                binding: SearchBinding(),
                transition: Transition.fadeIn,
              ),
            ),
          ),
          SizedBox(width: 12.h),
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                const VoiceSearchBottomSheet(),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
            child: CustomImageView(
              imagePath: ImageConstant.imgMic1,
              height: 14.h,
              width: 14.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 8.h, bottom: 0.h),
      decoration: BoxDecoration(
        gradient: appTheme.primaryGradient,
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
      decoration: BoxDecoration(
        gradient: appTheme.primaryGradient,
      ),
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 30),
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
      child: Obx(() {
        var children = <Widget>[];
        for (int i = 0; i < controller.categoryItems.length; i++) {
          var category = controller.categoryItems[i];
          children.add(
            AnimateFadeSlide(
              direction: Direction.horizontal,
              delay: Duration(milliseconds: i * 100),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.h),
                  splashColor: appTheme.teal_200.withOpacity(0.5),
                  highlightColor: appTheme.teal_100.withOpacity(0.3),
                  onTap: () {
                    final cartController = Get.find<CartController>();
                    
                    // ✅ Dynamic Lookup: Find the index in CartController that matches this title
                    int targetIndex = cartController.categories.indexWhere(
                      (name) => name.toLowerCase().contains(category.title.value.split('&')[0].trim().toLowerCase()) || 
                                category.title.value.toLowerCase().contains(name.toLowerCase())
                    );

                    // Fallback to if not found (likely because it's after All Products etc)
                    if (targetIndex == -1) targetIndex = 1; // Default to first actual category

                    Get.toNamed(
                      AppRoutes.categoryScreen,
                      arguments: targetIndex,
                    );
                  },
                  child: CategoryItemWidget(category: category),
                ),
              ),
            ),
          );

          // Add spacing between items
          if (i < controller.categoryItems.length - 1) {
            children.add(SizedBox(width: 14.h));
          }
        }
        return Row(children: children);
      }),
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
              return AnimateFadeSlide(
                delay: Duration(milliseconds: index * 100),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final imageGridHeight = constraints.maxHeight * 0.55;
                    return GestureDetector(
                      onTap: () {
                        final cartController = Get.find<CartController>();
                        
                        // ✅ Dynamic Lookup: Find the index in CartController that matches this title
                        int targetIndex = cartController.categories.indexWhere(
                          (name) => name.toLowerCase().contains(cat.title.split('&')[0].trim().toLowerCase()) || 
                                    cat.title.toLowerCase().contains(name.toLowerCase())
                        );

                        // Fallback to 0 if not found
                        if (targetIndex == -1) targetIndex = 0;

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
                ),
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
            child: Obx(() {
              var items = controller.groceryCategories;
              return Row(
                spacing: 10.h,
                children: List.generate(items.length, (index) {
                  var category = items[index];
                  return AnimateFadeSlide(
                    direction: Direction.horizontal,
                    delay: Duration(milliseconds: index * 100),
                    child: Material(
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
                            index = 1;
                          else if (title.contains("atta"))
                            index = 0;
                          else if (title.contains("oil"))
                            index = 0;
                          else if (title.contains("dairy"))
                            index = 3;
                          else if (title.contains("biscuits"))
                            index = 2;

                          Get.toNamed(
                            AppRoutes.categoryScreen,
                            arguments: index,
                          );
                        },
                        child: GroceryCategoryItemWidget(category: category),
                      ),
                    ),
                  );
                }),
              );
            }),
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
