// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_left_animation.dart';
import 'package:vff_group/modals/main_category_model.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

class AllServicesPage extends StatefulWidget {
  const AllServicesPage({super.key});

  @override
  State<AllServicesPage> createState() => _AllServicesPageState();
}

class _AllServicesPageState extends State<AllServicesPage> {
  bool showLoading = true;
  List<MainCategoryModel> categoryModel = [];

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
          backgroundColor: AppColors.blueColor,
          title: FadeAnimation(
            delay: 0.3,
            child: Text('Our Services',
                style: ralewayStyle.copyWith(
                    fontSize: 20.0,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1)),
          )),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showLoading
                ? LinearProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                        itemCount: categoryModel.length,
                        itemBuilder: ((context, index) {
                          Color randomColor =
                              glb.generateRandomColorWithOpacity();
                          return SlideFromLeftAnimation(
                            delay: 0.8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    //Send to Request PickUp Page
                                    //Navigator.pushNamed(context, PlaceOrderRoute);
                                    Navigator.pushNamed(
                                        context, DeliveryAddressRoute);
                                  },
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(12.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white
                                              .withOpacity(0.2), // Shadow color
                                          spreadRadius: 1, // Spread radius
                                          blurRadius: 5, // Blur radius
                                          offset: Offset(0,
                                              3), // Offset to control shadow position
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                    color: randomColor,
                                                  ),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                      child: Image.network(
                                                          categoryModel[index]
                                                              .categoryBGUrl))),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0, left: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        categoryModel[index]
                                                            .categoryName,
                                                        style: ralewayStyle
                                                            .copyWith(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    1)),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Text(
                                                          'Min ${categoryModel[index].minHours}Hours',
                                                          style: ralewayStyle
                                                              .copyWith(
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 4.0),
                                          child: Container(
                                            width: width,
                                            height: 1,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                color: AppColors.greyColor
                                                    .withOpacity(0.5)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text('Regular Price',
                                                        style: ralewayStyle
                                                            .copyWith(
                                                                fontSize: 8.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    1)),
                                                  ),
                                                  Text(
                                                      '${categoryModel[index].regularPrice}/${categoryModel[index].regularPriceType}',
                                                      style:
                                                          ralewayStyle.copyWith(
                                                              fontSize: 12.0,
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
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text('Express Price',
                                                        style: ralewayStyle
                                                            .copyWith(
                                                                fontSize: 8.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    1)),
                                                  ),
                                                  Text(
                                                      '${categoryModel[index].expressPrice}/${categoryModel[index].expressPriceType}',
                                                      style:
                                                          ralewayStyle.copyWith(
                                                              fontSize: 12.0,
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
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text('Offer Price',
                                                        style: ralewayStyle
                                                            .copyWith(
                                                                fontSize: 8.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    1)),
                                                  ),
                                                  Text(
                                                      '${categoryModel[index].offerPrice}/${categoryModel[index].offerPriceType}',
                                                      style:
                                                          ralewayStyle.copyWith(
                                                              fontSize: 12.0,
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  1)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        })),
                  )
          ],
        ),
      )),
    );
  }
}
