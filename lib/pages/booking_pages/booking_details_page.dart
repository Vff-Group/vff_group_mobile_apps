import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/animation/slide_left_animation.dart';
import 'package:vff_group/animation/slideright_animation.dart';
import 'package:vff_group/modals/cart_item_model.dart';
import 'package:vff_group/modals/order_detail_item_model.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';
import 'package:http/http.dart' as http;
import 'package:vff_group/global/vffglb.dart' as glb;

class BookingDetailsPage extends StatefulWidget {
  const BookingDetailsPage({super.key});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  bool showLoading = true,
      isItemAdded = true,
      showItemsLoading = false,
      itemsNotFound = true;
  String timeOrderRecieved = "";
  String pickupDate = "";
  String deliveryBoyName = "";
  String deliveryDateTime = "";
  String bookingStatus = "";

  String houseNo = "";
  String addressClient = "";
  String profilePicture = "";
  String deliveryMobno = "";
  String cancelReason = "NA";

  String totalItemsCount = "";
  String totalItemsPrice = "";
  List<OrderItemsModel> orderItemModel = [];

  @override
  void initState() {
    super.initState();
    print("glb.booking_id::${glb.booking_id}");
    loadOrderDetails();
  }

  Future loadOrderDetails() async {
    setState(() {
      showLoading = true;
      glb.delivery_boy_id = "";
      glb.clat = "";
      glb.clng = "";
    });
    // final prefs = await SharedPreferences.getInstance();
    // var customerid = prefs.getString('customerid');
    // if (glb.orderid.isEmpty) {
    //   glb.showSnackBar(context, 'Alert!', 'Please Select the Active Order');
    //   return;
    // }
    var todaysDate = glb.getDateTodays();
    try {
      var url = glb.endPoint;
      url+="load_customer_active_order_details/";
      final Map dictMap = {};
//select orderid,customerid,quantity,price,delivery_boy_id,delivery,clat,clng,order_status,delivery_customerid,laundry_ordertbl.customerid,cancel_reason,houseno,address from vff.laundry_customertbl,vff.usertbl,vff.laundry_delivery_boytbl,vff.laundry_ordertbl where usertbl.usrid=laundry_customertbl.usrid and laundry_ordertbl.customerid=laundry_customertbl.consmrid and(delivery_boyid='3' or drop_delivery_boy_id='3') and order_completed='0' and order_status='Rejected'  order by orderid desc
dictMap['key'] = 2;
      dictMap['booking_id'] = glb.booking_id;
      
      // dictMap['pktType'] = "10";
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
          glb.showSnackBar(context, 'Error', 'No Order Details Found');
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showLoading = false;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> orderMap = json.decode(response.body);
            if (kDebugMode) {
              print("orderMap:$orderMap");
            }

            glb.customerID = orderMap['customerid'];
            var delivery_boy_id = orderMap['delivery_boy_id'];
            var clat = orderMap['clat'];
            var clng = orderMap['clng'];
            var delivery_boyName = orderMap['delivery_boy_name'];
            var booking_status = orderMap['booking_status'];
            var time_at = orderMap['time_at'];
            var delvryBoyMobno = orderMap['delvry_boy_mobno'];
            var address = orderMap['address'];
            var city = orderMap['city'];
            var landmark = orderMap['landmark'];
            var pincode = orderMap['pincode'];

            var profileImg = orderMap['profileImg'];
            var delivery_boy_mobno = orderMap['delivery_boy_mobno'];
            var customer_name = orderMap['customer_name'];
            var customer_mobile_no = orderMap['customer_mobile_no'];

            var booking_recievef_at =
                glb.doubleEpochToFormattedDateTime(double.parse(time_at));
            setState(() {
              glb.delivery_boy_id = delivery_boy_id;
              glb.clat = clat;
              glb.clng = clng;
              timeOrderRecieved = booking_recievef_at;

              deliveryBoyName = delivery_boyName;

              deliveryDateTime = "Not Delivered yet";

              bookingStatus = booking_status;

              addressClient = address;
              profilePicture = profileImg;
              deliveryMobno = delvryBoyMobno;

              customer_name = customer_name;
            });

            setState(() {
              showLoading = false;
            });
            //loadOrderItemsDetails();
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
    loadOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: AppColors.backColor,
          title: Text(
            'Booking Details',
            style: nunitoStyle.copyWith(
              color: AppColors.backColor,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          actions: [
            bookingStatus == "Accepted"
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () {
                          //Navigator.pushNamed(context, CheckOutRoute);
                          Navigator.pushNamed(context, MyCartRoute);
                        },
                        child: const Icon(
                          Icons.card_giftcard,
                          color: AppColors.blueColor,
                        )),
                  )
                : Container()
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 1.2 * kToolbarHeight, 20, 20),
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      showLoading
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20, kToolbarHeight, 20, 20),
                              child: const LinearProgressIndicator(
                                semanticsLabel: 'Linear progress indicator',
                              ),
                            )
                          : Column(
                              children: [
                                _BookingDetails(
                                    bookingStatus: bookingStatus,
                                    bookingID: glb.booking_id,
                                    pickUpDateTime: timeOrderRecieved,
                                    deliveryDateTime: deliveryDateTime,
                                    addressClient: addressClient,
                                    width: width,
                                    height: height),
                                const Divider(
                                  color: AppColors.backColor,
                                  thickness: 0.5,
                                ),
                                Visibility(
                                  visible: glb.showDeliveryBoy,
                                  child: _DeliveryBoyDetails(
                                    width: width,
                                    profilePicture: profilePicture,
                                    deliveryBoyName: deliveryBoyName,
                                    deliveryMobno: deliveryMobno,
                                    bookingStatus: bookingStatus,
                                  ),
                                ),
                                Visibility(
                                  visible: glb.showDeliveryBoy,
                                  child: const Divider(
                                    color: AppColors.backColor,
                                    thickness: 0.5,
                                  ),
                                ),
                                _TotalClothesCount(
                                    showItemsLoading: showItemsLoading,
                                    isItemAdded: isItemAdded,
                                    totalQuantity: totalItemsCount,
                                    bookingStatus: bookingStatus),
                                itemsNotFound
                                    ? Padding(
                                        padding: EdgeInsets.zero,
                                        child: Column(
                                          children: [
                                            Text(
                                              'NO LAUNDRY ITEMS FOUND\n Please Add Items',
                                              style: nunitoStyle.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  letterSpacing: 1),
                                              textAlign: TextAlign.center,
                                            ),
                                            cancelReason == "NA" &&
                                                    glb.hideControls == false &&
                                                    glb.showPayOption == true
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    child:
                                                        SlideFromBottomAnimation(
                                                      delay: 0.5,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  CancelOrderRoute);
                                                            },
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0),
                                                            child: Ink(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      16.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16.0),
                                                                      gradient:
                                                                          const LinearGradient(
                                                                              colors: [
                                                                            Colors.red,
                                                                            AppColors.neonColor,
                                                                          ])),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Cancel Booking',
                                                                    style: nunitoStyle
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: AppColors
                                                                          .whiteColor,
                                                                      fontSize:
                                                                          16.0,
                                                                    ),
                                                                  ),
                                                                  const Icon(
                                                                    Icons
                                                                        .arrow_right_outlined,
                                                                    color: Colors
                                                                        .white,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const Text('')
                                          ],
                                        ),
                                      )
                                    : Container()
                              ],
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class _WashAndFoldListWidget extends StatelessWidget {
  const _WashAndFoldListWidget({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: AppColors.greyBGColor,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1), // Shadow color
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // Changes position of shadow
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Wash and Fold',
                    style: nunitoStyle.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: width * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/clothes/jacket.png',
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: width * 0.04,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jacket',
                            style: nunitoStyle.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Text(
                            '₹25',
                            style: nunitoStyle.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Qty: ',
                        style: nunitoStyle.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        '1',
                        style: nunitoStyle.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                color: AppColors.whiteColor,
                thickness: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DryCleaningListWidget extends StatelessWidget {
  const _DryCleaningListWidget({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: AppColors.greyBGColor,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1), // Shadow color
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // Changes position of shadow
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Dry Clean',
                    style: nunitoStyle.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: width * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/clothes/t_shirt.png',
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: width * 0.04,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'T-Shirt',
                            style: nunitoStyle.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Text(
                            '₹10',
                            style: nunitoStyle.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Qty: ',
                        style: nunitoStyle.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        '3',
                        style: nunitoStyle.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                color: AppColors.lightGreyColor,
                thickness: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TotalClothesCount extends StatelessWidget {
  const _TotalClothesCount({
    super.key,
    required this.showItemsLoading,
    required this.isItemAdded,
    required this.totalQuantity,
    required this.bookingStatus,
  });
  final bool showItemsLoading;
  final bool isItemAdded;
  final String totalQuantity;
  final String bookingStatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Laundry',
            style: nunitoStyle.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              color: AppColors.backColor,
            ),
          ),
          InkWell(
            onTap: () {
              glb.addItems = true;

              Navigator.pushNamed(context, MyBagRoute);
            },
            child: Text(
              'Add Item',
              style: nunitoStyle.copyWith(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blueColor),
            ),
          )
        ],
      ),
    );
  }
}

class _DeliveryBoyDetails extends StatelessWidget {
  const _DeliveryBoyDetails({
    super.key,
    required this.width,
    required this.profilePicture,
    required this.deliveryBoyName,
    required this.deliveryMobno,
    required this.bookingStatus,
  });

  final double width;
  final String? profilePicture;
  final String deliveryBoyName;
  final String deliveryMobno;

  final String bookingStatus;

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
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey[200]),
                          child: CircleAvatar(
                            radius: 25.0,
                            backgroundImage: NetworkImage('$profilePicture'),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                SizedBox(
                  width: width * 0.04,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deliveryBoyName,
                      style: nunitoStyle.copyWith(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blueColor),
                    ),
                    Visibility(
                      visible: false,
                      child: Text(
                        deliveryMobno,
                        style: nunitoStyle.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: AppColors.whiteColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SlideFromRightAnimation(
              delay: 0.9,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (bookingStatus == "Accepted" ||
                        bookingStatus == "Payment Done") {
                      _makePhoneCall(deliveryMobno);
                    } else {
                      glb.showSnackBar(context, 'Alert',
                          "Order is not yet assigned to Delivery agent");
                      return;
                    }
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
            )
          ],
        ),
      ),
    );
  }
}

class _BookingDetails extends StatelessWidget {
  const _BookingDetails({
    super.key,
    required this.bookingStatus,
    required this.bookingID,
    required this.pickUpDateTime,
    required this.deliveryDateTime,
    required this.addressClient,
    required this.width,
    required this.height,
  });
  final String bookingStatus;
  final String bookingID;
  final String pickUpDateTime;
  final String deliveryDateTime;
  final String addressClient;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: width * 0.05,
            ),
            FadeAnimation(
              delay: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: bookingStatus == "Accepted" ||
                                bookingStatus == "Payment Done"
                            ? AppColors.neonColor
                            : AppColors.lightBlackColor,
                        borderRadius: BorderRadius.circular(50.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.delivery_dining_sharp,
                        color: bookingStatus == "Accepted" ||
                                bookingStatus == "Payment Done"
                            ? AppColors.backColor
                            : AppColors.backColor,
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 1,
                    color: bookingStatus == "Processing"
                        ? AppColors.neonColor
                        : AppColors.backColor,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: bookingStatus == "Processing"
                            ? AppColors.neonColor
                            : AppColors.lightBlackColor,
                        borderRadius: BorderRadius.circular(50.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.local_laundry_service_outlined,
                        color: bookingStatus == "Processing"
                            ? AppColors.backColor
                            : AppColors.backColor,
                      ),
                    ),
                  ),
                  Container(
                      width: 80,
                      height: 1,
                      color: bookingStatus == "Processing"
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
                    'Status',
                    style: nunitoStyle.copyWith(
                      color: AppColors.backColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  bookingStatus == "Rejected"
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
                          bookingStatus,
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
                    'Booking ID',
                    style: nunitoStyle.copyWith(
                      color: AppColors.backColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '#${bookingID}',
                    style: nunitoStyle.copyWith(
                      color: AppColors.blueColor,
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

class _TitleLayout extends StatelessWidget {
  const _TitleLayout({
    Key? key,
    required this.width,
  }) : super(key: key);
  final double width;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(12.0),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.blueDarkColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          'Order Details',
          style: nunitoStyle.copyWith(
            color: AppColors.whiteColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer()
      ],
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}
