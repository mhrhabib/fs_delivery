import 'package:bottom_bar/bottom_bar.dart';
import 'package:fs_delivery/fsSpotApp/dashboard/fs_spot_dashboard.dart';
import 'package:fs_delivery/fsSpotApp/parcel/fs_all_parcel_screen.dart';
import '../../Screen/Widgets/constant.dart';
import '/Screen/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class FsSpotHome extends StatefulWidget {
  const FsSpotHome({super.key});

  @override
  State<FsSpotHome> createState() => _FsSpotHome();
}

class _FsSpotHome extends State<FsSpotHome> {
  bool isSelected = true;
  int _currentPage = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    FsSpotDashboard(),
    FsAllParcelScreen(),
    // PaymentParcelHistoryPage(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: _widgetOptions.elementAt(_currentPage),
      bottomNavigationBar: BottomBar(
        backgroundColor: Color(0xFFf9f9fe),
        items: [
          /// Home
          BottomBarItem(
            icon: const Icon(FontAwesomeIcons.house, size: 16.0),
            title: Text(
              "home".tr,
              style: kTextStyle.copyWith(color: kGreyTextColor),
            ),
            activeColor: kGreyTextColor,
            inactiveColor: kTitleColor,
          ),

          /// History
          BottomBarItem(
            icon: const Icon(FontAwesomeIcons.clipboardList, size: 16.0),
            title: Text(
              "Parcels".tr,
              style: kTextStyle.copyWith(color: kGreyTextColor),
            ),
            activeColor: kGreyTextColor,
            inactiveColor: kTitleColor,
          ),

          /// Orders
          // BottomBarItem(
          //   backgroundColorOpacity: 0.1,
          //   icon: const Icon(
          //     FontAwesomeIcons.paperPlane,
          //     size: 16.0,
          //   ),
          //   title: Text(
          //     "parcel_payment_history".tr,
          //     style: kTextStyle.copyWith(color: kGreyTextColor),
          //   ),
          //   activeColor: kGreyTextColor,
          //   inactiveColor: kTitleColor,
          // ),

          /// Profile
          BottomBarItem(
            icon: Icon(FontAwesomeIcons.user, size: 16.0),
            title: Text("profile".tr),
            activeColor: kGreyTextColor,
            inactiveColor: kTitleColor,
          ),
        ],
        onTap: (int index) {
          setState(() => _currentPage = index);
        },
        selectedIndex: _currentPage,
      ),
    );
  }
}
