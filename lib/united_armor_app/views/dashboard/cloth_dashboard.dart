import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:vff_group/gym_app/views/diet_plans/diet_plans.dart';
import 'package:vff_group/gym_app/views/gym_fees_plans/gym_fees_plans.dart';
import 'package:vff_group/gym_app/views/setttings/settings.dart';
import 'package:vff_group/pages/main_pages/home.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/common/size_config.dart';
import 'package:vff_group/global/vffglb.dart' as glb;

import 'package:vff_group/united_armor_app/views/home/home_latest.dart';


import 'package:vff_group/united_armor_app/views/home/my_wishlist_page.dart';
import 'package:vff_group/united_armor_app/views/settings/settings_page.dart';

class ClothingDashboard extends StatefulWidget {
  const ClothingDashboard({super.key});

  @override
  State<ClothingDashboard> createState() => _ClothingDashboardState();
}

class _ClothingDashboardState extends State<ClothingDashboard> {
  int _currentIndex = 0;
  List pages = [
    const HOmeLatestPage(),
    
    const MyClothingWishListPage(),
    const ClothingSettingsPage()
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          height: 64,
          child: CustomNavigationBar(
            isFloating: true,
            borderRadius: const Radius.circular(40),
            selectedColor: kWhite,
            unSelectedColor: kGrey,
            backgroundColor: kBrown,
            strokeColor: Colors.transparent,
            scaleFactor: 0.1,
            iconSize: 40,
            items: [
               CustomNavigationBarItem(
                icon: glb.gymPageIndex == 0
                    ? SvgPicture.asset('assets/home_icon_selected.svg')
                    : SvgPicture.asset('assets/home_icon_unselected.svg'),
              ),
              CustomNavigationBarItem(
                icon: glb.gymPageIndex == 1
                    ? SvgPicture.asset('assets/cart_icon_selected.svg')
                    : SvgPicture.asset('assets/cart_icon_unselected.svg'),
              ),
              CustomNavigationBarItem(
                icon: glb.gymPageIndex == 2
                    ? SvgPicture.asset('assets/favorite_icon_selected.svg')
                    : SvgPicture.asset('assets/favorite_icon_unselected.svg'),
              ),
              CustomNavigationBarItem(
                icon: glb.gymPageIndex == 3
                    ? SvgPicture.asset('assets/account_icon_selected.svg')
                    : SvgPicture.asset('assets/account_icon_unselected.svg'),
              ),
            ],
            currentIndex: glb.gymPageIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                changeTab(index);
              });
            },
          ),
        ),
      );
    
  }
}


