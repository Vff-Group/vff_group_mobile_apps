//select usrname,mobile_no,profile_img,device_token from vff.usertbl,vff.laundry_delivery_boytbl,vff.laundry_ordertbl where laundry_delivery_boytbl.usrid=usertbl.usrid and laundry_ordertbl.delivery_boyid=laundry_delivery_boytbl.delivery_boy_id and orderid='81';
//select usrname,mobile_no,profile_img,device_token from vff.usertbl,vff.laundry_customertbl,vff.laundry_ordertbl where laundry_customertbl.usrid=usertbl.usrid and laundry_ordertbl.customerid=laundry_customertbl.consmrid and orderid='81';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/animation/slide_left_animation.dart';
import 'package:vff_group/animation/slideright_animation.dart';
import 'package:vff_group/delivery_boy_app/pages/orders_pages/update_order_popup.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/widgets/dotted_line.dart';
import 'package:vff_group/widgets/rating_bar.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;
import 'package:widget_circular_animator/widget_circular_animator.dart';

class CurrentDeliveryPage extends StatefulWidget {
  const CurrentDeliveryPage({super.key});

  @override
  State<CurrentDeliveryPage> createState() => _CurrentDeliveryPageState();
}

class _CurrentDeliveryPageState extends State<CurrentDeliveryPage> {
  bool isOrderDelivered = false,
      isOrderPickup = false,
      isOrderProcessing = false;
  bool showData = false;
  bool showLoading = true, noOrders = true;
  String orderRecievedDate = "",
      orderID = "",
      bookingID = "",
      branchID = "",
      customerName = "",
      orderStatus = "",
      cLat = "",
      cLng = "",
      houseNo = "",
      addressUser = "",
      pinCode = "",
      cityName = "",
      landMark = "",
      profileImg = "",
      deviceToken = "",
      mobileNo = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCurrentOrders();
  }

  Future loadCurrentOrders() async {
    //norder_id
    setState(() {
      showLoading = true;
      noOrders = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var delivery_boy_id = prefs.getString('delivery_boy_id');
    if (true) {
      try {
        var url = glb.endPoint;
        url+="load_all_pickup_or_drop_booking_details/";
        final Map dictMap = {};

        // dictMap['pktType'] = "32";
        dictMap['delivery_boy_id'] = delivery_boy_id;
        dictMap['order_id'] = glb.orderid_or_bookingid;
        dictMap['order_type'] = glb.orderType;
        dictMap['booking_to_order_id'] = glb.booking_to_order_id;
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
            // glb.showSnackBar(context, 'Alert', 'No New Order Assigned');
            SharedPreferenceUtils.save_val("mark_free", "Free");
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
              Map<String, dynamic> currentOrderMap = json.decode(response.body);
              // print('currentOrderMap::$currentOrderMap');
              var orderid = currentOrderMap['orderid'];
              var customer_name = currentOrderMap['customer_name'];
              var pickup_dt = currentOrderMap['pickup_dt'];
              var order_status = currentOrderMap['order_status'];
              var clat = currentOrderMap['clat'];
              var clng = currentOrderMap['clng'];
              var houseno = currentOrderMap['houseno'];
              var address = currentOrderMap['address'];
              var pincode = currentOrderMap['pincode'];
              var landmark = currentOrderMap['landmark'];
              var city = currentOrderMap['city'];
              var profile_img = currentOrderMap['profile_img'];
              var device_token = currentOrderMap['device_token'];
              var mobile_no = currentOrderMap['mobile_no'];
              var booking_id = currentOrderMap['booking_id'];
              var customer_id = currentOrderMap['customer_id'];
              var branch_id = currentOrderMap['branch_id'];

              setState(() {
                orderRecievedDate =
                    glb.doubleEpochToFormattedDateTime(double.parse(pickup_dt));

                print("orderRecievedDate::$orderRecievedDate");
                showLoading = false;
                noOrders = false;
                orderID = orderid;
                bookingID = booking_id;
                customerName = customer_name;
                glb.customerID = customer_id;
                orderStatus = order_status;
                cLat = clat;
                cLng = clng;
                houseNo = houseno;
                addressUser = address;
                pinCode = pincode;
                cityName = city;
                landMark = landmark;
                profileImg = profile_img;
                deviceToken = device_token;
                mobileNo = mobile_no;
                branchID = branch_id;
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
    }
  }

  // Future<void> navigateTo(double lat, double lng) async {
  //   var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
  //   try {
  //     await launchUrl(uri);
  //   } catch (e) {
  //     print('Error Opening Map::$e');
  //   }
  // }

  Future<void> _handleRefresh() async {
    Future.delayed(Duration(milliseconds: 5));
    loadCurrentOrders();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        actions: [
          orderStatus == "Accepted" ||
          orderStatus == "Reached Pickup Location" ||
          orderStatus == "Payment Done" ||
                  orderStatus == "Out for Delivery" ||
                  orderStatus == "Pick Up Done"
              ? InkWell(
                  onTap: () {
                    if(orderID == '-1'){
                      orderID = bookingID;
                    }
                    _showPopup(context, orderID, orderStatus,deviceToken);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.update_outlined,
                      color: AppColors.whiteColor,
                    ),
                  ),
                )
              : Container()
        ],
        title: Text(
          noOrders == false && orderID == '-1'
              ? 'CURRENT PICKUP'
              : 'CURRENT DELIVERY',
          style: nunitoStyle.copyWith(
            color: AppColors.whiteColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: showLoading
          ? Center(child: CircularProgressIndicator())
          : noOrders
              ? Center(
                  child: Text(
                    'Not Assigned any Order Pickup / Drop',
                    style: nunitoStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: AppColors.backColor,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                          child: Column(
                        children: [
                          _OrderDetails(
                              bookingID: bookingID,
                              addressClient: addressUser,
                              orderID: orderID,
                              orderStatus: orderStatus,
                              pickUpDateTime: orderRecievedDate,
                              deliveryDateTime: 'Not Delivered'),
                          const Divider(
                            color: AppColors.backColor,
                            thickness: 0.5,
                          ),
                          _CustomerDetails(
                              width: width,
                              profilePicture: profileImg,
                              customerName: customerName,
                              mobileNo: mobileNo,
                              cLat: cLat,
                              cLng: cLng,
                              orderStatus: orderStatus),
                          const Divider(
                            color: AppColors.backColor,
                            thickness: 0.5,
                          ),
                          orderID == '-1'
                              ? Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Laundry',
                                        style: nunitoStyle.copyWith(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                          color: AppColors.backColor,
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                )
                              : Container()
                        ],
                      ))
                    ],
                  ),
                ),
    );
  }

  void _showPopup(BuildContext context, String orderID, String orderStatus,String deviceToken) {
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return UpdateOrderStatusPopup(
          orderID: orderID,
          orderStatus: orderStatus,
          deviceToken: deviceToken,
        );
      },
    );
  
  }
}

class _TotalClothesCount {}

Future<void> navigateTo(double lat, double lng) async {
  // Check if the URL can be launched (i.e., if the user has a map app installed).
  final webMapUrl =
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";
  print('webMapUrl::$webMapUrl');
  try {
    // Launch the map app with the specified coordinates and mode.
    await launchUrl(Uri.parse(webMapUrl));
  } catch (e) {
    print('Error Opening Map: $e');
    //     print('Could not launch the map app. Make sure a map app is installed.');
    // final webMapUrl = "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";

    // if (await canLaunch(webMapUrl)) {
    //   await launchUrl(Uri.parse(webMapUrl));
    // } else {
    //   print('Could not open the map in a web browser.');
    // }
  }
}

Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

class _CustomerDetails extends StatelessWidget {
  const _CustomerDetails({
    super.key,
    required this.width,
    required this.profilePicture,
    required this.customerName,
    required this.mobileNo,
    required this.orderStatus,
    required this.cLat,
    required this.cLng,
  });

  final double width;
  final String? profilePicture;
  final String customerName;
  final String mobileNo;
  final String cLat;
  final String cLng;
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
                        child: profilePicture != "NA"
                            ? Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[200]),
                                child: CircleAvatar(
                                  radius: 25.0,
                                  backgroundImage:
                                      NetworkImage('$profilePicture'),
                                  backgroundColor: Colors.transparent,
                                ),
                              )
                            : Container()),
                SizedBox(
                  width: width * 0.04,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      style: nunitoStyle.copyWith(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blueColor),
                    ),
                    Visibility(
                      visible: false,
                      child: Text(
                        mobileNo,
                        style: nunitoStyle.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: AppColors.backColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                SlideFromRightAnimation(
                  delay: 0.9,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _makePhoneCall(mobileNo);
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
                                color: AppColors.blueColor,
                                size: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Text(
                                  'Call',
                                  style: nunitoStyle.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.blueColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SlideFromRightAnimation(
                  delay: 0.9,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        navigateTo(double.parse(cLat), double.parse(cLng));
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
                                Icons.location_on,
                                color: AppColors.blueColor,
                                size: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Text(
                                  'Navigate',
                                  style: nunitoStyle.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.blueColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
    required this.bookingID,
  });
  final String orderStatus;
  final String orderID;
  final String bookingID;
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
                                orderStatus == "Pick Up Done" ||
                                orderStatus == "Processing" ||
                                orderStatus == "Out for Delivery" ||
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
                                orderStatus == "Pick Up Done" ||
                                orderStatus == "Processing" ||
                                orderStatus == "Out for Delivery" ||
                                orderStatus == "Completed"
                            ? AppColors.backColor
                            : AppColors.blueColor,
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 1,
                    color: orderStatus == "Processing" ||
                            orderStatus == "Pick Up Done" ||
                            orderStatus == "Out for Delivery" ||
                            orderStatus == "Completed"
                        ? AppColors.neonColor
                        : AppColors.backColor,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: orderStatus == "Processing" ||
                                orderStatus == "Out for Delivery" ||
                                orderStatus == "Completed"
                            ? AppColors.neonColor
                            : AppColors.lightBlackColor,
                        borderRadius: BorderRadius.circular(50.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.local_laundry_service_outlined,
                        color: orderStatus == "Processing" ||
                                orderStatus == "Out for Delivery" ||
                                orderStatus == "Completed"
                            ? AppColors.backColor
                            : AppColors.blueColor,
                      ),
                    ),
                  ),
                  Container(
                      width: 100,
                      height: 1,
                      color: orderStatus == "Processing" ||
                              orderStatus == "Out for Delivery" ||
                              orderStatus == "Completed"
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    orderID == '-1' ? 'Status' : 'Order',
                    style: nunitoStyle.copyWith(
                      color: AppColors.backColor,
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
                                    color: AppColors.blueColor,
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
                          orderStatus,
                          style: nunitoStyle.copyWith(
                              color: AppColors.blueColor,
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
                    orderID == '-1' ? 'Booking ID' : 'Order ID',
                    style: nunitoStyle.copyWith(
                      color: AppColors.backColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    orderID == '-1' ? '#${bookingID}' : '#${orderID}',
                    style: nunitoStyle.copyWith(
                      color: Colors.deepPurple,
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
                      color: AppColors.backColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    pickUpDateTime,
                    style: nunitoStyle.copyWith(
                      color: AppColors.backColor,
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
                      color: AppColors.backColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    deliveryDateTime,
                    style: nunitoStyle.copyWith(
                      color: AppColors.backColor,
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
                      color: AppColors.backColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    addressClient,
                    style: nunitoStyle.copyWith(
                      color: AppColors.backColor,
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

class _OldUI extends StatelessWidget {
  const _OldUI({
    super.key,
    required this.orderRecievedDate,
  });

  final String orderRecievedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: AppColors.lightBlackColor,
                    borderRadius: BorderRadius.circular(16.0)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Recieved',
                      style: nunitoStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      orderRecievedDate,
                      style: nunitoStyle.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 12.0,
                          color: AppColors.whiteColor),
                    )
                  ],
                ),
              ),
            ],
          ),
          // FadeAnimation(
          //   delay: 0.5,
          //   child: Container(
          //     padding: const EdgeInsets.only(left: 28),
          //     child: DottedVerticalLine(
          //       height: 30.0,
          //       color: Colors.green,
          //     ),
          //   ),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Container(
          //       decoration: BoxDecoration(
          //           color: AppColors.lightBlackColor,
          //           borderRadius:
          //               BorderRadius.circular(16.0)),
          //       child: const Padding(
          //           padding: EdgeInsets.all(16.0),
          //           child: Icon(
          //             Icons.pin_drop_rounded,
          //             color: Colors.deepPurple,
          //           )),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Column(
          //         crossAxisAlignment:
          //             CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             'Pickup',
          //             style: nunitoStyle.copyWith(
          //                 fontWeight: FontWeight.bold,
          //                 color: AppColors.whiteColor),
          //           ),
          //           const SizedBox(
          //             height: 2.0,
          //           ),
          //           Text(
          //             '10:30 AM',
          //             style: nunitoStyle.copyWith(
          //                 fontWeight: FontWeight.normal,
          //                 fontSize: 12.0,
          //                 color: AppColors.whiteColor),
          //           )
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          // FadeAnimation(
          //   delay: 1,
          //   child: Container(
          //     padding: const EdgeInsets.only(left: 28),
          //     child: DottedVerticalLine(
          //       height: 30.0,
          //       color: Colors.deepPurple,
          //     ),
          //   ),
          // ),
          // Row(
          //   children: [
          //     Container(
          //       decoration: BoxDecoration(
          //           color: AppColors.lightBlackColor,
          //           borderRadius:
          //               BorderRadius.circular(16.0)),
          //       child: const Padding(
          //           padding: EdgeInsets.all(16.0),
          //           child: Icon(
          //             Icons.local_laundry_service,
          //             color: Colors.blue,
          //           )),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Column(
          //         crossAxisAlignment:
          //             CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             'Processing',
          //             style: nunitoStyle.copyWith(
          //                 fontWeight: FontWeight.bold,
          //                 color: AppColors.whiteColor),
          //           ),
          //           const SizedBox(
          //             height: 2.0,
          //           ),
          //           Text(
          //             '10:30 AM',
          //             style: nunitoStyle.copyWith(
          //                 fontWeight: FontWeight.normal,
          //                 fontSize: 12.0,
          //                 color: AppColors.whiteColor),
          //           )
          //         ],
          //       ),
          //     ),
          //   ],
          // ),

          // FadeAnimation(
          //   delay: 1.5,
          //   child: Container(
          //     padding: const EdgeInsets.only(left: 28),
          //     child: DottedVerticalLine(
          //       height: 30.0,
          //       color: Colors.blue,
          //     ),
          //   ),
          // ),
          // Row(
          //   children: [
          //     Container(
          //       decoration: BoxDecoration(
          //           color: AppColors.lightBlackColor,
          //           borderRadius:
          //               BorderRadius.circular(16.0)),
          //       child: const Padding(
          //           padding: EdgeInsets.all(16.0),
          //           child: Icon(
          //             Icons.delivery_dining_sharp,
          //             color: Colors.green,
          //           )),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Column(
          //         crossAxisAlignment:
          //             CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             'Order Delivered',
          //             style: nunitoStyle.copyWith(
          //                 fontWeight: FontWeight.bold,
          //                 color: AppColors.whiteColor),
          //           ),
          //           const SizedBox(
          //             height: 2.0,
          //           ),
          //           Text(
          //             '01:30 PM',
          //             style: nunitoStyle.copyWith(
          //                 fontWeight: FontWeight.normal,
          //                 fontSize: 12.0,
          //                 color: AppColors.whiteColor),
          //           )
          //         ],
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
