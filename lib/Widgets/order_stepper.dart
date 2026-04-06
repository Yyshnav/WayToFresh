import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:waytofresh/core/app_expote.dart';

class CustomOrderStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const CustomOrderStepper({
    Key? key,
    required this.currentStep,
    this.steps = const ['Placed', 'Packed', 'On the way', 'Delivered'],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dotted Background Line
          Positioned(
            left: 30.h,
            right: 30.h,
            top: 15.h,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final boxWidth = constraints.maxWidth;
                const dashWidth = 4.0;
                const dashHeight = 1.5;
                final dashCount = (boxWidth / (2 * dashWidth)).floor();
                return Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  children: List.generate(dashCount, (_) {
                    return SizedBox(
                      width: dashWidth,
                      height: dashHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.grey.shade400),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
          // Active Line (Solid or Dashed - keeping solid for clarity of progress unless asked)
          Positioned(
            left: 30.h,
            top: 15.h,
            child: Container(
              width: (MediaQuery.of(context).size.width - 80.h) *
                  (currentStep / (steps.length - 1)),
              height: 2.h,
              decoration: BoxDecoration(
                color: appTheme.amber_A200,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          // Steps
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length, (index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStepIcon(index),
                  SizedBox(height: 8.h),
                  Text(
                    steps[index],
                    style: TextStyle(
                      fontSize: 10.fSize,
                      color: index <= currentStep
                          ? Colors.black87
                          : Colors.grey.shade500,
                      fontWeight: index <= currentStep
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIcon(int index) {
    IconData icon;
    switch (index) {
      case 0:
        icon = CupertinoIcons.bag;
        break;
      case 1:
        icon = CupertinoIcons.archivebox;
        break;
      case 2:
        icon = CupertinoIcons.bus;
        break;
      case 3:
        icon = CupertinoIcons.person;
        break;
      default:
        icon = CupertinoIcons.circle_fill;
    }

    bool isActive = index <= currentStep;
    bool isCurrent = index == currentStep;

    return Container(
      width: 30.h,
      height: 30.h,
      decoration: BoxDecoration(
        color: isActive ? appTheme.amber_A200 : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? appTheme.amber_A200 : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: appTheme.amber_A200.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
      child: Icon(
        icon,
        size: 16.h,
        color: isActive ? Colors.white : Colors.grey.shade400,
      ),
    );
  }
}
