import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import 'package:vff_group/delivery_boy_app/pages/current_pages/DropOrdersPage.dart';
import 'package:vff_group/delivery_boy_app/pages/current_pages/PickupOrdersPage.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class MyAssignedOrdersPage extends StatefulWidget {
  const MyAssignedOrdersPage({super.key});

  @override
  State<MyAssignedOrdersPage> createState() => _MyAssignedOrdersPageState();
}

class _MyAssignedOrdersPageState extends State<MyAssignedOrdersPage> {
   late final TabContainerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabContainerController(length: 3);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrange,
        title: Text(
          'Assigned Orders',
          style: nunitoStyle.copyWith(
            color: AppColors.whiteColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: width * 0.03,
              ),
              ButtonsTabBar(
                backgroundColor: Colors.deepOrange,
                unselectedBackgroundColor: AppColors.lightBlackColor,
                unselectedLabelStyle: TextStyle(color: AppColors.textColor),
                labelStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(
                    icon: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(Icons.delivery_dining_sharp),
                    ),
                    text: "Pickup Orders",
                  ),
                  Tab(
                    icon: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(Icons.pin_drop),
                    ),
                    text: "Delivery Orders",
                  ),
                  
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: <Widget>[
                    PickupOrdersPage(),
                    DropOrdersPage(),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}