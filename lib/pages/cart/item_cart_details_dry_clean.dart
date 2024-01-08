// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/modals/dry_clean_items_model.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

class ItemDetailsBottomSheet extends StatefulWidget {
  final DryCleanItemModel item;
  final String catID;
  final String categoryImage;
  final String categoryName;

  ItemDetailsBottomSheet(
      {required this.item,
      required this.catID,
      required this.categoryImage,
      required this.categoryName});

  @override
  State<ItemDetailsBottomSheet> createState() => _ItemDetailsBottomSheetState();
}

class _ItemDetailsBottomSheetState extends State<ItemDetailsBottomSheet> {
  var adultCount = 0;
  var kidsCount = 0;
  bool showLoading = false;

  var cat_id = "";
  var sub_cat_id = "";
  var quantity = "";
  var price = "";
  var customer_id = "";
  var order_id = "";
  var order_type = "";
  var adult_cost = 0.0;
  var kids_cost = 0.0;
  var total_price = 0.0;
  var total_quantity = 0;
  var cat_img = "";
  var cat_name = "";
  var sub_cat_name = "";
  var sub_cat_img = "";
  var actual_cost = "0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      cat_id = widget.catID;
      sub_cat_id = widget.item.subCategoryID;
      order_id = glb.orderid;
      order_type = "Dry Cleaning";
      cat_img = widget.categoryImage;
      cat_name = widget.categoryName;
      sub_cat_img = widget.item.subCategoryImage;
      sub_cat_name = widget.item.subCategoryName;
    });
  }

  Future addDryCleanItemToCart() async {
    setState(() {
      showLoading = true;
    });
    glb.prefs = await SharedPreferences.getInstance();

    var customrid = glb.prefs?.getString('customerid');
    print("customrid::$customrid");
    if (customrid != null) {
      customer_id = customrid;
    } else {
      glb.showSnackBar(
          context, 'Alert', 'Please use valid credentials and Login In Again');
      return;
    }

    if (adultCount == 0 && kidsCount == 0) {
      glb.showSnackBar(
          context, 'Alert', 'Please add anyone one category item quantity');
      return;
    }
    var actualAdultPrice = "0";
    var actualKidsPrice = "0";

    var adultResult = (double.parse(actualAdultPrice) * adultCount);
    if (adultCount != 0) {
      adult_cost = adultResult;
    }
    var kidsResult = (double.parse(actualKidsPrice) * kidsCount);
    if (kidsCount != 0) {
      kids_cost = kidsResult;
    }
    total_price = adult_cost + kids_cost;
    total_quantity = adultCount + kidsCount;
    try {
      var url = glb.endPoint;
      url+="add_laundry_items_to_cart/";
      final Map dictMap = {};

      dictMap['cat_id'] = cat_id;
      dictMap['sub_cat_id'] = sub_cat_id;
      dictMap['quantity'] = total_quantity;
      dictMap['price'] = total_price;
      dictMap['customer_id'] = customer_id;
      dictMap['order_id'] = order_id;
      dictMap['order_type'] = order_type;
      dictMap['adult_cost'] = adult_cost;
      dictMap['kids_cost'] = kids_cost;
      dictMap['adult_quantity'] = adultCount;
      dictMap['kids_quantity'] = kidsCount;
      dictMap['cat_img'] = cat_img;
      dictMap['cat_name'] = cat_name;
      dictMap['sub_cat_name'] = sub_cat_name;
      dictMap['sub_cat_img'] = sub_cat_img;
      dictMap['actual_cost'] = actual_cost;
      // dictMap['pktType'] = "14";
      // dictMap['token'] = "vff";
      // dictMap['uid'] = "-1";

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
          glb.showSnackBar(context, 'Success',
              '${widget.item.subCategoryName} Added Successfully to cart \n AdultCount:${adultCount}\nKidsCount${kidsCount}');

          Navigator.pop(context);
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlackColor,
      ),
      child: Wrap(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.item.subCategoryName,
                    style: nunitoStyle.copyWith(
                      color: AppColors.mainBlueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.network(
                      widget.item.subCategoryImage,
                      width: 30,
                      height: 30,
                      color: AppColors.blueColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.person_2_outlined,
                            color: AppColors.mainBlueColor,
                          ),
                        ),
                        Text(
                          "Adult ₹",
                          style: nunitoStyle.copyWith(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (adultCount > 0) {
                                  adultCount--; // Decrement adult count
                                }
                              });
                            },
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          adultCount.toString(),
                          style: nunitoStyle.copyWith(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green[700],
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                adultCount++; // Increment adult count
                              });
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.child_care,
                            color: AppColors.mainBlueColor,
                          ),
                        ),
                        Text(
                          "Kids ₹",
                          style: nunitoStyle.copyWith(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (kidsCount > 0) {
                                  kidsCount--; // Decrement kids count
                                }
                              });
                            },
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          kidsCount.toString(),
                          style: nunitoStyle.copyWith(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green[700],
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                kidsCount++; // Increment kids count
                              });
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          // Add to cart button
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
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
                            print(
                                'Added ${widget.item.subCategoryName} to cart.');

                            // Close the bottom sheet
                            addDryCleanItemToCart();
                            // Navigator.pop(context);
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
                                'Add To Cart',
                                style: nunitoStyle.copyWith(
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
    );
  }
}
