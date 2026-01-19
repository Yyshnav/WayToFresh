import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class AddressController extends GetxController {
  var isLocationLoading = false.obs;
  var currentAddress = "802, Kundan Eternia, B T Kawade Road...".obs;
  var currentLatLng = Rxn<LatLng>();

  Future<void> getCurrentLocation() async {
    isLocationLoading.value = true;
    try {
      var status = await Permission.location.request();
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        currentLatLng.value = LatLng(position.latitude, position.longitude);
        // In a real app, you would reverse geocode here to get the address string
        currentAddress.value = "${position.latitude}, ${position.longitude}";
      } else {
        Get.snackbar("Permission Denied", "Location permission is required");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to get location: $e");
    } finally {
      isLocationLoading.value = false;
    }
  }
}
