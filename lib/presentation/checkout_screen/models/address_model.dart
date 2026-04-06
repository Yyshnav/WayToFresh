import 'package:google_maps_flutter/google_maps_flutter.dart';

enum AddressType { home, work, other }

class AddressModel {
  final String id;
  final String label;
  final String fullAddress;
  final LatLng latLng;
  final AddressType type;
  bool isDefault;

  AddressModel({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.latLng,
    required this.type,
    this.isDefault = false,
  });
}
