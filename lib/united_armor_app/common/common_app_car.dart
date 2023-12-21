import 'package:flutter/material.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';

class CommonAppBar extends StatefulWidget {
  const CommonAppBar({super.key});

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
          backgroundColor: kDarkBrown,
          centerTitle: true,
          leading: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, MenuRoute);
              },
              borderRadius: BorderRadius.circular(50),
              child: Ink(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: kDarkBrown,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      "assets/icons/menu_arrow.png",
                      fit: BoxFit.fill,
                    ),
                  )),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  // Navigator.pushNamed(context, NotificationScreenRoute);
                },
                icon: Image.asset(
                  "assets/icons/notification_icon.png",
                  width: 25,
                  height: 25,
                  color: Colors.white,
                  fit: BoxFit.fitHeight,
                ))
          ],
          title: IconButton(
              onPressed: () {
                // Navigator.pushNamed(context, NotificationScreenRoute);
              },
              icon: Image.asset(
                "assets/logo/logo_united_armor.png",
                fit: BoxFit.fitHeight,
              )),
        );
 
  }
}