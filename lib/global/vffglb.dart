library global;

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

String endPoint = "http://62.72.57.222:8085/"; //8085,3000
bool debugStatus = false;

// String endPointGym = "http://62.72.57.222:8000/gym_mobile_app/"; //8085,3000
String endPointClothing = "http://62.72.57.222:8000/clothing_mobile_app/"; 
String endPointGym = "https://www.vffgroup.in/gym_mobile_app/"; //8085,3000
// String endPointClothing = "https://www.vffgroup.in/clothing_mobile_app/"; //8085,3000
var gymPageIndex=0;
String account_created_date = "",
    orderid = "",
    
    booking_id = "",
    deliveryBoyID = "",
    order_status = "0",
    customerID = "",
    orderid_or_bookingid = "",
    orderType = "",
    booking_to_order_id = "",
    customer_mobno = "",
    customer_name = "";
bool addItems = false,
    hideControls = false,
    showPayOption = false,
    justSaveAddress = true,
    showDeliveryBoy = false;
String cartQuantity = "",
    cartCost = "",
    paymentType = "",
    delivery_boy_id = "",
    branch_id = "",
    clat = "",
    clng = "",
    imagePath = "";
  
String currentSubCatID = "", currentCategoryID = "", currentMainCatId = "", currentMainCategoryName = "",currentCategorySelectedName = "",currentSubCategoryName = "",currentSelectedType="";

// void showSnackBar(BuildContext context, String alertTxt, String text) {
//   Get.snackbar(alertTxt, text,
//       snackPosition: SnackPosition.TOP,
//       colorText: Colors.black,
//       backgroundGradient: alertTxt == "Error"
//           ? RadialGradient(colors: [Colors.redAccent, Colors.red])
//           : RadialGradient(
//               colors: [AppColors.primaryColor1, AppColors.primaryColor2]),
//       icon: Image.asset('assets/logo/logo.png'));
// }

void showSnackBar(BuildContext context, String alertTxt, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
    text,
    style: ralewayStyle.copyWith(fontSize: 14.0, fontWeight: FontWeight.bold),
    textAlign: TextAlign.center,
  )));
}

String makeCommaSepatedList(subCategoryNameList) {
  String subCategoryName = subCategoryNameList.join(', ');
  return subCategoryName;
}

DateTime epochToDateTime(double epoch) {
  // Convert seconds since epoch to a DateTime object
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epoch.floor() * 1000);

  return dateTime;
}

String doubleEpochToFormattedDateTime(double epoch) {
  // Convert seconds since epoch to a DateTime object
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch((epoch * 1000).toInt());

  // Format the DateTime object to a formatted date and time string with AM/PM
  String formattedDateTime = DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);

  return formattedDateTime;
}

// String epochToTime(int epoch) {
//   // Convert milliseconds since epoch to a DateTime object
//   DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epoch);

//   // Format the DateTime object to a time string with AM/PM
//   String formattedTime = DateFormat.jm().format(dateTime);

//   return formattedTime;
// }

String ext_upload_url = "https://d26ksqb4lnqfvh.cloudfront.net/";
String upload_url = "http://164.52.210.25:3335/upload";
String mainCategoryID = "", mainCategoryName = "", usrid = "";
String profileImage = "";
SharedPreferences? prefs;
int pageIndex = 0, pageDIndex = 0;
List strToLst(String str) {
  var split = str.toString().split(",");
  return split;
}

List<String> strToLst2(String str) {
  var split = str.toString().split(",");
  return split;
}

Location location = new Location();
late bool _serviceEnabled;
late PermissionStatus permissionGranted;
late LocationData _locationData;

Future<void> handleLocationPermission() async {
  // Check if the location service is enabled.
  _locationData = await location.getLocation();
  print('_locationData.latitude:${_locationData.latitude}');
  _serviceEnabled = await location.serviceEnabled();
  if (_serviceEnabled) {}
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  // _locationData = await location.getLocation();
  // print('_locationData.latitude:${_locationData.latitude}');
}

handleErrors(Object e, BuildContext context) {
  if (e.toString().contains('Connection failed')) {
    showSnackBar(context, 'Network Error',
        'No Internet Connection Found / Server is Down');
    return;
  }
  print("handle Exception here::$e");
  if (e.toString().contains("XMLHttpRequest")) {
    showSnackBar(context, 'Network Error',
        'No Internet Connection Found / Server is Down');
    return;
  }
  if (e.toString() == "Connection reset by peer") {
    showSnackBar(context, 'Network Error',
        'No Internet Connection Found / Server is Down');
    return;
  }
  if (e.toString().contains("Connection refused")) {
    showSnackBar(context, 'Network Error',
        'No Internet Connection Found / Server is Down');
    return;
  } else if (e.toString().contains("Operation timed out")) {
    showSnackBar(context, 'Network Error', 'Connection Time Out');
    return;
  } else if (e
      .toString()
      .contains("Connection closed before full header was received")) {
    showSnackBar(context, 'Network Error', 'Something Went Wrong');
    return;
  } else if (e.toString().contains("ClientException with SocketException")) {
    showSnackBar(context, 'Network Error', 'Connection timeout');
    return;
  } else {
    //showSnackBar(context, 'Network Error', 'Connection timeout');
    return;
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

showLoaderDialog(BuildContext context, bool isLoading) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
          margin: const EdgeInsets.only(left: 7),
          child: const Text("Loading..."),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: isLoading,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

// 18 OCT 2023
String getDate() {
  var now = DateTime.now();
  var formatter = DateFormat('dd MMM yyyy');
  String formattedDate = formatter.format(now);
  return formattedDate;
}

//2023-12-10
String getTodaysDate() {
  String todaysDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  return todaysDate;
}

//18/10/2023
String getDateTodays() {
  DateTime today = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(today);
  return formattedDate;
}

// Function to generate a random gradient
LinearGradient generateRandomGradient() {
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
  ];

  final Random random = Random();
  final int startIndex = random.nextInt(colors.length);
  final int endIndex = (startIndex + 1) % colors.length;

  return LinearGradient(
    colors: [colors[startIndex], colors[endIndex]],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

// Function to generate a random color with opacity

  // Generate a random gradient for each item
  LinearGradient randomGradient = generateRandomGradient();
}

Color generateRandomColorWithOpacity() {
  final Random random = Random();
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
  ];
  final int randomIndex = random.nextInt(colors.length);
  final Color randomColor = colors[randomIndex];

  // Apply 0.3 opacity to the random color
  return randomColor.withOpacity(0.5);
}

// Generate a random color with opacity for each item
Color randomColor = generateRandomColorWithOpacity();

// Future<void> checkLocationPermission() async {
//   bool isLocation = false;
//   if (await Permission.location.serviceStatus.isEnabled) {
//     //Permission is Enabled
//     isLocation = true;
//     print('location permission is enabled');
//   } else {
//     //Permission is Disbaled
//     isLocation = false;
//     var status = await Permission.location.status;
//     print('location status::$status');
//     if (status.isGranted) {
//       //Location permission granted
//       print('Location Permission Granted');
//     } else if (status.isDenied) {
//       //Location permission is not granted
//       Map<Permission, PermissionStatus> status = await [
//         Permission.location,
//       ].request();
//     } else {
//       //Permission denied permanently
//       if (await status.isPermanentlyDenied) {
//         openAppSettings();
//       }
//     }
//   }
// }

void makePhoneCall(String phoneNumber) async {
  final url = 'tel:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
