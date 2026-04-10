import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/address_model.dart';
import '../../../core/utils/toast_helper.dart';

class AddressController extends GetxController {
  var isLocationLoading = false.obs;
  var currentAddress = "802, Kundan Eternia, B T Kawade Road...".obs;
  var currentLatLng = Rxn<LatLng>();
  final selectedAddressId = Rxn<int>();

  // ✅ Saved Addresses List
  final RxList<AddressModel> savedAddresses = <AddressModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockAddresses();
  }

  void _loadMockAddresses() {
    savedAddresses.assignAll([
      AddressModel(
        id: "1",
        label: "Home",
        fullAddress: "802, Kundan Eternia, B T Kawade Road, Ghorpadi, Pune",
        latLng: const LatLng(18.5204, 73.8567),
        type: AddressType.home,
        isDefault: true,
      ),
      AddressModel(
        id: "2",
        label: "Work",
        fullAddress: "EON IT Park, Kharadi, Pune",
        latLng: const LatLng(18.551, 73.948),
        type: AddressType.work,
      ),
    ]);
    // Set initial address
    currentAddress.value = savedAddresses.first.fullAddress;
    selectedAddressId.value = int.tryParse(savedAddresses.first.id);
  }

  // ✅ Add New Address
  void addAddress(AddressModel address) {
    savedAddresses.add(address);
    selectAddress(address);
  }

  // ✅ Select Address
  void selectAddress(AddressModel address) {
    for (var addr in savedAddresses) {
      addr.isDefault = (addr.id == address.id);
    }
    currentAddress.value = address.fullAddress;
    currentLatLng.value = address.latLng;
    selectedAddressId.value = int.tryParse(address.id);
    savedAddresses.refresh();
  }

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
        ToastHelper.showWarning("Location permission is required to fetch your current address");
      }
    } catch (e) {
      ToastHelper.showError("Failed to get location: $e");
    } finally {
      isLocationLoading.value = false;
    }
  }
}
