import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

import '../../../Widgets/constant.dart';

class DrawerListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerListItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      leading: Icon(
        icon,
        color: kTitleColor,
        size: 18.0,
      ),
      title: Text(
        title.tr,
        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(FeatherIcons.chevronRight, color: kTitleColor, size: 18),
      ),
    );
  }
}
