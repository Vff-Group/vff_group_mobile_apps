import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/pages/main_pages/cart.dart';
import 'package:vff_group/pages/main_pages/home.dart';
import 'package:vff_group/pages/main_pages/orders.dart';
import 'package:vff_group/pages/main_pages/prize_chart.dart';
import 'package:vff_group/pages/main_pages/profile.dart';
import 'package:vff_group/pages/main_pages/settings.dart';
import 'package:vff_group/providers/tabchangeprovider.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/global/vffglb.dart' as glb;

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key, required this.pageIndex});
 final int pageIndex ;
  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  

  

  @override
  void initState() {
    super.initState();
    glb.pageIndex = widget.pageIndex;
  }

  List pages = [
    const HomePage(),
    const CartPage(),
    const OrdersPage(),
    const SettingsPage(),
  ];

  void changeTab(int index) {
    setState(() {
      //widget.pageIndex = index;

      glb.pageIndex = index ;
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[glb.pageIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: AppColors.blueColor,
              iconSize: 24,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.shoppingCart,
                  text: 'Cart',
                ),
                GButton(
                  icon: LineIcons.moon,
                  text: 'Orders',
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                ),
              ],
              selectedIndex: glb.pageIndex,
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
