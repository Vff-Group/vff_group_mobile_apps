import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_left_animation.dart';
import 'package:vff_group/delivery_boy_app/models/pickup_orders.dart';
import 'package:vff_group/modals/ongoing_orders_model.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;
import 'package:vff_group/widgets/shimmer_card.dart';

class DropOrdersPage extends StatefulWidget {
  const DropOrdersPage({super.key});

  @override
  State<DropOrdersPage> createState() => _DropOrdersPageState();
}

class _DropOrdersPageState extends State<DropOrdersPage> {
  final bool _noOrders = false;
  bool showLoading = false, showError = false;

  List<DropOrdersModel> dropOrdersModel = [];
  Future loadOrderDetails() async {
    setState(() {
      showLoading = true;
      showError = false;
      dropOrdersModel = [];
    });
    final prefs = await SharedPreferences.getInstance();
    var delivery_boy_id = prefs.getString('delivery_boy_id');
    var branch_id = prefs.getString('delivery_boy_branch_id');

    var todaysDate = glb.getDateTodays();
    glb.order_status = "0";
    try {
      var url = glb.endPoint;
      url+="load_all_drop_order/";
      final Map dictMap = {};

      dictMap['delivery_boy_id'] = delivery_boy_id;
      dictMap['branch_id'] = branch_id;
      // dictMap['pktType'] = "31";
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
          setState(() {
            showLoading = false;
          });
          //glb.showSnackBar(context, 'Error', 'No Order Details Found');
          showError = true;
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showLoading = false;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> onGoingOrdersMap = json.decode(response.body);
            if (kDebugMode) {
              print("onGoingOrdersMap:$onGoingOrdersMap");
            }

            var orderid = onGoingOrdersMap["order_id"];
            var customer_name = onGoingOrdersMap["customer_name"];
            var address = onGoingOrdersMap["address"];
            var city = onGoingOrdersMap["city"];
            var landmark = onGoingOrdersMap["landmark"];
            var pincode = onGoingOrdersMap["pincode"];
            var branch_name = onGoingOrdersMap["branch_name"];
            var branch_address = onGoingOrdersMap["branch_address"];
            
            

            List<String> orderidLst = glb.strToLst2(orderid);
            List<String> customer_nameLst = glb.strToLst2(customer_name);
            List<String> cityLst = glb.strToLst2(city);
            List<String> landmarkLst = glb.strToLst2(landmark);
            List<String> pincodeLst = glb.strToLst2(pincode);
            List<String> addressLst = glb.strToLst2(address);
            List<String> branch_nameLst = glb.strToLst2(branch_name);
            List<String> branch_addressLst = glb.strToLst2(branch_address);

            for (int i = 0; i < orderidLst.length; i++) {
              var orderid = orderidLst.elementAt(i).toString();
              var customer_name = customer_nameLst.elementAt(i).toString();
              var city_name = cityLst.elementAt(i).toString();
              var landmark = landmarkLst.elementAt(i).toString();
              var pincode = pincodeLst.elementAt(i).toString();
              var address = addressLst.elementAt(i).toString();
              var branch_name = branch_nameLst.elementAt(i).toString();
              var branch_address = branch_addressLst.elementAt(i).toString();

              var addressDetails = '';
              addressDetails = address +' '+ city_name +' '+ landmark+'-'+pincode;
              dropOrdersModel.add(DropOrdersModel(
                  orderId: orderid,
                  customerName: customer_name,
                  addressDetails: addressDetails,
                  branchName: branch_name,
                  branchAddress: branch_address));
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
                  'No Order Assigned For Delivery',
                  style: nunitoStyle.copyWith(
                      color: AppColors.backColor, fontSize: 20.0),
                ),
              )
            : RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                          itemCount: dropOrdersModel.length,
                          itemBuilder: ((context, index) {
                            Color randomColor =
                                glb.generateRandomColorWithOpacity();
                            return SlideFromLeftAnimation(
                              delay: 0.8,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      //Send to Current Order Screen
                                      glb.orderid_or_bookingid= dropOrdersModel[index].orderId;
                                      glb.orderType = "Drop";
                                      glb.booking_to_order_id='No';
                                      Navigator.pushNamed(context, CurrentOrderDeliveryRoute);
                                    },
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: AppColors.lightBlackColor,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0,
                                                          left: 8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          "Order ID #${dropOrdersModel[index].orderId}",
                                                          style: nunitoStyle
                                                              .copyWith(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: AppColors
                                                                      .blueColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1)),
                                                                        Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Text(
                                                            dropOrdersModel[index].customerName,
                                                            style: nunitoStyle.copyWith(
                                                                fontSize: 14.0,
                                                                color: AppColors
                                                                    .backColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    1)),
                                                      ),
                                                    
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Text(
                                                            dropOrdersModel[index].addressDetails,
                                                            style: nunitoStyle.copyWith(
                                                                fontSize: 10.0,
                                                                color: AppColors
                                                                    .textColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    1)),
                                                      ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                      'Branch Name: ${dropOrdersModel[index].branchName}',
                                                      style:
                                                          nunitoStyle.copyWith(
                                                              fontSize: 10.0,
                                                              color: Colors
                                                                  .deepPurple,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  1)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: SizedBox(
                                                    width: width - 50,
                                                    child: Text(
                                                        'Branch Address: [ ${dropOrdersModel[index].branchAddress} ]',
                                                        style: nunitoStyle
                                                            .copyWith(
                                                                fontSize: 12.0,
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    1)),
                                                  ),
                                                ),
                                                   
                                                    ],
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
