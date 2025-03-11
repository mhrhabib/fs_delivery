import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controllers/auth-controller.dart';
import '../../Controllers/global-controller.dart';
import '../../utils/image.dart';
import '../Authentication/sign_in.dart';
import '../Widgets/constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _authController = AuthController();

  @override
  void initState() {
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
    FirebaseMessaging.instance.getToken().then((token) {
      update(token!);
    });
    Timer(
      const Duration(seconds: 2),
      () => logInCheck(),
    );
    super.initState();
  }

  update(String token) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('deviceToken', token);
    print('fcm token===========>');
    print(token);
  }

  logInCheck() async {
    if (Get.find<GlobalController>().isUser) {
      _authController.refreshToken(context);
    } else {
      Get.off(() => const SignIn());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Container(
        // height: MediaQuery.of(context).size.width * 0.3,
        // width: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Center(
          child: Image(
            height: MediaQuery.of(context).size.width * 0.3,
            image: AssetImage(Images.appLogo),
          ),
        ),
      ),
    );
  }
}
