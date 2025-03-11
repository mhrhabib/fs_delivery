import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fs_delivery/Models/dashboard_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:dio/dio.dart' as dio;
import '../Screen/Home/drop_downs_lists.dart';
import '../Screen/Widgets/constant.dart';
import '../Screen/Widgets/custom_form_field.dart';
import '../Screen/Widgets/form_title.dart';
import '../services/base_client.dart';
import '/Models/dashboard_model.dart' as dm;
import 'package:flutter/cupertino.dart';
import '../services/api_list.dart';
import '/services/server.dart';
import '/services/user-service.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

class DashboardController extends GetxController {
  UserService userService = UserService();
  Server server = Server();
  var deliverymanAssign = <Delivered>[];
  var deliverymanReSchedule = <Delivered>[];
  var pickupAssign = <Delivered>[];
  List<Delivered> returnToCourier = <Delivered>[];
  List<Delivered> delivered = <Delivered>[];
  final TextEditingController cashController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String? statusID = '9';
  String? collectStatusID = '34';
  String? collectByDriverStatusID = '35';

  String? userID;
  RxBool dashboardLoader = false.obs;
  bool commonLoader = false;
  bool loader = false;
  late dm.Data dashboardData;

  @override
  void onInit() {
    getDashboard();
    super.onInit();
  }

  // image picker

  var selectedImage = ''.obs;
  var avatar = Rx<File?>(null);
  var avatarFilename = ''.obs;

  avatarImage() async {
    final pickImage = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
    selectedImage.value = pickImage!.path;
    if (selectedImage.value != '') {
      avatar.value = File(pickImage.path);
      avatarFilename.value = basename(avatar.value!.path);
    }
  }

  changeStatusWithOutSignature(
    context,
    statusID,
    parcelId,
  ) {
    dashboardLoader.value = true;

    update();
    Map<String, String> body = {
      'parcel_id': parcelId,
      'status_action': collectByDriverStatusID!,
      'note': noteController.text,
    };
    String jsonbody = jsonEncode(body);
    print(body);
    try {
      server.postRequestWithToken(endPoint: APIList.deliverymanChangeStatus, body: jsonbody).then((response) {
        print(response.statusCode);
        if (response != null) {
          onInit();
          dashboardLoader.value = false;
          update();

          // fsSpotsShipment.value = null;
          // pickupFromFsSpots.value = null;
          // fsOfficeHomeShipment.value = null;

          Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            title: 'Change Status',
            message: 'Status Successfully',
            backgroundColor: CupertinoColors.activeGreen.withOpacity(.9),
            margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          );
        } else {
          dashboardLoader.value = false;
          update();
        }
      });
    } catch (e) {
      Get.log(e.toString());
      dashboardLoader.value = false;
      update();
    }
  }

  getDashboard() async {
    dashboardLoader.value = true;

    dio.Response response = await BaseClient.get(url: APIList.deliverymanDashboard!);
    if (response.statusCode == 200) {
      deliverymanAssign = [];
      pickupAssign = [];
      delivered = [];
      returnToCourier = [];
      deliverymanReSchedule = [];

      // final jsonResponse = json.decode(response.data);
      print(" dashborad data ${response.data}");
      var dashboard = dm.DashboardModel.fromJson(response.data);
      dashboardData = dashboard.data!;
      deliverymanAssign = dashboardData.deliverymanAssign!;
      pickupAssign = dashboardData.pickupAssign!;
      delivered = dashboardData.delivered!;
      returnToCourier = dashboardData.returnToCourier!;
      deliverymanReSchedule = dashboardData.deliverymanReSchedule!;
      dashboardLoader.value = false;
      update();
    } else {
      dashboardLoader.value = false;
      update();
    }
  }

  //

  var pickUpCodeController = TextEditingController().obs;

  changeStatus(context, parcelId) {
    dashboardLoader.value = true;
    update();
    final queryParameters = {
      'parcel_id': parcelId,
      'status_action': statusID,
      'documents': avatar.value?.path,
      'note': noteController.text,
      'pickup_code': pickUpCodeController.value.text,
    };

    var jsonString = jsonEncode(queryParameters);
    print(jsonString);
    try {
      server.postRequestWithToken(endPoint: APIList.deliverymanChangeStatus, body: jsonString).then((response) {
        print(response.statusCode);
        var json = jsonDecode(response.body);
        print(json);
        if (response != null && response.statusCode == 200) {
          print(response);
          getDashboard();

          Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            title: 'Change Status',
            message: 'Status Successfully',
            backgroundColor: CupertinoColors.activeGreen.withOpacity(.9),
            margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          );

          cashController.clear();
          pickUpCodeController.value.clear();
          noteController.clear();
          avatar.value = null;
          avatarFilename.value = '';
          dashboardLoader.value = false;
          update();
        } else {
          dashboardLoader.value = false;
          update();
          Get.rawSnackbar(
            title: 'Change Error',
            message: 'Enter a valid input',
            backgroundColor: CupertinoColors.destructiveRed.withOpacity(.9),
            margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          );
        }
      });
    } catch (e) {
      Get.log(e.toString());
      dashboardLoader.value = false;
      update();
    }
  }

  changePickUpStatus(context, parcelId) {
    dashboardLoader.value = true;
    update();
    final queryParameters = {
      'parcel_id': parcelId,
      'status_action': collectStatusID,
      'cash_collection': cashController.text,
      'note': noteController.text,
    };

    var jsonString = jsonEncode(queryParameters);
    print(jsonString);
    try {
      server.postRequestWithToken(endPoint: APIList.deliverymanChangeStatus, body: jsonString).then((response) {
        print(response.statusCode);
        if (response != null && response.statusCode == 200) {
          print(response);
          getDashboard();

          Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            title: 'Change Status',
            message: 'Status Successfully',
            backgroundColor: CupertinoColors.activeGreen.withOpacity(.9),
            margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          );
          cashController.clear();
          noteController.clear();
          dashboardLoader.value = false;
          update();
        } else {
          dashboardLoader.value = false;
          update();
        }
      });
    } catch (e) {
      Get.log(e.toString());
      dashboardLoader.value = false;
      update();
    }
  }

  getBarcodeParcel(context, trackingid) {
    server.getRequest(endPoint: '${APIList.deliverymanBarcodeParcel!}$trackingid').then((response) {
      if (response != null && response.statusCode == 200) {
        dashboardLoader.value = false;
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse['data']['parcel']['id'] != null) {
          if (jsonResponse['data']['parcel']['status'].toString() == '2' ||
              jsonResponse['data']['parcel']['status'].toString() == '3' ||
              jsonResponse['data']['parcel']['status'].toString() == '36' ||
              jsonResponse['data']['parcel']['status'].toString() == '37') {
            showPickUpPopUp(context, jsonResponse['data']['parcel']['id']);
          } else if (jsonResponse['data']['parcel']['status'].toString() == '7' || jsonResponse['data']['parcel']['status'].toString() == '8') {
            collectByDriverPopUp(
              context,
              jsonResponse['data']['parcel']['id'],
            );
          } else if (jsonResponse['data']['parcel']['status'].toString() == '35') {
            showStatusPopUp(
              context,
              jsonResponse['data']['parcel']['id'],
            );
          } else {
            Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              title: 'Barcode Scanner',
              message: '${jsonResponse['message']}',
              backgroundColor: CupertinoColors.destructiveRed.withOpacity(.9),
              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            );
          }
        } else {
          Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            title: 'Barcode Scanner',
            message: 'Parcel Not Found. Please try again',
            backgroundColor: CupertinoColors.destructiveRed.withOpacity(.9),
            margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          );
        }
        update();
      } else {
        dashboardLoader.value = false;
        update();
      }
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void showPickUpPopUp(context, parcelID) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'change_status'.tr,
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: const BoxDecoration(color: kMainColor, shape: BoxShape.circle),
                                child: const Icon(
                                  FontAwesomeIcons.x,
                                  color: kBgColor,
                                )).onTap(() => finish(context)),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Divider(
                          thickness: 1.0,
                          color: kGreyTextColor.withOpacity(0.5),
                        ),
                        FormTitle(title: 'select_status'.tr),
                        pickupDropdownItems.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  height: 48,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          isExpanded: true,
                                          menuMaxHeight: ScreenSize(context).mainHeight / 3,
                                          items: pickupDropdownItems,
                                          value: collectStatusID,
                                          onChanged: (String? newValue) {
                                            collectStatusID = newValue!;
                                            print(collectStatusID);
                                            (context as Element).markNeedsBuild();
                                          }),
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10.0),
                        statusID == '32' ? FormTitle(title: 'cash_collection_tk'.tr) : SizedBox().marginZero,
                        statusID == '32'
                            ? CustomFormField(
                                controller: cashController,
                                validatorTxt: 'please_type_your_amount'.tr,
                              )
                            : SizedBox().marginZero,
                        const SizedBox(height: 10.0),
                        FormTitle(title: 'note'.tr),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: noteController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            cursorColor: kMainColor,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red,
                                ),
                              ),
                              fillColor: Colors.red,
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                                borderSide: BorderSide(width: 1, color: kMainColor),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                                borderSide: BorderSide(width: 1, color: Colors.black),
                              ),
                            ),
                            onFieldSubmitted: (value) {
                              //add code
                            },
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: Container(
                                height: 45,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: kTitleColor,
                                ),
                                child: Center(
                                  child: Text(
                                    'cancel'.tr,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                            TextButton(
                              child: Container(
                                height: 45,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: kMainColor,
                                ),
                                child: Center(
                                  child: Text(
                                    'yes_sure'.tr,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: kBgColor,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                print('tapped');

                                if (_formKey.currentState!.validate()) {
                                  Get.back();
                                  changePickUpStatus(context, parcelID.toString());
                                }
                                Get.back();
                              },
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }

  void showStatusPopUp(context, parcelID) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'change_status'.tr,
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: const BoxDecoration(color: kMainColor, shape: BoxShape.circle),
                                child: const Icon(
                                  FontAwesomeIcons.x,
                                  color: kBgColor,
                                )).onTap(() => finish(context)),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Divider(
                          thickness: 1.0,
                          color: kGreyTextColor.withOpacity(0.5),
                        ),
                        FormTitle(title: 'select_status'.tr),
                        dropdownItems.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  height: 48,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          isExpanded: true,
                                          menuMaxHeight: ScreenSize(context).mainHeight / 3,
                                          items: dropdownItems,
                                          value: statusID,
                                          onChanged: (String? newValue) {
                                            statusID = newValue!;
                                            print(statusID);
                                            (context as Element).markNeedsBuild();
                                          }),
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10.0),
                        statusID == '32' ? FormTitle(title: 'cash_collection_tk'.tr) : SizedBox().marginZero,
                        statusID == '32'
                            ? CustomFormField(
                                controller: cashController,
                                validatorTxt: 'please_type_your_amount'.tr,
                              )
                            : SizedBox().marginZero,
                        const SizedBox(height: 10.0),
                        FormTitle(title: 'ID'.tr),
                        Obx(
                          () => Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("File:"),
                                  InkWell(
                                      onTap: () {
                                        avatarImage();
                                      },
                                      child: Icon(Icons.image)),
                                ],
                              ),
                              avatarFilename.isEmpty ? Text('') : Text("${avatarFilename}"),
                            ],
                          ),
                        ),
                        FormTitle(title: 'PickUp code'.tr),
                        TextFormField(
                          controller: pickUpCodeController.value,
                          decoration: InputDecoration(
                            hintText: 'Pickup Code',
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(width: 1, color: Colors.black),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                              borderSide: BorderSide(width: 1, color: kMainColor),
                            ),
                          ),
                        ),
                        FormTitle(title: 'note'.tr),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: noteController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            cursorColor: kMainColor,
                            maxLines: 3,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red,
                                ),
                              ),
                              fillColor: Colors.red,
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                                borderSide: BorderSide(width: 1, color: kMainColor),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                                borderSide: BorderSide(width: 1, color: Colors.black),
                              ),
                            ),
                            onFieldSubmitted: (value) {
                              //add code
                            },
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: Container(
                                height: 45,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: kTitleColor,
                                ),
                                child: Center(
                                  child: Text(
                                    'cancel'.tr,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                            TextButton(
                              child: Container(
                                height: 45,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: kMainColor,
                                ),
                                child: Center(
                                  child: Text(
                                    'yes_sure'.tr,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: kBgColor,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                print('tapped');

                                if (_formKey.currentState!.validate()) {
                                  Get.back();
                                  changeStatus(context, parcelID.toString());
                                }
                                Get.back();
                              },
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }

  void collectByDriverPopUp(context, parcel) {
    noteController.text = '';
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'change_status'.tr,
                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: const BoxDecoration(color: kMainColor, shape: BoxShape.circle),
                              child: const Icon(
                                FontAwesomeIcons.x,
                                color: kBgColor,
                              )).onTap(() => finish(context)),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Divider(
                        thickness: 1.0,
                        color: kGreyTextColor.withOpacity(0.5),
                      ),
                      FormTitle(title: 'select_status'.tr),
                      dropdownItems.isEmpty
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                height: 48,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: borderColors,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        isExpanded: true,
                                        menuMaxHeight: ScreenSize(context).mainHeight / 3,
                                        items: pickupDropdownItemsCollectBydriver,
                                        value: collectByDriverStatusID,
                                        onChanged: (String? newValue) {
                                          collectByDriverStatusID = newValue;
                                          (context as Element).markNeedsBuild();
                                        }),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 10.0),
                      // Row(
                      //   children: [
                      //     Text(
                      //       'Signature Received'.tr,
                      //       style: const TextStyle(
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: 14,
                      //         color: titleColor,
                      //       ),
                      //     ),
                      //     const Text(
                      //       '*',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: 14,
                      //         color: Color(0xffDD2702),
                      //       ),
                      //     ),
                      //     TextButton(child: Text('Clear'), onPressed: _handleClearButtonPressed),
                      //     // TextButton(
                      //     //     child: Text('save Image'),
                      //     //     onPressed:_handleSaveButtonPressed
                      //     // )
                      //   ],
                      // ),
                      // Column(children: [
                      //   Padding(
                      //       padding: EdgeInsets.all(5),
                      //       child: Container(
                      //           height: 120,
                      //           child: SfSignaturePad(key: signatureGlobalKey, backgroundColor: Colors.white, strokeColor: Colors.black, minimumStrokeWidth: 1.0, maximumStrokeWidth: 3.0),
                      //           decoration: BoxDecoration(border: Border.all(color: kMainColor)))),
                      // ], mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center),
                      FormTitle(title: 'note'.tr),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: noteController,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          cursorColor: kMainColor,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.red,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.red,
                              ),
                            ),
                            fillColor: Colors.red,
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                              borderSide: BorderSide(width: 1, color: kMainColor),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                              borderSide: BorderSide(width: 1, color: Colors.grey),
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            //add code
                          },
                        ),
                      ),
                      // ElevatedButton.icon(
                      //   onPressed: () {
                      //     _getFromCamera();
                      //   },
                      //   icon: Icon(
                      //     // <-- Icon
                      //     Icons.camera_alt,
                      //     size: 24.0,
                      //   ),
                      //   label: Text('Photo'), // <-- Text
                      // ),

                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Container(
                              height: 45,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kTitleColor,
                              ),
                              child: Center(
                                child: Text(
                                  'cancel'.tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          TextButton(
                            child: Container(
                              height: 45,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kMainColor,
                              ),
                              child: Center(
                                child: Text(
                                  'yes_sure'.tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: kBgColor,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              // final data = await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
                              // final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
                              // Directory? directory = await getExternalStorageDirectory();
                              // String path = directory!.path;
                              // print(path);
                              // await Directory('$path/signature').create(recursive: true);
                              // pickedSignatureFile = await File('$path/signature/signature.png').writeAsBytes(bytes!.buffer.asUint8List());
                              (context as Element).markNeedsBuild();
                              final FormState? form = _formKey.currentState;
                              if (form!.validate()) {
                                // if (pickedSignatureFile != null && imageFile != null) {
                                Get.back();
                                changeStatusWithOutSignature(
                                  context,
                                  collectByDriverStatusID,
                                  parcel.toString(),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}
