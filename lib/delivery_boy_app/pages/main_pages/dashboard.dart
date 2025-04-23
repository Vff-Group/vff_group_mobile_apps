// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/animation/slide_left_animation.dart';
import 'package:vff_group/delivery_boy_app/models/new_orders.dart';
import 'package:vff_group/notification_services.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<NewOrders> newOrdersModel = [];
  bool showLoading = true, noOrders = true;
  NotificationServices notificationServices = NotificationServices();
  var deviceToken = "", myStatus = "";
  bool showProgress = false;
  String totalCompletedCount = "0";
  String totalRejectedCount = "0";
  String totalOngoingCount = "0";
  String totalReturned = "0";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermissions();
    notificationServices.foregroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefreshedDeliveryApp();
    loadStats();
    updateAsOnline();
    loadNewOrders();
    getDefault();

    //Set default app
    SharedPreferenceUtils.save_val('AppPreference', 'DMainRoute');
  }

  var profile_img = "", userName = "";
  Future getDefault() async {
    var profile = glb.prefs?.getString('dprofile_img');
    var dusrname = glb.prefs?.getString('dusrname');
    var dusrid = glb.prefs?.getString('dusrid');
    // print('dusrid::$dusrid');
    // if(dusrid == null || dusrid.isEmpty){
    //   Navigator.popAndPushNamed(context, DeliveryLoginRoute);
    //   return;
    // }
    if (profile != null && profile.isNotEmpty) {
      setState(() {
        profile_img = profile;
      });
    }

    if (dusrname != null && dusrname.isNotEmpty) {
      var split = dusrname.split(" ");

      setState(() {
        userName = split[0];
      });
    }
    var notificationToken = glb.prefs?.getString('delivery_notificationToken');
    print("DeliveryBoyNotificationToken::$notificationToken");
    if (notificationToken == null || notificationToken.isEmpty) {
      notificationServices.getDeviceToken().then((value) => {
            deviceToken = value.toString().replaceAll(':', '__colon__'),
            SharedPreferenceUtils.save_val('delivery_notificationToken', deviceToken),
            updateDeviceToken(),
            print('Delivery Boy DeviceToken:$value')
          });
    }
    // else {
    //   notificationServices.getDeviceToken().then((value) => {
    //         deviceToken = value.toString().replaceAll(':', '__colon__'),
    //         SharedPreferenceUtils.save_val('notificationToken', deviceToken),
    //         updateDeviceToken(),
    //         print('Delivery Boy DeviceToken:$value')
    //       });
    // }
  }

  Future updateDeviceToken() async {
    glb.prefs = await SharedPreferences.getInstance();

    var dclat = glb.prefs?.getString('dclat');
    if (deviceToken.isEmpty) {
      print('DeviceToken is Empty');
      return;
    }
    try {
      var url = glb.endPoint;
      url+="update_user_device_token/";
      final Map dictMap = {};

      dictMap['clat'] = dclat;
      dictMap['deviceToken'] = deviceToken;
      // dictMap['pktType'] = "5";
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
          // glb.showSnackBar(context, 'Error', 'No Categories Found');
          return;
        } else if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          print('Delivery Boy Device Token Updated Successfully');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      glb.handleErrors(e, context);
    }
  }

  Future loadStats() async {
    //norder_id
    setState(() {
      showLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var delivery_boy_id = prefs.getString('delivery_boy_id');
    if (true) {
      try {
        var url = glb.endPoint;
        url+="delivery_boy_stats/";
        final Map dictMap = {};

        dictMap['deliveryboyid'] = delivery_boy_id;
        // dictMap['pktType'] = "28";
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
            glb.showSnackBar(context, 'Alert', 'No New Orders Found');
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
            try {
              Map<String, dynamic> statsMap = json.decode(response.body);
              print("statsMap::$statsMap");
              var total_pickup = statsMap['total_pickup'];
              
              var total_drop = statsMap['total_drop'];
              var total_returned = statsMap['total_returned'];
            print('total_drop::$total_drop');
              setState(() {
                totalCompletedCount = total_pickup;
                
                totalOngoingCount = total_drop;
                print('totalOngoingCount::$totalOngoingCount');
                totalReturned = total_returned;
              });
//9535934596
              setState(() {
                showLoading = false;
              });
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
              return "Failed";
            }
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

  Future loadNewOrders() async {
    //norder_id
    setState(() {
      showLoading = true;
      noOrders = false;
    });
    final prefs = await SharedPreferences.getInstance();
    var nbooking_id = prefs.getString('nbooking_id');
    var delivery_boy_branch_id = prefs.getString('delivery_boy_branch_id');
    print('Notification OrderID Dashboard::$nbooking_id');
    if (nbooking_id != null && nbooking_id.isNotEmpty) {
      try {
        var url = glb.endPoint;
        url+="load_new_orders_requested_to_delivery_boy/";
        final Map dictMap = {};

        dictMap['booking_id'] = nbooking_id;
        dictMap['branch_id'] = delivery_boy_branch_id;
        // dictMap['pktType'] = "7";
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
            //glb.showSnackBar(context, 'Error', 'No New Orders Found');
            setState(() {
              showLoading = false;
              noOrders = true;
            });
            return;
          } else if (res.contains("ErrorCode#8")) {
            glb.showSnackBar(context, 'Error', 'Something Went Wrong');
            setState(() {
              showLoading = false;
              noOrders = true;
            });
            return;
          } else {
            try {
              Map<String, dynamic> orderMap = json.decode(response.body);
              print("OrderNotificationMap::$orderMap");
              var bookingid = orderMap['bookingid'];
              var customerid = orderMap['customerid'];
              var address = orderMap['address'];
              var city = orderMap['city'];
              var pincode = orderMap['pincode'];
              var landmark = orderMap['landmark'];
              // var clat = orderMap['clat'];
              // var clng = orderMap['clng'];
              var time_at = orderMap['time_at'];
              var customer_name = orderMap['customer_name'];

              List<String> bookingidLst = glb.strToLst2(bookingid);
              List<String> customeridLst = glb.strToLst2(customerid);
              List<String> addressLst = glb.strToLst2(address);
              List<String> cityLst = glb.strToLst2(city);
              List<String> pincodeLst = glb.strToLst2(pincode);
              List<String> landmarkLst = glb.strToLst2(landmark);
              // List<String> clatLst = glb.strToLst2(clat);
              // List<String> clngLst = glb.strToLst2(clng);
              List<String> time_atLst = glb.strToLst2(time_at);
              List<String> customer_nameLst = glb.strToLst2(customer_name);

              for (int i = 0; i < bookingidLst.length; i++) {
                var bookingid = bookingidLst.elementAt(i).toString();
                var customerid = customeridLst.elementAt(i).toString();
                var address = addressLst.elementAt(i).toString();
                var city = cityLst.elementAt(i).toString();
                var pincode = pincodeLst.elementAt(i).toString();
                var landmark = landmarkLst.elementAt(i).toString();
                // var clat = clatLst.elementAt(i).toString();
                // var clng = clngLst.elementAt(i).toString();
                var time_at = time_atLst.elementAt(i).toString();
                var customer_name = customer_nameLst.elementAt(i).toString();
                var time_booking_done =
                    glb.doubleEpochToFormattedDateTime(double.parse(time_at));
                newOrdersModel.add(NewOrders(
                    bookingID: bookingid,
                    CustomerID: customerid,
                    CustomerName: customer_name,
                    // CLatitute: clat,
                    // CLongitude: clng,
                    Time: time_booking_done,
                    Address: address + city,
                    Landmark: landmark,
                    Pincode: pincode));
              }

              setState(() {
                showLoading = false;
                noOrders = false;
              });
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
              return "Failed";
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        glb.handleErrors(e, context);
        setState(() {
          showLoading = false;
          noOrders = true;
        });
      }
    } else {
      setState(() {
        showLoading = false;
        noOrders = true;
      });
    }
  }

  Future updateAsOnline() async {
    final prefs = await SharedPreferences.getInstance();

    var deliveryBoyId = prefs.getString('delivery_boy_id');
    var mark_free = prefs.getString('mark_free');
    if (mark_free == null || mark_free.isEmpty) {
      mark_free = "";
    }
    try {
      var url = glb.endPoint;
      url+="mark_delivery_boy_as_online/";
      final Map dictMap = {};

      dictMap['delivery_boy_id'] = deliveryBoyId;
      dictMap['set_free'] = mark_free;
      // dictMap['pktType'] = "23";
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
          // glb.showSnackBar(context, 'Error', 'No New Orders Found');
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showProgress = false;
          });
          // glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            if (mark_free != null &&
                mark_free.isNotEmpty &&
                mark_free == "Free") {
              print('Restoring to default status');
              SharedPreferenceUtils.save_val("mark_free", "");
            }
            Map<String, dynamic> statusMap = json.decode(response.body);

            var status = statusMap['status'];
            print('Delivery Boy Current Status::$status');
            setState(() {
              myStatus = status;
            });
          } catch (e) {
            print(e);
          }
          //status
          setState(() {
            showProgress = false;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        showProgress = false;
      });
      glb.handleErrors(e, context);
    }
  }

  Future accept_or_rejectOrder(String bookingStatus) async {
    //norder_id
    setState(() {
      showProgress = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var nbooking_id = prefs.getString('nbooking_id');
    var delivery_boy_branch_id = prefs.getString('delivery_boy_branch_id');
    var deliveryBoyId = prefs.getString('delivery_boy_id');
    if (nbooking_id != null) {
      print('Notification nbooking_id Dashboard::$nbooking_id');
      try {
        var url = glb.endPoint;
        url+="accept_or_reject_order_delivery_boy/";
        final Map dictMap = {};

        dictMap['booking_id'] = nbooking_id;
        dictMap['delivery_boy_id'] = deliveryBoyId;
        dictMap['status'] = bookingStatus;
        dictMap['branch_id'] = delivery_boy_branch_id;
        // dictMap['pktType'] = "8";
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
            // glb.showSnackBar(context, 'Error', 'No New Orders Found');
            return;
          } else if (res.contains("ErrorCode#8")) {
            setState(() {
              showProgress = false;
            });
            glb.showSnackBar(context, 'Error', 'Something Went Wrong');
            return;
          } else {
            SharedPreferenceUtils.save_val('nbooking_id', '');
            setState(() {
              showProgress = false;
            });
            glb.showSnackBar(context, 'Success', 'Order Accepted Successfully');

            Navigator.pushReplacementNamed(context, DMainRoute);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        setState(() {
          showProgress = false;
        });
        glb.handleErrors(e, context);
      }
    }
  }

  /// when you want to close the menu you have to create
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  // Widget float1() {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 8.0),
  //     child: FloatingActionButton(
  //       onPressed: () {},
  //       backgroundColor: Colors.deepPurple,
  //       heroTag: "btn1",
  //       tooltip: 'VFF Gym',
  //       child: const Icon(Icons.fitness_center),
  //     ),
  //   );
  // }

  Widget float2() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, MainRoute);
        },
        backgroundColor: Colors.deepPurple,
        heroTag: "btn2",
        tooltip: 'Laundry',
        child: const Icon(Icons.local_laundry_service),
      ),
    );
  }

  // Widget float3() {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 8.0),
  //     child: FloatingActionButton(
  //       onPressed: () {},
  //       backgroundColor: Colors.green,
  //       heroTag: "btn3",
  //       tooltip: 'Coming Soon',
  //       child: const Icon(LineIcons.tShirt),
  //     ),
  //   );
  // }

  Future<void> _handleRefresh() async {
    notificationServices.requestNotificationPermissions();
    notificationServices.foregroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefreshed();
    loadStats();
    updateAsOnline();
    loadNewOrders();
    getDefault();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        actions: [
          // Positioned(
          //                       left: 20,
          //                       child: Container(
          //                         width: 10,
          //                         height: 10,
          //                         decoration: const BoxDecoration(
          //                           shape: BoxShape.circle,
          //                           color: Colors.red,
          //                         ),
          //                       ),
          //                     ),
           IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, DeliveryBoyNotificationRoute);
                        },
                        icon: Image.asset(
                          "assets/icons/notification_icon.png",
                          width: 25,
                          height: 25,
                          color: Colors.white,
                          fit: BoxFit.fitHeight,
                        ))
         
        ],
        title: Image.asset(
          'assets/logo/velvet_2.png',
          width: 150,
        ),
        // leading: InkWell(
        //   onTap: () {},
        //   child: WidgetCircularAnimator(
        //     size: 40,
        //     innerIconsSize: 3,
        //     outerIconsSize: 3,
        //     innerAnimation: Curves.easeInOutBack,
        //     outerAnimation: Curves.easeInOutBack,
        //     innerColor: Colors.deepPurple,
        //     outerColor: Colors.orangeAccent,
        //     innerAnimationSeconds: 10,
        //     outerAnimationSeconds: 10,
        //     child: Container(
        //         decoration: BoxDecoration(
        //             shape: BoxShape.circle, color: Colors.grey[200]),
        //         child: profile_img.isEmpty == false
        //             ? CircleAvatar(
        //                 radius: 25.0,
        //                 backgroundImage: NetworkImage(profile_img),
        //                 backgroundColor: Colors.transparent,
        //               )
        //             : const Icon(Icons.person)),
        //   ),
        // ),
     
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 2.2 * kToolbarHeight, 20, 20),
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _handleRefresh,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Text('Hey,',
                                style: nunitoStyle.copyWith(
                                    color: AppColors.backColor,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.normal)),
                            Text('${userName} 👋',
                                style: nunitoStyle.copyWith(
                                    color: AppColors.backColor,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text('Delivering Speed and Care',
                            style: nunitoStyle.copyWith(
                                color: AppColors.backColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.normal)),
                        SizedBox(
                          height: width * 0.02,
                        ),
                        Container(
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                color:
                                                    AppColors.lightBlackColor),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 30.0,
                                                            bottom: 10.0),
                                                    child: Icon(
                                                      Icons.delivery_dining,
                                                      color: Colors.green,
                                                      size: 35.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Pickups Done',
                                                    style: nunitoStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            AppColors.backColor,
                                                        fontSize: 16.0),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 6.0,
                                                            bottom: 10.0),
                                                    child: Text(
                                                      totalCompletedCount,
                                                      style:
                                                          nunitoStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .backColor,
                                                              fontSize: 25.0),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ]),
                                          ),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              color: AppColors.lightBlackColor,
                                            ),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 30.0,
                                                            bottom: 10.0),
                                                    child: Icon(
                                                      LineIcons.truck,
                                                      color: Colors.deepOrange,
                                                      size: 35.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Drops Done',
                                                    style: nunitoStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            AppColors.backColor,
                                                        fontSize: 16.0),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 6.0,
                                                            bottom: 10.0),
                                                    child: Text(
                                                      totalOngoingCount.toString(),
                                                      style:
                                                          nunitoStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .backColor,
                                                              fontSize: 25.0),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ]),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10.0,
                                    left: 8.0,
                                    right: 8.0,
                                    top: 1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              color: AppColors.lightBlackColor,
                                            ),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 30.0,
                                                            bottom: 10.0),
                                                    child: Icon(
                                                      Icons.cancel_outlined,
                                                      color: Colors.red,
                                                      size: 35.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Cancelled Delivery',
                                                    style: nunitoStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            AppColors.backColor,
                                                        fontSize: 16.0),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 6.0,
                                                            bottom: 10.0),
                                                    child: Text(
                                                      totalRejectedCount,
                                                      style:
                                                          nunitoStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .backColor,
                                                              fontSize: 25.0),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ]),
                                          ),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              color: AppColors.lightBlackColor,
                                            ),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 30.0,
                                                            bottom: 10.0),
                                                    child: Icon(
                                                      Icons.report_rounded,
                                                      color: Colors.blue,
                                                      size: 35.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Return Delivery',
                                                    style: nunitoStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            AppColors.backColor,
                                                        fontSize: 16.0),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 6.0,
                                                            bottom: 10.0),
                                                    child: Text(
                                                      totalReturned,
                                                      style:
                                                          nunitoStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .backColor,
                                                              fontSize: 25.0),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ]),
                                          ),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('New Orders [ ${myStatus}]',
                                  style: nunitoStyle.copyWith(
                                      fontSize: 20.0,
                                      color: AppColors.backColor,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1)),
                              showLoading
                                  ? Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Center(
                                          child: LinearProgressIndicator()),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: noOrders
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(26.0),
                                              child: Center(
                                                child: Text(
                                                  'No New Orders\n My Current Status is ${myStatus}',
                                                  style: nunitoStyle.copyWith(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.backColor,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : showProgress
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : Container(
                                                  height: 200,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          newOrdersModel.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Container(
                                                            width: width - 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .lightBlackColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            100, // Adjust the width and height as needed
                                                                        height:
                                                                            100,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                AppColors.backColor, // Choose your border color
                                                                            width:
                                                                                2.0, // Choose your border width
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            ClipOval(
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/delivery.gif',
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(
                                                                              8.0,
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              'Pick Up Request',
                                                                              style: nunitoStyle.copyWith(fontWeight: FontWeight.bold, color: AppColors.backColor, fontSize: 16.0),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(5.0),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(right: 8.0),
                                                                                  child: Icon(
                                                                                    Icons.location_history_rounded,
                                                                                    color: Colors.orange,
                                                                                    size: 18,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: width - 180,
                                                                                  child: Text(
                                                                                    "${newOrdersModel[index].Address}-${newOrdersModel[index].Pincode}\n${newOrdersModel[index].Landmark}",
                                                                                    style: nunitoStyle.copyWith(
                                                                                      fontSize: 12.0,
                                                                                      color: AppColors.backColor,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(5.0),
                                                                                child: Icon(
                                                                                  Icons.watch_later_outlined,
                                                                                  color: Colors.orange,
                                                                                  size: 18,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                newOrdersModel[index].Time,
                                                                                style: nunitoStyle.copyWith(
                                                                                  fontSize: 12.0,
                                                                                  color: AppColors.backColor,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Material(
                                                                          color:
                                                                              Colors.transparent,
                                                                          child:
                                                                              InkWell(
                                                                            borderRadius:
                                                                                BorderRadius.circular(12.0),
                                                                            onTap:
                                                                                () {
                                                                              var bookingStatus = "Accepted";
                                                                              accept_or_rejectOrder(bookingStatus);
                                                                            },
                                                                            child:
                                                                                Ink(
                                                                              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12.0)),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 12.0),
                                                                                child: Text(
                                                                                  'Accept',
                                                                                  style: nunitoStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Visibility(
                                                                        visible: false,
                                                                        child: Material(
                                                                          color: Colors
                                                                              .transparent,
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              var bookingStatus =
                                                                                  "Rejected";
                                                                              accept_or_rejectOrder(bookingStatus);
                                                                            },
                                                                            borderRadius:
                                                                                BorderRadius.circular(12.0),
                                                                            child:
                                                                                Ink(
                                                                              decoration:
                                                                                  BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12.0)),
                                                                              child:
                                                                                  Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 12.0),
                                                                                child: Text(
                                                                                  'Reject',
                                                                                  style: nunitoStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
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
                                                        );
                                                      }),
                                                ),
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
          onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, MainRoute);
          },
          child: Icon(Icons.local_laundry_service), // Icon inside the FAB
        ),
      // floatingActionButton: SlideFromLeftAnimation(
      //   delay: 1.2,
      //   child: AnimatedFloatingActionButton(
      //       //Fab list
      //       // fabButtons: <Widget>[float1(), float2(), float3()],
      //       fabButtons: <Widget>[float2()],
      //       key: key,
      //       colorStartAnimation: Colors.orange,
      //       colorEndAnimation: Colors.deepOrange,
      //       animatedIconData: AnimatedIcons.list_view //To principal button
      //       ),
      // ),
    
    );
  }
}
