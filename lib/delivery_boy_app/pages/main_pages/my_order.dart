import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import 'package:vff_group/delivery_boy_app/pages/orders_pages/cancelled_orders.dart';
import 'package:vff_group/delivery_boy_app/pages/orders_pages/completed_orders.dart';
import 'package:vff_group/delivery_boy_app/pages/orders_pages/current_orders.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
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
        backgroundColor: Colors.deepPurple,
        title: Text(
          'ORDERS',
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
          length: 3,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: width * 0.03,
              ),
              ButtonsTabBar(
                backgroundColor: Colors.deepPurple,
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
                    text: "Current Orders",
                  ),
                  Tab(
                    icon: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(Icons.done),
                    ),
                    text: "Dropped Orders",
                  ),
                  Tab(
                    icon: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(Icons.cancel),
                    ),
                    text: "Cancelled",
                  ),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: <Widget>[
                    CurrentOrdersPage(),
                    CompletedOrdersPage(),
                    CancelledOrderPage(),
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
