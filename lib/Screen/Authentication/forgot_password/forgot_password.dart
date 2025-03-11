import '../../../utils/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Widgets/button_global.dart';
import '../../Widgets/constant.dart';
import 'controller/forgot_pass_controller.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final ForgotPassController forgotPassController = Get.put(ForgotPassController());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          title: Text(
            'reset_password'.tr,
            style: kTextStyle.copyWith(color: kBgColor),
          ),
          iconTheme: const IconThemeData(
            color: kBgColor,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: (Column(
            children: [
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
                'reset_password'.tr,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.0),
                        Text(
                          "Don't worry we'll send you an email to reset your password.".tr,
                          style: kTextStyle.copyWith(
                            color: kTitleColor,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        AppTextField(
                          showCursor: true,
                          cursorColor: kTitleColor,
                          controller: forgotPassController.emailController.value,
                          textFieldType: TextFieldType.NUMBER,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Mobile'.tr,
                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
                            hintText: '01#########',
                            hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                            suffixIcon: const Icon(Icons.mail, color: kGreyTextColor),
                          ),
                          validator: (value) {
                            if (forgotPassController.emailController.value.text.isEmpty) {
                              return "this_field_can_t_be_empty".tr;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Obx(
                          () => forgotPassController.loader.value
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: kMainColor,
                                  ),
                                )
                              : ButtonGlobal(
                                  buttontext: 'Send OTP'.tr,
                                  buttonDecoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: kMainColor),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await forgotPassController.sentOtpForgotPassword();
                                    }
                                  },
                                ),
                        ),
                        const SizedBox(height: 10.0),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       'dont_have_an_account'.tr,
                        //       style: kTextStyle.copyWith(color: kGreyTextColor),
                        //     ),
                        //     const SizedBox(width: 5.0),
                        //     Container(
                        //       width: 1.0,
                        //       height: 15.0,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(2.0),
                        //         color: kGreyTextColor,
                        //       ),
                        //     ),
                        //     const SizedBox(width: 5.0),
                        //     Text(
                        //       'sign_in'.tr,
                        //       style: kTextStyle.copyWith(color: kSecondaryColor),
                        //     ).onTap(
                        //       () => const SignIn().launch(context),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
