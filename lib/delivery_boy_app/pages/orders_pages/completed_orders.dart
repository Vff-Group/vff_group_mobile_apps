import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vff_group/modals/ongoing_orders_model.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:http/http.dart' as http;
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:vff_group/widgets/shimmer_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CompletedOrdersPage extends StatefulWidget {
  const CompletedOrdersPage({super.key});

  @override
  State<CompletedOrdersPage> createState() => _CompletedOrdersPageState();
}

class _CompletedOrdersPageState extends State<CompletedOrdersPage> {
  final bool _noOrders = false;
  bool showLoading = false, showError = false;

  List<OngoingOrdersModel> completeOrdersModel = [];
  Future loadOrderDetails() async {
    setState(() {
      showLoading = true;
      showError = false;
      completeOrdersModel = [];
    });
    final prefs = await SharedPreferences.getInstance();
    var delivery_boy_id = prefs.getString('delivery_boy_id');

    var todaysDate = glb.getDateTodays();
    glb.order_status = "1";
    try {
      var url = glb.endPoint;
      final Map dictMap = {};
//select orderid,customerid,quantity,price,pickup_dt,delivery,clat,clng,order_status,delivery_epoch,laundry_ordertbl.epoch,cancel_reason,houseno,address from vff.usertbl,vff.laundry_delivery_boytbl,vff.laundry_ordertbl where usertbl.usrid=laundry_delivery_boytbl.usrid and laundry_delivery_boytbl.delivery_boy_id=laundry_ordertbl.delivery_boyid and delivery_boyid='3' and order_completed='1' and order_status='Accepted'  order by orderid desc
      dictMap['delivery_boy_id'] = delivery_boy_id;
      dictMap['order_completed'] = glb.order_status;
      dictMap['order_status'] = 'Completed';
      dictMap['pktType'] = "24";
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
            showError = true;
          });
          // glb.showSnackBar(context, 'Error', 'No Order Details Found');
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showLoading = false;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> completedMap = json.decode(response.body);
            if (kDebugMode) {
              print("completedMap:$completedMap");
            }

            var orderid = completedMap["orderid"];

            var customer_id = completedMap["customer_id"];
            var quantity = completedMap["quantity"];
            var price = completedMap["price"];
            var pickup_date = completedMap["pickup_date"];
            var delivery_date = completedMap["delivery_date"];
            var clat = completedMap["clat"];
            var clng = completedMap["clng"];
            var order_status = completedMap["order_status"];
            var delivery_epoch = completedMap["delivery_epoch"];
            var order_taken_epoch = completedMap["order_taken_epoch"];
            var cancel_reason = completedMap["cancel_reason"];
            var house_no = completedMap["house_no"];
            var address = completedMap["address"];

            List<String> orderIDLst = glb.strToLst2(orderid);

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
            List<String> customer_idLst = glb.strToLst2(customer_id);

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
              var customerid = customer_idLst.elementAt(i).toString();
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
              completeOrdersModel.add(OngoingOrdersModel(
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
                  customerID: customerid));
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
                  itemCount: completeOrdersModel.length,
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
                    itemCount: completeOrdersModel.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              glb.orderid = completeOrdersModel[index].orderID;
                              glb.hideControls = true;
                              glb.showPayOption = false;
                              glb.customerID =
                                  completeOrdersModel[index].customerID;
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
                                            '${completeOrdersModel[index].order_status}',
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
                                            '#${completeOrdersModel[index].orderID}',
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
                                            completeOrdersModel[index]
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
                                            completeOrdersModel[index]
                                                .delivery_epoch,
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
                                            completeOrdersModel[index].address,
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
                                            '₹ ${completeOrdersModel[index].totalPrice}/-',
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
