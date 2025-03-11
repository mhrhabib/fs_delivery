import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:fs_delivery/Screen/Widgets/constant.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../../sign_in.dart';
import '../../sign_up_verify/sign_up_verify_screen.dart';
import '../repository/sign_up_repo.dart';

class SignUpController extends GetxController {
  var nameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var mobileController = TextEditingController().obs;
  var addressController = ''.obs;
  var passwordController = TextEditingController().obs;
  RxInt? hubId = 0.obs;
  RxDouble? lat = 0.0.obs;
  RxDouble? long = 0.0.obs;

  // image picker

  var selectedImage = ''.obs;
  var image = Rx<File?>(null);
  var imageFileName = ''.obs;

  avatarImage() async {
    final pickImage = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
    selectedImage.value = pickImage!.path;
    if (selectedImage.value != '') {
      image.value = File(pickImage.path);
      imageFileName.value = basename(image.value!.path);
    }
  }

  var selectedDrivingLicense = ''.obs;
  var drivingLicense = Rx<File?>(null);
  var drivingFileName = ''.obs;

  drivingLicenseImage() async {
    final pickImage = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
    selectedDrivingLicense.value = pickImage!.path;
    if (selectedDrivingLicense.value != '') {
      drivingLicense.value = File(pickImage.path);
      drivingFileName.value = basename(drivingLicense.value!.path);
    }
  }

  var isLoading = false.obs;
  signUP({String? usertype}) async {
    isLoading.value = true;
    var response = await SignUpRepo.signUpApiCall(
      userType: usertype,
      name: nameController.value.text,
      email: emailController.value.text,
      phone: mobileController.value.text,
      address: addressController.value,
      password: passwordController.value.text,
      hubId: hubId!.value,
      lat: lat!.value,
      long: long!.value,
      image: selectedImage.value == '' ? null : image.value!.path,
      drivingLicense: selectedDrivingLicense == '' ? null : drivingLicense.value!.path,
    );
    if (response['success'] == true) {
      isLoading.value = false;
      print("success");
      Get.to(() => SignUpVerifyScreen());
    } else {
      print("failed");
      isLoading.value = false;
    }
  }

  // sign up verify section

  var otpcontroller = TextEditingController().obs;

  signUpOtpVerify() async {
    isLoading.value = true;
    var response = await SignUpRepo.signUpVerifyApiCall(
      otp: otpcontroller.value.text,
      mobile: mobileController.value.text.isEmpty ? storage.read('email') : mobileController.value.text,
    );
    if (response['success'] == true) {
      print("success");
      Get.off(() => SignIn());
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }
}
