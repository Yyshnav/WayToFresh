import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../Widgets/custom_loading_indicator.dart';
import '../models/address_model.dart';
import '../controller/address_controller.dart';

class AddressBottomSheet extends GetView<AddressController> {
  const AddressBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Select delivery location",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 20),

                        // Search Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: "Search for area, street name...",
                              border: InputBorder.none,
                              prefixIcon: Icon(CupertinoIcons.search, color: Color(0xFF07575B), size: 20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Use Current Location Button
                        InkWell(
                          onTap: () => controller.getCurrentLocation(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: const Color(0xFF07575B).withOpacity(0.1), shape: BoxShape.circle),
                                  child: const Icon(CupertinoIcons.location_fill, color: Color(0xFF07575B), size: 20),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Use current location",
                                      style: TextStyle(color: Color(0xFF07575B), fontWeight: FontWeight.w800, fontSize: 16),
                                    ),
                                    Text(
                                      "Using GPS for precise delivery",
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Obx(() => controller.isLocationLoading.value
                                    ? const CustomLoadingIndicator(width: 20, height: 20)
                                    : const Icon(CupertinoIcons.chevron_right, color: Colors.grey, size: 16)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(thickness: 0.5),
                        const SizedBox(height: 16),

                        const Text(
                          "SAVED ADDRESSES",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                  // Saved Addresses List
                  Obx(() => ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.savedAddresses.length,
                        separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
                        itemBuilder: (context, index) {
                          final address = controller.savedAddresses[index];
                          return InkWell(
                            onTap: () {
                              controller.selectAddress(address);
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildAddressIcon(address.type),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              address.label,
                                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: -0.3),
                                            ),
                                            if (address.isDefault) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                                                child: Text("DEFAULT", style: TextStyle(color: Colors.green.shade700, fontSize: 9, fontWeight: FontWeight.bold)),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          address.fullAddress,
                                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.3),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(CupertinoIcons.ellipsis_vertical, color: Colors.grey, size: 16),
                                ],
                              ),
                            ),
                          );
                        },
                      )),

                  const SizedBox(height: 100), // Spacing for confirming map
                ],
              ),
            ),
          ),

          // Map Preview & Confirm Button (Shared logic)
          Obx(() {
            if (controller.currentLatLng.value != null) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(target: controller.currentLatLng.value!, zoom: 15),
                            markers: {Marker(markerId: const MarkerId('current'), position: controller.currentLatLng.value!)},
                            liteModeEnabled: true,
                            zoomControlsEnabled: false,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF07575B),
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: const Text("Confirm Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Widget _buildAddressIcon(AddressType type) {
    IconData icon;
    Color color;
    switch (type) {
      case AddressType.home:
        icon = CupertinoIcons.house_fill;
        color = const Color(0xFF07575B);
        break;
      case AddressType.work:
        icon = CupertinoIcons.briefcase_fill;
        color = Colors.orange;
        break;
      case AddressType.other:
        icon = CupertinoIcons.location_fill;
        color = Colors.blue;
        break;
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
