import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vff_group/modals/cart_item_model.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:http/http.dart' as http;
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:vff_group/widgets/shimmer_card.dart';

class AddToCartItem extends StatefulWidget {
  const AddToCartItem({super.key});

  @override
  State<AddToCartItem> createState() => _AddToCartItemState();
}

class _AddToCartItemState extends State<AddToCartItem> {
  bool _noItems = false, showLoading = true;
  List<CartItemModel> cartItemModel = [];

  Future loadCartItems() async {
    setState(() {
      showLoading = true;
      cartItemModel = [];
    });
    final prefs = await SharedPreferences.getInstance();
    var customerid = prefs.getString('customerid');

    var todaysDate = glb.getDateTodays();
    try {
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['customer_id'] = customerid;
      dictMap['pktType'] = "15";
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
          setState(() {
            showLoading = false;
            _noItems = true;
          });
          //glb.showSnackBar(context, 'Error', 'No Category Details Found');
          //Navigator.pop(context);
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showLoading = false;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          //Navigator.pop(context);
          return;
        } else {
          try {
            Map<String, dynamic> cartMap = json.decode(response.body);

            var itemID = cartMap['itemid'];
            var categoryID = cartMap['catid'];
            var subCategoryID = cartMap['subcatid'];
            var totalQuantity = cartMap['total_quantity'];
            var totalPrice = cartMap['total_price'];
            var orderID = cartMap['order_id'];
            var date = cartMap['date'];
            var time = cartMap['time'];
            var orderType = cartMap['order_type'];
            var totalAdultCost = cartMap['total_adult_cost'];
            var totalKidsCost = cartMap['total_kids_cost'];
            var categoryImage = cartMap['category_img'];
            var categoryName = cartMap['category_name'];
            var subCategoryName = cartMap['sub_cat_name'];
            var subCategoryImage = cartMap['sub_cat_img'];
            var regularPrice = cartMap['regular_price'];
            var expressPrice = cartMap['express_price'];
            var offerPrice = cartMap['offer_price'];
            var dryCleaningAdultCost = cartMap['dry_adult_cost'];
            var actualCost = cartMap['actual_cost'];

            List<String> itemIDlst = glb.strToLst2(itemID);
            List<String> categoryIDst = glb.strToLst2(categoryID);
            List<String> subCategoryIDlst = glb.strToLst2(subCategoryID);
            List<String> totalQuantitylst = glb.strToLst2(totalQuantity);
            List<String> totalPricelst = glb.strToLst2(totalPrice);
            List<String> orderIDlst = glb.strToLst2(orderID);
            List<String> datelst = glb.strToLst2(date);
            List<String> timelst = glb.strToLst2(time);
            List<String> orderTypelst = glb.strToLst2(orderType);
            List<String> totalAdultCostlst = glb.strToLst2(totalAdultCost);
            List<String> totalKidsCostlst = glb.strToLst2(totalKidsCost);
            List<String> categoryImagelst = glb.strToLst2(categoryImage);
            List<String> categoryNamelst = glb.strToLst2(categoryName);
            List<String> subCategoryNamelst = glb.strToLst2(subCategoryName);
            List<String> subCategoryImagelst = glb.strToLst2(subCategoryImage);
            List<String> actualCostlst = glb.strToLst2(actualCost);

            for (int i = 0; i < itemIDlst.length; i++) {
              var itemID = itemIDlst.elementAt(i).toString();
              var categoryID = categoryIDst.elementAt(i).toString();
              var subCategoryID = subCategoryIDlst.elementAt(i).toString();
              var totalQuantity = totalQuantitylst.elementAt(i).toString();
              var totalPrice = totalPricelst.elementAt(i).toString();
              var orderID = orderIDlst.elementAt(i).toString();
              var date = datelst.elementAt(i).toString();
              var time = timelst.elementAt(i).toString();
              var orderType = orderTypelst.elementAt(i).toString();
              var totalAdultCost = totalAdultCostlst.elementAt(i).toString();
              var totalKidsCost = totalKidsCostlst.elementAt(i).toString();
              var categoryImage = categoryImagelst.elementAt(i).toString();
              var categoryName = categoryNamelst.elementAt(i).toString();
              var subCategoryName = subCategoryNamelst.elementAt(i).toString();
              var subCategoryImage =
                  subCategoryImagelst.elementAt(i).toString();
              var actualCost = actualCostlst.elementAt(i).toString();

              var timeFormatted =
                  glb.doubleEpochToFormattedDateTime(double.parse(time));
              cartItemModel.add(CartItemModel(
                  itemID: itemID,
                  categoryID: categoryID,
                  subCategoryID: subCategoryID,
                  totalQuantity: totalQuantity,
                  totalPrice: totalPrice,
                  orderID: orderID,
                  date: date,
                  time: timeFormatted,
                  orderType: orderType,
                  totalAdultCost: totalAdultCost,
                  totalKidsCost: totalKidsCost,
                  categoryImage: categoryImage,
                  categoryName: categoryName,
                  subCategoryName: subCategoryName,
                  subCategoryImage: subCategoryImage,
                  actualCost: actualCost));
            }
            setState(() {
              showLoading = false;
              _noItems = false;
            });
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
            setState(() {
              showLoading = false;
            });
            return "Failed";
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        showLoading = false;
      });
      glb.handleErrors(e, context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Cart',
          style: ralewayStyle.copyWith(
            color: AppColors.whiteColor,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: _noItems
          ? Center(
              child: Text(
                'No Laundry Items Found',
                style: ralewayStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: AppColors.whiteColor),
              ),
            )
          : Stack(
              children: [
                Column(
                  children: [
                    showLoading
                        ? Expanded(
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.2),
                              highlightColor: Colors.grey.withOpacity(0.1),
                              enabled: showLoading,
                              child: ListView.separated(
                                  itemCount: 10,
                                  separatorBuilder: (context, _) =>
                                      SizedBox(height: height * 0.02),
                                  itemBuilder: ((context, index) {
                                    return const ShimmerCardLayout();
                                  })),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: cartItemModel.length,
                                itemBuilder: ((context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          //Navigator.pushNamed(context, OrderDetailsRoute);
                                        },
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Ink(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              color: AppColors.lightBlackColor
                                              // Container color
                                              ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0),
                                                      child: Image.network(
                                                        cartItemModel[index]
                                                            .categoryImage,
                                                        width: 25,
                                                        height: 25,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    cartItemModel[index]
                                                        .categoryName,
                                                    style:
                                                        ralewayStyle.copyWith(
                                                      color:
                                                          AppColors.whiteColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 2.0),
                                                child: Container(
                                                  width: width,
                                                  height: 0.1,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        color: Colors.white,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Image.network(
                                                          cartItemModel[index]
                                                              .subCategoryImage,
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        cartItemModel[index]
                                                            .subCategoryName,
                                                        style: ralewayStyle
                                                            .copyWith(
                                                          color: AppColors
                                                              .whiteColor,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        cartItemModel[index]
                                                            .totalPrice,
                                                        style: nunitoStyle
                                                            .copyWith(
                                                          color: AppColors
                                                              .textColor,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .delete_sweep_rounded,
                                                            color: Colors.red,
                                                          ),
                                                           Text(
                                                        'Remove',
                                                        style: nunitoStyle
                                                            .copyWith(
                                                          color: Colors
                                                              .red[500],
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                })),
                          ),
                  ],
                ),
                Positioned(
                  bottom: 30.0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
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
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50.0, vertical: 10.0),
                                      child: Text(
                                        'Proceed',
                                        style: ralewayStyle.copyWith(
                                            fontSize: 16.0,
                                            letterSpacing: 1,
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
                ),
              ],
            ),
    );
  }
}
