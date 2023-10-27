import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/modals/notifications_model.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:http/http.dart' as http;
import 'package:vff_group/global/vffglb.dart' as glb;

class CustomerNotifications extends StatefulWidget {
  const CustomerNotifications({super.key});

  @override
  State<CustomerNotifications> createState() => _CustomerNotificationsState();
}

class _CustomerNotificationsState extends State<CustomerNotifications> {
  bool noNotification = false, showLoading = true;
  List<NotifyModel> notifyModel = [];
  Future<void> _handleRefresh() async {
    Future.delayed(Duration(milliseconds: 5));
  }

  Future loadNotifications() async {
    setState(() {
      showLoading = true;
      noNotification = true;
      notifyModel = [];
    });
    final prefs = await SharedPreferences.getInstance();
    var customerid = prefs.getString('customerid');

    var todaysDate = glb.getDateTodays();
    try {
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['customerordeliveryboyid'] = customerid;
      dictMap['pktType'] = "27";
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
            noNotification = true;
          });
          glb.showSnackBar(
              context, 'Error', 'No New Notifications Found For Today');
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showLoading = false;
            noNotification = true;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> notifyMap = json.decode(response.body);
            // if (kDebugMode) {
            //   print("categoryMap:$catMap");
            // }
            var notify_id = notifyMap['notify_id'];
            var title = notifyMap['title'];
            var body = notifyMap['body'];
            var epoch_time = notifyMap['epoch_time'];
            var order_id = notifyMap['order_id'];
 var intent = notifyMap['intent'];

            List<String> notify_idLst = glb.strToLst2(notify_id);
            List<String> titleLst = glb.strToLst2(title);
            List<String> bodyLst = glb.strToLst2(body);
            List<String> epoch_timeLst = glb.strToLst2(epoch_time);
            List<String> order_idLst = glb.strToLst2(order_id);
            List<String> intentLst = glb.strToLst2(intent);

            for (int i = 0; i < notify_idLst.length; i++) {
              var notify_id = notify_idLst.elementAt(i).toString();
              var title = titleLst.elementAt(i).toString();
              var PickUpDate = bodyLst.elementAt(i).toString();
              var epoch_time = epoch_timeLst.elementAt(i).toString();
              var order_id = order_idLst.elementAt(i).toString();
              var intent = intentLst.elementAt(i).toString();

              var formattedDateTime =
                  glb.doubleEpochToFormattedDateTime(double.parse(epoch_time));

              notifyModel.add(NotifyModel(
                  notifyID: notify_id,
                  title: title,
                  body: body,
                  time: formattedDateTime,
                  orderID: order_id,
                  intentScreen: intent));
            }

            setState(() {
              showLoading = false;
              noNotification = false;
            });
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
            setState(() {
              showLoading = false;
              noNotification = true;
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
        noNotification = true;
      });
      glb.handleErrors(e, context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Notifications 📬',
              style: ralewayStyle.copyWith(
                  fontSize: 25.0,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 0.1 * kToolbarHeight, 0, 20),
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: showLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : noNotification
                    ? Center(
                        child: Text(
                          'No New Notifications Found For Today',
                          style: ralewayStyle.copyWith(
                              color: AppColors.whiteColor, fontSize: 20.0),
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: 2,
                                itemBuilder: ((context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          color: AppColors.lightBlackColor),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        color:
                                                            AppColors.hisColor,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Text(
                                                          'WF',
                                                          style: ralewayStyle
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Wash and Fold laundry',
                                                            style: ralewayStyle.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .whiteColor),
                                                          ),
                                                          SizedBox(
                                                            height: 2.0,
                                                          ),
                                                          Text(
                                                            'Delivery in the next 24 hrs',
                                                            style: nunitoStyle.copyWith(
                                                                color: AppColors
                                                                    .whiteColor,
                                                                fontSize: 10.0),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: false,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.amber,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 18.0,
                                                          vertical: 4.0),
                                                      child: Text(
                                                        'In Progress',
                                                        style: ralewayStyle
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .whiteColor,
                                                                fontSize: 10.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: false,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 18.0,
                                                          vertical: 4.0),
                                                      child: Text(
                                                        'Completed',
                                                        style: ralewayStyle
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .whiteColor,
                                                                fontSize: 10.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: true,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 18.0,
                                                          vertical: 4.0),
                                                      child: Text(
                                                        'Cancelled',
                                                        style: ralewayStyle
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .whiteColor,
                                                                fontSize: 10.0),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(6.0),
                                              child: Divider(
                                                color: AppColors.whiteColor,
                                                height: 0.2,
                                                thickness: 0.2,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'March 18, 2023',
                                                  style: nunitoStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12.0,
                                                      color:
                                                          AppColors.whiteColor),
                                                ),
                                                Icon(
                                                  Icons.more_horiz,
                                                  color: Colors.white,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })),
                          ),
                        ],
                      ),
          ),
        ));
  }
}
