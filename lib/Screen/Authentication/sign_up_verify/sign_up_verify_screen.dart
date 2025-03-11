import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/image.dart';
import '../../Widgets/button_global.dart';
import '../../Widgets/constant.dart';
import '../../Widgets/loader.dart';
import '../signUp/controller/sign_up_controller.dart';

class SignUpVerifyScreen extends StatefulWidget {
  const SignUpVerifyScreen({super.key});

  @override
  State<SignUpVerifyScreen> createState() => _SignUpVerifyScreenState();
}

class _SignUpVerifyScreenState extends State<SignUpVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Stack(children: [
        Center(
            child: SingleChildScrollView(
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
                height: 30,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
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
                      child: Column(
                        children: [
                          const SizedBox(height: 20.0),
                          AppTextField(
                            showCursor: true,
                            controller: signUpController.otpcontroller.value,
                            validator: (value) {
                              if (signUpController.otpcontroller.value.text.isEmpty) {
                                return "this_field_can_t_be_empty".tr;
                              }
                              return null;
                            },
                            cursorColor: kTitleColor,
                            textFieldType: TextFieldType.EMAIL,
                            decoration: kInputDecoration.copyWith(
                              labelText: 'Otp'.tr,
                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                              hintText: 'Otp',
                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                              suffixIcon: const Icon(Icons.mail, color: kGreyTextColor),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const SizedBox(height: 10.0),
                          const SizedBox(height: 30.0),
                          ButtonGlobal(
                            buttontext: 'Verify'.tr,
                            buttonDecoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: kMainColor),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await signUpController.signUpOtpVerify();
                              }
                            },
                          ),
                        ],
                      ),
                    )),
              )
            ],
          ),
        )),
        Obx(
          () => signUpController.isLoading.value
              ? Positioned(
                  child: Container(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, color: Colors.white60, child: const Center(child: LoaderCircle())),
                )
              : const SizedBox.shrink(),
        ),
      ]),
    );
  }
}
