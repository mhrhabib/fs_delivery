import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fs_delivery/fsSpotApp/home/fs_spot_home.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../Controllers/global-controller.dart';
import '../../../Payment/payment.dart';
import '../../../Payment/payment_parcel_history.dart';
import '../../../Profile/profile.dart';
import '../../../Widgets/constant.dart';
import '../../barcode.dart';
import '../widgets/drawer_list_item.dart';
import '../widgets/user_info.dart';

class RefactoredDrawer extends StatelessWidget {
  const RefactoredDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kBgColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50.0),
              UserInfo(),
              DrawerListItem(
                icon: FontAwesomeIcons.house,
                title: 'dashboard',
                onTap: () => const FsSpotHome().launch(context),
              ),
              DrawerListItem(
                icon: FontAwesomeIcons.user,
                title: 'profile',
                onTap: () => const Profile().launch(context),
              ),
              storage.read('userType') == 'deliveryman'
                  ? DrawerListItem(
                      icon: FontAwesomeIcons.list,
                      title: 'payment_log',
                      onTap: () => const PaymentPage().launch(context),
                    )
                  : SizedBox.shrink(),
              storage.read('userType') == 'deliveryman'
                  ? DrawerListItem(
                      icon: Icons.document_scanner,
                      title: 'Barcode Scanner',
                      onTap: () => const BarcodeParcel().launch(context),
                    )
                  : DrawerListItem(
                      icon: Icons.document_scanner,
                      title: 'Barcode Scanner',
                      onTap: () => const SpotBarcodeParcel().launch(context),
                    ),
              storage.read('userType') == 'deliveryman'
                  ? DrawerListItem(
                      icon: FontAwesomeIcons.clipboardList,
                      title: 'parcel_payment_history',
                      onTap: () => const PaymentParcelHistoryPage().launch(context),
                    )
                  : SizedBox.shrink(),
              DrawerListItem(
                icon: Icons.exit_to_app,
                title: 'log_out',
                onTap: () {
                  Get.find<GlobalController>().userLogout();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
