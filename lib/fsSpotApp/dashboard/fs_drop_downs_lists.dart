import 'package:flutter/material.dart';
import 'package:fs_delivery/Screen/Widgets/constant.dart';
import 'package:get/get.dart';

List<DropdownMenuItem<String>> get fsPickupDropdownItems {
  List<DropdownMenuItem<String>> pickupMenuItems = [
    DropdownMenuItem(
        value: '38',
        child: Text(
          "Accept".tr,
          style: TextStyle(
            color: kTitleColor,
            fontWeight: FontWeight.w500,
          ),
        )),
    // DropdownMenuItem(
    //     child: Text(
    //       "Awaiting Pickup".tr,
    //       style: TextStyle(
    //         color: kTitleColor,
    //         fontWeight: FontWeight.w500,
    //       ),
    //     ),
    //     value: '36'),
    // DropdownMenuItem(
    //     child: Text(
    //       "Pickup Delayed".tr,
    //       style: TextStyle(
    //         color: kTitleColor,
    //         fontWeight: FontWeight.w500,
    //       ),
    //     ),
    //     value: '37'),
  ];
  return pickupMenuItems;
}

List<DropdownMenuItem<String>> get fsPickupDropdownItemsCollectBydriver {
  List<DropdownMenuItem<String>> pickupMenuItems = [
    DropdownMenuItem(
        value: '40',
        child: Text(
          "Release".tr,
          style: TextStyle(
            color: kTitleColor,
            fontWeight: FontWeight.w500,
          ),
        )),
  ];
  return pickupMenuItems;
}

List<DropdownMenuItem<String>> get fsDropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(
        value: '9',
        child: Text(
          "delivered".tr,
          style: TextStyle(
            color: kTitleColor,
            fontWeight: FontWeight.w500,
          ),
        )),
    // DropdownMenuItem(
    //     child: Text(
    //       "partial_delivered".tr,
    //       style: TextStyle(
    //         color: kTitleColor,
    //         fontWeight: FontWeight.w500,
    //       ),
    //     ),
    //     value: "32"),
    DropdownMenuItem(
        value: "24",
        child: Text(
          "return_to_courier".tr,
          style: TextStyle(
            color: kTitleColor,
            fontWeight: FontWeight.w500,
          ),
        )),
  ];
  return menuItems;
}
