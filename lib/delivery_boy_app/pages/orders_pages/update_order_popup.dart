import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/delivery_boy_app/pages/main_pages/bottom_page_main.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

class UpdateOrderStatusPopup extends StatefulWidget {
  const UpdateOrderStatusPopup(
      {super.key, required this.orderID, required this.orderStatus});
  final String orderID;
  final String orderStatus;
  @override
  State<UpdateOrderStatusPopup> createState() => _UpdateOrderStatusPopupState();
}

class _UpdateOrderStatusPopupState extends State<UpdateOrderStatusPopup> {
  String selectedValue = "";
  var updateToStatus = "";

  bool showLoading = false;
  Future updateOrderStatus() async {
    //norder_id
    setState(() {
      showLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var delivery_boy_id = prefs.getString('delivery_boy_id');
    if (true) {
      try {
        var url = glb.endPoint;
        final Map dictMap = {};
        dictMap['order_status'] = updateToStatus;
        dictMap['order_id'] = widget.orderID;
        dictMap['delivery_boy_id'] = delivery_boy_id;
        dictMap['pktType'] = "26";
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
            //  glb.showSnackBar(context, 'Error', 'No New Orders Found');
            setState(() {
              showLoading = false;
            });
            return;
          } else if (res.contains("ErrorCode#8")) {
            glb.showSnackBar(context, 'Error', 'Something Went Wrong');
            setState(() {
              showLoading = false;
            });
            return;
          } else {
            //Order Updated Successfully
            setState(() {
              showLoading = false;
            });
            glb.showSnackBar(context, 'Success', 'Order Updated Successfully');
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BottomBarDeliveryBoy(pageDIndex: 0)));
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        glb.handleErrors(e, context);
        setState(() {
          showLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('widget.orderStatus::${widget.orderStatus}');
    setState(() {
      if (widget.orderStatus == "Payment Done") {
        updateToStatus = "Pick Up Done";
      } else if (widget.orderStatus == "Out for Delivery") {
        updateToStatus = "Completed";
      }
      selectedValue = updateToStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightBlackColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Update Order Status',
                    style: ralewayStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: AppColors.whiteColor),
                  ),
                ),
              ),
              FadeAnimation(
                delay: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: widget.orderStatus == "Accepted" ||
                                  widget.orderStatus == "Payment Done" ||
                                  widget.orderStatus == "Pick Up Done" ||
                                  widget.orderStatus == "Processing" ||
                                  widget.orderStatus == "Out for Delivery" ||
                                  widget.orderStatus == "Delivered"
                              ? AppColors.neonColor
                              : AppColors.lightBlackColor,
                          borderRadius: BorderRadius.circular(50.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.delivery_dining_sharp,
                          color: widget.orderStatus == "Accepted" ||
                                  widget.orderStatus == "Payment Done" ||
                                  widget.orderStatus == "Pick Up Done" ||
                                  widget.orderStatus == "Processing" ||
                                  widget.orderStatus == "Out for Delivery" ||
                                  widget.orderStatus == "Completed"
                              ? AppColors.backColor
                              : AppColors.whiteColor,
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 1,
                      color: widget.orderStatus == "Processing" ||
                              widget.orderStatus == "Pick Up Done" ||
                              widget.orderStatus == "Out for Delivery" ||
                              widget.orderStatus == "Completed"
                          ? AppColors.neonColor
                          : AppColors.whiteColor,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: widget.orderStatus == "Processing" ||
                                  widget.orderStatus == "Out for Delivery" ||
                                  widget.orderStatus == "Completed"
                              ? AppColors.neonColor
                              : AppColors.lightBlackColor,
                          borderRadius: BorderRadius.circular(50.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.local_laundry_service_outlined,
                          color: widget.orderStatus == "Processing" ||
                                  widget.orderStatus == "Out for Delivery" ||
                                  widget.orderStatus == "Completed"
                              ? AppColors.backColor
                              : AppColors.whiteColor,
                        ),
                      ),
                    ),
                    Container(
                        width: 100,
                        height: 1,
                        color: widget.orderStatus == "Processing" ||
                                widget.orderStatus == "Out for Delivery" ||
                                widget.orderStatus == "Completed"
                            ? AppColors.neonColor
                            : AppColors.whiteColor),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.lightBlackColor,
                          borderRadius: BorderRadius.circular(50.0)),
                      child: const Padding(
                          padding: EdgeInsets.all(8.0), child: Text('👍')),
                    ),
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Switch(
                            activeColor: AppColors.neonColor,
                            value: true,
                            onChanged: (value) {},
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  updateToStatus,
                                  style: nunitoStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.whiteColor),
                                ),
                                const SizedBox(
                                  height: 2.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      showLoading
                          ? CircularProgressIndicator()
                          : SlideFromBottomAnimation(
                              delay: 0.5,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12.0),
                                      onTap: () {
                                        print(
                                            "updateToStatus::$widget.updateToStatus");
                                        print("orderID::$widget.orderID");
                                        updateOrderStatus();
                                      },
                                      child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: Colors.deepOrange),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            'Update Status',
                                            style: ralewayStyle.copyWith(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
