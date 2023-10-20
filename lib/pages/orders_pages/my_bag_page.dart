import 'dart:convert';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:http/http.dart' as http;

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

  List<String> catIdLst = [];
  List<String> catNameLst = [];
  List<String> catImgLst = [];
  List<String> regularPricelst = [];
  List<String> regularPriceTypelst = [];
  List<String> expressPricelst = [];
  List<String> expressPriceTypeLst = [];
  List<String> offerPriceLst = [];
  List<String> offerPriceTypeLst = [];
  List<String> descriptionLst = [];
  List<String> minHoursLst = [];

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initState is called');
    allCategoryAsync();
  }

  Future allCategoryAsync() async {
    setState(() {
      catIdLst = [];
      catNameLst = [];
      catImgLst = [];
      regularPricelst = [];
      regularPriceTypelst = [];
      expressPricelst = [];
      expressPriceTypeLst = [];
      offerPriceLst = [];
      offerPriceTypeLst = [];
      descriptionLst = [];
      minHoursLst = [];
      isLoading = true;
    });
    try {
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['pktType'] = "2";
      dictMap['token'] = "vff";
      dictMap['uid'] = "-1";

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            "Accept": "application/json",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(dictMap));

      if (response.statusCode == 200) {
        var res = response.body;
        if (res.contains("ErrorCode#2")) {
          glb.showSnackBar(context, 'Error', 'No Categories Found');

          return;
        } else if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> catMap = json.decode(response.body);
            // if (kDebugMode) {
            //   print("categoryMap:$catMap");
            // }
            var catid = catMap['catid'];
            var catname = catMap['catname'];
            var catimg = catMap['catimg'];
            var regularPrice = catMap['regular_price'];
            var regularPriceType = catMap['regular_price_type'];
            var expressPrice = catMap['express_price'];
            var expressPriceType = catMap['express_price_type'];
            var offerPrice = catMap['offer_price'];
            var offerPriceType = catMap['offer_price_type'];
            var description = catMap['description'];
            var minHours = catMap['min_hours'];

            catIdLst = glb.strToLst2(catid);
            catNameLst = glb.strToLst2(catname);
            catImgLst = glb.strToLst2(catimg);
            regularPricelst = glb.strToLst2(regularPrice);
            regularPriceTypelst = glb.strToLst2(regularPriceType);
            expressPricelst = glb.strToLst2(expressPrice);
            expressPriceTypeLst = glb.strToLst2(expressPriceType);
            offerPriceLst = glb.strToLst2(offerPrice);
            offerPriceTypeLst = glb.strToLst2(offerPriceType);
            descriptionLst = glb.strToLst2(description);
            minHoursLst = glb.strToLst2(minHours);

            setState(() {
              isLoading = false;
            });
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
            return "Failed";
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      glb.handleErrors(e, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Bag',
          style: ralewayStyle.copyWith(
            color: AppColors.whiteColor,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  //Navigator.pushNamed(context, CheckOutRoute);
                  Navigator.pushNamed(context, MyCartRoute);
                },
                child: const Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                )),
          )
        ],
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : DefaultTabController(
                length: catIdLst.length,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: width * 0.01,
                    ),
                    ButtonsTabBar(
                      backgroundColor: AppColors.blueColor,
                      unselectedBackgroundColor: AppColors.lightBlackColor,
                      unselectedLabelStyle:
                          nunitoStyle.copyWith(color: AppColors.whiteColor),
                      labelStyle: nunitoStyle.copyWith(color: AppColors.whiteColor),
                      tabs: catNameLst.asMap().entries.map((entry) {
                        int index = entry.key;
                        String catName = entry.value;
                        String catId = catIdLst[index];
                        catName = catNameLst[index];
                        String catImage = catImgLst[index];

                        Tab tabBar;
                        if (catName == 'DRY CLEAN') {
                          tabBar = Tab(
                            icon: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Image.network(
                                    catImage,
                                    width: 50,
                                    height: 50,
                                  )),
                            ),
                            text: catName,
                            // Pass the catId to the Tab
                          );
                        } else {
                          tabBar = Tab(
                            icon: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Image.network(
                                    catImage,
                                    width: 50,
                                    height: 50,
                                  )),
                            ),
                            text: catName,
                            // Pass the catId to the Tab
                          );
                        }
                        return tabBar;
                      }).toList(),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: catIdLst.asMap().entries.map<Widget>((entry) {
                          int index = entry.key;
                          String catId = entry.value;
                          String catName = catNameLst[index];
                          String catImage = catImgLst[index];
                          catId = catIdLst[index];

                          Widget categoryScreen;
                          if (catName == 'DRY CLEAN') {
                            categoryScreen = DryCleaningCart(
                                catId: catId,
                                catName: catName,
                                catImage: catImage);
                          } else {
                            categoryScreen = PlaceOrderPage(
                              updateQuantity: updateQuantity,
                              catId: catId,
                            );
                          }

                          return categoryScreen;
                        }).toList(),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(12.0),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Column(
                    //       children: [
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Material(
                    //               color: Colors.transparent,
                    //               child: InkWell(
                    //                 onTap: () {
                    //                   // Navigator.pushNamed(
                    //                   //     context, CheckOutRoute);
                    //                 },
                    //                 borderRadius: BorderRadius.circular(12.0),
                    //                 child: Ink(
                    //                   decoration: BoxDecoration(
                    //                     color: AppColors.blueColor,
                    //                     borderRadius:
                    //                         BorderRadius.circular(12.0),
                    //                   ),
                    //                   child: Padding(
                    //                     padding: const EdgeInsets.symmetric(
                    //                         horizontal: 50.0, vertical: 10.0),
                    //                     child: Text(
                    //                       'Add To Cart',
                    //                       style: ralewayStyle.copyWith(
                    //                           fontSize: 16.0,
                    //                           color: AppColors.whiteColor,
                    //                           fontWeight: FontWeight.bold),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             )
                    //           ],
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
