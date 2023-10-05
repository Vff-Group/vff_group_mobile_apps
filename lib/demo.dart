// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/scale_and_revert_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/animation/slide_left_animation.dart';
import 'package:vff_group/animation/slideright_animation.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:vff_group/modals/main_category_model.dart';
import 'package:vff_group/notification_services.dart';
import 'package:vff_group/pages/main_pages/emotion_widget.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:http/http.dart' as http;
import 'package:widget_circular_animator/widget_circular_animator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _todaysDate = "";
  var profile_img = "", userName = "";
  Position? _currentPosition;

  NotificationServices notificationServices = NotificationServices();
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1626806819282-2c1dc01a5e0c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=80',
    'https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=80',
    'https://images.unsplash.com/photo-1638949493140-edb10b7be2f3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2772&q=80',
    'https://images.unsplash.com/photo-1549037173-e3b717902c57?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=80',
    'https://images.unsplash.com/photo-1535999148025-f0f66109d384?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=80',
    'https://images.unsplash.com/photo-1630329273801-8f629dba0a72?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=80'
  ];
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<MainCategoryModel> categoryModel = [];
  bool _isLoading = true;
  Location location = new Location();

  late bool _serviceEnabled;
  late PermissionStatus permissionGranted;
  late LocationData _locationData;
  @override
  void initState() {
    super.initState();
    var tDate = glb.getDate();
    getDefaultData();
    setState(() {
      _todaysDate = tDate;
    });

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
    _handleLocationPermission();
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

             
            }
            setState(() {
              _isLoading = false;
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

    var profile = glb.prefs!.getString('profile_img');
    var usrname = glb.prefs!.getString('usrname');

    if (usrname!.isEmpty == false) {
      setState(() {
        userName = usrname;
      });
    }

    if (profile!.isEmpty == false) {
      setState(() {
        profile_img = profile;
      });
    }
  }

  Future<void> _handleLocationPermission() async {
    // Check if the location service is enabled.

    _serviceEnabled = await location.serviceEnabled();
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

    _locationData = await location.getLocation();
    print('_locationData.latitude:${_locationData.latitude}');
  }

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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: AppColors.whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _GreetingsLayout(),
                SizedBox(
                  height: width * 0.05,
                ),
                Text(
                  'What do you need today ?',
                  style: nunitoStyle.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                SizedBox(
                  height: width * 0.05,
                ),
                _isLoading
                    ? const LinearProgressIndicator()
                    : Expanded(
                        child: ListView.separated(
                            separatorBuilder: (context, _) =>
                                SizedBox(height: height * 0.02),
                            itemCount: categoryModel.length,
                            itemBuilder: (context, index) {
                              return Main_Category_Layout(
                                  width: width,
                                  categorymodel: categoryModel[index]);
                            }),
                      )
              ],
            ),
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
            animatedIconData: AnimatedIcons.menu_close //To principal button
            ),
      ),
    );
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
            ?
             WidgetCircularAnimator(
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
              ) :  Image.asset(
                'assets/logo/logo.png',
                width: 50,
                height: 50,
              ),
        
      ],
    );
  }
}
