import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/animation/slide_left_animation.dart';
import 'package:vff_group/animation/slideright_animation.dart';
import 'package:vff_group/modals/cart_item_model.dart';
import 'package:vff_group/modals/order_detail_item_model.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';
import 'package:http/http.dart' as http;
import 'package:vff_group/global/vffglb.dart' as glb;

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  bool showLoading = true,
      isItemAdded = true,
      showItemsLoading = true,
      itemsNotFound = true;
  String timeOrderRecieved = "";
  String pickupDate = "";
  String deliveryBoyName = "";
  String deliveryDateTime = "";
  String orderStatus = "";
  String houseNo = "";
  String addressClient = "";
  String profilePicture = "";
  String deliveryMobno = "";
  String cancelReason = "";
  String feedBack = "";
  String totalItemsCount = "";
  String totalItemsPrice = "";
  List<OrderItemsModel> orderItemModel = [];

  @override
  void initState() {
    super.initState();
    loadOrderDetails();
  }

  Future loadOrderDetails() async {
    setState(() {
      showLoading = true;
    });
    // final prefs = await SharedPreferences.getInstance();
    // var customerid = prefs.getString('customerid');
    if (glb.orderid.isEmpty) {
      glb.showSnackBar(context, 'Alert!', 'Please Select the Active Order');
      return;
    }
    var todaysDate = glb.getDateTodays();
    try {
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['order_id'] = glb.orderid;
      dictMap['pktType'] = "10";
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
          });
          glb.showSnackBar(context, 'Error', 'No Order Details Found');
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showLoading = false;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> orderMap = json.decode(response.body);
            if (kDebugMode) {
              print("orderMap:$orderMap");
            }

            var epoch = orderMap['epoch'];
            var pickupDt = orderMap['pickup_dt'];
            var clat = orderMap['clat'];
            var clng = orderMap['clng'];
            var deliveryBoyId = orderMap['delivery_boy_id'];
            var delivery_boyName = orderMap['delivery_boy_name'];
            var order_status = orderMap['order_status'];
            var delvryBoyMobno = orderMap['delvry_boy_mobno'];
            var deliveryDt = orderMap['delivery_dt'];
            var houseno = orderMap['houseno'];
            var address = orderMap['address'];
            var landmark = orderMap['landmark'];
            var pincode = orderMap['pincode'];
            var deliveryEpoch = orderMap['deliveryEpoch'];
            var profileImg = orderMap['profileImg'];
            var cancel_reason = orderMap['cancel_reason'];
            var feedback = orderMap['feedback'];

            var formattedDateTime =
                glb.doubleEpochToFormattedDateTime(double.parse(epoch));
            var deliveryEpochTime =
                glb.doubleEpochToFormattedDateTime(double.parse(deliveryEpoch));
            setState(() {
              timeOrderRecieved = formattedDateTime;
              pickupDate = pickupDt;

              deliveryBoyName = delivery_boyName;
              if (order_status != 'Delivered') {
                deliveryDateTime = "Not Delivered yet";
              } else {
                deliveryDateTime = deliveryEpochTime;
              }
              orderStatus = order_status;
              houseNo = houseno;
              addressClient = address;
              profilePicture = profileImg;
              deliveryMobno = delvryBoyMobno;
              cancelReason = cancel_reason;
              feedBack = feedback;
            });

            setState(() {
              showLoading = false;
            });
            loadOrderItemsDetails();
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

  Future loadOrderItemsDetails() async {
    setState(() {
      showItemsLoading = true;
      isItemAdded = true;
      orderItemModel = [];
    });
    final prefs = await SharedPreferences.getInstance();
    var customerid = prefs.getString('customerid');
    if (glb.orderid.isEmpty) {
      glb.showSnackBar(context, 'Alert!', 'Please Select the Active Order');
      return;
    }
    var todaysDate = glb.getDateTodays();
    try {
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['order_id'] = glb.orderid;
      dictMap['pktType'] = "11";
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
            showItemsLoading = false;
            isItemAdded = true;
            itemsNotFound = true;
          });
          //glb.showSnackBar(context, 'Alert', 'No Laundry Items Added');
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showItemsLoading = false;
            isItemAdded = false;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> cartMap = json.decode(response.body);
            // if (kDebugMode) {
            //   print("cartMap:$cartMap");
            // }

            var categoryID = cartMap['cat_id'];
            var subCategoryID = cartMap['sub_cat_id'];
            var date = cartMap['dt'];
            var time = cartMap['time'];
            var orderType = cartMap['order_type'];
            var item_cost = cartMap['item_cost'];
            var item_quantity = cartMap['item_quantity'];
            var categoryImage = cartMap['cat_img'];
            var categoryName = cartMap['category_name'];
            var subCategoryName = cartMap['sub_cat_name'];
            var subCategoryImage = cartMap['sub_cat_img'];
            var type_of = cartMap['type_of'];

            var total_items_count = cartMap['total_items_count'];
            var total_item_price = cartMap['total_item_price'];
            var section_type = cartMap['section_type'];

            setState(() {
              totalItemsCount = total_items_count;
              totalItemsPrice = total_item_price;
            });
            List<String> categoryIDst = glb.strToLst2(categoryID);
            List<String> subCategoryIDlst = glb.strToLst2(subCategoryID);

            List<String> datelst = glb.strToLst2(date);
            List<String> timelst = glb.strToLst2(time);
            List<String> orderTypelst = glb.strToLst2(orderType);
            List<String> itemCostlst = glb.strToLst2(item_cost);
            List<String> itemQuantitylst = glb.strToLst2(item_quantity);
            List<String> categoryImagelst = glb.strToLst2(categoryImage);
            List<String> categoryNamelst = glb.strToLst2(categoryName);
            List<String> subCategoryNamelst = glb.strToLst2(subCategoryName);
            List<String> subCategoryImagelst = glb.strToLst2(subCategoryImage);
            List<String> typeOflst = glb.strToLst2(type_of);
            List<String> section_typelst = glb.strToLst2(section_type);

            for (int i = 0; i < categoryIDst.length; i++) {
              var categoryID = categoryIDst.elementAt(i).toString();
              var subCategoryID = subCategoryIDlst.elementAt(i).toString();

              var date = datelst.elementAt(i).toString();
              var time = timelst.elementAt(i).toString();
              var orderType = orderTypelst.elementAt(i).toString();
              var itemCost = itemCostlst.elementAt(i).toString();
              var itemQuantity = itemQuantitylst.elementAt(i).toString();
              var categoryImage = categoryImagelst.elementAt(i).toString();
              var categoryName = categoryNamelst.elementAt(i).toString();
              var subCategoryName = subCategoryNamelst.elementAt(i).toString();
              var subCategoryImage =
                  subCategoryImagelst.elementAt(i).toString();
              var typeOf = typeOflst.elementAt(i).toString();
              var section_type = section_typelst.elementAt(i).toString();

              var timeFormatted =
                  glb.doubleEpochToFormattedDateTime(double.parse(time));
              orderItemModel.add(OrderItemsModel(
                  categoryID: categoryID,
                  subCategoryID: subCategoryID,
                  totalQuantity: itemQuantity,
                  totalPrice: itemCost,
                  date: date,
                  time: timeFormatted,
                  orderType: orderType,
                  itemCost: itemCost,
                  itemQuantity: itemQuantity,
                  typeOf: typeOf,
                  categoryImage: categoryImage,
                  categoryName: categoryName,
                  subCategoryName: subCategoryName,
                  subCategoryImage: subCategoryImage,
                  sectionType: section_type));
            }
            setState(() {
              showItemsLoading = false;
              isItemAdded = false;
              itemsNotFound = false;
            });
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
            setState(() {
              showItemsLoading = false;
              isItemAdded = false;
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
        showItemsLoading = false;
        isItemAdded = false;
      });
      glb.handleErrors(e, context);
    }
  }

  Future<void> _handleRefresh() async {
    loadOrderDetails();
    loadOrderItemsDetails();
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
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 1.2 * kToolbarHeight, 20, 20),
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Order Details',
                            style: ralewayStyle.copyWith(
                              color: AppColors.whiteColor,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          showLoading
                              ? LinearProgressIndicator(
                                  semanticsLabel: 'Linear progress indicator',
                                )
                              : Column(
                                  children: [
                                    _OrderDetails(
                                        orderStatus: orderStatus,
                                        orderID: glb.orderid,
                                        pickUpDateTime: timeOrderRecieved,
                                        deliveryDateTime: deliveryDateTime,
                                        addressClient: addressClient),
                                    const Divider(
                                      color: AppColors.whiteColor,
                                      thickness: 0.5,
                                    ),
                                    _DeliveryBoyDetails(
                                        width: width,
                                        profilePicture: profilePicture,
                                        deliveryBoyName: deliveryBoyName,
                                        deliveryMobno: deliveryMobno,
                                        feedBack: feedBack,
                                        orderStatus: orderStatus),
                                    const Divider(
                                      color: AppColors.whiteColor,
                                      thickness: 0.5,
                                    ),
                                    _TotalClothesCount(
                                      showItemsLoading: showItemsLoading,
                                      isItemAdded: isItemAdded,
                                      totalQuantity: totalItemsCount,
                                    ),
                                    itemsNotFound
                                        ? Padding(
                                            padding: EdgeInsets.zero,
                                            child: Column(
                                              children: [
                                                Text(
                                                  'NO LAUNDRY ITEMS FOUND\n Please Add Items',
                                                  style: ralewayStyle.copyWith(
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                      letterSpacing: 1),
                                                  textAlign: TextAlign.center,
                                                ),
                                                cancelReason == "NA"
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10.0),
                                                        child:
                                                            SlideFromBottomAnimation(
                                                          delay: 0.5,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      CancelOrderRoute);
                                                                },
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16.0),
                                                                child: Ink(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          16.0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              16.0),
                                                                          gradient:
                                                                              LinearGradient(colors: [
                                                                            Colors.red,
                                                                            AppColors.neonColor,
                                                                          ])),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        'Cancel Order',
                                                                        style: nunitoStyle
                                                                            .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          color:
                                                                              AppColors.whiteColor,
                                                                          fontSize:
                                                                              16.0,
                                                                        ),
                                                                      ),
                                                                      const Icon(
                                                                        Icons
                                                                            .arrow_right_outlined,
                                                                        color: Colors
                                                                            .white,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Text('')
                                              ],
                                            ),
                                          )
                                        : SizedBox(
                                            height: 300,
                                            child: ListView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                itemCount:
                                                    orderItemModel.length,
                                                itemBuilder: ((context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        color: AppColors
                                                            .lightBlackColor,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  orderItemModel[
                                                                          index]
                                                                      .categoryName
                                                                      .toCapitalized(),
                                                                  style: ralewayStyle
                                                                      .copyWith(
                                                                    fontSize:
                                                                        14.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: AppColors
                                                                        .neonColor,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  width * 0.03,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    if (orderItemModel[index]
                                                                            .subCategoryImage ==
                                                                        'NA')
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(2.0),
                                                                        child: Image
                                                                            .network(
                                                                          orderItemModel[index]
                                                                              .categoryImage,
                                                                          width:
                                                                              50,
                                                                          height:
                                                                              50,
                                                                        ),
                                                                      )
                                                                    else
                                                                      Image
                                                                          .network(
                                                                        orderItemModel[index]
                                                                            .subCategoryImage,
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
                                                                      ),
                                                                    SizedBox(
                                                                      width: width *
                                                                          0.04,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        orderItemModel[index].subCategoryName ==
                                                                                'NA'
                                                                            ? Text(
                                                                                orderItemModel[index].categoryName.toCapitalized(),
                                                                                style: nunitoStyle.copyWith(
                                                                                  fontSize: 14.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  color: AppColors.whiteColor,
                                                                                ),
                                                                              )
                                                                            : Row(
                                                                                children: [
                                                                                  Text(
                                                                                    orderItemModel[index].subCategoryName.toCapitalized(),
                                                                                    style: nunitoStyle.copyWith(
                                                                                      fontSize: 14.0,
                                                                                      fontWeight: FontWeight.normal,
                                                                                      color: AppColors.whiteColor,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    ' - ${orderItemModel[index].sectionType.toCapitalized()}',
                                                                                    style: nunitoStyle.copyWith(
                                                                                      fontSize: 14.0,
                                                                                      fontWeight: FontWeight.normal,
                                                                                      color: AppColors.whiteColor,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                        SizedBox(
                                                                          height:
                                                                              height * 0.01,
                                                                        ),
                                                                        Text(
                                                                          '₹${orderItemModel[index].totalPrice}',
                                                                          style: nunitoStyle.copyWith(
                                                                              fontSize: 14.0,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: AppColors.neonColor),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'Qty: ',
                                                                      style: nunitoStyle.copyWith(
                                                                          fontSize:
                                                                              14.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              AppColors.neonColor),
                                                                    ),
                                                                    Text(
                                                                      '${orderItemModel[index].totalQuantity} ',
                                                                      style: nunitoStyle.copyWith(
                                                                          fontSize:
                                                                              14.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              AppColors.neonColor),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            const Divider(
                                                              color: AppColors
                                                                  .lightGreyColor,
                                                              thickness: 0.1,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                })),
                                          )
                                  ],
                                )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class _WashAndFoldListWidget extends StatelessWidget {
  const _WashAndFoldListWidget({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: AppColors.greyBGColor,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1), // Shadow color
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // Changes position of shadow
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Wash and Fold',
                    style: nunitoStyle.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: width * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/clothes/jacket.png',
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: width * 0.04,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jacket',
                            style: nunitoStyle.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Text(
                            '₹25',
                            style: nunitoStyle.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Qty: ',
                        style: nunitoStyle.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        '1',
                        style: nunitoStyle.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                color: AppColors.whiteColor,
                thickness: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DryCleaningListWidget extends StatelessWidget {
  const _DryCleaningListWidget({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: AppColors.greyBGColor,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1), // Shadow color
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // Changes position of shadow
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Dry Clean',
                    style: nunitoStyle.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: width * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/clothes/t_shirt.png',
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: width * 0.04,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'T-Shirt',
                            style: nunitoStyle.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Text(
                            '₹10',
                            style: nunitoStyle.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Qty: ',
                        style: nunitoStyle.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        '3',
                        style: nunitoStyle.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
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
  }
}

class _TotalClothesCount extends StatelessWidget {
  const _TotalClothesCount({
    super.key,
    required this.showItemsLoading,
    required this.isItemAdded,
    required this.totalQuantity,
  });
  final bool showItemsLoading;
  final bool isItemAdded;
  final String totalQuantity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Laundry',
            style: nunitoStyle.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              color: AppColors.whiteColor,
            ),
          ),
          showItemsLoading
              ? const LinearProgressIndicator()
              : isItemAdded
                  ? InkWell(
                      onTap: () {
                        glb.addItems = true;
                        Navigator.pushNamed(context, MyBagRoute);
                      },
                      child: Text(
                        'Add Item',
                        style: nunitoStyle.copyWith(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.neonColor),
                      ),
                    )
                  : Text(
                      '$totalQuantity items',
                      style: nunitoStyle.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.neonColor),
                    )
        ],
      ),
    );
  }
}

class _DeliveryBoyDetails extends StatelessWidget {
  const _DeliveryBoyDetails({
    super.key,
    required this.width,
    required this.profilePicture,
    required this.deliveryBoyName,
    required this.deliveryMobno,
    required this.feedBack,
    required this.orderStatus,
  });

  final double width;
  final String? profilePicture;
  final String deliveryBoyName;
  final String deliveryMobno;
  final String feedBack;
  final String orderStatus;

  @override
  Widget build(BuildContext context) {
    return SlideFromLeftAnimation(
      delay: 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                profilePicture!.isEmpty
                    ? const CircularProgressIndicator()
                    : WidgetCircularAnimator(
                        size: 50,
                        innerIconsSize: 3,
                        outerIconsSize: 3,
                        innerAnimation: Curves.easeInOutBack,
                        outerAnimation: Curves.easeInOutBack,
                        innerColor: Colors.deepPurple,
                        outerColor: Colors.orangeAccent,
                        innerAnimationSeconds: 10,
                        outerAnimationSeconds: 10,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey[200]),
                          child: CircleAvatar(
                            radius: 25.0,
                            backgroundImage: NetworkImage('$profilePicture'),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                SizedBox(
                  width: width * 0.04,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deliveryBoyName,
                      style: nunitoStyle.copyWith(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.neonColor),
                    ),
                    Text(
                      deliveryMobno,
                      style: nunitoStyle.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: AppColors.whiteColor),
                    ),
                  ],
                ),
              ],
            ),
            feedBack == "NA" && orderStatus == "Delivered"
                ? SlideFromRightAnimation(
                    delay: 0.9,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, FeedbackRoute);
                        },
                        borderRadius: BorderRadius.circular(10.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.message,
                                  color: AppColors.neonColor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(
                                    'Feedback',
                                    style: nunitoStyle.copyWith(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal,
                                        color: AppColors.neonColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SlideFromRightAnimation(
                    delay: 0.9,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (orderStatus == "Accepted") {
                            _makePhoneCall(deliveryMobno);
                          } else if (orderStatus == "Delivered") {
                            glb.showSnackBar(context, 'Alert',
                                "Order is Delivered so you can't call this delivery boy");
                            return;
                          } else if (orderStatus == "Processing") {
                            glb.showSnackBar(
                                context, 'Alert', "Order is yet in Processing");
                            return;
                          } else {
                            glb.showSnackBar(context, 'Alert',
                                "Order is not yet assigned to Delivery agent");
                            return;
                          }
                        },
                        borderRadius: BorderRadius.circular(10.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.phone,
                                  color: AppColors.neonColor,
                                  size: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(
                                    'Call',
                                    style: nunitoStyle.copyWith(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal,
                                        color: AppColors.neonColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class _OrderDetails extends StatelessWidget {
  const _OrderDetails({
    super.key,
    required this.orderStatus,
    required this.orderID,
    required this.pickUpDateTime,
    required this.deliveryDateTime,
    required this.addressClient,
  });
  final String orderStatus;
  final String orderID;
  final String pickUpDateTime;
  final String deliveryDateTime;
  final String addressClient;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeAnimation(
              delay: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: orderStatus == "Accepted" ||
                                orderStatus == "Payment Done" ||
                                orderStatus == "Processing" ||
                                orderStatus == "Delivered"
                            ? AppColors.neonColor
                            : AppColors.lightBlackColor,
                        borderRadius: BorderRadius.circular(50.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.delivery_dining_sharp,
                        color: orderStatus == "Accepted" ||
                                orderStatus == "Payment Done" ||
                                orderStatus == "Processing" ||
                                orderStatus == "Delivered"
                            ? AppColors.backColor
                            : AppColors.whiteColor,
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 1,
                    color: orderStatus == "Processing" ||
                            orderStatus == "Delivered"
                        ? AppColors.neonColor
                        : AppColors.whiteColor,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: orderStatus == "Processing" ||
                                orderStatus == "Delivered"
                            ? AppColors.neonColor
                            : AppColors.lightBlackColor,
                        borderRadius: BorderRadius.circular(50.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.local_laundry_service_outlined,
                        color: orderStatus == "Processing" ||
                                orderStatus == "Delivered"
                            ? AppColors.backColor
                            : AppColors.whiteColor,
                      ),
                    ),
                  ),
                  Container(
                      width: 100,
                      height: 1,
                      color: orderStatus == "Processing" ||
                              orderStatus == "Delivered"
                          ? AppColors.neonColor
                          : AppColors.whiteColor),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.lightBlackColor,
                        borderRadius: BorderRadius.circular(50.0)),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0), child: Text('👍')),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order',
                    style: nunitoStyle.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  orderStatus == "Rejected"
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                'Assigning',
                                style: nunitoStyle.copyWith(
                                    color: AppColors.orangeColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            CircularProgressIndicator(
                              color: Colors.green,
                              strokeWidth: 1,
                            )
                          ],
                        )
                      : Text(
                          orderStatus,
                          style: nunitoStyle.copyWith(
                              color: AppColors.orangeColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ID',
                    style: nunitoStyle.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '#${orderID}',
                    style: nunitoStyle.copyWith(
                      color: AppColors.neonColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pick Up:',
                    style: nunitoStyle.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    pickUpDateTime,
                    style: nunitoStyle.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivered Date:',
                    style: nunitoStyle.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    deliveryDateTime,
                    style: nunitoStyle.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Address:',
                    style: nunitoStyle.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    addressClient,
                    style: nunitoStyle.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          'Order Details',
          style: nunitoStyle.copyWith(
            color: AppColors.whiteColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer()
      ],
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

Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}
