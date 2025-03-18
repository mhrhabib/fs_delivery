import 'dart:convert';

import 'package:fs_delivery/Screen/Authentication/sign_up_verify/sign_up_verify_screen.dart';
import 'package:fs_delivery/fsSpotApp/home/fs_spot_home.dart';

import '../Screen/Widgets/constant.dart';
import '/Models/login_model.dart';
import '/Models/refresh_token_model.dart';
import '/Screen/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_list.dart';
import '/services/server.dart';
import '/services/user-service.dart';
import '/services/validators.dart';
import 'package:get/get.dart';

import 'global-controller.dart';

class AuthController extends GetxController {
  UserService userService = UserService();
  final Validators _validators = Validators();
  Server server = Server();
  TextEditingController otp1 = TextEditingController();
  TextEditingController otp2 = TextEditingController();
  TextEditingController otp3 = TextEditingController();
  TextEditingController otp4 = TextEditingController();
  TextEditingController otp5 = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();
  bool obscureText = true;
  bool loader = false;

  changeVisibility() {
    obscureText = !obscureText;
    Future.delayed(const Duration(milliseconds: 10), () {
      update();
    });
  }

  loginOnTap({BuildContext? context, String? email, String? pass}) async {
    print('email');
    loader = true;
    Future.delayed(const Duration(milliseconds: 10), () {
      update();
    });
    // var emailValidator = _validators.validateEmail(value: email);
    var passValidator = _validators.validatePassword(value: pass);
    if (passValidator == null) {
      Map body = {
        'email': email,
        'password': pass,
      };
      String jsonBody = json.encode(body);
      server.postRequest(endPoint: APIList.login, body: jsonBody).then((response) {
        print(response.statusCode);
        if (response != null && response.statusCode == 200) {
          updateFcmSubscribe(email);
          final jsonResponse = json.decode(response.body);
          print(jsonResponse);
          var loginData = LoginModel.fromJson(jsonResponse);
          var bearerToken = 'Bearer ' "${loginData.data?.token}";
          storage.write('token', loginData.data!.token);
          storage.write('userType', loginData.data!.userType!);
          userService.saveBoolean(key: 'is-user', value: true);
          userService.saveString(key: 'token', value: loginData.data?.token);
          userService.saveString(key: 'user-id', value: loginData.data!.user?.id.toString());
          userService.saveString(key: 'email', value: loginData.data!.user!.email.toString());
          userService.saveString(key: 'image', value: loginData.data!.user!.image.toString());
          userService.saveString(key: 'name', value: loginData.data!.user!.name.toString());
          userService.saveString(key: 'phone', value: loginData.data!.user!.phone.toString());

          Server.initClass(token: bearerToken);
          Get.put(GlobalController()).initController();
          emailController.clear();
          passwordController.clear();
          loader = false;
          Future.delayed(const Duration(milliseconds: 10), () {
            update();
          });
          print(storage.read('userType'));
          print('user type${loginData.data!.user!.userType!}');

          storage.read('userType') == 'deliveryman' ? Get.off(() => Home()) : Get.off(() => FsSpotHome());
          Get.rawSnackbar(message: "${loginData.message}", backgroundColor: Colors.green, snackPosition: SnackPosition.TOP);
        } else if (response.statusCode == 400) {
          storage.write('email', email);
          loader = false;
          Future.delayed(const Duration(milliseconds: 10), () {
            update();
          });
          final jsonResponse = json.decode(response.body);
          print(jsonResponse);
          if (jsonResponse['success'] == false) {
            Get.to(() => SignUpVerifyScreen());
          }
        } else if (response.statusCode == 422) {
          loader = false;
          Future.delayed(const Duration(milliseconds: 10), () {
            update();
          });
          final jsonResponse = json.decode(response.body);
          print(jsonResponse);
          Get.rawSnackbar(message: "${jsonResponse['data']['errors']['email']}", backgroundColor: Colors.red, snackPosition: SnackPosition.TOP);
        } else {
          loader = false;
          Future.delayed(const Duration(milliseconds: 10), () {
            update();
          });
          final jsonResponse = json.decode(response.body);
          print(jsonResponse);
          Get.rawSnackbar(message: "${jsonResponse['message']}", backgroundColor: Colors.red, snackPosition: SnackPosition.TOP);
        }
      });
    } else {
      loader = false;
      Future.delayed(Duration(milliseconds: 10), () {
        update();
      });
      Get.rawSnackbar(message: 'Please enter email address and password');
    }
  }

  refreshToken(context) async {
    server.getRequest(endPoint: APIList.refreshToken).then((response) {
      print(response);
      if (response != null && response.statusCode == 200) {
        try {
          final jsonResponse = json.decode(response.body);
          var refreshData = RefreshTokenModel.fromJson(jsonResponse);
          print(refreshData);
          var newToken = 'Bearer ' "${refreshData.data!.token}";
          userService.saveBoolean(key: 'is-user', value: true);
          userService.saveString(key: 'token', value: refreshData.data!.token);
          storage.write('token', refreshData.data!.token);
          Server.initClass(token: newToken);
          Get.put(GlobalController()).initController();
          storage.read('userType') == 'deliveryman' ? Get.off(() => Home()) : Get.off(() => FsSpotHome());
          return true;
        } catch (e) {
          Get.find<GlobalController>().userLogout(context: context);
        }
      } else {
        Get.find<GlobalController>().userLogout(context: context);
        return false;
      }
    });
  }

  otpVerification(mobile) async {
    loader = true;
    Future.delayed(const Duration(milliseconds: 10), () {
      update();
    });
    Map body = {'otp': otp1.text.toString() + otp2.text.toString() + otp3.text.toString() + otp4.text.toString() + otp5.text.toString(), 'mobile': mobile};
    String jsonBody = json.encode(body);
    print(jsonBody);
    server.postRequest(endPoint: APIList.verifyOtp, body: jsonBody).then((response) {
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        var loginData = LoginModel.fromJson(jsonResponse);
        var bearerToken = 'Bearer ' "${loginData.data?.token}";
        userService.saveBoolean(key: 'is-user', value: true);
        userService.saveString(key: 'token', value: loginData.data?.token);
        userService.saveString(key: 'user-id', value: loginData.data!.user?.id.toString());
        userService.saveString(key: 'email', value: loginData.data!.user!.email.toString());
        userService.saveString(key: 'image', value: loginData.data!.user!.image.toString());
        userService.saveString(key: 'name', value: loginData.data!.user!.name.toString());
        userService.saveString(key: 'phone', value: loginData.data!.user!.phone.toString());

        Server.initClass(token: bearerToken);
        Get.put(GlobalController()).initController();
        otp1.clear();
        otp2.clear();
        otp3.clear();
        otp4.clear();
        otp5.clear();
        loader = false;
        Future.delayed(const Duration(milliseconds: 10), () {
          update();
        });
        Get.off(() => const Home());
        Get.rawSnackbar(message: "${loginData.message}", backgroundColor: Colors.green, snackPosition: SnackPosition.TOP);
      } else {
        loader = false;
        Future.delayed(const Duration(milliseconds: 10), () {
          update();
        });
        final jsonResponse = json.decode(response.body);
        Get.rawSnackbar(message: "${jsonResponse['message']}", backgroundColor: Colors.red, snackPosition: SnackPosition.TOP);
      }
    });
  }

  updateFcmSubscribe(email) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var deviceToken = storage.getString('deviceToken');
    Map body = {
      "device_token": deviceToken,
      "topic": email,
    };
    print(body);
    String jsonBody = json.encode(body);
    server.postRequestWithToken(endPoint: APIList.fcmSubscribe, body: jsonBody).then((response) {
      print("fcm subscribe returns code ::::${response.statusCode}");
      print("fcm subscribe returns code ::::$response");
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('responseBody===========>');
        print(jsonResponse);
      }
    });
  }
}
