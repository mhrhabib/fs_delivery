import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fs_delivery/Screen/Widgets/constant.dart';
import '../Models/profile_model.dart';
import '../services/api_list.dart';
import '../services/base_client.dart';
import '/services/server.dart';
import 'package:dio/dio.dart' as dio;
import '/services/user-service.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  UserService userService = UserService();
  Server server = Server();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordCurrentController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  String? userID;

  bool profileLoader = true;
  bool commonLoader = false;
  var loader = false.obs;
  bool passwordLoader = false;
  late ProfileData profileUser = ProfileData();
  late String name = '', email = '', address = '', mobile = '', image = '', businessName = '';

  @override
  void onInit() {
    getUserProfile();
    super.onInit();
  }

  getUserProfile() {
    server.getRequest(endPoint: APIList.getProfileUrl(storage.read('userType'))).then((response) {
      if (response != null && response.statusCode == 200) {
        profileLoader = false;
        final jsonResponse = json.decode(response.body);
        var profileData = ProfileModel.fromJson(jsonResponse);
        profileUser = profileData.data!;
        name = profileData.data!.user!.name!;
        image = profileData.data!.user!.image!;
        mobile = profileData.data!.user!.phone!;
        email = profileData.data!.user!.email.toString();
        address = profileData.data!.user!.address.toString();

        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else {
        profileLoader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      }
    });
  }

  updateUserProfile(filepath, type) async {
    loader.value = true;
    Future.delayed(Duration(milliseconds: 10), () {
      update();
    });
    dio.FormData body = dio.FormData.fromMap({
      'name': nameController.text,
      'address': addressController.text,
      'email': emailController.text,
      'mobile': phoneController.text,
    });
    print(filepath);
    if (type) {
      body.files.add(MapEntry('image_id', await dio.MultipartFile.fromFile(filepath)));
    }

    try {
      dio.Response response = await BaseClient.post(
        url: APIList.getProfileUpdateUrl(storage.read('userType')),
        payload: body,
      );
      print(APIList.getProfileUpdateUrl(storage.read('userType')));
      print(storage.read('token'));
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        emailController.clear();
        nameController.clear();
        businessNameController.clear();
        addressController.clear();
        phoneController.clear();
        loader.value = false;
        getUserProfile();
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
        Get.back();
      }
    } catch (e) {
      loader.value = false;
      Future.delayed(Duration(milliseconds: 10), () {
        update();
      });
      Get.rawSnackbar(message: 'Please enter valid input');
    } finally {
      loader.value = false;
    }

    // server.multipartRequest(endPoint: APIList.getProfileUpdateUrl(storage.read('userType')), body: body, filepath: filepath, type: type).then((response) {
    //   print(APIList.getProfileUpdateUrl(storage.read('userType')));
    //   print(response);
    //   if (response != null && response.statusCode == 200) {
    //     emailController.clear();
    //     nameController.clear();
    //     businessNameController.clear();
    //     addressController.clear();
    //     phoneController.clear();
    //     loader = false;
    //     getUserProfile();
    //     Future.delayed(Duration(milliseconds: 10), () {
    //       update();
    //     });
    //     Get.back();
    //   } else {
    //     loader = false;
    //     Future.delayed(Duration(milliseconds: 10), () {
    //       update();
    //     });
    //     Get.rawSnackbar(message: 'Please enter valid input');
    //   }
    // });
  }

  updateUserPassword({BuildContext? context}) async {
    passwordLoader = true;
    Future.delayed(Duration(milliseconds: 10), () {
      update();
    });
    Map body = {
      'password_current': passwordCurrentController.text,
      'password': passwordController.text,
      'password_confirmation': passwordConfirmController.text,
    };
    String jsonBody = json.encode(body);
    print(jsonBody);
    server.putRequest(endPoint: APIList.passwordUpdate, body: jsonBody).then((response) {
      final jsonResponse = json.decode(response.body);
      if (response != null && response.statusCode == 200) {
        Get.back();
        Get.rawSnackbar(message: 'Successfully Updated Password');
        passwordCurrentController.clear();
        passwordController.clear();
        passwordConfirmController.clear();
        passwordLoader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else if (response != null && response.statusCode == 422) {
        if (jsonResponse['message']['password_current'] != null) {
          Get.rawSnackbar(message: jsonResponse['message']['password_current'].toString());
        } else if (jsonResponse['message']['password'] != null) {
          Get.rawSnackbar(message: jsonResponse['message']['password'].toString());
        } else if (jsonResponse['message']['password_confirmation'] != null) {
          Get.rawSnackbar(message: jsonResponse['message']['password_confirmation'].toString());
        }
        passwordLoader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else {
        passwordLoader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
        Get.rawSnackbar(message: 'Please enter valid input');
      }
    });
  }
}
