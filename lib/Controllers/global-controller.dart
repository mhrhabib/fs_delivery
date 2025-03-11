import 'dart:convert';

import 'package:fs_delivery/Screen/Widgets/constant.dart';
import 'package:fs_delivery/services/base_client.dart';

import '/Models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import '../Models/hubs_model.dart';
import '../Models/profile_model.dart';
import '../Screen/Authentication/sign_in.dart';
import '../services/api_list.dart';
import '/services/server.dart';
import '/services/user-service.dart';

class GlobalController extends GetxController {
  Server server = Server();

  UserService userService = UserService();
  bool profileLoader = true;
  String? bearerToken, siteName, siteEmail, siteLogo, currencyName;

  bool isUser = false;
  String? userId;
  String? userImage;
  String? userName;
  String? userEmail;

  String? get currency => currencyName;
  List<Hubs> hubList = <Hubs>[];
  List<DropdownMenuItem<Hubs>> dropDownItems = [];

  initController() async {
    final validUser = await userService.loginCheck();
    isUser = validUser;
    Future.delayed(const Duration(milliseconds: 10), () {
      update();
    });
    if (isUser) {
      final token = await userService.getToken();
      final myId = await userService.getUserId();
      bearerToken = token;
      userId = myId;
      Future.delayed(const Duration(milliseconds: 10), () {
        update();
      });
      Server.initClass(token: bearerToken);
      getUserProfile();
    }
  }

  getHub() {
    server.getRequestNotToken(endPoint: APIList.hub).then((response) {
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        var hubData = HubsModel.fromJson(jsonResponse);
        hubList = <Hubs>[];
        dropDownItems = [];
        hubList.addAll(hubData.data!.hubs!);
        hubList.forEach((element) {
          var item = DropdownMenuItem(
            value: element,
            child: Text(element.name.toString()),
          );
          dropDownItems.add(item);
        });
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      }
    });
  }

  @override
  void onInit() {
    initController();
    getHub();
    siteSettings();
    super.onInit();
  }

  getUserProfile() {
    server.getRequest(endPoint: APIList.getProfileUrl(storage.read('userType'))).then((response) {
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        var profileData = ProfileModel.fromJson(jsonResponse);
        userName = profileData.data!.user!.name;
        userEmail = profileData.data!.user!.email;
        userImage = profileData.data!.user!.image;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      }
    });
  }

  siteSettings() async {
    dio.Response response = await BaseClient.get(url: APIList.generalSettings!);
    print("response code ${response.statusCode}");
    if (response.statusCode == 200) {
      // final jsonResponse = json.decode(response.data);
      // print("general setting $jsonResponse");
      var settingData = SettingsModel.fromJson(response.data);
      currencyName = settingData.data!.currency;
      siteName = settingData.data!.name;
      siteEmail = settingData.data!.email;
      Future.delayed(Duration(milliseconds: 10), () {
        update();
      });
    } else {
      return Container(child: Center(child: CircularProgressIndicator()));
    }
  }

  userLogout({BuildContext? context}) async {
    getValue();
    await userService.removeSharedPreferenceData();
    await updateFcmUnSubscribe();
    isUser = false;
    Future.delayed(Duration(milliseconds: 10), () {
      update();
    });
    Get.off(() => const SignIn());
  }

  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('token');

    return stringValue;
  }

  updateFcmUnSubscribe() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var deviceToken = storage.getString('deviceToken');
    Map body = {
      "device_token": deviceToken,
      "topic": null,
    };
    String jsonBody = json.encode(body);
    server.postRequest(endPoint: APIList.fcmUnSubscribe, body: jsonBody).then((response) {
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('responseBody===========>');
        print(jsonResponse);
      }
    });
  }
}
