import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/gym_app/views/diet_plans/diet_plans.dart';
import 'package:vff_group/gym_app/views/gym_fees_plans/gym_fees_plans.dart';
import 'package:vff_group/gym_app/views/home/home.dart';
import 'package:vff_group/gym_app/views/setttings/settings.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import '../../common_widgets/gradient_icons.dart';

class DashboardGymScreen extends StatefulWidget {
  const DashboardGymScreen({super.key, required this.pageIndex});
final int pageIndex;
  @override
  State<DashboardGymScreen> createState() => _DashboardGymScreenState();
}

class _DashboardGymScreenState extends State<DashboardGymScreen> {
  int selectTab = 0;
@override
  void initState() {
    // TODO: implement initState
    
     glb.gymPageIndex = widget.pageIndex;
  }
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const AllGymPlansScreen(),
    const DietPlanScreen(),
    const SettingsGym()
  ];
var pageIndex = 0;
List pages = [
    const HomeScreen(),
    const AllGymPlansScreen(),
    const DietPlanScreen(),
    const SettingsGym()
  ];
  void changeTab(int index) {
    setState(() {
      //widget.pageIndex = index;

      glb.gymPageIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[glb.gymPageIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: AppColors.whiteColor.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: AppColors.whiteColor,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppColors.primaryColor1,
              color: AppColors.primaryColor1,
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                // GButton(
                //   icon: LineIcons.bomb,
                //   text: 'Offers',
                // ),
                GButton(
                  icon: LineIcons.chalkboardTeacher,
                  text: 'Plans',
                ),
                GButton(
                  icon: LineIcons.delicious,
                  text: 'Diet',
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                ),
              ],
              selectedIndex: glb.gymPageIndex,
              onTabChange: (index) {
                changeTab(index);
              },
            ),
          ),
        ),
      ),
    );
  
  }
}

class TabButton extends StatelessWidget {
  final String icon;
  final String selectIcon;
  final bool isActive;
  final VoidCallback onTap;
  final IconData? iconData;
  const TabButton(
      {Key? key,
      required this.icon,
      required this.selectIcon,
      required this.isActive,
      required this.onTap,
      this.iconData})
      : super(key: key);

  Color? getColorFromObject(dynamic object) {
    if (object is Color) {
      return object; // If the object is already a Color, return it
    } else {
      // Handle conversion from the object to a Color
      // For example, you might parse a string representing a color
      // and return a Color object
      return Colors.red; // Default color if conversion fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconData != null
              ? GradientIcon(
                  icon: iconData!,
                  gradientColors: isActive ? AppColors.secondaryG : [AppColors.midGrayColor,AppColors.midGrayColor], // Replace with your desired gradient colors
                  size: isActive ? 30 : 25, // Adjust the size of the icon as needed
                )
              : Image.asset(
                  isActive ? selectIcon : icon,
                  width: 25,
                  height: 25,
                  fit: BoxFit.fitWidth,
                ),
          SizedBox(height: isActive ? 8 : 12),
          Visibility(
            visible: isActive,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.secondaryG),
                  borderRadius: BorderRadius.circular(2)),
            ),
          )
        ],
      ),
    );
  }
}
