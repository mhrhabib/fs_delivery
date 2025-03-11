import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screen/Widgets/constant.dart';

Future<void> handleBackgrounMessage(RemoteMessage message) async {
  Get.rawSnackbar(
    snackPosition: SnackPosition.TOP,
    title: message.notification?.title,
    message: message.notification?.body,
    backgroundColor: kMainColor.withValues(alpha: 0.9),
    margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
  );
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    await storage.setString('deviceToken', fCMToken!);

    FirebaseMessaging.onBackgroundMessage(handleBackgrounMessage);
  }
}
