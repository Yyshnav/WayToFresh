import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomBottomBar extends StatefulWidget {
  final List<CustomBottomBarItem> bottomBarItems;
  final int selectedIndex;
  final Function(int) onItemTap;
  final Color? indicatorColor;
  final ScrollController? scrollController;

  const CustomBottomBar({
    Key? key,
    required this.bottomBarItems,
    required this.selectedIndex,
    required this.onItemTap,
    this.indicatorColor,
    this.scrollController,
  }) : super(key: key);

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (widget.scrollController == null) return;
    if (widget.scrollController!.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isVisible) setState(() => _isVisible = false);
    } else if (widget.scrollController!.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isVisible) setState(() => _isVisible = true);
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 250),
      offset: _isVisible ? Offset.zero : const Offset(0, 1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: _isVisible ? 1 : 0,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: widget.selectedIndex,
          selectedItemColor: widget.indicatorColor ?? Colors.black,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: (index) {
            widget.onItemTap(index);
            widget.scrollController?.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
          items: widget.bottomBarItems.map((item) {
            int index = widget.bottomBarItems.indexOf(item);
            bool isSelected = widget.selectedIndex == index;
            return BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔹 Added top indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 3,
                    width: isSelected ? 24 : 0,
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (widget.indicatorColor ?? Colors.black)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Image.asset(item.icon, height: 24, width: 24),
                ],
              ),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CustomBottomBarItem {
  final String icon;
  final String label;
  final String routeName;

  CustomBottomBarItem({
    required this.icon,
    required this.label,
    required this.routeName,
  });
}
