import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'promotion_carousel_card.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/utils/image_constants.dart';

class HomeCarousel extends StatefulWidget {
  final List<String> images;
  const HomeCarousel({Key? key, required this.images}) : super(key: key);

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> promoData = [
    {
      "title": "70% OFF",
      "subtitle": "with free delivery",
      "footer": "no COOKing! July",
      "color": const Color(0xFFF8BBD0), // Soft Pink
      "image": ImageConstant.imgCarouselPromotion,
    },
    {
      "title": "50% OFF",
      "subtitle": "on fresh vegetables",
      "footer": "Eat Healthy! July",
      "color": const Color(0xFFC8E6C9), // Soft Green
      "image": ImageConstant.imgImage20,
    },
    {
      "title": "FREE DELIVERY",
      "subtitle": "on your first order",
      "footer": "ORDER NOW! July",
      "color": const Color(0xFFBBDEFB), // Soft Blue
      "image": ImageConstant.imgImage55,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.95);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < promoData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: promoData.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              final data = promoData[index];
              return PromotionCarouselCard(
                backgroundColor: data["color"],
                title: data["title"],
                subtitle: data["subtitle"],
                footerText: data["footer"],
                imagePath: data["image"],
                onTap: () {
                  Get.toNamed(AppRoutes.goldPromotionScreen);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: promoData.asMap().entries.map((entry) {
            return Container(
              width: _currentPage == entry.key ? 20.0 : 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentPage == entry.key
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.withOpacity(0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
