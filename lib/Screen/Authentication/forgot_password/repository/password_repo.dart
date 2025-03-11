import 'package:get/get.dart';
import '../../../../services/api_list.dart';
import '../../../../services/base_client.dart';
import 'package:dio/dio.dart' as dio;

import '../controller/forgot_pass_controller.dart';

class PasswordRepo {
  static Future sendOTPforPasswordChange({String? email}) async {
    var data = {
      "mobile": email,
    };
    try {
      dio.Response response = await BaseClient.post(url: APIList.sentOtpForReset, payload: data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.statusCode);
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>");
        return response.data;
      } else {
        Get.find<ForgotPassController>().loader.value = false;
        print(response.data);
        Get.rawSnackbar(message: 'Enter a valid input');
      }
    } catch (e) {
      Get.find<ForgotPassController>().loader.value = false;

      print(e);
    }
  }

  static Future OTPcheck({String? mobile, String? otp}) async {
    var data = {
      "mobile": mobile,
      "otp": otp,
    };
    print(data);
    try {
      dio.Response response = await BaseClient.post(url: APIList.otpCheck, payload: data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.statusCode);
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>");
        return response.data;
      } else {
        Get.find<ForgotPassController>().loader.value = false;
        print(response.data);
        Get.rawSnackbar(
          message: ' ${response.statusMessage}',
        );
      }
    } catch (e) {
      Get.find<ForgotPassController>().loader.value = false;

      print(e);
    }
  }
}
