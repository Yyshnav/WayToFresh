import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:ui'; // Required for BackdropFilter

class BulkOrderScreen extends StatefulWidget {
  const BulkOrderScreen({Key? key}) : super(key: key);

  @override
  State<BulkOrderScreen> createState() => _BulkOrderScreenState();
}

class _BulkOrderScreenState extends State<BulkOrderScreen> {
  // --- Enhanced Professional Theme ---
  final Color kPrimaryColor = const Color(0xFF5D001E); // Deep Maroon
  final Color kAccentColor = const Color(0xFFC5A059); // Champagne Gold
  final Color kBgColor = const Color(0xFFF8F9FA);
  final Color kTextMain = const Color(0xFF1A1A1A);
  final Color kTextSecondary = const Color(0xFF757575);

  double _guestCount = 50;
  String _selectedEventType = "Wedding";
  int _selectedCategoryIndex = 0;
  final TextEditingController _dateController = TextEditingController();

  final List<String> _eventTypes = [
    "Wedding",
    "Corporate",
    "Private Party",
    "BBQ Event",
  ];
  final List<Map<String, dynamic>> _meatCategories = [
    {'name': 'Mixed Grill', 'icon': Icons.outdoor_grill_outlined},
    {'name': 'Premium Beef', 'icon': Icons.outdoor_grill_outlined},
    {'name': 'Lamb/Mutton', 'icon': Icons.outdoor_grill_outlined},
    {'name': 'Poultry', 'icon': Icons.outdoor_grill_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    double estimatedKg = _guestCount * 0.45;

    return Scaffold(
      backgroundColor: kBgColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildModernAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel("ESTIMATION CALCULATOR"),
                      const SizedBox(height: 12),
                      _buildCalculatorCard(estimatedKg),
                      const SizedBox(height: 32),

                      _buildSectionLabel("EVENT SETTINGS"),
                      const SizedBox(height: 12),
                      _buildHorizontalChips(),
                      const SizedBox(height: 32),

                      _buildSectionLabel("MEAT SELECTION"),
                      const SizedBox(height: 12),
                      _buildMeatGrid(),
                      const SizedBox(height: 32),

                      _buildSectionLabel("LOGISTICS"),
                      const SizedBox(height: 12),
                      _buildUnifiedFormCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildFloatingBottomBar(estimatedKg),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
        color: kAccentColor,
      ),
    );
  }

  Widget _buildModernAppBar() {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      elevation: 0,
      backgroundColor: kPrimaryColor,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.2),
              child: IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          "Bulk Reserve",
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.5),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              "https://images.unsplash.com/photo-1551028150-64b9f398f678?q=80&w=1000&auto=format&fit=crop",
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, kPrimaryColor.withOpacity(0.9)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorCard(double kg) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "GUESTS",
                    style: TextStyle(
                      color: kTextSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${_guestCount.toInt()}",
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Container(height: 60, width: 2, color: kBgColor),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "EST. WEIGHT",
                    style: TextStyle(
                      color: kTextSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${kg.toStringAsFixed(1)} kg",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 12,
              activeTrackColor: kPrimaryColor,
              inactiveTrackColor: kBgColor,
              thumbColor: kAccentColor,
              overlayColor: kAccentColor.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10,
                elevation: 5,
              ),
            ),
            child: Slider(
              value: _guestCount,
              min: 20,
              max: 500,
              onChanged: (v) {
                HapticFeedback.lightImpact();
                setState(() => _guestCount = v);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _eventTypes.length,
        itemBuilder: (context, i) {
          bool isSel = _selectedEventType == _eventTypes[i];
          return GestureDetector(
            onTap: () => setState(() => _selectedEventType = _eventTypes[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSel ? kPrimaryColor : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSel ? kPrimaryColor : Colors.grey.shade300,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                _eventTypes[i],
                style: TextStyle(
                  color: isSel ? Colors.white : kTextMain,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMeatGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: _meatCategories.length,
      itemBuilder: (context, i) {
        bool isSel = _selectedCategoryIndex == i;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategoryIndex = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSel ? kPrimaryColor : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isSel ? null : Border.all(color: Colors.grey.shade200),
              boxShadow: isSel
                  ? [
                      BoxShadow(
                        color: kPrimaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _meatCategories[i]['icon'],
                  color: isSel ? kAccentColor : kPrimaryColor,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  _meatCategories[i]['name'],
                  style: TextStyle(
                    color: isSel ? Colors.white : kTextMain,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUnifiedFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildFormTile(
            Icons.calendar_month_outlined,
            "Preferred Date",
            controller: _dateController,
            isLast: false,
          ),
          _buildFormTile(
            Icons.location_on_outlined,
            "Delivery Location",
            isLast: false,
          ),
          _buildFormTile(
            Icons.edit_note_outlined,
            "Special Butchery Instructions",
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFormTile(
    IconData icon,
    String hint, {
    TextEditingController? controller,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(icon, size: 20, color: kTextSecondary),
          hintText: hint,
          hintStyle: TextStyle(
            color: kTextSecondary.withOpacity(0.5),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBar(double kg) {
    return Positioned(
      bottom: 30,
      left: 20,
      right: 20,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "TOTAL ESTIMATE",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${kg.toStringAsFixed(0)} kg",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentColor,
                foregroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                elevation: 0,
              ),
              child: const Text(
                "GET QUOTE",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
