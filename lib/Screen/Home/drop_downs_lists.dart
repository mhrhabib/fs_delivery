import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets/constant.dart';

List<DropdownMenuItem<String>> get pickupDropdownItems {
  List<DropdownMenuItem<String>> pickupMenuItems = [
    DropdownMenuItem(
        child: Text(
          "collect pick up".tr,
          style: TextStyle(
            color: kTitleColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: '34'),
    DropdownMenuItem(
        child: Text(
          "Awaiting Pickup".tr,
          style: TextStyle(
            color: kTitleColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: '36'),
    DropdownMenuItem(
        child: Text(
          "Pickup Delayed".tr,
          style: TextStyle(
            color: kTitleColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: '37'),
  ];
  return pickupMenuItems;
}

List<DropdownMenuItem<String>> get pickupDropdownItemsCollectBydriver {
  List<DropdownMenuItem<String>> pickupMenuItems = [
    DropdownMenuItem(
        child: Text(
          "Collect by driver".tr,
          style: TextStyle(
            color: kTitleColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: '35'),
  ];
  return pickupMenuItems;
}

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(
        child: Text(
          "delivered".tr,
          style: TextStyle(
            color: kTitleColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: '9'),
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
        child: Text(
          "return_to_courier".tr,
          style: TextStyle(
            color: kTitleColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: "24"),
  ];
  return menuItems;
}
