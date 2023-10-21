import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vff_group/modals/order_detail_item_model.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:http/http.dart' as http;
import 'package:vff_group/global/vffglb.dart' as glb;

class OngoingOrders extends StatefulWidget {
  const OngoingOrders({super.key});

  @override
  State<OngoingOrders> createState() => _OngoingOrdersState();
}

class _OngoingOrdersState extends State<OngoingOrders> {
  final bool _noOrders = false;
/*
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
    glb.order_status = "0";
    try {
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['order_id'] = glb.orderid;
      dictMap['order_status'] = glb.order_status;
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
            glb.deliveryBoyID = deliveryBoyId;
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
*/
  Future<void> _handleRefresh() async {
    Future.delayed(Duration(milliseconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
          itemCount: 10,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, OrderDetailsRoute);
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: AppColors.lightBlackColor, // Container color
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1), // Shadow color
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // Changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order ID:',
                                  style: nunitoStyle.copyWith(
                                      color: AppColors.whiteColor,
                                      fontSize: 14),
                                ),
                                Text(
                                  '#123456',
                                  style: nunitoStyle.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
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
                                  'Order Date:',
                                  style: nunitoStyle.copyWith(
                                      color: AppColors.whiteColor,
                                      fontSize: 14),
                                ),
                                Text(
                                  '04-01-2023',
                                  style: nunitoStyle.copyWith(
                                    color: AppColors.whiteColor,
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
                                      fontSize: 14),
                                ),
                                Text(
                                  'New Vaibhav Nagar,590010',
                                  style: nunitoStyle.copyWith(
                                    color: AppColors.whiteColor,
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
                                  'Total Amount:',
                                  style: nunitoStyle.copyWith(
                                      color: AppColors.whiteColor,
                                      fontSize: 14),
                                ),
                                Text(
                                  '₹ 230/-',
                                  style: nunitoStyle.copyWith(
                                    color: AppColors.blueDarkColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(
                              color: AppColors.whiteColor,
                              height: 0.1,
                              thickness: 0.1,
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      // TODO:Need To give alert and cancel the order
                                    },
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          color: AppColors.dangerColor),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          'Cancel',
                                          style: nunitoStyle.copyWith(
                                            color: AppColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Visibility(
                                visible: true,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      // TODO: Need To show this only when order is confirmed
                                    },
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          color: AppColors.blueDarkColor),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          'Confirmed',
                                          style: nunitoStyle.copyWith(
                                            color: AppColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
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
              ),
            );
          })),
    );
  }
}

class _OnOrders extends StatelessWidget {
  const _OnOrders({
    super.key,
    required bool noOrders,
  }) : _noOrders = noOrders;

  final bool _noOrders;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _noOrders,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'There are no order',
              style: nunitoStyle.copyWith(
                  fontSize: 16.0, color: AppColors.textColor),
            ),
            SizedBox(
              height: 15.0,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12.0),
                child: Ink(
                  decoration: BoxDecoration(
                    color: AppColors.blueDarkColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Text(
                      'Start Now',
                      style: nunitoStyle.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.backColor),
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
