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
import 'package:vff_group/delivery_boy_app/pages/orders_pages/update_order_popup.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/widgets/dotted_line.dart';
import 'package:vff_group/widgets/rating_bar.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

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
    // final prefs = await SharedPreferences.getInstance();
    // var norderId = prefs.getString('norder_id');
    if (true) {
      try {
        var url = glb.endPoint;
        final Map dictMap = {};

        dictMap['pktType'] = "25";
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
            glb.showSnackBar(context, 'Error', 'No New Orders Found');
            SharedPreferenceUtils.save_val("mark_free","Free");
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

              setState(() {
                orderRecievedDate =
                    glb.doubleEpochToFormattedDateTime(double.parse(pickup_dt));

                print("orderRecievedDate::$orderRecievedDate");
                showLoading = false;
                noOrders = false;
                orderID = orderid;
                customerName = customer_name;
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        actions: [
          orderStatus == "Payment Done" || orderStatus == "Out for Delivery"
              ? InkWell(
                  onTap: () {
                    _showPopup(context, orderID, orderStatus);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.update_outlined,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container()
        ],
        title: Text(
          'CURRENT DELIVERY',
          style: ralewayStyle.copyWith(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: noOrders
          ? Center(
              child: Text(
                'No Orders Assigned',
                style: ralewayStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: AppColors.whiteColor),
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: Container(
                  decoration: const BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.green, Colors.blue]),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(26.0),
                        topRight: Radius.circular(26.0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.green, Colors.blue]),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(26.0),
                              topRight: Radius.circular(26.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Customer Details',
                                    style: ralewayStyle.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                             SizedBox(height: 10.0,), 
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          child: profileImg.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  child: Image.network(
                                                    profileImg,
                                                    fit: BoxFit.fill,
                                                  ))
                                              : SizedBox()),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: width - 200,
                                              child: Text(
                                                customerName,
                                                style: ralewayStyle.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              'Velvet Wash Customer',
                                              style: ralewayStyle.copyWith(
                                                  color: Colors.white60,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14.0),
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            // const Row(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.spaceAround,
                                            //   children: [
                                            //     Icon(
                                            //       Icons.star,
                                            //       color: Colors.amber,
                                            //       size: 10,
                                            //     ),
                                            //     Icon(
                                            //       Icons.star,
                                            //       color: Colors.amber,
                                            //       size: 10,
                                            //     ),
                                            //     Icon(
                                            //       Icons.star,
                                            //       color: Colors.amber,
                                            //       size: 10,
                                            //     ),
                                            //     Icon(
                                            //       Icons.star,
                                            //       color: Colors.amber,
                                            //       size: 10,
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      var latitute = double.parse(cLat);
                                      var longitute = double.parse(cLng);
                                      navigateTo(latitute, longitute);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          color: Colors.orange),
                                      child: const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Icon(
                                          Icons.location_history,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Divider(
                                  indent: 10.0,
                                  color: AppColors.whiteColor,
                                  height: 0.1,
                                  thickness: 0.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.green, Colors.blue]),
                          // borderRadius: BorderRadius.only(
                          //     topLeft: Radius.circular(26.0),
                          //     topRight: Radius.circular(26.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        color: Colors.green[50]),
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Icon(
                                        Icons.watch_later_outlined,
                                        color: Colors.green,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Order Received At ',
                                          style: ralewayStyle.copyWith(
                                              fontSize: 12.0,
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          orderRecievedDate,
                                          style: nunitoStyle.copyWith(
                                              fontSize: 14.0,
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        color: Colors.orange[50]),
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Icon(
                                        Icons.location_city,
                                        color: Colors.orange,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Address',
                                          style: ralewayStyle.copyWith(
                                              fontSize: 12.0,
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        SizedBox(
                                          width: width - 100,
                                          child: Text(
                                            '${houseNo} ${addressUser},${cityName}-${pinCode}'
                                                .toUpperCase(),
                                            style: nunitoStyle.copyWith(
                                                fontSize: 14.0,
                                                color: AppColors.whiteColor,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        color: Colors.pink[50]),
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Icon(
                                        Icons.location_city,
                                        color: Colors.pink,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Order ID ',
                                          style: ralewayStyle.copyWith(
                                              fontSize: 12.0,
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(
                                          '#${orderID}',
                                          style: nunitoStyle.copyWith(
                                              fontSize: 14.0,
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/images/driving.gif',
                        height: 350,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ))
              ],
            ),
      floatingActionButton: InkWell(
        onTap: () {
          _makePhoneCall(mobileNo);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.deepOrange),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(
              Icons.phone,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void _showPopup(BuildContext context, String orderID, String orderStatus) {
    var updateToStatus = "";
    if (orderStatus == "Accepted") {
      updateToStatus = "Pick Up Done";
    } else if (orderStatus == "Out for Delivery") {
      updateToStatus = "Completed";
    }
    String selectedValue = updateToStatus;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return UpdateOrderStatusPopup(
          orderID: orderID,
          orderStatus: orderStatus,
        );
      },
    );
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(16.0),
    //       ),
    //       elevation: 5,
    //       backgroundColor: Colors.black,
    //       content: StatefulBuilder(
    //         builder: (context, setState) {
    //           return Container(
    //             width: 200,
    //             height: 200,
    //             child: Column(
    //               children: [
    //                 Text(
    //                   'Update Order Status',
    //                   style: ralewayStyle.copyWith(
    //                       fontWeight: FontWeight.bold,
    //                       fontSize: 20.0,
    //                       color: AppColors.whiteColor),
    //                 ),
    //                 Container(
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(20.0),
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Row(
    //                           children: [
    //                             Container(
    //                               width: 50,
    //                               height: 50,
    //                               decoration: BoxDecoration(
    //                                   color: Colors.green[50],
    //                                   borderRadius:
    //                                       BorderRadius.circular(16.0)),
    //                               child: Padding(
    //                                 padding: const EdgeInsets.all(16.0),
    //                                 child: Radio(
    //                                   value: 'Pick Up Done',
    //                                   groupValue: selectedValue,
    //                                   onChanged: (value) {
    //                                     // Implement radio button selection logic here
    //                                     selectedValue = value!;
    //                                   },
    //                                 ),
    //                               ),
    //                             ),
    //                             Padding(
    //                               padding: const EdgeInsets.all(8.0),
    //                               child: Column(
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 children: [
    //                                   Text(
    //                                     updateToStatus,
    //                                     style: ralewayStyle.copyWith(
    //                                         fontWeight: FontWeight.bold,
    //                                         color: AppColors.whiteColor),
    //                                   ),
    //                                   const SizedBox(
    //                                     height: 2.0,
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                         SlideFromBottomAnimation(
    //                           delay: 0.5,
    //                           child: Padding(
    //                             padding: const EdgeInsets.all(20.0),
    //                             child: Center(
    //                               child: Material(
    //                                 color: Colors.transparent,
    //                                 child: InkWell(
    //                                   borderRadius: BorderRadius.circular(12.0),
    //                                   onTap: () {
    //                                     print(
    //                                         "updateToStatus::$updateToStatus");
    //                                     print("orderID::$orderID");
    //                                   },
    //                                   child: Ink(
    //                                     decoration: BoxDecoration(
    //                                         borderRadius:
    //                                             BorderRadius.circular(12.0),
    //                                         color: Colors.deepOrange),
    //                                     child: Padding(
    //                                       padding: const EdgeInsets.all(12.0),
    //                                       child: Text(
    //                                         'Update Status',
    //                                         style: ralewayStyle.copyWith(
    //                                             fontSize: 16.0,
    //                                             fontWeight: FontWeight.bold,
    //                                             color: Colors.white),
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         )
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           );

    //         },
    //       ),
    //     );
    //   },
    // );
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
                        color: Colors.deepOrange,
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
                      style: ralewayStyle.copyWith(
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
          //             style: ralewayStyle.copyWith(
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
          //             style: ralewayStyle.copyWith(
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
          //             style: ralewayStyle.copyWith(
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
