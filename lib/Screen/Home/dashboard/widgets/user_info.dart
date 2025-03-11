import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Controllers/global-controller.dart';
import '../../../Widgets/constant.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final globalController = Get.find<GlobalController>();
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: kMainColor,
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: globalController.userImage == null ? 'images/profile.png' : globalController.userImage.toString(),
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: 25.0,
              backgroundImage: imageProvider,
              backgroundColor: Colors.transparent,
            ),
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[400]!,
              child: CircleAvatar(radius: 25.0),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                globalController.userName == null
                    ? Text('')
                    : Text(
                        globalController.userName.toString(),
                        style: kTextStyle.copyWith(color: kBgColor, fontWeight: FontWeight.bold),
                      ),
                globalController.userEmail == null
                    ? Text('')
                    : Text(
                        globalController.userEmail.toString(),
                        style: kTextStyle.copyWith(color: kBgColor),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
