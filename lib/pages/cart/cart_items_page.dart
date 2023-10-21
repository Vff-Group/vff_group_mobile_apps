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
      dictMap['order_id'] = glb.orderid;
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

            var orderID = cartMap['order_id'];
            var date = cartMap['date'];
            var time = cartMap['time'];
            var orderType = cartMap['order_type'];
            var itemCost = cartMap['item_cost'];
            var itemQuantity = cartMap['item_quantity'];
            var typeOf = cartMap['type_of'];
            var categoryImage = cartMap['category_img'];
            var categoryName = cartMap['category_name'];
            var subCategoryName = cartMap['sub_cat_name'];
            var subCategoryImage = cartMap['sub_cat_img'];
            var actualCost = cartMap['actual_cost'];
            var sectionType = cartMap['section_type'];

            List<String> itemIDlst = glb.strToLst2(itemID);
            List<String> categoryIDst = glb.strToLst2(categoryID);
            List<String> subCategoryIDlst = glb.strToLst2(subCategoryID);

            List<String> orderIDlst = glb.strToLst2(orderID);
            List<String> datelst = glb.strToLst2(date);
            List<String> timelst = glb.strToLst2(time);
            List<String> orderTypelst = glb.strToLst2(orderType);
            List<String> itemCostlst = glb.strToLst2(itemCost);
            List<String> itemQuantitylst = glb.strToLst2(itemQuantity);
            List<String> typeOflst = glb.strToLst2(typeOf);

            List<String> categoryImagelst = glb.strToLst2(categoryImage);
            List<String> categoryNamelst = glb.strToLst2(categoryName);
            List<String> subCategoryNamelst = glb.strToLst2(subCategoryName);
            List<String> subCategoryImagelst = glb.strToLst2(subCategoryImage);
            List<String> actualCostlst = glb.strToLst2(actualCost);
            List<String> sectionTypelst = glb.strToLst2(sectionType);

            for (int i = 0; i < itemIDlst.length; i++) {
              var itemID = itemIDlst.elementAt(i).toString();
              var categoryID = categoryIDst.elementAt(i).toString();
              var subCategoryID = subCategoryIDlst.elementAt(i).toString();

              var orderID = orderIDlst.elementAt(i).toString();
              var date = datelst.elementAt(i).toString();
              var time = timelst.elementAt(i).toString();
              var orderType = orderTypelst.elementAt(i).toString();
              var itemCost = itemCostlst.elementAt(i).toString();
              var itemQuantity = itemQuantitylst.elementAt(i).toString();
              var typeOf = typeOflst.elementAt(i).toString();
              var categoryImage = categoryImagelst.elementAt(i).toString();
              var categoryName = categoryNamelst.elementAt(i).toString();
              var subCategoryName = subCategoryNamelst.elementAt(i).toString();
              var subCategoryImage =
                  subCategoryImagelst.elementAt(i).toString();
              var actualCost = actualCostlst.elementAt(i).toString();
              var sectionType = sectionTypelst.elementAt(i).toString();

              var timeFormatted =
                  glb.doubleEpochToFormattedDateTime(double.parse(time));
              cartItemModel.add(CartItemModel(
                  itemID: itemID,
                  categoryID: categoryID,
                  subCategoryID: subCategoryID,
                  itemCost: itemCost,
                  itemQuantity: itemQuantity,
                  typeOf: typeOf,
                  orderID: orderID,
                  date: date,
                  time: timeFormatted,
                  orderType: orderType,
                  categoryImage: categoryImage,
                  categoryName: categoryName,
                  subCategoryName: subCategoryName,
                  subCategoryImage: subCategoryImage,
                  actualCost: actualCost,
                  sectionType: sectionType));
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

  Future deleteCartItem(String itemID) async {
    setState(() {
      showLoading = true;
    });

    try {
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['item_id'] = itemID;
      dictMap['pktType'] = "16";
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
          loadCartItems();
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
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: _noItems
          ? SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      'No Laundry Items Added Yet',
                      style: ralewayStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: AppColors.whiteColor),
                    ),
                  ),
                ],
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
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: AppColors.lightBlackColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  cartItemModel[index]
                                                      .categoryName
                                                      .toCapitalized(),
                                                  style: ralewayStyle.copyWith(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.neonColor,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    var itemID =
                                                        cartItemModel[index]
                                                            .itemID;
                                                    deleteCartItem(itemID);
                                                  },
                                                  child: Icon(
                                                    Icons
                                                        .delete_outline_outlined,
                                                    color: Colors.red,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: width * 0.03,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    if (cartItemModel[index]
                                                            .subCategoryImage ==
                                                        'NA')
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2.0),
                                                        child: Image.network(
                                                          cartItemModel[index]
                                                              .categoryImage,
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                      )
                                                    else
                                                      Image.network(
                                                        cartItemModel[index]
                                                            .subCategoryImage,
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                    SizedBox(
                                                      width: width * 0.04,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        cartItemModel[index]
                                                                    .subCategoryName ==
                                                                'NA'
                                                            ? Text(
                                                                cartItemModel[
                                                                        index]
                                                                    .categoryName
                                                                    .toCapitalized(),
                                                                style: nunitoStyle
                                                                    .copyWith(
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: AppColors
                                                                      .whiteColor,
                                                                ),
                                                              )
                                                            : Row(
                                                                children: [
                                                                  Text(
                                                                    cartItemModel[
                                                                            index]
                                                                        .subCategoryName
                                                                        .toCapitalized(),
                                                                    style: nunitoStyle
                                                                        .copyWith(
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: AppColors
                                                                          .whiteColor,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    ' - ${cartItemModel[index].sectionType.toCapitalized()}',
                                                                    style: nunitoStyle
                                                                        .copyWith(
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      color: AppColors
                                                                          .whiteColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                        SizedBox(
                                                          height: height * 0.01,
                                                        ),
                                                        Text(
                                                          '₹${cartItemModel[index].itemCost}',
                                                          style: nunitoStyle
                                                              .copyWith(
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: AppColors
                                                                      .neonColor),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Qty: ',
                                                      style:
                                                          nunitoStyle.copyWith(
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .neonColor),
                                                    ),
                                                    Text(
                                                      '${cartItemModel[index].itemQuantity}  ${cartItemModel[index].typeOf}',
                                                      style:
                                                          nunitoStyle.copyWith(
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .neonColor),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              color: AppColors.lightGreyColor,
                                              thickness: 2,
                                            ),
                                          ],
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
                                      gradient: LinearGradient(colors: [
                                        Colors.green,
                                      Colors.blue,
                                      ]),
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

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
