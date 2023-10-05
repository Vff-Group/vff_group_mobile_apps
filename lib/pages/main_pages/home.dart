// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:math';
import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as geolocator;
import 'package:location_platform_interface/location_platform_interface.dart'
    as location;
import 'package:url_launcher/url_launcher.dart';

import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/animation/slide_left_animation.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:vff_group/modals/main_category_model.dart';
import 'package:vff_group/notification_services.dart';
import 'package:vff_group/pages/main_pages/bottom_bar.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:http/http.dart' as http;
import 'package:vff_group/widgets/custom_slider.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _todaysDate = "";
  var profile_img = "", userName = "", activeOrdersText = "Active Orders [0]";
  Position? _currentPosition;

  NotificationServices notificationServices = NotificationServices();

  List<MainCategoryModel> categoryModel = [];

  // Location location = new Location();

  // late bool _serviceEnabled;
  // late PermissionStatus permissionGranted;
  // late LocationData _locationData;
  // Create a controller
  bool showRequestBtn = true,
      showLoading = true,
      showSuccessGif = false,
      showDefaultPickup = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    notificationServices.requestNotificationPermissions();
    notificationServices.foregroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    // notificationServices.isTokenRefreshed();
    notificationServices.getDeviceToken().then((value) => {
          SharedPreferenceUtils.save_val('notificationToken', value),
          print('DeviceToken:$value')
        });

    //Checking Location permission
getDefaultData();
    _getCurrentPosition();
    allCategoryAsync();
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

  void getDefaultData() async {
  glb.prefs = await SharedPreferences.getInstance();

  var profile = glb.prefs?.getString('profile_img');
  var usrname = glb.prefs?.getString('usrname');

  if (usrname != null && usrname.isNotEmpty) {
    setState(() {
      userName = usrname;
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
        heroTag: "btn1",
        tooltip: 'VFF Gym',
        child: const Icon(Icons.fitness_center),
      ),
    );
  }

  Widget float2() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.pink,
        heroTag: "btn2",
        tooltip: 'Delivery Boy',
        child: const Icon(Icons.delivery_dining),
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
        child: const Icon(Icons.aspect_ratio),
      ),
    );
  }

  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.backColor,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     _NavBar(profileImg: profile_img,),
                    SizedBox(
                      height: width * 0.05,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Explore Offers',
                            style: ralewayStyle.copyWith(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1)),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text('Laundry Made Simple with VFF',
                              style: ralewayStyle.copyWith(
                                  fontSize: 12.0,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 1)),
                        ),
                        SizedBox(
                          height: width * 0.05,
                        ),
                        _SliderLayout(width: width),
                        SizedBox(
                          height: width * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Services',
                                style: ralewayStyle.copyWith(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1)),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, AllServicesRoute);
                              },
                              child: Text('See all',
                                  style: ralewayStyle.copyWith(
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
                            ? const LinearProgressIndicator()
                            : SizedBox(
                                height: 140,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categoryModel.length,
                                    itemBuilder: (context, index) {
                                      // Generate a random gradient for each item
                                      //LinearGradient randomGradient = generateRandomGradient();
                                      Color randomColor =
                                          glb.generateRandomColorWithOpacity();
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  DeliveryAddressRoute);
                                            },
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: Ink(
                                              width: width - 120,
                                              decoration: BoxDecoration(
                                                color: AppColors.whiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white
                                                        .withOpacity(
                                                            0.2), // Shadow color
                                                    spreadRadius:
                                                        1, // Spread radius
                                                    blurRadius:
                                                        5, // Blur radius
                                                    offset: const Offset(0,
                                                        1), // Offset to control shadow position
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                            width: 60.0,
                                                            height: 60.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                              color:
                                                                  randomColor,
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
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 8.0,
                                                                  left: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  categoryModel[
                                                                          index]
                                                                      .categoryName,
                                                                  style: ralewayStyle.copyWith(
                                                                      fontSize:
                                                                          16.0,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      letterSpacing:
                                                                          1)),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            8.0),
                                                                child: Text(
                                                                    'Min ${categoryModel[index].minHours}Hours',
                                                                    style: ralewayStyle.copyWith(
                                                                        fontSize:
                                                                            10.0,
                                                                        color: AppColors
                                                                            .textColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        letterSpacing:
                                                                            1)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4.0),
                                                    child: Container(
                                                      width: width,
                                                      height: 1,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                          color: AppColors
                                                              .greyColor
                                                              .withOpacity(
                                                                  0.5)),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text('Regular Price',
                                                              style: ralewayStyle.copyWith(
                                                                  fontSize: 8.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1)),
                                                          Text(
                                                              '${categoryModel[index].regularPrice}/${categoryModel[index].regularPriceType}',
                                                              style: ralewayStyle.copyWith(
                                                                  fontSize:
                                                                      12.0,
                                                                  color: Colors
                                                                      .deepOrange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1)),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: 1,
                                                        height: 15,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text('Express Price',
                                                              style: ralewayStyle.copyWith(
                                                                  fontSize: 8.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1)),
                                                          Text(
                                                              '${categoryModel[index].expressPrice}/${categoryModel[index].expressPriceType}',
                                                              style: ralewayStyle.copyWith(
                                                                  fontSize:
                                                                      12.0,
                                                                  color: Colors
                                                                      .deepPurple,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1)),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: 1,
                                                        height: 15,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text('Offer Price',
                                                              style: ralewayStyle.copyWith(
                                                                  fontSize: 8.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1)),
                                                          Text(
                                                              '${categoryModel[index].offerPrice}/${categoryModel[index].offerPriceType}',
                                                              style: ralewayStyle.copyWith(
                                                                  fontSize:
                                                                      12.0,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
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
                                style: ralewayStyle.copyWith(
                                    fontSize: 20.0,
                                    color: Colors.black,
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
                                  style: ralewayStyle.copyWith(
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
                        Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Center(
                            child: Text(
                              'No Orders',
                              style: ralewayStyle.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.titleTxtColor),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: SizedBox(
                            height: 300,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: 2,
                                itemBuilder: (context, index) {
                                  // Generate a random gradient for each item
                                  //LinearGradient randomGradient = generateRandomGradient();
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          //Send to Order detail Screen
                                          //  CupertinoPageRoute(builder: (context) => OrderDetailsPage());
                                          Navigator.pushNamed(
                                              context, OrderDetailsRoute);
                                          // Navigator.push(
                                          //   context,
                                          //   CupertinoPageRoute(
                                          //       builder: (context) =>
                                          //           OrderDetailsPage()),
                                          // );
                                        },
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: Ink(
                                          decoration: BoxDecoration(
                                            color: AppColors.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(
                                                    0.2), // Shadow color
                                                spreadRadius:
                                                    1, // Spread radius
                                                blurRadius: 5, // Blur radius
                                                offset: const Offset(0,
                                                    1), // Offset to control shadow position
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        width: 60.0,
                                                        height: 60.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                          color: AppColors
                                                              .whiteColor,
                                                        ),
                                                        child: Stack(
                                                          children: [
                                                            Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Image.asset(
                                                                    'assets/images/delivery.gif')),
                                                            const SizedBox(
                                                                width: 60.0,
                                                                height: 60.0,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: AppColors
                                                                      .blueColor,
                                                                  value: 0.6,
                                                                ))
                                                          ],
                                                        )),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            child: Text(
                                                              'Order ID: #346782134768768687',
                                                              style: nunitoStyle.copyWith(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: true,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0),
                                                            child: Text(
                                                                'Order Confirmed',
                                                                style: ralewayStyle.copyWith(
                                                                    fontSize:
                                                                        12.0,
                                                                    color: AppColors
                                                                        .blueColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    letterSpacing:
                                                                        1)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
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
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
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
                    style: ralewayStyle.copyWith(
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
                    style: ralewayStyle.copyWith(
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
                style: ralewayStyle.copyWith(
                  fontSize: 25.0,
                  color: AppColors.blueColor,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: () {
                  _makePhoneCall('+918296565587');
                },
                child: Icon(
                  Icons.phone,
                  color: Colors.green,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.notifications,
                color: AppColors.orangeColor,
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
                child:  profileImg.isEmpty == false ? CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(profileImg) ,
                  backgroundColor: Colors.transparent,
                ) : Icon(Icons.person)
              ),
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
                                color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                                            color: AppColors.whiteColor,
                                            fontSize: 16.0),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Icon(
                                          Icons.arrow_right_alt,
                                          color: AppColors.whiteColor,
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

class _GreetingsLayout extends StatelessWidget {
  const _GreetingsLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/logo/logo.png',
          width: 50,
          height: 50,
        ),
        Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Positioned(
                      top: 10,
                      left: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Text(
                          'Hi, Shaheed',
                          style: nunitoStyle.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 13.0,
                              color: const Color.fromARGB(255, 116, 115, 115)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Text(
                        'New Vaibhav Nagar,Belgaum',
                        style: nunitoStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: AppColors.descTxtColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        glb.profileImage != null
            ? WidgetCircularAnimator(
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
                    backgroundImage: NetworkImage(glb.profileImage!),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              )
            : Image.asset(
                'assets/logo/logo.png',
                width: 50,
                height: 50,
              ),
      ],
    );
  }
}
