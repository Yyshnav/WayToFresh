import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';

class AnimatedBackground extends StatelessWidget {
  final CartController controller;

  const AnimatedBackground({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = controller.currentTheme;
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [theme.gradientBegin, theme.gradientEnd],
          ),
        ),
        child: Stack(children: _buildPatterns(theme)),
      );
    });
  }

  List<Widget> _buildPatterns(CategoryTheme theme) {
    List<Widget> shapes = [];
    final color = theme.primaryColor.withOpacity(0.05);

    switch (theme.pattern) {
      case BackgroundPattern.circles:
        shapes = [
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(radius: 100, backgroundColor: color),
          ),
          Positioned(
            bottom: 100,
            left: -30,
            child: CircleAvatar(radius: 80, backgroundColor: color),
          ),
          Positioned(
            top: 200,
            left: 50,
            child: CircleAvatar(radius: 40, backgroundColor: color),
          ),
        ];
        break;
      case BackgroundPattern.waves:
        // Simple circular waves simulation
        shapes = [
          Positioned(
            top: 100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 20),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 40),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ];
        break;
      case BackgroundPattern.leaves:
        // simulate leaves with rotated oval containers
        shapes = [
          Positioned(
            top: 50,
            right: 20,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 100,
                height: 200,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 150,
            left: -40,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: 150,
                height: 250,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(100),
                    bottomLeft: Radius.circular(100),
                  ),
                ),
              ),
            ),
          ),
        ];
        break;
      case BackgroundPattern.none:
      default:
        break;
    }
    return shapes;
  }
}
