// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as geolocator;
import 'package:location_platform_interface/location_platform_interface.dart'
    as location;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/animation/slide_left_animation.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:vff_group/modals/active_orders_model.dart';
import 'package:vff_group/modals/main_category_model.dart';
import 'package:vff_group/notification_services.dart';
import 'package:vff_group/pages/main_pages/bottom_bar.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:http/http.dart' as http;
import 'package:vff_group/widgets/custom_slider.dart';
import 'package:vff_group/widgets/shimmer_card.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _todaysDate = "";
  var profile_img = "",
      userName = "",
      activeOrdersText = "Active Orders [0]",
      activeBookingsText = "Current Bookings [0]";
  Position? _currentPosition;

  NotificationServices notificationServices = NotificationServices();

  List<MainCategoryModel> categoryModel = [];
  List<ActiveOrders> activeOrdersModel = [];
  List<ActiveBookings> activeBookingsModel = [];

  // Location location = new Location();

  // late bool _serviceEnabled;
  // late PermissionStatus permissionGranted;
  // late LocationData _locationData;
  // Create a controller
  bool showRequestBtn = true,
      showLoading = true,
      showSuccessGif = false,
      showDefaultPickup = true,
      noOrders = false,
      noBookings = false,
      activeOrdersLoading = true,
      activeBookingsLoading = true;
  var deviceToken = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    notificationServices.requestNotificationPermissions();
    notificationServices.foregroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefreshed();
    // SharedPreferenceUtils.save_val('notificationToken', '');

    //Checking Location permission
    getDefaultData();
    _getCurrentPosition();

    allCategoryAsync();
    loadMyActiveCurrentOrder();
    loadMyBookingsCurrentOrder();
    //Set default app
    SharedPreferenceUtils.save_val('AppPreference', 'MainRoute');
  }

  Future allCategoryAsync() async {
    try {
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['pktType'] = "2";
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
          glb.showSnackBar(context, 'Error', 'No Categories Found');
          return;
        } else if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> catMap = json.decode(response.body);
            // if (kDebugMode) {
            //   print("categoryMap:$catMap");
            // }
            var catid = catMap['catid'];
            var catname = catMap['catname'];
            var catimg = catMap['catimg'];
            var regularPrice = catMap['regular_price'];
            var regularPriceType = catMap['regular_price_type'];
            var expressPrice = catMap['express_price'];
            var expressPriceType = catMap['express_price_type'];
            var offerPrice = catMap['offer_price'];
            var offerPriceType = catMap['offer_price_type'];
            var description = catMap['description'];
            var minHours = catMap['min_hours'];

            List<String> catIdLst = glb.strToLst2(catid);
            List<String> catNameLst = glb.strToLst2(catname);
            List<String> catImgLst = glb.strToLst2(catimg);
            List<String> regularPricelst = glb.strToLst2(regularPrice);
            List<String> regularPriceTypelst = glb.strToLst2(regularPriceType);
            List<String> expressPricelst = glb.strToLst2(expressPrice);
            List<String> expressPriceTypeLst = glb.strToLst2(expressPriceType);
            List<String> offerPriceLst = glb.strToLst2(offerPrice);
            List<String> offerPriceTypeLst = glb.strToLst2(offerPriceType);
            List<String> descriptionLst = glb.strToLst2(description);
            List<String> minHoursLst = glb.strToLst2(minHours);
            categoryModel = [];
            for (int i = 0; i < catIdLst.length; i++) {
              var catId = catIdLst.elementAt(i).toString();
              var catName = catNameLst.elementAt(i).toString();
              var catImg = catImgLst.elementAt(i).toString();
              var regularPrice = regularPricelst.elementAt(i).toString();
              var regularPriceType =
                  regularPriceTypelst.elementAt(i).toString();
              var expressPrice = expressPricelst.elementAt(i).toString();
              var expressPriceType =
                  expressPriceTypeLst.elementAt(i).toString();
              var offerPrice = offerPriceLst.elementAt(i).toString();
              var offerPriceType = offerPriceTypeLst.elementAt(i).toString();
              var description = descriptionLst.elementAt(i).toString();
              var minHours = minHoursLst.elementAt(i).toString();
              if (offerPrice == "0.0") {
                offerPrice = "-";
                offerPriceType = '';
              }
              categoryModel.add(MainCategoryModel(
                  categoryId: catId,
                  categoryName: catName,
                  categoryBGUrl: catImg,
                  regularPrice: regularPrice,
                  regularPriceType: regularPriceType,
                  expressPrice: expressPrice,
                  expressPriceType: expressPriceType,
                  offerPrice: offerPrice,
                  offerPriceType: offerPriceType,
                  description: description,
                  minHours: minHours));
            }
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
    }
  }

  Future loadMyBookingsCurrentOrder() async {
    setState(() {
      activeBookingsLoading = true;
      noBookings = false;
      activeBookingsText = "Current Bookings [0]";
      activeBookingsModel = [];
    });
    final prefs = await SharedPreferences.getInstance();
    var customerid = prefs.getString('customerid');

    var todaysDate = glb.getDateTodays();
    try {
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['customer_id'] = customerid;
      dictMap['key'] = 2;
      dictMap['pktType'] = "9";
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
            activeBookingsLoading = false;
            noBookings = true;
          });
          //glb.showSnackBar(context, 'Error', 'No Active Orders Found');
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            activeBookingsLoading = false;
            noBookings = true;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> orderMap = json.decode(response.body);
            // if (kDebugMode) {
            //   print("categoryMap:$catMap");
            // }

            var booking_id = orderMap['booking_id'];
            var delivery_boy_id = orderMap['delivery_boy_id'];
            var booking_status = orderMap['booking_status'];
            var booking_time = orderMap['booking_time'];
            var branch_id = orderMap['branch_id'];

            List<String> booking_idLst = glb.strToLst2(booking_id);
            List<String> delivery_boy_idLst = glb.strToLst2(delivery_boy_id);
            List<String> booking_statusLst = glb.strToLst2(booking_status);
            List<String> booking_timeLst = glb.strToLst2(booking_time);
            List<String> branch_idLst = glb.strToLst2(branch_id);

            for (int i = 0; i < booking_idLst.length; i++) {
              var booking_id = booking_idLst.elementAt(i).toString();
              var delivery_boy_id = delivery_boy_idLst.elementAt(i).toString();
              var booking_status = booking_statusLst.elementAt(i).toString();
              var booking_time = booking_timeLst.elementAt(i).toString();
              var branch_id = branch_idLst.elementAt(i).toString();
              var bookingTime = glb
                  .doubleEpochToFormattedDateTime(double.parse(booking_time));
              activeBookingsModel.add(ActiveBookings(
                  bookingID: booking_id,
                  deliveryBoyID: delivery_boy_id,
                  bookingStatus: booking_status,
                  bookingTime: bookingTime,
                  branchID: branch_id));
            }

            setState(() {
              activeBookingsLoading = false;
              noBookings = false;
              activeBookingsText =
                  "Current Bookings [${activeBookingsModel.length}]";
            });
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
            setState(() {
              activeBookingsLoading = false;
              noBookings = true;
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
        activeOrdersLoading = false;
        noOrders = true;
      });
      glb.handleErrors(e, context);
    }
  }

  Future loadMyActiveCurrentOrder() async {
    setState(() {
      activeOrdersLoading = true;
      noOrders = false;
      activeOrdersText = "Active Orders [0]";
      activeOrdersModel = [];
    });
    final prefs = await SharedPreferences.getInstance();
    var customerid = prefs.getString('customerid');

    var todaysDate = glb.getDateTodays();
    try {
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['customer_id'] = customerid;
      dictMap['key'] = 1;
      dictMap['branch_id'] = "1";
      dictMap['pktType'] = "9";
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
            activeOrdersLoading = false;
            noOrders = true;
          });
          //glb.showSnackBar(context, 'Error', 'No Active Orders Found');
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            activeOrdersLoading = false;
            noOrders = true;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> orderMap = json.decode(response.body);
            // if (kDebugMode) {
            //   print("categoryMap:$catMap");
            // }

            var order_id = orderMap['order_id'];
            var epoch = orderMap['epoch'];
            var pickup_dt = orderMap['pickup_dt'];
            var clat = orderMap['clat'];
            var clng = orderMap['clng'];
            var customer_name = orderMap['customer_name'];
            var customer_usrid = orderMap['customer_usrid'];
            var delivery_boy_id = orderMap['delivery_boy_id'];
            var delivery_boy_name = orderMap['delivery_boy_name'];
            var order_status = orderMap['order_status'];
            var branch_id = orderMap['branch_id'];

            List<String> order_idLst = glb.strToLst2(order_id);
            List<String> epochLst = glb.strToLst2(epoch);
            List<String> order_statusLst = glb.strToLst2(order_status);
            List<String> delivery_boy_idLst = glb.strToLst2(delivery_boy_id);
            List<String> branch_idLst = glb.strToLst2(branch_id);
            List<String> delivery_boy_nameLst =
                glb.strToLst2(delivery_boy_name);

            for (int i = 0; i < order_idLst.length; i++) {
              var orderID = order_idLst.elementAt(i).toString();
              var epoch = epochLst.elementAt(i).toString();
              var orderStatus = order_statusLst.elementAt(i).toString();
              var branch_id = branch_idLst.elementAt(i).toString();
              var delivery_boy_name =
                  delivery_boy_nameLst.elementAt(i).toString();
              var time =
                  glb.doubleEpochToFormattedDateTime(double.parse(epoch));
              activeOrdersModel.add(ActiveOrders(
                  orderID: orderID,
                  time: time,
                  deliveryBoyName: delivery_boy_name,
                  orderStatus: orderStatus,
                  branchID: branch_id));
            }

            setState(() {
              activeOrdersLoading = false;
              noOrders = false;
              activeOrdersText = "Active Orders [${activeOrdersModel.length}]";
            });
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
            setState(() {
              activeOrdersLoading = false;
              noOrders = true;
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
        activeOrdersLoading = false;
        noOrders = true;
      });
      glb.handleErrors(e, context);
    }
  }

  Future updateDeviceToken() async {
    glb.prefs = await SharedPreferences.getInstance();

    var usrid = glb.prefs?.getString('usrid');
    if (deviceToken.isEmpty) {
      print('DeviceToken is Empty');
      return;
    }
    try {
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['usrid'] = usrid;
      dictMap['deviceToken'] = deviceToken;
      dictMap['pktType'] = "5";
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
          //glb.showSnackBar(context, 'Error', 'No Categories Found');
          return;
        } else if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          print('Device TOken Updated Successfully');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      glb.handleErrors(e, context);
    }
  }

  void getDefaultData() async {
    glb.prefs = await SharedPreferences.getInstance();

    var profile = glb.prefs?.getString('profile_img');
    var usrname = glb.prefs?.getString('usrname');
    //  SharedPreferenceUtils.save_val("notificationToken", "");
    var notificationToken = glb.prefs?.getString('notificationToken');
    print('notificationToken::$notificationToken');
    if (notificationToken == null || notificationToken.isEmpty) {
      notificationServices.getDeviceToken().then((value) => {
            deviceToken = value.toString().replaceAll(':', '__colon__'),
            SharedPreferenceUtils.save_val('notificationToken', deviceToken),
            updateDeviceToken(),
            print('DeviceToken:$value')
          });
    }

    if (usrname != null && usrname.isNotEmpty) {
      var split = usrname.split(" ");

      setState(() {
        userName = split[0];
      });
    }

    if (profile != null && profile.isNotEmpty) {
      setState(() {
        profile_img = profile;
      });
    }
  }

  //Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we need location permission to serve your better.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
            desiredAccuracy: geolocator.LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      // _getAddressFromLatLng(_currentPosition!);
      print(_currentPosition);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  // Future<void> _getAddressFromLatLng(Position position) async {
  //   await placemarkFromCoordinates(
  //           _currentPosition!.latitude, _currentPosition!.longitude)
  //       .then((List<Placemark> placemarks) {
  //     Placemark place = placemarks[0];
  //     setState(() {
  //       _currentAddress =
  //           '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
  //     });
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  /// when you want to close the menu you have to create
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  /// and then assign it to the our widget library
  Widget float1() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.deepPurple,
        heroTag: "btn1",
        tooltip: 'VFF Gym',
        child: const Icon(
          Icons.fitness_center,
        ),
      ),
    );
  }

  Widget float2() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: FloatingActionButton(
        onPressed: () {
          goToDeliveryBoyPage();
        },
        backgroundColor: Colors.pink,
        heroTag: "btn2",
        tooltip: 'Delivery Boy',
        child: const Icon(
          Icons.delivery_dining,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget float3() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        heroTag: "btn3",
        tooltip: 'Coming Soon',
        child: const Icon(
          LineIcons.tShirt,
          color: Colors.white,
        ),
      ),
    );
  }

  final _advancedDrawerController = AdvancedDrawerController();

  Future<void> _handleRefresh() async {
    // Future.delayed(Duration(milliseconds: 2));
    notificationServices.requestNotificationPermissions();
    notificationServices.foregroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefreshed();
    // SharedPreferenceUtils.save_val('notificationToken', '');
    activeBookingsModel = [];
    activeOrdersModel = [];
    glb.justSaveAddress = true;
    //Checking Location permission
    getDefaultData();
    _getCurrentPosition();

    allCategoryAsync();
    loadMyActiveCurrentOrder();
    loadMyBookingsCurrentOrder();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
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
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, CustomerNotificationRoute);
            },
            child: Icon(
              Icons.notifications_none_outlined,
              color: AppColors.whiteColor,
              size: 30,
            ),
          )
        ],
        title: Image.asset(
          'assets/logo/velvet_2.png',
          width: 150,
        ),
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        leading: InkWell(
          onTap: () {},
          child: WidgetCircularAnimator(
            size: 40,
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
                child: profile_img.isEmpty == false && profile_img != 'NA' && profile_img.isNotEmpty
                    ? CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(profile_img),
                        backgroundColor: Colors.transparent,
                      )
                    : const Icon(
                        Icons.person,
                        color: AppColors.blueColor,
                      )),
          ),
        ),
      ),
     
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          color: Colors.blue,
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height + 150,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height + 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                Text('Hey, ',
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
                            Text('Get Smart Experience in Washing',
                                style: nunitoStyle.copyWith(
                                    color: AppColors.backColor,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal)),
                            SizedBox(
                              height: width * 0.02,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: width * 0.05,
                                ),
                                _SliderLayout(width: width),
                              ],
                            ),
                            SizedBox(
                              height: width * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Services',
                                    style: nunitoStyle.copyWith(
                                        fontSize: 20.0,
                                        color: AppColors.backColor,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1)),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AllServicesRoute);
                                  },
                                  child: Text('See all',
                                      style: nunitoStyle.copyWith(
                                          fontSize: 12.0,
                                          color: AppColors.textColor,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: width * 0.02,
                            ),
                            showLoading
                                ? const Center(
                                    child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.blue,
                                    ),
                                  ))
                                : SizedBox(
                                    height: 120,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: categoryModel.length,
                                        itemBuilder: (context, index) {
                                          // Generate a random gradient for each item
                                          //LinearGradient randomGradient = generateRandomGradient();
                                          Color randomColor = glb
                                              .generateRandomColorWithOpacity();
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, AllBranchesRoute);
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .secondaryBackColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                          width: 60.0,
                                                          height: 60.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0),
                                                            color: randomColor,
                                                          ),
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                              child: Image.network(
                                                                  categoryModel[
                                                                          index]
                                                                      .categoryBGUrl))),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Text(
                                                      categoryModel[index]
                                                          .categoryName
                                                          .toCapitalized(),
                                                      style:
                                                          nunitoStyle.copyWith(
                                                              fontSize: 10.0,
                                                              color: AppColors
                                                                  .backColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  1)),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                            SizedBox(
                              height: width * 0.05,
                            ),
                              Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(activeBookingsText,
                                    style: nunitoStyle.copyWith(
                                        fontSize: 20.0,
                                        color: AppColors.backColor,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1)),
                              ],
                            ),
                            SizedBox(
                              height: width * 0.02,
                            ),
                            activeBookingsLoading
                                ? const LinearProgressIndicator(
                                    color: Colors.blue,
                                  )
                                : SizedBox(
                                    height: 105,
                                    child: noBookings
                                        ? Padding(
                                            padding: const EdgeInsets.all(26.0),
                                            child: Center(
                                              child: Text(
                                                'No Bookings Found',
                                                style: nunitoStyle.copyWith(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.backColor),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        : ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                activeBookingsModel.length,
                                            itemBuilder: (context, index) {
                                              // Generate a random gradient for each item
                                              //LinearGradient randomGradient = generateRandomGradient();
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      //Send to Order detail Screen
                                                      glb.orderid = "";
                                                      glb.booking_id = "";
                                                      glb.branch_id = "";
                                                      glb.order_status = "0";
                                                      glb.hideControls = false;
                                                      glb.showPayOption = true;
                                                      glb.showDeliveryBoy =
                                                          true;
                                        
                                                      if (activeBookingsModel
                                                          .isNotEmpty) {
                                                        if (activeBookingsModel[
                                                                    index]
                                                                .bookingStatus ==
                                                            "NA") {
                                                          glb.showSnackBar(
                                                              context,
                                                              'Alert',
                                                              "Please wait until a Delivery Boy is Assigned To You.\nThank You");
                                                          return;
                                                        }
                                                        glb.booking_id =
                                                            activeBookingsModel[
                                                                    index]
                                                                .bookingID;
                                                        glb.branch_id = activeBookingsModel[index].branchID;
                                                        glb.deliveryBoyID = activeBookingsModel[index].deliveryBoyID;
                                                        Navigator.pushNamed(
                                                            context,
                                                            BookingDetailsRoute);
                                                      }
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    child: Ink(
                                                        width: width - 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .secondaryBackColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.2), // Shadow color
                                                              spreadRadius:
                                                                  1, // Spread radius
                                                              blurRadius:
                                                                  5, // Blur radius
                                                              offset: const Offset(
                                                                  0,
                                                                  1), // Offset to control shadow position
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                decoration: const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .deepPurple),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          2.0),
                                                                  child: Container(
                                                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.lightBlackColor),
                                                                      child: const Padding(
                                                                        padding:
                                                                            EdgeInsets.all(8.0),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .delivery_dining_sharp,
                                                                          color:
                                                                              Colors.deepOrange,
                                                                        ),
                                                                      )),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20.0),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      child:
                                                                          Text(
                                                                        'Booking ID: #${activeBookingsModel[index].bookingID}',
                                                                        style: nunitoStyle.copyWith(
                                                                            fontSize:
                                                                                16.0,
                                                                            color:
                                                                                AppColors.backColor,
                                                                            fontWeight: FontWeight.bold,
                                                                            letterSpacing: 1),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        softWrap:
                                                                            true,
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              6.0),
                                                                      child: Text(
                                                                          activeBookingsModel[index].bookingStatus == "NA"
                                                                              ? "Assiging Delivery Boy"
                                                                              : activeBookingsModel[index]
                                                                                  .bookingStatus,
                                                                          style: nunitoStyle.copyWith(
                                                                              fontSize: 14.0,
                                                                              color: AppColors.blueColor,
                                                                              fontWeight: FontWeight.w500,
                                                                              letterSpacing: 1)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                              );
                                            }),
                                
                                  ),
                          
                            SizedBox(
                              height: width * 0.05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(activeOrdersText,
                                    style: nunitoStyle.copyWith(
                                        fontSize: 20.0,
                                        color: AppColors.backColor,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1)),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const BottomBarScreen(
                                                    pageIndex: 2)));
                                    //widget.changeTabBar();
                                    // Provider.of<TabProvider>(context, listen: false).changeTab(1);
                                    //Navigator.pushNamed(context, OrderTabRoute);
                                  },
                                  child: Text('Previous',
                                      style: nunitoStyle.copyWith(
                                          fontSize: 12.0,
                                          color: AppColors.textColor,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: width * 0.02,
                            ),
                            activeOrdersLoading
                                ? const LinearProgressIndicator(
                                    color: Colors.blue,
                                  )
                                : SizedBox(
                                    height: 105,
                                    child: noOrders
                                        ? Padding(
                                            padding: const EdgeInsets.all(26.0),
                                            child: Center(
                                              child: Text(
                                                'No Active Order Found\nIf you have Requested a Pickup Request please check your booking status above.',
                                                style: nunitoStyle.copyWith(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.backColor),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        : ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: activeOrdersModel.length,
                                            itemBuilder: (context, index) {
                                              // Generate a random gradient for each item
                                              //LinearGradient randomGradient = generateRandomGradient();
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      //Send to Order detail Screen
                                                      glb.orderid =
                                                          activeOrdersModel[
                                                                  index]
                                                              .orderID;
                                                      glb.booking_id = "";
                                                      glb.branch_id = "";
                                                      glb.order_status = "0";
                                                      glb.hideControls = false;
                                                      glb.showPayOption = true;
                                                      glb.showDeliveryBoy =
                                                          true;
                                                      glb.branch_id =
                                                          activeOrdersModel[
                                                                  index]
                                                              .branchID;
                                                      Navigator.pushNamed(
                                                          context,
                                                          OrderDetailsRoute);
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    child: Ink(
                                                        width: width - 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .secondaryBackColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.2), // Shadow color
                                                              spreadRadius:
                                                                  1, // Spread radius
                                                              blurRadius:
                                                                  5, // Blur radius
                                                              offset: const Offset(
                                                                  0,
                                                                  1), // Offset to control shadow position
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                decoration: const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .blue),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          2.0),
                                                                  child: Container(
                                                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.lightBlackColor),
                                                                      child: Padding(
                                                                        padding:
                                                                            EdgeInsets.all(8.0),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .local_laundry_service_outlined,
                                                                          color:
                                                                              Colors.green[900],
                                                                        ),
                                                                      )),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20.0),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      child:
                                                                          Text(
                                                                        'Order ID: #${activeOrdersModel[index].orderID}',
                                                                        style: nunitoStyle.copyWith(
                                                                            fontSize:
                                                                                16.0,
                                                                            color:
                                                                                AppColors.backColor,
                                                                            fontWeight: FontWeight.bold,
                                                                            letterSpacing: 1),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        softWrap:
                                                                            true,
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              6.0),
                                                                      child: Text(
                                                                          activeOrdersModel[index]
                                                                              .orderStatus,
                                                                          style: nunitoStyle.copyWith(
                                                                              fontSize: 14.0,
                                                                              color: AppColors.blueColor,
                                                                              fontWeight: FontWeight.w500,
                                                                              letterSpacing: 1)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                              );
                                            }),
                                  ),
                          
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: SlideFromLeftAnimation(
        delay: 1.2,
        child: AnimatedFloatingActionButton(
            //Fab list
            fabButtons: <Widget>[float1(), float2(), float3()],
            key: key,
            colorStartAnimation: Colors.blue,
            colorEndAnimation: Colors.red,
            animatedIconData: AnimatedIcons.list_view //To principal button
            ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  Future goToDeliveryBoyPage() async {
    glb.prefs = await SharedPreferences.getInstance();

    var dusrid = glb.prefs?.getString('dusrid');
    if (dusrid != null) {
      Navigator.pushReplacementNamed(context, DMainRoute);
    } else {
      Navigator.pushNamed(context, DeliveryLoginRoute);
    }
  }
}

class CustomClipperForProgress extends CustomClipper<Path> {
  final double progress; // Progress as a percentage (0 to 100)

  CustomClipperForProgress(this.progress);

  @override
  Path getClip(Size size) {
    double clipWidth = (progress / 100) * size.width;
    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(clipWidth, 0)
      ..lineTo(clipWidth, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _SliderLayout extends StatelessWidget {
  const _SliderLayout({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return AutoSlider(
      slides: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=80',
              ),
              fit: BoxFit
                  .fitWidth, // Fit the image to the width of the container
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 50,
                left: 20,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: AppColors.blueColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Text(
                        'Top Offers',
                        style: nunitoStyle.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: AppColors.whiteColor),
                      ),
                    )),
              ),
              Positioned(
                bottom: 15,
                left: 20,
                child: SizedBox(
                  width: width - 50,
                  child: Text(
                    '20% OFF on Dry Cleaning ',
                    style: nunitoStyle.copyWith(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: AppColors.whiteColor),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1638949493140-edb10b7be2f3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2772&q=80',
              ),
              fit: BoxFit
                  .fitWidth, // Fit the image to the width of the container
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 50,
                left: 20,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: AppColors.blueColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Text(
                        '10% Offers',
                        style: nunitoStyle.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: AppColors.whiteColor),
                      ),
                    )),
              ),
              Positioned(
                bottom: 15,
                left: 20,
                child: SizedBox(
                  width: width - 50,
                  child: Text(
                    'Wash and Fold',
                    style: nunitoStyle.copyWith(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: AppColors.whiteColor),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({
    super.key,
    required this.profileImg,
  });
  final String profileImg;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/logo/logo.png',
              width: 50,
              height: 50,
            ),
            Text('VFF Group',
                style: nunitoStyle.copyWith(
                  fontSize: 25.0,
                  color: AppColors.backColor,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: () {
                  _makePhoneCall('+918296565587');
                },
                child: const Icon(
                  Icons.phone,
                  color: AppColors.backColor,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.notifications,
                color: AppColors.backColor,
              ),
            ),
            WidgetCircularAnimator(
              size: 40,
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
                  child: profileImg.isEmpty == false
                      ? CircleAvatar(
                          radius: 25.0,
                          backgroundImage: NetworkImage(profileImg),
                          backgroundColor: Colors.transparent,
                        )
                      : const Icon(Icons.person)),
            ),
          ],
        )
      ],
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}

class Main_Category_Layout extends StatelessWidget {
  const Main_Category_Layout({
    super.key,
    required this.width,
    required this.categorymodel,
  });

  final double width;
  final MainCategoryModel categorymodel;

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      delay: 0.8,
      child: Container(
          width: width,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            image: DecorationImage(
              image: NetworkImage(
                categorymodel.categoryBGUrl,
              ),
              fit: BoxFit
                  .fitWidth, // Fit the image to the width of the container
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 8,
                left: 5,
                right: 5,
                child: Container(
                  width: width,
                  height: 130,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor
                        .withOpacity(0.2), // Adjust opacity as needed
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(
                            0.3), // Adjust shadow color and opacity
                        spreadRadius: 0,
                        blurRadius: 7,
                        offset: const Offset(0, 0), // Offset of the shadow
                      ),
                    ],
                  ),
                  child: Stack(children: [
                    Positioned(
                        top: 2,
                        left: 10,
                        child: SizedBox(
                          width: width - 100,
                          child: Text(
                            categorymodel.categoryName,
                            style: nunitoStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.backColor,
                                fontSize: 30.0),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        )),
                    Positioned(
                      top: 45,
                      left: 10,
                      child: SizedBox(
                        width: width - 200,
                        child: Text(
                          "Regular Price : ${categorymodel.regularPrice}/${categorymodel.regularPriceType}",
                          style: nunitoStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.backColor,
                              fontSize: 14.0),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 70,
                      left: 10,
                      child: SizedBox(
                        width: width - 200,
                        child: Text(
                          'Express Price : ${categorymodel.expressPrice}/${categorymodel.expressPriceType}',
                          style: nunitoStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.backColor,
                              fontSize: 14.0),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 95,
                      left: 10,
                      child: SizedBox(
                        width: width - 200,
                        child: Text(
                          'Offer Price : ${categorymodel.offerPrice}/${categorymodel.offerPriceType}',
                          style: nunitoStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.backColor,
                              fontSize: 14.0),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.0),
                              onTap: () {
                                /**
                                 * Detailed Screen to see and place order
                                 */
                                glb.mainCategoryID = categorymodel.categoryId;
                                glb.mainCategoryName =
                                    categorymodel.categoryName;
                                Navigator.pushNamed(
                                    context, MainCategoryDetailsRoute);
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: AppColors.blueColor),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 26.0, vertical: 12.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Continue',
                                        style: nunitoStyle.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.backColor,
                                            fontSize: 16.0),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Icon(
                                          Icons.arrow_right_alt,
                                          color: AppColors.backColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          )),
    );
  }
}
