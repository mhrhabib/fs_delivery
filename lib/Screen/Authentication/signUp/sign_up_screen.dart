import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../Controllers/global-controller.dart';
import '../../../utils/image.dart';
import '../../Widgets/button_global.dart';
import '../../Widgets/constant.dart';
import '../../Widgets/loader.dart';
import '../sign_in.dart';
import 'controller/sign_up_controller.dart';
import 'widgets/dropdown_widget.dart';
import 'widgets/location_widget.dart';
import 'widgets/map_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final SignUpController signUpController = Get.put(SignUpController());
  final GlobalController globalController = Get.put(GlobalController());

  final userTypeList = ['Deliveryman', 'SpotManager'];
  String? selectUserType;
  String? userType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.center,
                    width: 100,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Images.appLogo),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  'please_enter_your_user_information'.tr,
                  style: kTextStyle.copyWith(color: kBgColor, fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              const SizedBox(height: 20.0),
                              DropDownWidget(
                                  itemList: userTypeList.map((element) => element).toList(),
                                  selectedValue: selectUserType,
                                  initialValue: 'User Type',
                                  onChanged: (val) {
                                    setState(() {
                                      selectUserType = val;
                                      if (selectUserType == "Deliveryman") {
                                        userType = 'delivery_man';
                                      } else {
                                        userType = 'spot_manager';
                                      }
                                    });
                                  }),
                              const SizedBox(height: 20.0),
                              AppTextField(
                                showCursor: true,
                                controller: signUpController.nameController.value,
                                validator: (value) {
                                  if (signUpController.emailController.value.text.isEmpty) {
                                    return "this_field_can_t_be_empty".tr;
                                  }
                                  return null;
                                },
                                cursorColor: kTitleColor,
                                textFieldType: TextFieldType.EMAIL,
                                decoration: kInputDecoration.copyWith(
                                  labelText: 'Name'.tr,
                                  labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                  hintText: 'name',
                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                  //suffixIcon: const Icon(Icons.mail, color: kGreyTextColor),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              AppTextField(
                                showCursor: true,
                                controller: signUpController.mobileController.value,
                                validator: (value) {
                                  if (signUpController.emailController.value.text.isEmpty) {
                                    return "this_field_can_t_be_empty".tr;
                                  }
                                  return null;
                                },
                                cursorColor: kTitleColor,
                                textFieldType: TextFieldType.EMAIL,
                                decoration: kInputDecoration.copyWith(
                                  labelText: 'phone'.tr,
                                  labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                  hintText: 'phone',
                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                  suffixIcon: const Icon(Icons.mobile_friendly, color: kGreyTextColor),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              AppTextField(
                                showCursor: true,
                                controller: signUpController.emailController.value,
                                validator: (value) {
                                  if (signUpController.emailController.value.text.isEmpty) {
                                    return "this_field_can_t_be_empty".tr;
                                  }
                                  return null;
                                },
                                cursorColor: kTitleColor,
                                textFieldType: TextFieldType.EMAIL,
                                decoration: kInputDecoration.copyWith(
                                  labelText: 'email_mobile'.tr,
                                  labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                  hintText: 'example@gmail.com',
                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                  suffixIcon: const Icon(Icons.mail, color: kGreyTextColor),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              AppTextField(
                                showCursor: true,
                                cursorColor: kTitleColor,
                                controller: signUpController.passwordController.value,
                                validator: (value) {
                                  if (signUpController.passwordController.value.text.isEmpty) {
                                    return "this_field_can_t_be_empty".tr;
                                  }
                                  return null;
                                },
                                textFieldType: TextFieldType.PASSWORD,
                                decoration: kInputDecoration.copyWith(
                                  labelText: 'password'.tr,
                                  labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                  hintText: '********',
                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              DropDownWidget(
                                  itemList: globalController.hubList.map((element) => element.name!).toList(),
                                  selectedValue: '',
                                  initialValue: 'HUB',
                                  onChanged: (val) {
                                    var hubs = globalController.hubList.firstWhere((element) => element.name == val);
                                    setState(() {
                                      signUpController.hubId!.value = hubs.id!;
                                    });
                                  }),
                              const SizedBox(height: 20.0),
                              Obx(
                                () => BookingLocationWidget(
                                  txt: signUpController.lat!.value == 0.0 ? 'Address' : signUpController.addressController.value,
                                  voidCallback: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MapScreenOne(
                                        controller: signUpController,
                                      ),
                                    ));
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        image: signUpController.image.value == null
                                            ? DecorationImage(
                                                image: AssetImage(Images.appLogo),
                                              )
                                            : DecorationImage(
                                                image: FileImage(signUpController.image.value!),
                                              ),
                                        color: Colors.white.withOpacity(0.2),
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(backgroundColor: kMainColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                    onPressed: () async {
                                      await signUpController.avatarImage();
                                    },
                                    icon: const Icon(
                                      Icons.photo_camera,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Profile',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        image: signUpController.drivingLicense.value == null
                                            ? DecorationImage(
                                                image: AssetImage(Images.appLogo),
                                              )
                                            : DecorationImage(
                                                image: FileImage(signUpController.drivingLicense.value!),
                                              ),
                                        color: Colors.white.withOpacity(0.2),
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(backgroundColor: kMainColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                    onPressed: () async {
                                      await signUpController.drivingLicenseImage();
                                    },
                                    icon: const Icon(
                                      Icons.photo_camera,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Driving license',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              Obx(
                                () => ButtonGlobal(
                                  buttontext: signUpController.isLoading.value ? 'Loading.....' : 'Sign Up'.tr,
                                  buttonDecoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: kMainColor),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await signUpController.signUP(usertype: userType);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  Get.to(() => SignIn());
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Already have an account? "),
                                    Text(
                                      "Sign In",
                                      style: TextStyle(
                                        color: kMainColor,
                                        decoration: TextDecoration.underline,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      )),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Obx(
            () => signUpController.isLoading.value
                ? Positioned(
                    child: Container(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, color: Colors.white60, child: const Center(child: LoaderCircle())),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
