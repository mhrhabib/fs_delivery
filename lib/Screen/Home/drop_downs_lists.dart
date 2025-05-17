import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets/constant.dart';

List<DropdownMenuItem<String>> get pickupDropdownItems {
  List<DropdownMenuItem<String>> pickupMenuItems = [
    DropdownMenuItem(value: '34', child: Text("collect pick up".tr, style: TextStyle(color: kTitleColor, fontWeight: FontWeight.w500))),
    DropdownMenuItem(value: '14', child: Text("Cancel Pickup".tr, style: TextStyle(color: kTitleColor, fontWeight: FontWeight.w500))),
    // DropdownMenuItem(
    //     value: '37',
    //     child: Text(
    //       "Pickup Delayed".tr,
    //       style: TextStyle(
    //         color: kTitleColor,
    //         fontWeight: FontWeight.w500,
    //       ),
    //     )),
  ];
  return pickupMenuItems;
}

List<DropdownMenuItem<String>> get pickupDropdownItemsCollectBydriver {
  List<DropdownMenuItem<String>> pickupMenuItems = [DropdownMenuItem(value: '35', child: Text("Collect by driver".tr, style: TextStyle(color: kTitleColor, fontWeight: FontWeight.w500)))];
  return pickupMenuItems;
}

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(value: '9', child: Text("delivered".tr, style: TextStyle(color: kTitleColor, fontWeight: FontWeight.w500))),
    // DropdownMenuItem(
    //     child: Text(
    //       "partial_delivered".tr,
    //       style: TextStyle(
    //         color: kTitleColor,
    //         fontWeight: FontWeight.w500,
    //       ),
    //     ),
    //     value: "32"),
    DropdownMenuItem(value: "44", child: Text("return_to_courier".tr, style: TextStyle(color: kTitleColor, fontWeight: FontWeight.w500))),
  ];
  return menuItems;
}
