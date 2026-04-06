import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/utils/size_utils.dart';
import 'package:waytofresh/theme/theme_helper.dart';
import 'package:waytofresh/presentation/view_bill_screen/view_bill_screen.dart';
import 'package:waytofresh/Widgets/order_stepper.dart';
import 'dart:ui';
import 'controller/order_tracking_controller.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({Key? key}) : super(key: key);

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final OrderTrackingController controller = Get.put(OrderTrackingController());
  late GoogleMapController mapController;
  BitmapDescriptor? riderIcon;

  static const LatLng _center = LatLng(-23.9618, -46.3322);

  @override
  void initState() {
    super.initState();
    _loadMarkerIcons();
  }

  void _loadMarkerIcons() async {
    riderIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(32, 32)),
      'assets/images/rider_icon.png',
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Google Map Background (Active Marker)
          _buildMap(),

          // Top Header
          _buildHeader(),

          // ✅ Distance Bubble (Dynamic)
          _buildDistanceBubble(),

          // Bottom Details Sheet
          _buildBottomDetails(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Obx(() => GoogleMap(
          onMapCreated: (c) => mapController = c,
          initialCameraPosition: const CameraPosition(target: _center, zoom: 15.0),
          markers: {
            Marker(
              markerId: const MarkerId('delivery_boy'),
              position: controller.deliveryBoyLocation.value,
              icon: riderIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
              infoWindow: const InfoWindow(title: 'Delivery Partner'),
            ),
            const Marker(
              markerId: MarkerId('destination'),
              position: _center,
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(title: 'You'),
            ),
          },
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
        ));
  }

  Widget _buildHeader() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10.h,
      left: 16.h,
      right: 16.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.h),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(30.h),
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: EdgeInsets.all(10.h),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Icon(CupertinoIcons.back, size: 16.h, color: Colors.black87),
                  ),
                ),
                SizedBox(width: 12.h),
                Text(
                  "Track Order",
                  style: TextStyle(fontSize: 16.fSize, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: -0.5),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 8.h),
                  decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(24.h)),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.question_circle, size: 14.h, color: Colors.white),
                      SizedBox(width: 6.h),
                      Text('Help', style: TextStyle(fontSize: 11.fSize, fontWeight: FontWeight.w600, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDistanceBubble() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 75.h,
      left: MediaQuery.of(context).size.width / 2 - 65.h,
      child: Obx(() => ClipRRect(
            borderRadius: BorderRadius.circular(12.h),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 8.h),
                decoration: BoxDecoration(
                  color: appTheme.amber_A200.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12.h),
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.timer, size: 14.h, color: Colors.black87),
                    SizedBox(width: 6.h),
                    Text(
                      '${controller.distanceRemaining.value} km away',
                      style: TextStyle(fontSize: 12.fSize, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildBottomDetails() {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24.h), topRight: Radius.circular(24.h)),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 14.h),
                    width: 48.h,
                    height: 5.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade400], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(2.5.h),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PREVISÃO DE ENTREGA (ATUALIZADO)',
                                style: TextStyle(fontSize: 10.fSize, color: Colors.grey.shade500, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                              ),
                              SizedBox(height: 6.h),
                              Obx(() => Text(
                                    controller.estimatedTime.value,
                                    style: TextStyle(fontSize: 22.fSize, fontWeight: FontWeight.w900, color: Colors.black87, letterSpacing: -0.5),
                                  )),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.h),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.h), border: Border.all(color: Colors.grey.shade200)),
                            child: Column(
                              children: [
                                Text('Código ID', style: TextStyle(fontSize: 8.fSize, color: Colors.grey)),
                                Text('9246', style: TextStyle(fontSize: 14.fSize, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      // ✅ Dynamic Order Stepper
                      Obx(() => CustomOrderStepper(currentStep: controller.currentStepIndex)),
                      SizedBox(height: 15.h),

                      _buildInfoCard(
                        title: 'Delivery Details & Instructions:',
                        titleColor: Colors.red.shade400,
                        children: [
                          _buildDetailRow(
                            icon: CupertinoIcons.phone,
                            title: 'Shruti Parashar, 9999999999',
                            subtitle: 'Delivery partner may call this number',
                            hasEdit: true,
                          ),
                          _buildDashedDivider(verticalPadding: 16.h),
                          _buildDetailRow(
                            icon: CupertinoIcons.location,
                            title: 'Delivery at location',
                            subtitle: 'Ludhiana Bus Stop, Vishwakarma Road,\nSant pura, Ludhiana',
                            hasEdit: true,
                          ),
                          _buildDashedDivider(verticalPadding: 16.h),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildInfoCard(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.h),
                                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200, width: 1)),
                                child: CircleAvatar(radius: 18.h, backgroundImage: const AssetImage('assets/images/meat.jpg')),
                              ),
                              SizedBox(width: 12.h),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Julie\'s', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.fSize)),
                                    Text('Model Town, Ludhiana', style: TextStyle(color: Colors.grey, fontSize: 11.fSize)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(6.h),
                                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)),
                                child: Icon(CupertinoIcons.phone_fill, color: Colors.red.shade400, size: 16.h),
                              ),
                            ],
                          ),
                          _buildDashedDivider(),
                          _buildDetailRow(icon: CupertinoIcons.doc_text, title: 'Order #5842126599', subtitle: '1 x Taco', iconColor: Colors.grey.shade400, statusWidget: Container(width: 8.h, height: 8.h, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle))),
                          _buildDashedDivider(),
                          _buildInteractiveInstructionsRow(),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildBillSummaryCard(),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDashedDivider({double? verticalPadding}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 20.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = constraints.maxWidth;
          const dashWidth = 4.0;
          const dashHeight = 1.0;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) => SizedBox(width: dashWidth, height: dashHeight, child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey.shade300)))),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({String? title, Color? titleColor, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.h), border: Border.all(color: Colors.grey.withOpacity(0.1), width: 0.5), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 8))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title, style: TextStyle(color: titleColor ?? Colors.black87, fontSize: 13.fSize, fontWeight: FontWeight.w600, letterSpacing: 0.2)),
            _buildDashedDivider(verticalPadding: 12.h),
          ],
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow({IconData? icon, Widget? iconWidget, required String title, String? subtitle, bool hasEdit = false, bool hasArrow = false, Color? iconColor, Widget? statusWidget}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        iconWidget ?? Icon(icon, color: iconColor ?? Colors.black54, size: 22.h),
        SizedBox(width: 12.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (statusWidget != null) ...[statusWidget, SizedBox(width: 8.h)],
                  Expanded(child: Text(title, style: TextStyle(fontSize: 13.fSize, fontWeight: FontWeight.w700, color: Colors.black87, letterSpacing: -0.2))),
                ],
              ),
              if (subtitle != null) ...[SizedBox(height: 4.h), Text(subtitle, style: TextStyle(fontSize: 11.fSize, color: Colors.grey.shade600, fontWeight: FontWeight.w500))],
            ],
          ),
        ),
        if (hasEdit) Icon(CupertinoIcons.play_fill, color: Colors.red.shade400, size: 10.h),
        if (hasArrow) Icon(CupertinoIcons.chevron_right, size: 14.h, color: Colors.grey.shade300),
      ],
    );
  }

  Widget _buildBillSummaryCard() {
    return GestureDetector(
      onTap: () => Get.to(() => const ViewBillScreen()),
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.h), border: Border.all(color: Colors.grey.withOpacity(0.1), width: 0.5), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 8))]),
        child: Row(
          children: [
            Icon(CupertinoIcons.doc_text, size: 18.h, color: Colors.blueGrey),
            SizedBox(width: 12.h),
            Text("Bill Summary", style: TextStyle(fontSize: 14.fSize, fontWeight: FontWeight.bold)),
            const Spacer(),
            Text("₹92", style: TextStyle(fontSize: 16.fSize, fontWeight: FontWeight.w900, color: Colors.black87)),
            Icon(CupertinoIcons.chevron_right, size: 16.h, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveInstructionsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(CupertinoIcons.info, color: Colors.grey.shade400, size: 22.h),
        SizedBox(width: 12.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery instructions',
                style: TextStyle(fontSize: 13.fSize, fontWeight: FontWeight.w700, color: Colors.black87, letterSpacing: -0.2),
              ),
              SizedBox(height: 6.h),
              TextField(
                controller: controller.instructionsController,
                maxLines: null,
                style: TextStyle(fontSize: 12.fSize, color: Colors.grey.shade700),
                decoration: InputDecoration(
                  hintText: 'e.g. Leave at the gate',
                  hintStyle: TextStyle(fontSize: 11.fSize, color: Colors.grey.shade400),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 4.h),
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
        Icon(CupertinoIcons.pencil, size: 14.h, color: Colors.red.shade400),
      ],
    );
  }
}
