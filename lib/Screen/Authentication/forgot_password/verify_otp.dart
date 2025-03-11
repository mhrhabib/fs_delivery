import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/image.dart';
import '../../Widgets/button_global.dart';
import '../../Widgets/constant.dart';
import 'package:get/get.dart';

import 'controller/forgot_pass_controller.dart';

class OtpVerify extends StatefulWidget {
  const OtpVerify({
    Key? key,
  }) : super(key: key);

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  ForgotPassController forgotPassController = Get.put(ForgotPassController());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: (Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Container(
              margin: EdgeInsets.only(right: 30),
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.appLogo),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text(
              'confirm_otp'.tr,
              style: kTextStyle.copyWith(color: kBgColor, fontWeight: FontWeight.bold, fontSize: 20.0),
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
                      Text(
                        "Don't worry we'll send you an email to reset your password".tr,
                        style: kTextStyle.copyWith(color: kTitleColor),
                        textAlign: TextAlign.center,
                      ),
                      Center(
                        child: Text(
                          '********',
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Center(
                        child: Text(
                          'Your Otp'.tr,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      AppTextField(
                        showCursor: true,
                        cursorColor: kTitleColor,
                        controller: forgotPassController.otp.value,
                        textFieldType: TextFieldType.NUMBER,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'OTP'.tr,
                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                          hintText: 'OTP',
                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                          suffixIcon: const Icon(Icons.mail, color: kGreyTextColor),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "this_field_can_t_be_empty".tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30.0),
                      ButtonGlobal(
                          buttontext: 'submit'.tr,
                          buttonDecoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: kMainColor),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await forgotPassController.otpCheckApiCall();
                            } else {
                              Get.rawSnackbar(message: "enter_your_otp_code".tr, backgroundColor: Colors.red, snackPosition: SnackPosition.TOP);
                            }
                          }),
                      const SizedBox(height: 10.0),
                      InkWell(
                        onTap: () async {
                          await forgotPassController.resendOTP();
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'didn_t_get'.tr,
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                            children: [
                              TextSpan(
                                text: 'resend_code'.tr,
                                style: kTextStyle.copyWith(color: Colors.pink),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
