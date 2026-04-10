import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/presentation/my_orders_screen/controller/my_orders_controller.dart';
import 'package:waytofresh/presentation/my_orders_screen/models/order_item_model.dart';
import 'package:intl/intl.dart';

class MyOrdersScreen extends GetView<MyOrdersController> {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshOrders,
              color: const Color(0xFF07575B),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.orders.isEmpty) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: _buildEmptyState(),
                    ),
                  );
                }

                return _buildOrdersList();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 8.h, bottom: 20.h),
      decoration: BoxDecoration(
        gradient: appTheme.primaryGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(8.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                    size: 18.h,
                  ),
                ),
              ),
              SizedBox(width: 16.h),
              Text(
                "My Orders",
                style: TextStyleHelper.instance.title20BoldPoppins.copyWith(
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.h),
      itemCount: controller.orders.length,
      itemBuilder: (context, index) {
        final order = controller.orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(OrderItemModel order) {
    Color statusColor;
    switch (order.status) {
      case OrderStatus.delivered:
        statusColor = Colors.green;
        break;
      case OrderStatus.onTheWay:
      case OrderStatus.preparing:
        statusColor = Colors.orange;
        break;
      case OrderStatus.cancelled:
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.blue;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => controller.onOrderTap(order),
        borderRadius: BorderRadius.circular(16.h),
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.id,
                    style: TextStyleHelper.instance.body14BoldPoppins,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                    child: Text(
                      order.statusText,
                      style: TextStyleHelper.instance.label10SemiBoldPoppins.copyWith(
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                DateFormat('dd MMM yyyy, hh:mm a').format(order.date),
                style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.itemNames.join(", "),
                          style: TextStyleHelper.instance.body12RegularPoppins,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Total: ₹${order.totalAmount.toStringAsFixed(2)}",
                          style: TextStyleHelper.instance.body14BoldPoppins.copyWith(
                            color: appTheme.green_600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(CupertinoIcons.chevron_right, size: 14.h, color: Colors.grey.shade400),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.bag, size: 80.h, color: Colors.grey.shade200),
          SizedBox(height: 16.h),
          Text(
            "No orders yet",
            style: TextStyleHelper.instance.body14BoldPoppins.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "When you place an order, it will appear here",
            style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
