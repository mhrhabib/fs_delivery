import 'dart:async';
import 'package:fs_delivery/fsSpotApp/dashboard/fs_drop_downs_lists.dart';
import '../../Models/fs_dashboard_model.dart';
import '../../Screen/Home/dashboard/launch_methods.dart';
import '../../Screen/Widgets/custom_form_field.dart';
import '../../Screen/Widgets/form_title.dart';
import '../controllers/fs_spot_dashboard_controller.dart';
import 'package:geolocator/geolocator.dart';
import '../../Screen/Home/dashboard/drawer/refactored_drawer.dart';
import '../../Screen/Widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import '../../Controllers/global-controller.dart';
import '../../Controllers/language_controller.dart';
import '../../Models/language_model.dart';
import '../../utils/image.dart';

class FsSpotDashboard extends StatefulWidget {
  const FsSpotDashboard({super.key});

  @override
  State<FsSpotDashboard> createState() => _FsSpotDashboardState();
}

class _FsSpotDashboardState extends State<FsSpotDashboard> {
  Language? selectedLang;
  FsSpotDashboardController dashboardController = Get.put(FsSpotDashboardController());
  GlobalController globalController = GlobalController();
  LanguageController languageController = Get.put(LanguageController());

  final box = GetStorage();
  bool servicestatus = false;
  bool haspermission = false;
  bool isSwitched = true;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;
  @override
  void initState() {
    checkGps();
    super.initState();
    // FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {});

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print(message.notification!.title);
    //   Get.snackbar(message.notification!.title!, message.notification!.body!,
    //       snackPosition: SnackPosition.TOP, backgroundColor: Colors.greenAccent, maxWidth: ScreenSize(context).mainWidth / 1.007, margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20));
    // });
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();
  }

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        getLocation();
      });
    } else {
      setState(() {
        isSwitched = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(">>pick up ${dashboardController.fsSpotsShipment.value!.pickupAssign!.length}");
    selectedLang = languageController.languageList[languageController.languageList.indexWhere((i) => i.locale == Get.locale)];
    return GetBuilder<FsSpotDashboardController>(
      init: FsSpotDashboardController(),
      builder: (dashboard) => DefaultTabController(
        length: 3,
        child: Scaffold(
          // backgroundColor: kMainColor,
          drawer: RefactoredDrawer(),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: kBgColor),
            titleSpacing: 0,
            backgroundColor: kMainColor,
            elevation: 0.0,
            title: ListTile(
              horizontalTitleGap: 0,
              contentPadding: const EdgeInsets.all(5.0),
              title: Text(
                'FS-Spot manager',
                style: kTextStyle.copyWith(color: kBgColor, fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              trailing: Container(
                padding: EdgeInsets.only(left: 8, right: 0),
                decoration: BoxDecoration(
                  color: Colors.white, //<-- SEE HERE
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 25.0,
                child: DropdownButton<Language>(
                  iconSize: 18,
                  elevation: 16,
                  value: selectedLang,
                  style: const TextStyle(color: Colors.white),
                  underline: Container(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    color: Colors.transparent,
                  ),
                  onChanged: (newValue) async {
                    setState(() {
                      selectedLang = newValue!;
                      if (newValue.langName == 'English') {
                        languageController.changeLanguage("en");
                      } else if (newValue.langName == 'Bangla') {
                        languageController.changeLanguage("bn");
                      } else if (newValue.langName == 'हिन्दी') {
                        languageController.changeLanguage("hi");
                      } else if (newValue.langName == 'عربي') {
                        languageController.changeLanguage("ar");
                      } else if (newValue.langName == 'Spanish') {
                        languageController.changeLanguage("es");
                      }
                    });
                  },
                  items: languageController.languageList.map<DropdownMenuItem<Language>>((Language value) {
                    return DropdownMenuItem<Language>(
                      value: value,
                      child: Text(
                        value.langName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            bottom: TabBar(
              padding: EdgeInsets.zero,
              isScrollable: true,
              indicatorPadding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              labelColor: Colors.black,
              unselectedLabelColor: kBgColor,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: kBgColor,
              ),
              tabs: [
                Tab(
                  child: Container(
                    margin: EdgeInsets.only(top: 5, bottom: 0, left: 0, right: 0),
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                    ),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                            'Pending Parcel'.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          )),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    margin: EdgeInsets.only(top: 5, bottom: 0, left: 0, right: 0),
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                    ),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                            'Accepted parcel'.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          )),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 0),
                    width: MediaQuery.of(context).size.width / 2.50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'Released Parcel'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Tab(
                //   child: Container(
                //     margin: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                //     width: MediaQuery.of(context).size.width / 3.50,
                //     decoration: BoxDecoration(
                //       borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                //     ),
                //     child: Center(
                //       child: Padding(
                //         padding: const EdgeInsets.only(top: 5),
                //         child: Text(
                //           'All Parcel'.tr,
                //           style: TextStyle(
                //             fontWeight: FontWeight.w500,
                //             fontSize: 16,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          // floatingActionButton: dashboard.dashboardLoader.value
          //     ? Center(
          //         child: CircularProgressIndicator(
          //           color: kBgColor,
          //         ),
          //       )
          //     : dashboard.pendingParcelList.isEmpty
          //         ? Container()
          //         : Align(
          //             alignment: Alignment.bottomCenter,
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 ElevatedButton(
          //                     onPressed: () {
          //                       Get.to(ParcelMapShow(lat, long));
          //                     },
          //                     child: const Text('See Route')),
          //                 SizedBox(
          //                   width: 20,
          //                 ),
          //                 Container(
          //                     width: 150,
          //                     height: 36,
          //                     margin: const EdgeInsets.all(0.0),
          //                     padding: const EdgeInsets.only(left: 4),
          //                     decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          //                     child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          //                       const Text('Location ON'),
          //                       Switch(
          //                         onChanged: toggleSwitch,
          //                         value: isSwitched,
          //                         activeColor: Colors.white,
          //                         activeTrackColor: Colors.red,
          //                         inactiveThumbColor: Colors.red,
          //                         inactiveTrackColor: Colors.black,
          //                       ),
          //                     ])),
          //               ],
          //             )),
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: [
              //Tab 1 item
              GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: RefreshIndicator(
                    displacement: 250,
                    backgroundColor: Colors.yellow,
                    color: Colors.red,
                    strokeWidth: 3,
                    onRefresh: () async {
                      await Future.delayed(Duration(milliseconds: 1500));
                      setState(() {
                        dashboard.onInit();
                      });
                    },
                    child: SingleChildScrollView(
                      child: Obx(
                        () => dashboard.dashboardLoader.value
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height * .80,
                                width: double.infinity,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: kMainColor,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      // padding: const EdgeInsets.only(bottom: 250),
                                      height: MediaQuery.of(context).size.height / 1.0,
                                      child: dashboard.pendingParcelList.isEmpty
                                          ? Center(
                                              child: Text(
                                              'no_item_found'.tr,
                                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                            ))
                                          : RefreshIndicator(
                                              displacement: 250,
                                              backgroundColor: Colors.yellow,
                                              color: Colors.red,
                                              strokeWidth: 3,
                                              onRefresh: () async {
                                                await Future.delayed(Duration(milliseconds: 1500));
                                                setState(() {
                                                  dashboard.onInit();
                                                });
                                              },
                                              child: ListView.builder(
                                                  itemCount: dashboard.pendingParcelList.length,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          showPopUp(dashboard.pendingParcelList[index]);
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom: 14.0),
                                                        child: Container(
                                                          height: 192.h,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(width: 1, color: kMainColor),
                                                          ),
                                                          child: FittedBox(
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(50),
                                                                    color: Colors.white,
                                                                    image: DecorationImage(
                                                                      image: AssetImage(Images.parcel),
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  ),
                                                                  height: 60.h,
                                                                  width: 60.w,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          SizedBox(
                                                                            width: 150.w,
                                                                            child: Text(
                                                                              dashboard.pendingParcelList[index].customerName.toString(),
                                                                              style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 14,
                                                                                color: nameColor,
                                                                              ),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            onTap: () {
                                                                              showPickUpPopUp(dashboard.pendingParcelList[index]);
                                                                            },
                                                                            child: SizedBox(
                                                                              height: 35.h,
                                                                              child: Card(
                                                                                elevation: 5,
                                                                                color: Colors.green,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(left: 12, right: 12),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      'change_status'.tr,
                                                                                      style: kTextStyle.copyWith(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(children: [
                                                                        Text(
                                                                          dashboard.pendingParcelList[index].customerPhone.toString(),
                                                                          style: const TextStyle(
                                                                            fontWeight: FontWeight.w400,
                                                                            fontSize: 14,
                                                                            color: hintColor,
                                                                          ),
                                                                          maxLines: 1,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 5.w,
                                                                        ),
                                                                        TextButton(
                                                                          onPressed: () => launchURL(dashboard.pendingParcelList[index].customerPhone.toString()),
                                                                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(50, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap, alignment: Alignment.centerLeft),
                                                                          child: Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.phone,
                                                                                color: Colors.green,
                                                                                size: 20,
                                                                              ),
                                                                              Text("Call me",
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.w800,
                                                                                    fontSize: 14,
                                                                                    color: Colors.green,
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                      Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width: 200.w,
                                                                            child: Text(
                                                                              dashboard.pendingParcelList[index].customerAddress.toString(),
                                                                              style: const TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 12,
                                                                                color: hintColor,
                                                                              ),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 5,
                                                                          ),
                                                                          TextButton(
                                                                            onPressed: () {
                                                                              var url = 'https://www.google.com/maps/dir/?api=1&origin=&destination=${dashboard.pendingParcelList[index].customerAddress.toString()}&travelmode=driving';
                                                                              launchMapURL(Uri.parse(url));
                                                                            },
                                                                            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(50, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap, alignment: Alignment.centerLeft),
                                                                            child: Row(
                                                                              children: [
                                                                                Text("Map",
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.w800,
                                                                                      fontSize: 14,
                                                                                      color: kMainColor,
                                                                                    )),
                                                                                Icon(
                                                                                  Icons.location_on_outlined,
                                                                                  color: kMainColor,
                                                                                  size: 20,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            '${Get.find<GlobalController>().currency!}${dashboard.pendingParcelList[index].cashCollection.toString()}',
                                                                            style: const TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 12,
                                                                              color: hintColor,
                                                                            ),
                                                                          ),
                                                                          SizedBox(width: 6),
                                                                          Text(
                                                                            '${dashboard.pendingParcelList[index].statusName.toString()}',
                                                                            style: const TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 12,
                                                                              color: hintColor,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  })),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    )),
              ),
              GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: RefreshIndicator(
                    displacement: 250,
                    backgroundColor: Colors.yellow,
                    color: Colors.red,
                    strokeWidth: 3,
                    onRefresh: () async {
                      await Future.delayed(Duration(milliseconds: 1500));
                      setState(() {
                        dashboard.onInit();
                      });
                    },
                    child: SingleChildScrollView(
                      child: Obx(
                        () => dashboard.dashboardLoader.value
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height * .80,
                                width: double.infinity,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: kMainColor,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 18),
                                      padding: const EdgeInsets.only(bottom: 250),
                                      height: MediaQuery.of(context).size.height / 1.0,
                                      child: dashboard.acceptParcelList.length == 0
                                          ? Center(
                                              child: Text(
                                              'no_item_found'.tr,
                                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                            ))
                                          : RefreshIndicator(
                                              displacement: 250,
                                              backgroundColor: Colors.yellow,
                                              color: Colors.red,
                                              strokeWidth: 3,
                                              onRefresh: () async {
                                                await Future.delayed(Duration(milliseconds: 1500));
                                                setState(() {
                                                  dashboard.onInit();
                                                });
                                              },
                                              child: ListView.builder(
                                                  itemCount: dashboard.acceptParcelList.length,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          showPopUp(dashboard.acceptParcelList[index]);
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom: 14.0),
                                                        child: Container(
                                                          height: 192.h,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(width: 1, color: kMainColor),
                                                          ),
                                                          child: FittedBox(
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(50),
                                                                    color: Colors.white,
                                                                    image: DecorationImage(
                                                                      image: AssetImage(Images.parcel),
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  ),
                                                                  height: 60.h,
                                                                  width: 60.w,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          SizedBox(
                                                                            width: 150.w,
                                                                            child: Text(
                                                                              dashboard.acceptParcelList[index].customerName.toString(),
                                                                              style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 14,
                                                                                color: nameColor,
                                                                              ),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            onTap: () {
                                                                              // Get.back();
                                                                              if (dashboard.acceptParcelList[index].status == 2) {
                                                                                collectByDriverPopUp(dashboard.acceptParcelList[index]);
                                                                              } else {
                                                                                Get.snackbar(
                                                                                  "!Warning!",
                                                                                  "Delivery man not assigned yet!!",
                                                                                  backgroundColor: Colors.orange.shade600,
                                                                                  colorText: Colors.white,
                                                                                );
                                                                              }
                                                                            },
                                                                            child: SizedBox(
                                                                              height: 35.h,
                                                                              child: Card(
                                                                                elevation: 5,
                                                                                color: Colors.green,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(2.0),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(left: 12, right: 12),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      'change_status'.tr,
                                                                                      style: kTextStyle.copyWith(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(children: [
                                                                        Text(
                                                                          dashboard.acceptParcelList[index].customerPhone.toString(),
                                                                          style: const TextStyle(
                                                                            fontWeight: FontWeight.w400,
                                                                            fontSize: 14,
                                                                            color: hintColor,
                                                                          ),
                                                                          maxLines: 1,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 5.w,
                                                                        ),
                                                                        TextButton(
                                                                          onPressed: () => launchURL(dashboard.acceptParcelList[index].customerPhone.toString()),
                                                                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(50, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap, alignment: Alignment.centerLeft),
                                                                          child: Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.phone,
                                                                                color: Colors.green,
                                                                                size: 20,
                                                                              ),
                                                                              Text("Call me",
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.w800,
                                                                                    fontSize: 14,
                                                                                    color: Colors.green,
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                      Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width: 200.w,
                                                                            child: Text(
                                                                              dashboard.acceptParcelList[index].customerAddress.toString(),
                                                                              style: const TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 12,
                                                                                color: hintColor,
                                                                              ),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 5,
                                                                          ),
                                                                          TextButton(
                                                                            onPressed: () {
                                                                              var url = 'https://www.google.com/maps/dir/?api=1&origin=&destination=${dashboard.acceptParcelList[index].customerAddress.toString()}&travelmode=driving';
                                                                              launchMapURL(Uri.parse(url));
                                                                            },
                                                                            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(50, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap, alignment: Alignment.centerLeft),
                                                                            child: Row(
                                                                              children: [
                                                                                Text("Map",
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.w800,
                                                                                      fontSize: 14,
                                                                                      color: kMainColor,
                                                                                    )),
                                                                                Icon(
                                                                                  Icons.location_on_outlined,
                                                                                  color: kMainColor,
                                                                                  size: 20,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            '${Get.find<GlobalController>().currency!}${dashboard.acceptParcelList[index].cashCollection.toString()}',
                                                                            style: const TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 12,
                                                                              color: hintColor,
                                                                            ),
                                                                          ),
                                                                          SizedBox(width: 6),
                                                                          Text(
                                                                            '${dashboard.acceptParcelList[index].statusName.toString()}',
                                                                            style: const TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 12,
                                                                              color: hintColor,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  })),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    )),
              ),
              GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: RefreshIndicator(
                    displacement: 250,
                    backgroundColor: Colors.yellow,
                    color: Colors.red,
                    strokeWidth: 3,
                    onRefresh: () async {
                      await Future.delayed(Duration(milliseconds: 1500));
                      setState(() {
                        dashboard.onInit();
                      });
                    },
                    child: SingleChildScrollView(
                      child: Obx(
                        () => dashboard.dashboardLoader.value
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height * .80,
                                width: double.infinity,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: kMainColor,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 18),
                                      padding: const EdgeInsets.only(bottom: 250),
                                      height: MediaQuery.of(context).size.height / 1.0,
                                      child: dashboard.releaseParcelList.length == 0
                                          ? Center(
                                              child: Text(
                                              'no_item_found'.tr,
                                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                            ))
                                          : RefreshIndicator(
                                              displacement: 250,
                                              backgroundColor: Colors.yellow,
                                              color: Colors.red,
                                              strokeWidth: 3,
                                              onRefresh: () async {
                                                await Future.delayed(Duration(milliseconds: 1500));
                                                setState(() {
                                                  dashboard.onInit();
                                                });
                                              },
                                              child: ListView.builder(
                                                  itemCount: dashboard.releaseParcelList.length,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          showPopUp(dashboard.releaseParcelList[index]);
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom: 14.0),
                                                        child: Container(
                                                          height: 145.h,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(width: 1, color: kMainColor),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(50),
                                                                  color: Colors.white,
                                                                  image: DecorationImage(
                                                                    image: AssetImage(Images.parcel),
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                                height: 60,
                                                                width: 60,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      dashboard.releaseParcelList[index].customerName.toString(),
                                                                      style: const TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 14,
                                                                        color: nameColor,
                                                                      ),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                    Row(children: [
                                                                      Text(
                                                                        dashboard.releaseParcelList[index].customerPhone.toString(),
                                                                        style: const TextStyle(
                                                                          fontWeight: FontWeight.w400,
                                                                          fontSize: 14,
                                                                          color: hintColor,
                                                                        ),
                                                                        maxLines: 1,
                                                                      ),
                                                                      SizedBox(
                                                                        width: 5,
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () => launchURL(dashboard.releaseParcelList[index].customerPhone.toString()),
                                                                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(50, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap, alignment: Alignment.centerLeft),
                                                                        child: Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.phone,
                                                                              color: Colors.green,
                                                                              size: 20,
                                                                            ),
                                                                            Text("Call me",
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w800,
                                                                                  fontSize: 14,
                                                                                  color: Colors.green,
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ]),
                                                                    Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width: 200.w,
                                                                          child: Text(
                                                                            dashboard.releaseParcelList[index].customerAddress.toString(),
                                                                            style: const TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 12,
                                                                              color: hintColor,
                                                                            ),
                                                                            maxLines: 2,
                                                                            overflow: TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            var url = 'https://www.google.com/maps/dir/?api=1&origin=&destination=${dashboard.releaseParcelList[index].customerAddress.toString()}&travelmode=driving';
                                                                            launchMapURL(Uri.parse(url));
                                                                          },
                                                                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(50, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap, alignment: Alignment.centerLeft),
                                                                          child: Row(
                                                                            children: [
                                                                              Text("Map",
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.w800,
                                                                                    fontSize: 14,
                                                                                    color: kMainColor,
                                                                                  )),
                                                                              Icon(
                                                                                Icons.location_on_outlined,
                                                                                color: kMainColor,
                                                                                size: 20,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          '${Get.find<GlobalController>().currency!}${dashboard.releaseParcelList[index].cashCollection.toString()}',
                                                                          style: const TextStyle(
                                                                            fontWeight: FontWeight.w400,
                                                                            fontSize: 12,
                                                                            color: hintColor,
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 6),
                                                                        Text(
                                                                          '${dashboard.releaseParcelList[index].statusName.toString()}',
                                                                          style: const TextStyle(
                                                                            fontWeight: FontWeight.w400,
                                                                            fontSize: 12,
                                                                            color: hintColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  })),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    )),
              ),
              // GestureDetector(
              //   onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              //   child: RefreshIndicator(
              //       displacement: 250,
              //       backgroundColor: Colors.yellow,
              //       color: Colors.red,
              //       strokeWidth: 3,
              //       onRefresh: () async {
              //         await Future.delayed(Duration(milliseconds: 1500));
              //         setState(() {
              //           dashboard.onInit();
              //         });
              //       },
              //       child: SingleChildScrollView(
              //         child: Obx(
              //           () => dashboard.dashboardLoader.value
              //               ? Center(
              //                   child: CircularProgressIndicator(
              //                     color: kMainColor,
              //                   ),
              //                 )
              //               : Padding(
              //                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //                   child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.center,
              //                     children: [
              //                       Container(
              //                         margin: const EdgeInsets.only(top: 18),
              //                         padding: const EdgeInsets.only(bottom: 250),
              //                         height: MediaQuery.of(context).size.height / 0.95,
              //                         child: dashboard.allParcelList.length == 0
              //                             ? Center(
              //                                 child: Text(
              //                                 'no_item_found'.tr,
              //                                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              //                               ))
              //                             : RefreshIndicator(
              //                                 displacement: 250,
              //                                 backgroundColor: Colors.yellow,
              //                                 color: Colors.red,
              //                                 strokeWidth: 3,
              //                                 onRefresh: () async {
              //                                   await Future.delayed(Duration(milliseconds: 1500));
              //                                   setState(() {
              //                                     dashboard.onInit();
              //                                   });
              //                                 },
              //                                 child: ListView.builder(
              //                                     itemCount: dashboard.allParcelList.length,
              //                                     shrinkWrap: true,
              //                                     padding: EdgeInsets.zero,
              //                                     itemBuilder: (BuildContext context, int index) {
              //                                       return InkWell(
              //                                         onTap: () {
              //                                           setState(() {
              //                                             showPopUp(dashboard.allParcelList[index]);
              //                                           });
              //                                         },
              //                                         child: Padding(
              //                                           padding: const EdgeInsets.only(bottom: 14.0),
              //                                           child: Container(
              //                                             height: 145.h,
              //                                             decoration: BoxDecoration(
              //                                               color: Colors.white,
              //                                               borderRadius: BorderRadius.circular(10),
              //                                               border: Border.all(width: 1, color: kMainColor),
              //                                             ),
              //                                             child: Row(
              //                                               children: [
              //                                                 Container(
              //                                                   margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
              //                                                   decoration: BoxDecoration(
              //                                                     borderRadius: BorderRadius.circular(50),
              //                                                     color: Colors.white,
              //                                                     image: DecorationImage(
              //                                                       image: AssetImage(Images.parcel),
              //                                                       fit: BoxFit.cover,
              //                                                     ),
              //                                                   ),
              //                                                   height: 60.h,
              //                                                   width: 60.w,
              //                                                 ),
              //                                                 Padding(
              //                                                   padding: const EdgeInsets.symmetric(vertical: 10.0),
              //                                                   child: Column(
              //                                                     crossAxisAlignment: CrossAxisAlignment.start,
              //                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                                                     children: [
              //                                                       Text(
              //                                                         dashboard.allParcelList[index].customerName.toString(),
              //                                                         style: const TextStyle(
              //                                                           fontWeight: FontWeight.w500,
              //                                                           fontSize: 14,
              //                                                           color: nameColor,
              //                                                         ),
              //                                                         maxLines: 2,
              //                                                         overflow: TextOverflow.ellipsis,
              //                                                       ),
              //                                                       Row(children: [
              //                                                         Text(
              //                                                           dashboard.allParcelList[index].customerPhone.toString(),
              //                                                           style: const TextStyle(
              //                                                             fontWeight: FontWeight.w400,
              //                                                             fontSize: 14,
              //                                                             color: hintColor,
              //                                                           ),
              //                                                           maxLines: 1,
              //                                                         ),
              //                                                         SizedBox(
              //                                                           width: 5,
              //                                                         ),
              //                                                         TextButton(
              //                                                           onPressed: () => launchURL(dashboard.allParcelList[index].customerPhone.toString()),
              //                                                           style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(50, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap, alignment: Alignment.centerLeft),
              //                                                           child: Row(
              //                                                             children: [
              //                                                               Icon(
              //                                                                 Icons.phone,
              //                                                                 color: Colors.green,
              //                                                                 size: 20,
              //                                                               ),
              //                                                               Text("Call me",
              //                                                                   style: TextStyle(
              //                                                                     fontWeight: FontWeight.w800,
              //                                                                     fontSize: 14,
              //                                                                     color: Colors.green,
              //                                                                   )),
              //                                                             ],
              //                                                           ),
              //                                                         ),
              //                                                       ]),
              //                                                       Row(
              //                                                         children: [
              //                                                           SizedBox(
              //                                                             width: 200.w,
              //                                                             child: Text(
              //                                                               dashboard.allParcelList[index].customerAddress.toString(),
              //                                                               style: const TextStyle(
              //                                                                 fontWeight: FontWeight.w400,
              //                                                                 fontSize: 12,
              //                                                                 color: hintColor,
              //                                                               ),
              //                                                               maxLines: 2,
              //                                                               overflow: TextOverflow.ellipsis,
              //                                                             ),
              //                                                           ),
              //                                                           SizedBox(
              //                                                             width: 5,
              //                                                           ),
              //                                                           TextButton(
              //                                                             onPressed: () {
              //                                                               var url = 'https://www.google.com/maps/dir/?api=1&origin=&destination=${dashboard.allParcelList[index].customerAddress.toString()}&travelmode=driving';
              //                                                               launchMapURL(Uri.parse(url));
              //                                                             },
              //                                                             style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(50, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap, alignment: Alignment.centerLeft),
              //                                                             child: Row(
              //                                                               children: [
              //                                                                 Text("Map",
              //                                                                     style: TextStyle(
              //                                                                       fontWeight: FontWeight.w800,
              //                                                                       fontSize: 14,
              //                                                                       color: kMainColor,
              //                                                                     )),
              //                                                                 Icon(
              //                                                                   Icons.location_on_outlined,
              //                                                                   color: kMainColor,
              //                                                                   size: 20,
              //                                                                 ),
              //                                                               ],
              //                                                             ),
              //                                                           ),
              //                                                         ],
              //                                                       ),
              //                                                       Row(
              //                                                         children: [
              //                                                           Text(
              //                                                             '${Get.find<GlobalController>().currency!}${dashboard.allParcelList[index].cashCollection.toString()}',
              //                                                             style: const TextStyle(
              //                                                               fontWeight: FontWeight.w400,
              //                                                               fontSize: 12,
              //                                                               color: hintColor,
              //                                                             ),
              //                                                           ),
              //                                                           SizedBox(width: 6),
              //                                                           Text(
              //                                                             '${dashboard.allParcelList[index].statusName.toString()}',
              //                                                             style: const TextStyle(
              //                                                               fontWeight: FontWeight.w400,
              //                                                               fontSize: 12,
              //                                                               color: hintColor,
              //                                                             ),
              //                                                           ),
              //                                                         ],
              //                                                       ),
              //                                                     ],
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                             ),
              //                                           ),
              //                                         ),
              //                                       );
              //                                     })),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //         ),
              //       )),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void showPopUp(parcel) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Card(
                        elevation: 10,
                        color: kSecondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            '${parcel.statusName}',
                            style: kTextStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'merchant'.tr,
                    style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    thickness: 1.0,
                    color: kGreyTextColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Text(
                        '${'shop_name'.tr}:',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${parcel.merchantName}',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        '${'phone'.tr}:',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${parcel.merchantMobile}',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        '${'pickup_address'.tr}:',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                    ],
                  ),
                  SizedBox(
                    width: 400,
                    child: Text(
                      '${parcel.merchantAddress}',
                      style: kTextStyle.copyWith(color: kGreyTextColor),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    'parcel_info'.tr,
                    style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    thickness: 1.0,
                    color: kGreyTextColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Text(
                        '${'tracking_id'.tr}:',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${parcel.trackingId}',
                        style: kTextStyle.copyWith(color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        '${'delivery_type'.tr}:',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${parcel.deliveryType}',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        '${'pickup_time'.tr}:',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${parcel.pickupDate}',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        '${'delivery_time'.tr}:',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${parcel.deliveryDate}',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        '${'total_charge_amount'.tr}:',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${Get.find<GlobalController>().currency!}${parcel.totalDeliveryAmount}',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        '${'vat_amount'.tr}:',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${Get.find<GlobalController>().currency!}${parcel.vatAmount}',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        '${'current_payable'.tr}:',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${Get.find<GlobalController>().currency!}${parcel.currentPayable}',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        '${'cash_collection'.tr}:',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${Get.find<GlobalController>().currency!}${parcel.cashCollection}',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Center(
                    child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(color: kMainColor, shape: BoxShape.circle),
                        child: const Icon(
                          FontAwesomeIcons.x,
                          color: kBgColor,
                        )).onTap(
                      () => finish(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void showStatusPopUp(Parcel parcel) {
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
                        fsDropdownItems.isEmpty
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
                                          items: fsDropdownItems,
                                          value: dashboardController.statusID,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dashboardController.statusID = newValue!;
                                              print(dashboardController.statusID);
                                              (context as Element).markNeedsBuild();
                                            });
                                          }),
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10.0),
                        dashboardController.statusID == '32' ? FormTitle(title: 'cash_collection_tk'.tr) : SizedBox().marginZero,
                        dashboardController.statusID == '32'
                            ? CustomFormField(
                                controller: dashboardController.cashController,
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
                                        dashboardController.avatarImage();
                                      },
                                      child: Icon(Icons.image)),
                                ],
                              ),
                              dashboardController.avatarFilename.isEmpty ? Text('') : Text("${dashboardController.avatarFilename}"),
                            ],
                          ),
                        ),
                        FormTitle(title: 'PickUp code'.tr),
                        TextFormField(
                          controller: dashboardController.pickUpCodeController.value,
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
                            controller: dashboardController.noteController,
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
                                  dashboardController.changeStatus(context, parcel.id.toString());
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

  void collectByDriverPopUp(parcel) {
    dashboardController.noteController.text = '';
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
                      fsDropdownItems.isEmpty
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
                                        items: fsPickupDropdownItemsCollectBydriver,
                                        value: dashboardController.collectByDriverStatusID,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dashboardController.collectByDriverStatusID = newValue;
                                          });
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
                          controller: dashboardController.noteController,
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

                                dashboardController.changeStatusWithOutSignature(
                                  context,
                                  dashboardController.collectByDriverStatusID,
                                  parcel.id.toString(),
                                );

                                Get.back();
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

  void showPickUpPopUp(Parcel parcel) {
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
                        fsPickupDropdownItems.isEmpty
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
                                          items: fsPickupDropdownItems,
                                          value: dashboardController.collectStatusID,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dashboardController.collectStatusID = newValue!;
                                            });
                                            print(dashboardController.collectStatusID);
                                            (context as Element).markNeedsBuild();
                                          }),
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10.0),
                        // dashboardController.statusID == '32' ? FormTitle(title: 'cash_collection_tk'.tr) : SizedBox().marginZero,
                        // dashboardController.statusID == '32'
                        //     ? CustomFormField(
                        //         controller: dashboardController.cashController,
                        //         validatorTxt: 'please_type_your_amount'.tr,
                        //       )
                        //     : SizedBox().marginZero,
                        // const SizedBox(height: 10.0),
                        FormTitle(title: 'note'.tr),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: dashboardController.noteController,
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
                                  dashboardController.changePickUpStatus(context, parcel.id.toString());
                                  Navigator.of(context).pop();
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
        });
  }
}
