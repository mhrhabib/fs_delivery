import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../../../../services/api_list.dart';
import '../../../../services/base_client.dart';
import '../../change_password/change_password_screen.dart';
import '../../sign_in.dart';
import '../repository/password_repo.dart';
import '../verify_otp.dart';

class ForgotPassController extends GetxController {
  var emailController = TextEditingController().obs;
  var loader = false.obs;

  sentOtpForgotPassword() async {
    loader.value = true;
    var res = await PasswordRepo.sendOTPforPasswordChange(email: emailController.value.text);
    print('>>>>>>>>>$res');
    if (res["success"] == true) {
      Get.rawSnackbar(message: "${res['message']}");
      Get.to(() => OtpVerify());
      loader.value = false;
    } else {
      Get.rawSnackbar(message: "${res['message']}");

      loader.value = false;
    }
  }

  // confirm otp
  var otp = TextEditingController().obs;
  otpCheckApiCall() async {
    loader.value = true;
    var response = await PasswordRepo.OTPcheck(mobile: emailController.value.text, otp: otp.value.text);
    if (response["success"] == true) {
      Get.rawSnackbar(message: "${response['message']}");
      Get.to(() => ChangePasswordScreen());
      emailController.value.clear();
      loader.value = false;
    } else {
      Get.rawSnackbar(
        message: "${response['message']}",
      );
      loader.value = false;
      print(response);
    }
  }

  //resent otp
  var resendOtpLoader = false.obs;
  resendOTP() async {
    resendOtpLoader.value = true;
    var data = {
      "mobile": emailController.value.text,
    };
    try {
      dio.Response response = await BaseClient.post(url: APIList.resendOtp, payload: data);
      if (response.statusCode == 200) {
        Get.snackbar("success", "OTP resend successfully", backgroundColor: Colors.white);
        resendOtpLoader.value = false;
        emailController.value.clear();
      } else {
        print(response.data);
        Get.snackbar("Error", "OTP resend Unsuccessfull", backgroundColor: Colors.white);
        resendOtpLoader.value = false;
      }
    } catch (e) {
      resendOtpLoader.value = false;

      print(e);
    }
  }

  // reset password
  var newPassController = TextEditingController().obs;
  var confirmPassController = TextEditingController().obs;
  var isLoading = false.obs;

  resetPasswordApiCall() async {
    isLoading.value = true;
    var data = {
      "mobile": emailController.value.text,
      "password": newPassController.value.text,
      "password_confirmation": confirmPassController.value.text,
    };
    try {
      dio.Response response = await BaseClient.post(url: APIList.passwordReset, payload: data);
      if (response.statusCode == 200) {
        Get.to(() => SignIn());
        isLoading.value = false;
        Get.snackbar("Success", "${response.data['message']}", backgroundColor: Colors.white);
        newPassController.value.clear();
        confirmPassController.value.clear();

        return response.data;
      } else {
        Get.snackbar("Unsuccessfully", "${response.data['message']}", backgroundColor: Colors.red);
        print(response.data);
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }
}
