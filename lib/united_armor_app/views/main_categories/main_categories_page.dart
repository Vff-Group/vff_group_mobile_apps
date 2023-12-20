import 'package:flutter/material.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';

class MainCategoryPage extends StatefulWidget {
  const MainCategoryPage({super.key});

  @override
  State<MainCategoryPage> createState() => _MainCategoryPageState();
}

class _MainCategoryPageState extends State<MainCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
    ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (){
              
                  },
                        borderRadius: BorderRadius.circular(50),
                  child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: kDarkBrown,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/icons/menu_arrow.png",
                          width: 15,
                          height: 15,
                          fit: BoxFit.fitHeight,
                        ),
                      )),
                ),
              ),
              IconButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, NotificationScreenRoute);
                  },
                  icon: Image.asset(
                    "assets/logo/logo_united_armor.png",
                    fit: BoxFit.fitHeight,
                  )),
              IconButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, NotificationScreenRoute);
                  },
                  icon: Image.asset(
                    "assets/icons/notification_icon.png",
                    width: 25,
                    height: 25,
                    fit: BoxFit.fitHeight,
                  ))
              // const CircleAvatar(
              //   radius: 20,
              //   backgroundColor: kGrey,
              //   backgroundImage: NetworkImage(
              //       'https://randomuser.me/api/portraits/men/90.jpg'),
              // )
            ],
          ),
        ),
         
      ],
    ));
  }
}