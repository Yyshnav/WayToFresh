import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/address_controller.dart';

class AddressBottomSheet extends GetView<AddressController> {
  const AddressBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select delivery location",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search for area, street name...",
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Use Current Location Button
                InkWell(
                  onTap: () {
                    controller.getCurrentLocation();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.my_location, color: Colors.green),
                        const SizedBox(width: 12),
                        const Text(
                          "Use current location",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Obx(
                          () => controller.isLocationLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),

          // Map View (Shows when location is fetched)
          Expanded(
            child: Obx(() {
              if (controller.currentLatLng.value != null) {
                return Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: controller.currentLatLng.value!,
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('currentLocation'),
                          position: controller.currentLatLng.value!,
                        ),
                      },
                      circles: {
                        Circle(
                          circleId: const CircleId('currentCircle'),
                          center: controller.currentLatLng.value!,
                          radius: 500, // 500 meters radius
                          fillColor: Colors.green.withOpacity(0.2),
                          strokeColor: Colors.green,
                          strokeWidth: 1,
                        ),
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    ),
                    Positioned(
                      bottom: 20,
                      left: 16,
                      right: 16,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back(); // Close bottom sheet
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Confirm Location",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox(); // Empty if no location yet
            }),
          ),
        ],
      ),
    );
  }
}
