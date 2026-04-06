import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/app_expote.dart';

class PricelessWeekendBanner extends StatefulWidget {
  const PricelessWeekendBanner({Key? key}) : super(key: key);

  @override
  State<PricelessWeekendBanner> createState() => _PricelessWeekendBannerState();
}

class _PricelessWeekendBannerState extends State<PricelessWeekendBanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _titleSlide;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _titleSlide = Tween<double>(begin: 100, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Curves.elasticOut)),
    );

    _bounce = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.bounceOut)),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // PRICE ₹ LESS Section
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // The Colliding Text
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.translate(
                        offset: Offset(-_titleSlide.value, 0),
                        child: _buildTitleBox("PRICE", true),
                      ),
                      Transform.scale(
                        scale: _bounce.value,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.h),
                          child: Text(
                            "₹",
                            style: TextStyle(
                              fontSize: 40.fSize,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              shadows: const [Shadow(blurRadius: 10, color: Colors.black26, offset: Offset(2, 2))],
                            ),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(_titleSlide.value, 0),
                        child: _buildTitleBox("LESS", false),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          
          SizedBox(height: 8.h),
          
          // WEEKEND Text
          ScaleTransition(
            scale: _bounce,
            child: Text(
              "WEEKEND",
              style: TextStyle(
                fontSize: 24.fSize,
                fontWeight: FontWeight.w900,
                color: Colors.red[800],
                letterSpacing: 2,
              ),
            ),
          ),
          
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildTitleBox(String text, bool isLeft) {
    return Transform.rotate(
      angle: (isLeft ? -5 : 5) * pi / 180,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.red[700],
          borderRadius: BorderRadius.circular(4.h),
          boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26, offset: Offset(2, 2))],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 22.fSize,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class InvertedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 25);
    // Inverted curve (concave) at the bottom
    path.quadraticBezierTo(size.width / 2, size.height + 20, size.width, size.height - 25);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

