import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';

class CategoryAppBar extends StatelessWidget {
  final CartController controller;

  const CategoryAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8), // Glassmorphic
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Obx(
              () => Text(
                (controller.categories.isNotEmpty && 
                 controller.selectedIndex.value < controller.categories.length)
                  ? controller.categories[controller.selectedIndex.value]
                  : "Category",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: controller.currentTheme.primaryColor,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.search, size: 24, color: Colors.grey),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.bell,
                  size: 24,
                  color: Colors.grey,
                ),
              ),
              Obx(() {
                if (controller.totalCartItems > 0) {
                  return Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${controller.totalCartItems}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ],
      ),
    );
  }
}
