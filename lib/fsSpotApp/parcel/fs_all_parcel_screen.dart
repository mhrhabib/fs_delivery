import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_delivery/fsSpotApp/controllers/fs_spot_dashboard_controller.dart';
import 'package:get/get.dart';
import '../../Controllers/global-controller.dart';
import '../../Screen/Home/dashboard/launch_methods.dart';
import '../../Screen/Widgets/constant.dart';
import '../../utils/image.dart';

class FsAllParcelScreen extends StatefulWidget {
  const FsAllParcelScreen({super.key});

  @override
  State<FsAllParcelScreen> createState() => _FsAllParcelScreenState();
}

class _FsAllParcelScreenState extends State<FsAllParcelScreen> {
  final FsSpotDashboardController dashboard = Get.put(FsSpotDashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'All Parcels'.tr,
          style: kTextStyle.copyWith(color: kBgColor, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        titleSpacing: 25,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: kBgColor),
      ),
      body: RefreshIndicator(
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
                  ? Center(
                      child: CircularProgressIndicator(
                        color: kMainColor,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 18),
                            //padding: const EdgeInsets.only(bottom: 250),
                            height: MediaQuery.of(context).size.height / 0.95,
                            child: dashboard.allParcelList.length == 0
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
                                        itemCount: dashboard.allParcelList.length,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (BuildContext context, int index) {
                                          return InkWell(
                                            onTap: () {},
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
                                                      height: 60.h,
                                                      width: 60.w,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            dashboard.allParcelList[index].customerName.toString(),
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
                                                              dashboard.allParcelList[index].customerPhone.toString(),
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
                                                              onPressed: () => launchURL(dashboard.allParcelList[index].customerPhone.toString()),
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
                                                                  dashboard.allParcelList[index].customerAddress.toString(),
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
                                                                  var url = 'https://www.google.com/maps/dir/?api=1&origin=&destination=${dashboard.allParcelList[index].customerAddress.toString()}&travelmode=driving';
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
                                                                '${Get.find<GlobalController>().currency!}${dashboard.allParcelList[index].cashCollection.toString()}',
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 12,
                                                                  color: hintColor,
                                                                ),
                                                              ),
                                                              SizedBox(width: 6),
                                                              Text(
                                                                '${dashboard.allParcelList[index].statusName.toString()}',
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
    );
  }
}
