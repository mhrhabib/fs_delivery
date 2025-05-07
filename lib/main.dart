import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fs_delivery/services/firebase_api.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import '/Screen/Widgets/constant.dart';
import 'Controllers/global-controller.dart';
import 'Locale/language.dart';
import 'Screen/SplashScreen/splash_screen.dart';
import 'utils/keys.dart';
import 'firebase_options.dart';

const String appTitle = 'FS-platform';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = publishingKey;
  await Stripe.instance.applySettings();

  // ...

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission(alert: true, announcement: false, badge: true, carPlay: false, criticalAlert: false, provisional: false, sound: true);

  await FirebaseApi().initNotifications();
  await FirebaseApi().setupFlutterLocalNotifications();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    FirebaseApi().showFlutterNotification(title: message.notification!.title!, body: message.notification!.body!);
    print("hello");
  });
  final box = GetStorage();
  await requestLocationPermission();
  await GetStorage.init();
  dynamic langValue = const Locale('en', 'US');
  if (box.read('lang') != null) {
    langValue = Locale(box.read('lang'), box.read('langKey'));
  } else {
    langValue = const Locale('en', 'US');
  }
  runApp(MyApp(lang: langValue));
}

class MyApp extends StatelessWidget {
  final Locale lang;
  const MyApp({super.key, required this.lang});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: kMainColor));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    Get.put(GlobalController()).onInit();

    return ScreenUtilInit(
      designSize: Size(360, 800),
      builder:
          ((context, child) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            translations: Languages(),
            locale: lang,
            title: 'Merchant',
            theme: ThemeData(fontFamily: 'Display', appBarTheme: AppBarTheme(color: Colors.white, iconTheme: IconThemeData(color: Colors.white), titleTextStyle: TextStyle(color: Colors.white))),
            home: const SplashScreen(),
          )),
    );
  }
}

Future<void> requestLocationPermission() async {
  var status = await Permission.location.request();
  var status1 = await Permission.camera.request();

  if (status.isGranted || status1.isGranted) {
    print('Location permission granted');
  } else if (status.isDenied) {
    print('Location permission denied');

    // Request location permission again
    var secondStatus = await Permission.location.request();
    if (secondStatus.isGranted) {
      print('Location permission granted on second attempt');
    } else if (secondStatus.isPermanentlyDenied) {
      // The user has permanently denied the permission, navigate to app settings
      openAppSettings();
    }
  } else if (status.isPermanentlyDenied) {
    // The user has permanently denied the permission, navigate to app settings
    openAppSettings();
  }
}
