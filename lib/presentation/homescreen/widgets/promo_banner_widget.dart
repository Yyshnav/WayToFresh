import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PromoBannerWidget extends StatelessWidget {
  const PromoBannerWidget({super.key});

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
                    Color(0xFF500000), // Dark Red
                    Color(0xFFB71C1C), // Red
                    Color(0xFFD32F2F), // Light Red
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
                              // Gift Box Icon (Placeholder/Icon)
                              Container(
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  CupertinoIcons.gift,
                                  color: Colors.amber, // Gold color
                                  size: 40,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    "SAVE",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      height: 0.9,
                                    ),
                                  ),
                                  Text(
                                    "50%",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      height: 0.9,
                                    ),
                                  ),
                                  Text(
                                    "OFF",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      height: 0.9,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "WEBSITE.COM",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                              letterSpacing: 1,
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
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD32F2F), // MATCH RIGHT SIDE GRADIENT
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RotatedBox(
                            quarterTurns: 3,
                            child: const Text(
                              "YOUR PROMO CODE",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          RotatedBox(
                            quarterTurns: 3,
                            child: const Text(
                              "GIFTPROMO4",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
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

          // Border Outline (Optional to match image style perfectly)
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
    double validationPos = size.width * 0.65; // Position of the divider

    path.moveTo(0, cornerRadius);
    // Top Left Corner
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
    );

    // Top Edge with Punch
    path.lineTo(validationPos - punchRadius, 0);
    path.arcToPoint(
      Offset(validationPos + punchRadius, 0),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );
    path.lineTo(size.width - cornerRadius, 0);

    // Top Right Corner
    path.arcToPoint(
      Offset(size.width, cornerRadius),
      radius: Radius.circular(cornerRadius),
    );

    // Right Edge (add wavy effect if needed later, straight for now)
    path.lineTo(size.width, size.height - cornerRadius);

    // Bottom Right Corner
    path.arcToPoint(
      Offset(size.width - cornerRadius, size.height),
      radius: Radius.circular(cornerRadius),
    );

    // Bottom Edge with Punch
    path.lineTo(validationPos + punchRadius, size.height);
    path.arcToPoint(
      Offset(validationPos - punchRadius, size.height),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );
    path.lineTo(cornerRadius, size.height);

    // Bottom Left Corner
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
