import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/style.dart';
import '../constant.dart';
import '../profile_card.dart';
import '/utils/image.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmer extends StatefulWidget {
  const ProfileShimmer({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileShimmerState();
  }
}

class _ProfileShimmerState extends State<ProfileShimmer> {
  var mainHeight, mainWidth;
  String? phone, name, address;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              children: [
                SizedBox(
                  child: Column(children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        SizedBox(
                          width: 100.w,
                          height: 100.h,
                          child: Center(
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[400]!,
                              child: CircleAvatar(radius: 50.0),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 75,
                          right: 20,
                          child: InkWell(
                            child: SizedBox(
                              width: 30.w,
                              height: 30.h,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: SizedBox(
                                  width: 30.w,
                                  height: 30.h,
                                  child: CircleAvatar(
                                    backgroundColor: darkGray,
                                    child: Image.asset(
                                      Images.iconEdit,
                                      fit: BoxFit.cover,
                                      height: 22.h,
                                      width: 22.w,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 10),
                    Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[400]!,
                        child: Tracker(
                          trackNo: '0',
                          track: "progress".tr,
                        )),
                    SizedBox(width: 20),
                    Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[400]!,
                        child: Tracker(
                          trackNo: '0',
                          track: "delivered_completed".tr,
                        )),
                    SizedBox(width: 20),
                    Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[400]!,
                        child: Tracker(
                          trackNo: '0',
                          track: "canceled".tr,
                        )),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[400]!,
                        child: ProfileCard(
                          page: false,
                          topic: 'balance'.tr,
                          amount: '0.0',
                          imgUrl: Images.logo,
                          cardColor: kSecondaryColor,
                        )),
                    const SizedBox(
                      width: 7,
                    ),
                    Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[400]!,
                        child: ProfileCard(
                          page: true,
                          topic: "earning".tr,
                          amount: '0.00',
                          imgUrl: Images.logo,
                          cardColor: kMainColor,
                        )),
                    const SizedBox(
                      width: 7,
                    ),
                    Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[400]!,
                        child: ProfileCard(
                          page: true,
                          topic: "total_cod".tr,
                          amount: '0.00',
                          imgUrl: Images.logo,
                          cardColor: titleColor,
                        )),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  child: Column(
                    children: [
                      Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[400]!,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                Images.iconLogout,
                                height: 16.h,
                                width: 16.w,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                width: 16.h,
                              ),
                              Text(
                                "log_out".tr,
                                style: fontProfile,
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 14.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 90,
                ),
              ],
            ),
          ),
        ));
  }
}

class Tracker extends StatelessWidget {
  const Tracker({Key? key, required this.trackNo, required this.track}) : super(key: key);
  final String trackNo;
  final String track;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),

            spreadRadius: 3,
            blurRadius: 4,
            offset: const Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            trackNo,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            track,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
