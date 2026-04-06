import 'package:flutter/material.dart';

class GoldShineAnimation extends StatefulWidget {
  final Widget child;
  const GoldShineAnimation({Key? key, required this.child}) : super(key: key);

  @override
  State<GoldShineAnimation> createState() => _GoldShineAnimationState();
}

class _GoldShineAnimationState extends State<GoldShineAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: const Alignment(-2.0, -2.0),
              end: const Alignment(2.0, 2.0),
              stops: [
                _controller.value - 0.2,
                _controller.value,
                _controller.value + 0.2,
              ],
              colors: [
                Colors.white.withOpacity(0.0),
                const Color(0xFFFFF9E6).withOpacity(0.3), // Lighter Gold/Cream Shine
                Colors.white.withOpacity(0.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
