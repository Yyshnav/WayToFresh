import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final double? width;
  final double? height;

  const CustomLoadingIndicator({
    super.key,
    this.width = 100,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lodingindicator/Circular_Loading.json',
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}
