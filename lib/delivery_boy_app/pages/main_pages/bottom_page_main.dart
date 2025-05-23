import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:vff_group/delivery_boy_app/pages/main_pages/current_delivery.dart';
import 'package:vff_group/delivery_boy_app/pages/main_pages/dashboard.dart';
import 'package:vff_group/delivery_boy_app/pages/main_pages/my_assigned_order.dart';
import 'package:vff_group/delivery_boy_app/pages/main_pages/my_order.dart';
import 'package:vff_group/delivery_boy_app/pages/main_pages/my_profile.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:vff_group/utils/app_colors.dart';

class BottomBarDeliveryBoy extends StatefulWidget {
  const BottomBarDeliveryBoy({super.key, required this.pageDIndex});
  final int pageDIndex;
  @override
  State<BottomBarDeliveryBoy> createState() => _BottomBarDeliveryBoyState();
}

class _BottomBarDeliveryBoyState extends State<BottomBarDeliveryBoy> {
  @override
  void initState() {
    super.initState();
    glb.pageDIndex = widget.pageDIndex;
  }

  List pages = [
    const DashboardPage(),
    const MyAssignedOrdersPage(),
    // const MyOrdersPage(),
    const MyProfilePage(),
  ];

  void changeTab(int index) {
    setState(() {
      //widget.pageIndex = index;

      glb.pageDIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[glb.pageDIndex],
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
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 4,
              activeColor: Colors.deepPurple,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppColors.lightBlackColor,
              color: Colors.deepPurple[300],
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                  text: 'Dashboard',
                ),
                GButton(
                  icon: LineIcons.truck,
                  text: 'Delivery',
                ),
                // GButton(
                //   icon: LineIcons.clock,
                //   text: 'Orders',
                // ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                ),
              ],
              selectedIndex: glb.pageDIndex,
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
