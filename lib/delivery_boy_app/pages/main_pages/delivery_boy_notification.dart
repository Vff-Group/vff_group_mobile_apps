import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/modals/notifications_model.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:http/http.dart' as http;
import 'package:vff_group/global/vffglb.dart' as glb;

class DeliveryBoyNotificationsPage extends StatefulWidget {
  const DeliveryBoyNotificationsPage({super.key});

  @override
  State<DeliveryBoyNotificationsPage> createState() =>
      _DeliveryBoyNotificationsPageState();
}

class _DeliveryBoyNotificationsPageState
    extends State<DeliveryBoyNotificationsPage> {
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
    var delivery_boy_id = prefs.getString('delivery_boy_id');

    var todaysDate = glb.getDateTodays();
    try {
      var url = glb.endPoint;
      url+="load_todays_notifications/";
      final Map dictMap = {};

      dictMap['customerordeliveryboyid'] = delivery_boy_id;
      // dictMap['pktType'] = "27";
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
            noNotification = true;
          });
          glb.showSnackBar(
              context, 'Alert', 'No New Notifications Found For Today');
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
            var booking_id = notifyMap['booking_id'];

            List<String> notify_idLst = glb.strToLst2(notify_id);
            List<String> titleLst = glb.strToLst2(title);
            List<String> bodyLst = glb.strToLst2(body);
            List<String> epoch_timeLst = glb.strToLst2(epoch_time);
            List<String> order_idLst = glb.strToLst2(order_id);
            List<String> intentLst = glb.strToLst2(intent);
            List<String> bookingIdLst = glb.strToLst2(booking_id);

            for (int i = 0; i < notify_idLst.length; i++) {
              var notify_id = notify_idLst.elementAt(i).toString();
              var title = titleLst.elementAt(i).toString();
              var bodyMsg = bodyLst.elementAt(i).toString();
              var epoch_time = epoch_timeLst.elementAt(i).toString();
              var order_id = order_idLst.elementAt(i).toString();
              var intent = intentLst.elementAt(i).toString();
              var bookingid = bookingIdLst.elementAt(i).toString();

              var formattedDateTime =
                  glb.doubleEpochToFormattedDateTime(double.parse(epoch_time));

              notifyModel.add(NotifyModel(
                  notifyID: notify_id,
                  title: title,
                  body: bodyMsg,
                  time: formattedDateTime,
                  orderID: order_id,
                  intentScreen: intent,
                  bookingID: bookingid));
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
        backgroundColor: AppColors.whiteColor,
        
        appBar: AppBar(
          
          elevation: 0,
          title: Text('Notifications 📬',
              style: nunitoStyle.copyWith(
                  fontSize: 25.0,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: showLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : noNotification
                  ? Center(
                      child: Text(
                        'No New Notifications Found For Today',
                        style: nunitoStyle.copyWith(
                            color: AppColors.backColor, fontSize: 20.0),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: notifyModel.length,
                              itemBuilder: ((context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      print(
                                          'NotifyRoute::${notifyModel[index].intentScreen}');
                                      SharedPreferenceUtils.save_val(
                                          'nbooking_id',
                                          notifyModel[index].bookingID);
                                      Navigator.pop(context);
                                      Navigator.pushReplacementNamed(context,
                                          notifyModel[index].intentScreen);
                                    },
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
                                                      decoration:
                                                          BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    8.0),
                                                        color: glb
                                                            .generateRandomColorWithOpacity(),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Text(
                                                          notifyModel[index]
                                                              .notifyID,
                                                          style: nunitoStyle
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: AppColors
                                                                      .backColor),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .all(12.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            notifyModel[index]
                                                                .title,
                                                            style: nunitoStyle.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .backColor),
                                                          ),
                                                          SizedBox(
                                                            height: 2.0,
                                                          ),
                                                          SizedBox(
                                                            width: 200,
                                                            child: Text(
                                                              notifyModel[
                                                                      index]
                                                                  .body,
                                                              style: nunitoStyle.copyWith(
                                                                  color: AppColors
                                                                      .backColor,
                                                                  fontSize:
                                                                      10.0),
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
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
                                                                .circular(
                                                                    4.0)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                                  18.0,
                                                              vertical: 4.0),
                                                      child: Text(
                                                        'In Progress',
                                                        style: nunitoStyle
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .whiteColor,
                                                                fontSize:
                                                                    10.0),
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
                                                                .circular(
                                                                    4.0)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                                  18.0,
                                                              vertical: 4.0),
                                                      child: Text(
                                                        'Completed',
                                                        style: nunitoStyle
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .whiteColor,
                                                                fontSize:
                                                                    10.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: false,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    4.0)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                                  18.0,
                                                              vertical: 4.0),
                                                      child: Text(
                                                        'Cancelled',
                                                        style: nunitoStyle
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .whiteColor,
                                                                fontSize:
                                                                    10.0),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(6.0),
                                              child: Divider(
                                                color: AppColors.backColor,
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
                                                  notifyModel[index].time,
                                                  style: nunitoStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12.0,
                                                      color: AppColors
                                                          .backColor),
                                                ),
                                                Icon(
                                                  Icons.more_horiz,
                                                  color: AppColors.blueColor,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                        ),
                      ],
                    ),
        ));
  }
}
