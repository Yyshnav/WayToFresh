import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waytofresh/core/utils/size_utils.dart';
import '../../core/controllers/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationController controller = Get.find<NotificationController>();

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: _buildAppBar(context),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return _buildNotificationCard(notification);
          },
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(CupertinoIcons.back, color: Colors.black87, size: 22.h),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Notifications',
        style: TextStyle(color: Colors.black87, fontSize: 18.fSize, fontWeight: FontWeight.bold, letterSpacing: -0.5),
      ),
      actions: [
        TextButton(
          onPressed: () => controller.clearAll(),
          child: Text('Clear All', style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold, fontSize: 13.fSize)),
        ),
      ],
      centerTitle: true,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(30.h),
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(CupertinoIcons.bell_slash, size: 60.h, color: Colors.grey.shade300),
          ),
          SizedBox(height: 20.h),
          Text('No notifications yet', style: TextStyle(fontSize: 16.fSize, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
          SizedBox(height: 8.h),
          Text('You will receive updates about your order here.', style: TextStyle(fontSize: 12.fSize, color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.h),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
              color: const Color(0xFF07575B).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(CupertinoIcons.bell_fill, size: 20.h, color: const Color(0xFF07575B)),
          ),
          SizedBox(width: 16.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(fontSize: 14.fSize, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    Text(
                      DateFormat('hh:mm a').format(notification.timestamp),
                      style: TextStyle(fontSize: 10.fSize, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  notification.message,
                  style: TextStyle(fontSize: 12.fSize, color: Colors.grey.shade600, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
