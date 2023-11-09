import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/animation/slide_left_animation.dart';
import 'package:vff_group/delivery_boy_app/pages/main_pages/bottom_page_main.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;
import 'package:widget_circular_animator/widget_circular_animator.dart';

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
      } else if (widget.orderStatus == "Pick Up Done") {
        updateToStatus = "Reached Store";
      } else if (widget.orderStatus == "Out for Delivery") {
        updateToStatus = "Completed";
      }
      selectedValue = updateToStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        color: AppColors.whiteColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'UPDATE ORDER STATUS',
                    style: nunitoStyle.copyWith(
                      color: AppColors.backColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: FadeAnimation(
                    delay: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: widget.orderStatus == "Accepted" ||
                                      widget.orderStatus == "Payment Done" ||
                                      widget.orderStatus == "Pick Up Done" ||
                                      widget.orderStatus == "Reached Store" ||
                                      widget.orderStatus == "Processing" ||
                                      widget.orderStatus ==
                                          "Out for Delivery" ||
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
                                      widget.orderStatus == "Reached Store" ||
                                      widget.orderStatus == "Processing" ||
                                      widget.orderStatus ==
                                          "Out for Delivery" ||
                                      widget.orderStatus == "Completed"
                                  ? AppColors.backColor
                                  : AppColors.blueColor,
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 1,
                          color: widget.orderStatus == "Processing" ||
                                  widget.orderStatus == "Reached Store" ||
                                  widget.orderStatus == "Pick Up Done" ||
                                  widget.orderStatus == "Out for Delivery" ||
                                  widget.orderStatus == "Completed"
                              ? AppColors.neonColor
                              : AppColors.backColor,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: widget.orderStatus == "Processing" ||
                                      widget.orderStatus ==
                                          "Out for Delivery" ||
                                      widget.orderStatus == "Completed"
                                  ? AppColors.neonColor
                                  : AppColors.lightBlackColor,
                              borderRadius: BorderRadius.circular(50.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.local_laundry_service_outlined,
                              color: widget.orderStatus == "Processing" ||
                                      widget.orderStatus ==
                                          "Out for Delivery" ||
                                      widget.orderStatus == "Completed"
                                  ? AppColors.backColor
                                  : AppColors.blueColor,
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
                                : AppColors.backColor),
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
                ),
                SizedBox(
                  height: width * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Status',
                        style: nunitoStyle.copyWith(
                          color: AppColors.backColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      widget.orderStatus == "Rejected"
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
                                const CircularProgressIndicator(
                                  color: Colors.green,
                                  strokeWidth: 1,
                                )
                              ],
                            )
                          : Text(
                              widget.orderStatus,
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
                          color: AppColors.backColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '#${widget.orderID}',
                        style: nunitoStyle.copyWith(
                          color: AppColors.blueColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: AppColors.backColor,
                  thickness: 0.2,
                ),
                SlideFromLeftAnimation(
                  delay: 0.8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            WidgetCircularAnimator(
                                size: 50,
                                innerIconsSize: 3,
                                outerIconsSize: 3,
                                innerAnimation: Curves.easeInOutBack,
                                outerAnimation: Curves.easeInOutBack,
                                innerColor: Colors.pink,
                                outerColor: Colors.green,
                                innerAnimationSeconds: 10,
                                outerAnimationSeconds: 10,
                                child: updateToStatus == "Pick Up Done"
                                    ? Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[200]),
                                        child: Icon(
                                          Icons.delivery_dining_sharp,
                                          color: AppColors.backColor,
                                        ))
                                    : Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[200]),
                                        child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('👍')),
                                      )),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width - 120,
                                  child: Text(
                                    'You will update the Status from ${widget.orderStatus} to',
                                    style: nunitoStyle.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.normal,
                                        color: AppColors.backColor),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                                Text(
                                  updateToStatus,
                                  style: nunitoStyle.copyWith(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blueColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                showLoading
                    ? Center(child: CircularProgressIndicator())
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
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.deepOrange),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      'Update Status',
                                      style: nunitoStyle.copyWith(
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
                      ),
                SizedBox(
                  height: width * 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
