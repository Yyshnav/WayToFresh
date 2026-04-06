import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/utils/size_utils.dart';
import 'package:waytofresh/core/controllers/notification_controller.dart';

class ViewBillScreen extends StatelessWidget {
  const ViewBillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderHeader(),
              SizedBox(height: 16.h),
              _buildItemsCard(),
              SizedBox(height: 16.h),
              _buildBillDetailsCard(),
              SizedBox(height: 16.h),
              _buildPaymentInfoCard(),
              SizedBox(height: 30.h),
              _buildDownloadInvoiceButton(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(CupertinoIcons.back, color: Colors.black87, size: 20),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Bill Details',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16.fSize,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.h),
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(CupertinoIcons.checkmark_circle_fill, color: Colors.green.shade600, size: 24.h),
          ),
          SizedBox(width: 16.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Delivered',
                  style: TextStyle(
                    fontSize: 15.fSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Order ID: #2020039650',
                  style: TextStyle(
                    fontSize: 12.fSize,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsCard() {
    return _buildSectionCard(
      title: 'Items Ordered',
      icon: CupertinoIcons.bag,
      iconColor: Colors.orange.shade400,
      child: Column(
        children: [
          _buildItemRow('1 x Paneer Malai Tikka', 'Full', '₹160.00'),
        ],
      ),
    );
  }

  Widget _buildItemRow(String name, String qty, String price) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 13.fSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                qty,
                style: TextStyle(
                  fontSize: 11.fSize,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: 13.fSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetailsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.h),
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.h, 16.h, 16.h, 0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Icon(CupertinoIcons.doc_text, size: 18.h, color: Colors.blueGrey),
                ),
                SizedBox(width: 12.h),
                Text(
                  "Bill Summary",
                  style: TextStyle(
                    fontSize: 14.fSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Icon(CupertinoIcons.cloud_download, size: 20.h, color: Colors.red.shade300),
              ],
            ),
          ),
          _buildDashedDivider(verticalPadding: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              children: [
                _buildSummaryRow("Item total", "₹160.00"),
                SizedBox(height: 12.h),
                _buildSummaryRow("Grand total", "₹160.00", isBold: true),
                SizedBox(height: 12.h),
                _buildSummaryRow("Coupon applied -", "- ₹80.00", color: Colors.blue.shade700, isBold: true),
                SizedBox(height: 12.h),
                _buildSummaryRow("Paid", "₹92.00", isBold: true),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Savings Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FF), // Light blue from design
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.h),
                bottomRight: Radius.circular(20.h),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🥳', style: TextStyle(fontSize: 14.fSize)),
                SizedBox(width: 8.h),
                Text(
                  'You saved ₹80.00 on this order!',
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.fSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.fSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: color ?? Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.fSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfoCard() {
    return _buildSectionCard(
      title: 'Payment Information',
      icon: CupertinoIcons.creditcard,
      iconColor: Colors.blue.shade400,
      child: Column(
        children: [
          _buildInfoRow(CupertinoIcons.creditcard, 'Payment Method', 'Online (UPI)'),
          SizedBox(height: 12.h),
          _buildInfoRow(CupertinoIcons.calendar, 'Date', 'August 19, 2026 at 8:36 PM'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18.h, color: Colors.grey.shade400),
        SizedBox(width: 12.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11.fSize, color: Colors.grey.shade500)),
            Text(value, style: TextStyle(fontSize: 13.fSize, fontWeight: FontWeight.w600, color: Colors.black87)),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child, required IconData icon, Color? iconColor}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.h),
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.h, 16.h, 16.h, 0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Icon(icon, size: 18.h, color: iconColor ?? Colors.blueGrey),
                ),
                SizedBox(width: 12.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.fSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          _buildDashedDivider(verticalPadding: 12.h),
          Padding(
            padding: EdgeInsets.fromLTRB(16.h, 0, 16.h, 16.h),
            child: child,
          ),
        ],
      ),
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
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildDownloadInvoiceButton() {
    final notifController = Get.find<NotificationController>();

    return Obx(() {
      final isSent = notifController.isInvoiceSent.value;
      return Container(
        width: double.infinity,
        height: 54.h,
        child: ElevatedButton.icon(
          onPressed: isSent ? null : () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: isSent ? Colors.green.shade50 : Colors.white,
            foregroundColor: isSent ? Colors.green.shade700 : Colors.red.shade400,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.h),
              side: BorderSide(color: isSent ? Colors.green.shade100 : Colors.red.shade100, width: 1),
            ),
          ),
          icon: Icon(isSent ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.cloud_download),
          label: Text(
            isSent ? 'Invoice Sent to Email' : 'Download Invoice',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.fSize, letterSpacing: 0.2),
          ),
        ),
      );
    });
  }
}
