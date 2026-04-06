import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/app_expote.dart';
import '../../../../widgets/custom_image_view.dart';
import './priceless_weekend_banner.dart';

class GoldenEnvelopeBanner extends StatefulWidget {
  const GoldenEnvelopeBanner({Key? key}) : super(key: key);

  @override
  State<GoldenEnvelopeBanner> createState() => _GoldenEnvelopeBannerState();
}

class _GoldenEnvelopeBannerState extends State<GoldenEnvelopeBanner> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            final breathe = 0.05 * sin(_animController.value * 2 * pi);
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                // Background Food Items (Faded and Breathing)
                Positioned(
                  left: -10,
                  top: -10,
                  child: Transform.scale(
                    scale: 1.0 + breathe,
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation((-15 + (breathe * 20)) / 360),
                      child: ShaderMask(
                        shaderCallback: (rect) => const RadialGradient(
                          center: Alignment.center, radius: 0.45,
                          colors: [Colors.black54, Colors.transparent], stops: [0.4, 0.9],
                        ).createShader(rect),
                        blendMode: BlendMode.dstIn,
                        child: CustomImageView(imagePath: 'assets/images/priceless/burger.png', height: 85.h, width: 85.h),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  top: 20,
                  child: Transform.scale(
                    scale: 1.0 - breathe,
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation((10 + (breathe * 15)) / 360),
                      child: ShaderMask(
                        shaderCallback: (rect) => const RadialGradient(
                          center: Alignment.center, radius: 0.45,
                          colors: [Colors.black54, Colors.transparent], stops: [0.4, 0.9],
                        ).createShader(rect),
                        blendMode: BlendMode.dstIn,
                        child: CustomImageView(imagePath: 'assets/images/priceless/dumplings.png', height: 95.h, width: 95.h),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 30,
                  bottom: 30,
                  child: Transform.scale(
                    scale: 1.0 + breathe,
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation((5 - (breathe * 10)) / 360),
                      child: ShaderMask(
                        shaderCallback: (rect) => const RadialGradient(
                          center: Alignment.center, radius: 0.45,
                          colors: [Colors.black54, Colors.transparent], stops: [0.4, 0.9],
                        ).createShader(rect),
                        blendMode: BlendMode.dstIn,
                        child: CustomImageView(imagePath: 'assets/images/priceless/pizza.png', height: 105.h, width: 105.h),
                      ),
                    ),
                  ),
                ),
                
                // Background Confetti (Wilder movements)
                Positioned(
                  left: 30, top: 20,
                  child: Transform.translate(
                    offset: Offset(15 * cos(_animController.value * 2 * pi), 10 * sin(_animController.value * 2 * pi)),
                    child: Transform.rotate(
                      angle: _animController.value * 4 * pi,
                      child: Icon(Icons.star, color: Colors.amber[300], size: 24),
                    ),
                  ),
                ),
                Positioned(
                  right: 40, top: 40,
                  child: Transform.translate(
                    offset: Offset(-20 * sin(_animController.value * 2 * pi), 15 * cos(_animController.value * 2 * pi)),
                    child: Transform.rotate(
                      angle: _animController.value * 2 * pi,
                      child: Container(width: 10, height: 10, color: Colors.red[300]),
                    ),
                  ),
                ),
                Positioned(
                  left: 60, bottom: 60,
                  child: Transform.translate(
                    offset: Offset(25 * sin(_animController.value * 2 * pi), -20 * sin(_animController.value * pi)),
                    child: Transform.rotate(
                      angle: -_animController.value * 3 * pi,
                      child: Icon(Icons.change_history, color: Colors.amber[400], size: 28),
                    ),
                  ),
                ),
                Positioned(
                  right: 80, bottom: 40,
                  child: Transform.translate(
                    offset: Offset(-10 * cos(_animController.value * 2 * pi), -25 * sin(_animController.value * 2 * pi)),
                    child: Transform.scale(
                      scale: 1.0 + 0.5 * sin(_animController.value * pi),
                      child: Container(
                        width: 12, height: 12,
                        decoration: BoxDecoration(color: Colors.blue[300], shape: BoxShape.circle),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 140, top: 30,
                  child: Transform.translate(
                    offset: Offset(30 * sin(_animController.value * pi), 10 * cos(_animController.value * 2 * pi)),
                    child: Transform.scale(
                      scale: 0.8 + 0.4 * sin(_animController.value * 2 * pi),
                      child: Icon(Icons.star_border, color: Colors.amber[600], size: 20),
                    ),
                  ),
                ),
                Positioned(
                  right: 120, top: 50,
                  child: Transform.translate(
                    offset: Offset(-15 * cos(_animController.value * pi), 20 * sin(_animController.value * 2 * pi)),
                    child: Transform.rotate(
                      angle: _animController.value * pi,
                      child: Container(width: 8, height: 8, color: Colors.green[300]),
                    ),
                  ),
                ),
                // 5+ MORE CONFETTI
                Positioned(
                  left: 20, top: 140,
                  child: Transform.translate(
                    offset: Offset(20 * sin(_animController.value * 3 * pi), -15 * cos(_animController.value * pi)),
                    child: Transform.rotate(
                      angle: _animController.value * 2 * pi,
                      child: Container(width: 6, height: 12, color: Colors.purple[300]),
                    ),
                  ),
                ),
                Positioned(
                  right: 20, top: 130,
                  child: Transform.translate(
                    offset: Offset(-25 * cos(_animController.value * 2 * pi), 20 * sin(_animController.value * 2 * pi)),
                    child: Transform.scale(
                      scale: 0.8 + 0.3 * sin(_animController.value * 2 * pi),
                      child: Icon(Icons.favorite, color: Colors.pink[300], size: 14),
                    ),
                  ),
                ),
                Positioned(
                  left: 90, bottom: 20,
                  child: Transform.translate(
                    offset: Offset(15 * cos(_animController.value * 3 * pi), 25 * sin(_animController.value * pi)),
                    child: Transform.rotate(
                      angle: -_animController.value * 6 * pi,
                      child: Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.orange[400], shape: BoxShape.circle)),
                    ),
                  ),
                ),
                Positioned(
                  right: 90, top: 100,
                  child: Transform.translate(
                    offset: Offset(-20 * sin(_animController.value * 2 * pi), -20 * cos(_animController.value * 2 * pi)),
                    child: Transform.rotate(
                      angle: _animController.value * 3 * pi,
                      child: Icon(Icons.star, color: Colors.amber[200], size: 18),
                    ),
                  ),
                ),
                Positioned(
                  left: 160, bottom: 80,
                  child: Transform.translate(
                    offset: Offset(35 * cos(_animController.value * pi), 15 * sin(_animController.value * 3 * pi)),
                    child: Transform.rotate(
                      angle: _animController.value * 2 * pi,
                      child: Container(width: 8, height: 8, color: Colors.teal[300]),
                    ),
                  ),
                ),

                if (child != null) child,
              ],
            );
          },
          child: Column(
            children: [
              SizedBox(height: 30.h),
              // 1. The PRICE LESS WEEKEND Animation
              const PricelessWeekendBanner(),
              // 2. Extra Text
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.h),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16.fSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown[700],
                    ),
                    children: [
                      const TextSpan(text: "and extra discounts with "),
                      TextSpan(
                        text: "GOLD",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.brown[800],
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 60.h), // Extended bottom padding
            ],
          ),
        ),
    );
  }
}
