import 'package:flutter/material.dart';

import '../../Controllers/global-controller.dart';
import '../../Controllers/parcel_payment_log_controller.dart';
import '../Widgets/constant.dart';
import 'package:get/get.dart';

import '../Widgets/shimmer/parcel_payment_log_shimmer.dart';

class PaymentParcelHistoryPage extends StatefulWidget {
  const PaymentParcelHistoryPage({super.key});

  @override
  State<PaymentParcelHistoryPage> createState() => _PaymentParcelHistoryState();
}

class _PaymentParcelHistoryState extends State<PaymentParcelHistoryPage> {
  final ParcelPaymentLogController parcelPaymentLogController = ParcelPaymentLogController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'parcel_payment_history'.tr,
          style: kTextStyle.copyWith(color: kBgColor, fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        backgroundColor: kMainColor.withValues(alpha: 0.8),
        elevation: 0.0,
        iconTheme: const IconThemeData(color: kBgColor),
      ),
      body: GetBuilder<ParcelPaymentLogController>(
          init: ParcelPaymentLogController(),
          builder: (controller) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: Column(
                  children: [
                    /// headline section
                    SizedBox(
                      height: 10,
                    ),
                    headline(),
                    const Divider(height: 1, color: Colors.grey),

                    /// data section
                    controller.loader ? ParcelPaymentLogShimmer() : data(controller),
                  ],
                ),
              )),
    );
  }

  /// headline section
  Widget headline() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "date".tr,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            "note".tr,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            "amount".tr,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  /// data Section
  Widget data(ParcelPaymentLogController controller) {
    return Expanded(
      child: ListView.separated(
        itemCount: controller.parcelPaymentLogList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.10,
                  child: Text(
                    controller.parcelPaymentLogList[index].date.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.23,
                  child: Text(controller.parcelPaymentLogList[index].note.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                      )),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.16,
                  child: Text(
                    '${Get.find<GlobalController>().currency!}${controller.parcelPaymentLogList[index].amount.toString()}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height: 1, color: Colors.grey.withOpacity(.5));
        },
      ),
    );
  }
}
