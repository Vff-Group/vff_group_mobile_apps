import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;
import 'package:vff_group/widgets/typing_text.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as geolocator;

class DeliveryAddressPage extends StatefulWidget {
  const DeliveryAddressPage({super.key});

  @override
  State<DeliveryAddressPage> createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  TextEditingController buildingNoController = TextEditingController();
  TextEditingController streetAddressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  bool showLoading = false, showSuccess = false;
  Position? _currentPosition;
  double longitude = 0, latitude = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    allUsersAddressAsync();
  }

  Future allUsersAddressAsync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var usrid = prefs.getString('usrid');
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['usrid'] = usrid;
      dictMap['pktType'] = "3";
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
            var buildingNo = catMap['buildingNo'];
            var streetAddress = catMap['streetAddress'];
            var cityName = catMap['cityName'];
            var zipCode = catMap['zipCode'];
            var landMark = catMap['landMark'];

            setState(() {
              if(buildingNo.toString() !='NA'){
                buildingNoController.text = buildingNo;
              }
              if(streetAddress.toString() !='NA'){
                streetAddressController.text = streetAddress;
              }
              if(cityName.toString() !='NA'){
                cityController.text = cityName;
              }
              if(zipCode.toString() !='-1'){
                zipCodeController.text = zipCode;
              }
              if(landMark.toString() !='NA'){
                landmarkController.text = landMark;
              }
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

  Future requestPickupAsync(
      buildingNo, streetAddress, cityName, zipCode, landMark) async {
    setState(() {
      showLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      var usrid = prefs.getString('usrid');

      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['buildingNo'] = buildingNo;
      dictMap['streetAddress'] = streetAddress;
      dictMap['cityName'] = cityName;
      dictMap['zipCode'] = zipCode;
      dictMap['landMark'] = landMark;
      dictMap['customerId'] = usrid;
      dictMap['clat'] = latitude;
      dictMap['clng'] = longitude;
      dictMap['pktType'] = "4";
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
        print('res:::$res');
        if (res.contains("ErrorCode#2")) {
          glb.showSnackBar(context, 'Error', 'No Categories Found');
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
          //Successfully pickup request placed
          setState(() {
            showLoading = false;
            showSuccess = true;
          });
          //showSuccessPopup(context);
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

  void showSuccessPopup(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: FadeAnimation(
              delay: 1, child: Center(child: TypingText('Request Accepted'))),
          content: Wrap(
            children: [
              Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        'assets/images/success_2.gif',
                        fit: BoxFit.cover,
                      ))),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Go Back to Main Screen',
                        style: ralewayStyle.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50.0),
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, MainRoute);
                            },
                            child: Ink(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

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
              'Location permissions are permanently denied, we need location Permission so please provide us the location permission.')));
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
      if (_currentPosition != null) {
        latitude = _currentPosition!.latitude;
        longitude = _currentPosition!.longitude;
      }
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.backColor,
        appBar: AppBar(
            backgroundColor: AppColors.blueColor,
            title: FadeAnimation(
              delay: 0.3,
              child: Text('Address Details',
                  style: ralewayStyle.copyWith(
                      fontSize: 20.0,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1)),
            )),
        body: SafeArea(
            child: showSuccess
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: width * 0.04,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Pick Up Request Accepted Successfully !',
                          style: ralewayStyle.copyWith(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.titleTxtColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Image.asset('assets/images/success_2.gif'),
                      ),
                      SizedBox(
                        height: width * 0.04,
                      )
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: showLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Center(
                                            child: Text(
                                              'Add Pick Up & Delivery Address',
                                              style: ralewayStyle.copyWith(
                                                  fontSize: 14.0,
                                                  color: AppColors.textColor,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                          Text(
                                              'Our delivery experts will assist you through the process, and payment will be securely processed to ensure a convenient and efficient service experience.',
                                              style: ralewayStyle.copyWith(
                                                fontSize: 14.0,
                                                color: AppColors.textColor,
                                                fontWeight: FontWeight.w200,
                                              )),
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              color: AppColors.blueColor,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 45.0,
                                                  top: 22.0,
                                                  bottom: 22.0,
                                                  left: 20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.home_filled,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Text('Home',
                                                      style:
                                                          ralewayStyle.copyWith(
                                                        fontSize: 20.0,
                                                        color: AppColors
                                                            .whiteColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Text('Enter Address Details',
                                              style: ralewayStyle.copyWith(
                                                  fontSize: 20.0,
                                                  color:
                                                      AppColors.titleTxtColor,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1)),
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: 50.0,
                                                width: width,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    color:
                                                        AppColors.whiteColor),
                                                child: TextFormField(
                                                  controller:
                                                      buildingNoController,
                                                  style: nunitoStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .titleTxtColor,
                                                      fontSize: 14.0),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                      prefixIcon: const Icon(Icons
                                                          .home_work_outlined),
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              top: 16.0),
                                                      hintText:
                                                          ' Building/Society Name & Number',
                                                      hintStyle:
                                                          ralewayStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .textColor
                                                                  .withOpacity(
                                                                      0.5),
                                                              fontSize: 14.0)),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15.0,
                                              ),
                                              Container(
                                                height: 50.0,
                                                width: width,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    color:
                                                        AppColors.whiteColor),
                                                child: TextFormField(
                                                  controller:
                                                      streetAddressController,
                                                  style: nunitoStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .titleTxtColor,
                                                      fontSize: 14.0),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                      prefixIcon: const Icon(
                                                          Icons
                                                              .roundabout_right),
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              top: 16.0),
                                                      hintText:
                                                          ' Street Address, Landmark etc.',
                                                      hintStyle:
                                                          ralewayStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .textColor
                                                                  .withOpacity(
                                                                      0.5),
                                                              fontSize: 14.0)),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15.0,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      height: 50.0,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          color: AppColors
                                                              .whiteColor),
                                                      child: TextFormField(
                                                        controller:
                                                            cityController,
                                                        style: nunitoStyle
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .titleTxtColor,
                                                                fontSize: 14.0),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        decoration: InputDecoration(
                                                            prefixIcon: const Icon(Icons
                                                                .location_city_outlined),
                                                            border: InputBorder
                                                                .none,
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 16.0),
                                                            hintText: ' City',
                                                            hintStyle: ralewayStyle.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .textColor
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontSize:
                                                                    14.0)),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      height: 50.0,
                                                      width: width,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          color: AppColors
                                                              .whiteColor),
                                                      child: TextFormField(
                                                        controller:
                                                            zipCodeController,
                                                        style: nunitoStyle
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .titleTxtColor,
                                                                fontSize: 14.0),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration: InputDecoration(
                                                            prefixIcon: const Icon(
                                                                Icons.numbers),
                                                            border: InputBorder
                                                                .none,
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 16.0),
                                                            hintText:
                                                                ' Zip Code',
                                                            hintStyle: ralewayStyle.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .textColor
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontSize:
                                                                    14.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15.0,
                                              ),
                                              Container(
                                                height: 50.0,
                                                width: width,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    color:
                                                        AppColors.whiteColor),
                                                child: TextFormField(
                                                  controller:
                                                      landmarkController,
                                                  style: nunitoStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .titleTxtColor,
                                                      fontSize: 14.0),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                      prefixIcon: const Icon(
                                                          Icons.location_on),
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              top: 16.0),
                                                      hintText:
                                                          'Landmark [ Example:Car Showroom,etc ]',
                                                      hintStyle:
                                                          ralewayStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .textColor
                                                                  .withOpacity(
                                                                      0.5),
                                                              fontSize: 14.0)),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15.0,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SlideFromBottomAnimation(
                                          delay: 0.5,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                var buildingNo =
                                                    buildingNoController.text
                                                        .trim();
                                                var streetName =
                                                    streetAddressController.text
                                                        .trim();
                                                var cityName =
                                                    cityController.text.trim();
                                                var zipCode = zipCodeController
                                                    .text
                                                    .trim();
                                                var landmark =
                                                    landmarkController.text
                                                        .trim();
                                                if (buildingNo.isEmpty) {
                                                  glb.showSnackBar(
                                                      context,
                                                      'Alert',
                                                      'Please Add Building/Society Name/House No');
                                                  return;
                                                } else if (streetName.isEmpty) {
                                                  glb.showSnackBar(
                                                      context,
                                                      'Alert',
                                                      'Please Add Street Address');
                                                  return;
                                                } else if (cityName.isEmpty) {
                                                  glb.showSnackBar(
                                                      context,
                                                      'Alert',
                                                      'Please Add City Name');
                                                  return;
                                                } else if (zipCode.isEmpty) {
                                                  glb.showSnackBar(
                                                      context,
                                                      'Alert',
                                                      'Please Add ZipCode');
                                                  return;
                                                } else if (landmark.isEmpty) {
                                                  glb.showSnackBar(
                                                      context,
                                                      'Alert',
                                                      'Please Provide LandMark');
                                                  return;
                                                } else {
                                                  if (latitude == 0 ||
                                                      longitude == 0) {
                                                    glb.showSnackBar(
                                                        context,
                                                        'Alert',
                                                        'Please Turn On your location');
                                                    return;
                                                  }
                                                  requestPickupAsync(
                                                      buildingNo,
                                                      streetName,
                                                      cityName,
                                                      zipCode,
                                                      landmark);
                                                }
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              child: Ink(
                                                padding:
                                                    const EdgeInsets.all(18.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                    gradient:
                                                        const LinearGradient(
                                                            colors: [
                                                          AppColors.blueColor,
                                                          Colors.blue
                                                        ])),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Save & Request Pick Up',
                                                      style:
                                                          nunitoStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColors
                                                            .whiteColor,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                    const Icon(
                                                      Icons
                                                          .arrow_right_outlined,
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  )),
      ),
    );
  }
}
