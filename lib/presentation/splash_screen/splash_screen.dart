import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/splash_controller.dart';
import '../../Widgets/custom_loading_indicator.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Pattern
          Opacity(
            opacity: 0.15, // Subtle pattern
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                'assets/images/splash_bg.png',
                fit: BoxFit.cover,
                gaplessPlayback: true, // Prevents flicker if rebuilt
              ),
            ),
          ),
          // Central Logo
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "WayToFresh",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0066FF), // Bright blue
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 4),
                // Smile Curve
                CustomPaint(
                  size: const Size(120, 20),
                  painter: SmilePainter(),
                ),
                const SizedBox(height: 20),
                // Custom Lottie Loading Indicator
                const CustomLoadingIndicator(width: 120, height: 120), // Made indicator larger
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0066FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width / 2, size.height * 1.5, size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
