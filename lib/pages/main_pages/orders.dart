import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tab_container/tab_container.dart';
import 'package:vff_group/pages/orders_pages/cancelled_order.dart';
import 'package:vff_group/pages/orders_pages/completed_order.dart';
import 'package:vff_group/pages/orders_pages/ongoing_order.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
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
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('Orders',
                  style: ralewayStyle.copyWith(
                      fontSize: 20.0,
                      color: AppColors.blueColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1)),
            ),
            ButtonsTabBar(
              backgroundColor: AppColors.blueColor,
              unselectedBackgroundColor: Colors.grey[300],
              unselectedLabelStyle: TextStyle(color: AppColors.textColor),
              labelStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  icon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(Icons.delivery_dining_sharp),
                  ),
                  text: "Ongoing",
                ),
                Tab(
                  icon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(Icons.done),
                  ),
                  text: "Completed",
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
                  OngoingOrders(),
                  CompletedOrders(),
                  CancelledOrders(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
