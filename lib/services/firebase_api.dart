import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../Screen/Home/dashboard/dashboard_screen.dart';
import '../Screen/Widgets/constant.dart';

Future<void> handleBackgrounMessage(RemoteMessage message) async {
  print(message.notification!.title);
  Get.rawSnackbar(
    snackPosition: SnackPosition.TOP,
    title: message.notification?.title,
    message: message.notification?.body,
    backgroundColor: kMainColor.withValues(alpha: 0.9),
    margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
  );
  FirebaseApi().showFlutterNotification(
    title: message.notification!.title!,
    body: message.notification!.body!,
  );
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    await storage.setString('deviceToken', fCMToken!);
    //print(">>>>>>fcm token >>>>>>>${storage.read('deviceToken')}");

    FirebaseMessaging.onBackgroundMessage(handleBackgrounMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data.isNotEmpty) {
      Get.to(() => DashboardScreen(), arguments: message.data);
    }
  }

  late AndroidNotificationChannel channel;

  bool isFlutterLocalNotificationsInitialized = false;

  Future<void> setupFlutterLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await FlutterLocalNotificationsPlugin().initialize(
      initializationSettings,
    );
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'truckvala channel 1', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  showFlutterNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails("my channel", 'truckval', channelDescription: 'Channel description', importance: Importance.max, priority: Priority.high, ticker: 'ticker');

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }
}
