import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vff_group/modals/ongoing_orders_model.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:http/http.dart' as http;
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:vff_group/widgets/shimmer_card.dart';

class CompletedOrders extends StatefulWidget {
  const CompletedOrders({super.key});

  @override
  State<CompletedOrders> createState() => _CompletedOrdersState();
}

class _CompletedOrdersState extends State<CompletedOrders> {
  final bool _noOrders = false;
  bool showLoading = false, showError = false;

  List<OngoingOrdersModel> ongoingModel = [];
  Future loadOrderDetails() async {
    setState(() {
      showLoading = true;
      showError = true;
      ongoingModel = [];
    });
    final prefs = await SharedPreferences.getInstance();
    var customerid = prefs.getString('customerid');

    var todaysDate = glb.getDateTodays();
    glb.order_status = "1";
    try {
      var url = glb.endPoint;
      url+="load_all_orders_tab_details/";
      final Map dictMap = {};

      dictMap['customer_id'] = customerid;
      dictMap['order_status'] = glb.order_status;
      // dictMap['pktType'] = "22";
      // dictMap['token'] = "vff";
      // dictMap['uid'] = "-1";

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            "Accept": "application/json",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(dictMap));
print("response.statusCode::${response.statusCode}");
      if (response.statusCode == 200) {
        var res = response.body;
        if (res.contains("ErrorCode#2")) {
          setState(() {
            showLoading = false;
            showError = true;
          });
          // glb.showSnackBar(context, 'Error', 'No Order Details Found');
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showLoading = false;
            showError = true;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> onGoingOrdersMap = json.decode(response.body);
            if (kDebugMode) {
              // print("completedOrdersMap:$onGoingOrdersMap");
            }

            var orderid = onGoingOrdersMap["orderid"];
            var delivery_boyid = onGoingOrdersMap["delivery_boyid"];
            var quantity = onGoingOrdersMap["quantity"];
            var price = onGoingOrdersMap["price"];
            var pickup_date = onGoingOrdersMap["pickup_date"];
            var delivery_date = onGoingOrdersMap["delivery_date"];
            var clat = onGoingOrdersMap["clat"];
            var clng = onGoingOrdersMap["clng"];
            var order_status = onGoingOrdersMap["order_status"];
            var delivery_epoch = onGoingOrdersMap["delivery_epoch"];
            var order_taken_epoch = onGoingOrdersMap["order_taken_epoch"];
            var cancel_reason = onGoingOrdersMap["cancel_reason"];
            var house_no = onGoingOrdersMap["house_no"];
            var address = onGoingOrdersMap["address"];

            List<String> orderIDLst = glb.strToLst2(orderid);
            List<String> delivery_boyidLst = glb.strToLst2(delivery_boyid);
            List<String> quantityLst = glb.strToLst2(quantity);
            List<String> priceLst = glb.strToLst2(price);
            List<String> pickup_dateLst = glb.strToLst2(pickup_date);
            List<String> delivery_dateLst = glb.strToLst2(delivery_date);
            List<String> clatLst = glb.strToLst2(clat);
            List<String> clngLst = glb.strToLst2(clng);
            List<String> order_statusLst = glb.strToLst2(order_status);
            List<String> delivery_epochLst = glb.strToLst2(delivery_epoch);
            List<String> order_taken_epochLst =
                glb.strToLst2(order_taken_epoch);
            List<String> cancel_reasonLst = glb.strToLst2(cancel_reason);
            List<String> house_noLst = glb.strToLst2(house_no);
            List<String> addressLst = glb.strToLst2(address);

            for (int i = 0; i < orderIDLst.length; i++) {
              var orderID = orderIDLst.elementAt(i).toString();
              var pickup_date = pickup_dateLst.elementAt(i).toString();
              var delivery_date = delivery_dateLst.elementAt(i).toString();
              var order_status = order_statusLst.elementAt(i).toString();
              var depoch = delivery_epochLst.elementAt(i).toString();
              var orderepoch = order_taken_epochLst.elementAt(i).toString();
              var cancel_reason = cancel_reasonLst.elementAt(i).toString();
              var house_no = house_noLst.elementAt(i).toString();
              var address = addressLst.elementAt(i).toString();
              var price = priceLst.elementAt(i).toString();
              var formattedDateTime =
                  glb.doubleEpochToFormattedDateTime(double.parse(orderepoch));
              var deliveryEpochTime =
                  glb.doubleEpochToFormattedDateTime(double.parse(depoch));

              var timeOrderRecieved = formattedDateTime;

              var deliveryDateTime = "";
              if (order_status != 'Completed') {
                deliveryDateTime = "Not Delivered yet";
              } else {
                deliveryDateTime = deliveryEpochTime;
              }

              bool showCancelBtn = false;
              if (order_status == "Accepted") {
                showCancelBtn = true;
              }
              ongoingModel.add(OngoingOrdersModel(
                  orderID: orderID,
                  pickup_date: pickup_date,
                  delivery_date: delivery_date,
                  order_status: order_status,
                  delivery_epoch: deliveryDateTime,
                  order_taken_epoch: timeOrderRecieved,
                  cancel_reason: cancel_reason,
                  house_no: house_no,
                  address: address,
                  totalPrice: price,
                  showCancelBtn: showCancelBtn,
                  customerID: customerid.toString()));
            }

            setState(() {
              showLoading = false;
              showError = false;
            });
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
            setState(() {
              showLoading = false;
              showError = true;
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
        showError = true;
      });
      glb.handleErrors(e, context);
    }
  }

  Future<void> _handleRefresh() async {
    Future.delayed(Duration(milliseconds: 5));
    loadOrderDetails();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.2),
            highlightColor: Colors.grey.withOpacity(0.1),
            enabled: showLoading,
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: ListView.separated(
                  itemCount: 10,
                  separatorBuilder: (context, _) =>
                      SizedBox(height: height * 0.02),
                  itemBuilder: ((context, index) {
                    return const ShimmerCardLayout();
                  })),
            ),
          )
        : showError
            ? Center(
                child: Text(
                  'No Order History Found',
                  style: nunitoStyle.copyWith(
                      color: AppColors.backColor, fontSize: 20.0),
                ),
              )
            : RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                    itemCount: ongoingModel.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              glb.orderid = ongoingModel[index].orderID;
                              glb.hideControls = false;
                              glb.showDeliveryBoy = true;

                              Navigator.pushNamed(context, OrderDetailsRoute);
                            },
                            borderRadius: BorderRadius.circular(8.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: AppColors
                                    .lightBlackColor, // Container color
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.1), // Shadow color
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // Changes position of shadow
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Order Status:',
                                            style: nunitoStyle.copyWith(
                                                color: AppColors.backColor,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            '${ongoingModel[index].order_status}',
                                            style: nunitoStyle.copyWith(
                                              color: AppColors.blueColor,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Order ID:',
                                            style: nunitoStyle.copyWith(
                                                color: AppColors.backColor,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            '#${ongoingModel[index].orderID}',
                                            style: nunitoStyle.copyWith(
                                              color: AppColors.backColor,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Order Date:',
                                            style: nunitoStyle.copyWith(
                                                color: AppColors.backColor,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            ongoingModel[index]
                                                .order_taken_epoch,
                                            style: nunitoStyle.copyWith(
                                              color: AppColors.backColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Delivered Date:',
                                            style: nunitoStyle.copyWith(
                                                color: AppColors.backColor,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            ongoingModel[index].delivery_epoch,
                                            style: nunitoStyle.copyWith(
                                              color: AppColors.backColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Pick Up:',
                                            style: nunitoStyle.copyWith(
                                                color: AppColors.backColor,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            ongoingModel[index].address,
                                            style: nunitoStyle.copyWith(
                                              color: AppColors.backColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total Amount:',
                                            style: nunitoStyle.copyWith(
                                                color: AppColors.backColor,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            '₹ ${ongoingModel[index].totalPrice}/-',
                                            style: nunitoStyle.copyWith(
                                              color: AppColors.blueColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
