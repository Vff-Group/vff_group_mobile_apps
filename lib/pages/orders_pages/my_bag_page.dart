import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:vff_group/pages/cart/dry_clean_cart_page.dart';
import 'package:vff_group/pages/orders_pages/cancelled_order.dart';
import 'package:vff_group/pages/orders_pages/completed_order.dart';
import 'package:vff_group/pages/orders_pages/ongoing_order.dart';
import 'package:vff_group/pages/orders_pages/place_new_order.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;

class MyBagPage extends StatefulWidget {
  const MyBagPage({super.key});

  

  @override
  State<MyBagPage> createState() => _MyBagPageState();
  
}


class _MyBagPageState extends State<MyBagPage> {

  void updateQuantity(String newQuantity) {
    // Update the quantity value
    setState(() {
      glb.cartQuantity = newQuantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        backgroundColor: AppColors.blueColor,
        title: Text('My Bag',
        style: ralewayStyle.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: <Widget>[
             SizedBox(height: width * 0.01,),
              ButtonsTabBar(
                backgroundColor: AppColors.blueColor,
                unselectedBackgroundColor: Colors.grey[300],
                unselectedLabelStyle: const TextStyle(color: AppColors.textColor),
                labelStyle:
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(
                    icon: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.delivery_dining_sharp),
                    ),
                    text: "Wash and Fold",
                  ),
                  Tab(
                    icon: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.done),
                    ),
                    text: "Dry Clean",
                  ),
                  Tab(
                    icon: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.cancel),
                    ),
                    text: "Wash and Iron",
                  ),
                ],
              ),
               Expanded(
                child: TabBarView(
                  children: <Widget>[
                    PlaceOrderPage(updateQuantity: updateQuantity),
                    DryCleaningCart(),
                    PlaceOrderPage(updateQuantity: updateQuantity),
                  ],
                ),
              ),
              Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(14.0),topRight: Radius.circular(14.0)),
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset:
                          Offset(0, 3), // changes the position of the shadow
                    ),
                  ],
                ), // Set your desired color
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: AppColors.whiteColor),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.local_laundry_service_rounded,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Items',
                                      style: ralewayStyle.copyWith(
                                          fontSize: 14.0,
                                          color: AppColors.textColor),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      '4 Items',
                                      style: nunitoStyle.copyWith(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cost',
                                  style: ralewayStyle.copyWith(
                                      fontSize: 14.0,
                                      color: AppColors.textColor),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  '₹${glb.cartQuantity}',
                                  style: nunitoStyle.copyWith(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, CheckOutRoute);
                              },
                              borderRadius: BorderRadius.circular(12.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    color: AppColors.blueColor,
                                    borderRadius: BorderRadius.circular(12.0)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0, vertical: 10.0),
                                  child: Text(
                                    'Checkout',
                                    style: ralewayStyle.copyWith(
                                        fontSize: 16.0,
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleLayout extends StatelessWidget {
  const _TitleLayout({
    Key? key,
    required this.width,
  }) : super(key: key);
  final double width;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(12.0),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.blueDarkColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          'My Bags',
          style: nunitoStyle.copyWith(
            color: AppColors.blueDarkColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer()
      ],
    );
  }
}
