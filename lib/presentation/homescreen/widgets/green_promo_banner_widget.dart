import 'package:flutter/material.dart';

class GreenPromoBannerWidget extends StatelessWidget {
  const GreenPromoBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 160,
      child: Stack(
        children: [
          // Main Ticket Shape
          ClipPath(
            clipper: TicketClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1B5E20), // Dark Green
                    Color(0xFF388E3C), // Green
                    Color(0xFF4CAF50), // Light Green
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Left Side (Offer Details)
                  Expanded(
                    flex: 65,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Barcode Icon
                              Container(
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.qr_code,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    "PROMO",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      height: 0.9,
                                    ),
                                  ),
                                  Text(
                                    "COUPON",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      height: 1.0,
                                    ),
                                  ),
                                  Text(
                                    "50% OFF",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      height: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "For any product in grocery store",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Dashed Line Separator
                  Container(
                    width: 2,
                    height: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: CustomPaint(
                      painter: DashedLinePainter(color: Colors.white54),
                    ),
                  ),

                  // Right Side (Promo Code)
                  Expanded(
                    flex: 35,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: Color(0xFF4CAF50)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RotatedBox(
                            quarterTurns: 3,
                            child: const Text(
                              "Code No. 2193052",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 6,
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          RotatedBox(
                            quarterTurns: 3,
                            child: const Text(
                              "ALICE GROCERY",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Border Outline
          IgnorePointer(
            child: ClipPath(
              clipper: TicketClipper(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    double cornerRadius = 16.0;
    double punchRadius = 12.0;
    double validationPos = size.width * 0.65;

    path.moveTo(0, cornerRadius);
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
    );

    path.lineTo(validationPos - punchRadius, 0);
    path.arcToPoint(
      Offset(validationPos + punchRadius, 0),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );
    path.lineTo(size.width - cornerRadius, 0);

    path.arcToPoint(
      Offset(size.width, cornerRadius),
      radius: Radius.circular(cornerRadius),
    );

    path.lineTo(size.width, size.height - cornerRadius);

    path.arcToPoint(
      Offset(size.width - cornerRadius, size.height),
      radius: Radius.circular(cornerRadius),
    );

    path.lineTo(validationPos + punchRadius, size.height);
    path.arcToPoint(
      Offset(validationPos - punchRadius, size.height),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );
    path.lineTo(cornerRadius, size.height);

    path.arcToPoint(
      Offset(0, size.height - cornerRadius),
      radius: Radius.circular(cornerRadius),
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  DashedLinePainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
