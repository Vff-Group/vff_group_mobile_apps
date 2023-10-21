// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vff_group/modals/dry_clean_items_model.dart';
import 'package:vff_group/pages/cart/item_cart_details_dry_clean.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:http/http.dart' as http;
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:vff_group/widgets/shimmer_card.dart';

class DryCleaningCart extends StatefulWidget {
  final String catId;
  final String catName;
  final String catImage;
  const DryCleaningCart(
      {super.key,
      required this.catId,
      required this.catName,
      required this.catImage});

  @override
  State<DryCleaningCart> createState() => _DryCleaningCartState();
}

class _DryCleaningCartState extends State<DryCleaningCart> {
  bool _noOrders = false, showLoading = true;
  var orderQuantity = "0";
  List<DryCleanItemModel> dryCleanItemModel = [];

  List<DryCleanItemModel> taskModelCache = [];
  void filterSearchResults(String query) {
    List<DryCleanItemModel> dummySearchList = [];
    dummySearchList.clear();
    dummySearchList.addAll(taskModelCache);
    if (query.isNotEmpty) {
      List<DryCleanItemModel> dummyListData = [];

      final suggestions = dummySearchList.where((element) {
        final nameTitle = element.subCategoryName.toLowerCase();
        final input = query.toLowerCase();
        print(nameTitle);
        print(input);
        return nameTitle.contains(input);
      }).toList();

      setState(() {
        dryCleanItemModel.clear();
        dryCleanItemModel = suggestions;
        //taskModel.addAll(dummyListData);
      });
      return;
    } else {
      print('return to normal $taskModelCache');
      setState(() {
        dryCleanItemModel.clear();
        dryCleanItemModel.addAll(taskModelCache);
      });
    }
  }

  Future loadDryCleanItems() async {
    setState(() {
      showLoading = true;
      dryCleanItemModel = [];
      taskModelCache = [];
    });
    // final prefs = await SharedPreferences.getInstance();
    // var customerid = prefs.getString('customerid');
    if (glb.orderid.isEmpty) {
      glb.showSnackBar(context, 'Alert!', 'Please Select the Active Order');
      Navigator.pop(context);
      return;
    }
    var todaysDate = glb.getDateTodays();
    try {
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['cat_id'] = widget.catId;
      dictMap['pktType'] = "13";
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
            showLoading = false;
          });
          glb.showSnackBar(context, 'Error', 'No Category Details Found');
          Navigator.pop(context);
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showLoading = false;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          Navigator.pop(context);
          return;
        } else {
          try {
            Map<String, dynamic> dryMap = json.decode(response.body);

            var sub_categoryname = dryMap['sub_categoryname'];
            var subcat_img = dryMap['subcat_img'];
            var adult_cost = dryMap['adult_cost'];
            var adult_type = dryMap['adult_type'];
            var kids_cost = dryMap['kids_cost'];
            var kids_type = dryMap['kids_type'];
            var sub_catid = dryMap['sub_catid'];

            List<String> sub_catidLst = glb.strToLst2(sub_catid);
            List<String> subcat_imgLst = glb.strToLst2(subcat_img);
            List<String> adult_costLst = glb.strToLst2(adult_cost);
            List<String> adult_typeLst = glb.strToLst2(adult_type);
            List<String> kids_costLst = glb.strToLst2(kids_cost);
            List<String> kids_typeLst = glb.strToLst2(kids_type);
            List<String> sub_categorynameLst = glb.strToLst2(sub_categoryname);

            for (int i = 0; i < sub_catidLst.length; i++) {
              var catName = sub_categorynameLst.elementAt(i).toString();
              var catID = sub_catidLst.elementAt(i).toString();
              var catImg = subcat_imgLst.elementAt(i).toString();
              var adultCost = adult_costLst.elementAt(i).toString();
              var adultType = adult_typeLst.elementAt(i).toString();
              var kidsCost = kids_costLst.elementAt(i).toString();
              var kidsType = kids_typeLst.elementAt(i).toString();

              dryCleanItemModel.add(DryCleanItemModel(
                  subCategoryID: catID,
                  subCategoryName: catName,
                  subCategoryImage: catImg,
                  adultCost: adultCost,
                  adultType: adultType,
                  kidsCost: kidsCost,
                  kidsType: kidsType));
            }
            setState(() {
              taskModelCache = List.from(dryCleanItemModel);
              showLoading = false;
            });
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
    Future.delayed(const Duration(milliseconds: 5));
    loadDryCleanItems();
  }

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDryCleanItems();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50.0,
            width: width - 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: AppColors.lightBlackColor,
            ),
            child: TextFormField(
              onChanged: ((value) {
                print('Value::$value');
                filterSearchResults(value);
              }),
              controller: searchController,
              style: ralewayStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.whiteColor,
                  fontSize: 14.0),
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(top: 16.0),
                  hintText: 'Search',
                  hintStyle: ralewayStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.whiteColor.withOpacity(0.5),
                      fontSize: 12.0)),
            ),
          ),
        ),
        showLoading
            ? Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.2),
                  highlightColor: Colors.grey.withOpacity(0.1),
                  enabled: showLoading,
                  child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: ListView.separated(
                        itemCount: 10,
                        separatorBuilder: (context, _) =>
                            SizedBox(height: height * 0.02),
                        itemBuilder: ((context, index) {
                          return const ShimmerCardLayout();
                        })),
                  ),
                ),
              )
            : Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                      itemCount: dryCleanItemModel.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                //Navigator.pushNamed(context, OrderDetailsRoute);
                                _showItemDetailsBottomSheet(
                                    context,
                                    dryCleanItemModel[index],
                                    widget.catId,
                                    widget.catName,
                                    widget.catImage);
                              },
                              borderRadius: BorderRadius.circular(8.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  // Container color
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: AppColors
                                                        .lightBlackColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Image.network(
                                                    dryCleanItemModel[index]
                                                        .subCategoryImage,
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          dryCleanItemModel[
                                                                  index]
                                                              .subCategoryName
                                                              .toCapitalized(),
                                                          style: nunitoStyle
                                                              .copyWith(
                                                            color: AppColors
                                                                .whiteColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 4.0),
                                                          child: Icon(
                                                            Icons
                                                                .person_2_outlined,
                                                            color: AppColors
                                                                .neonColor,
                                                            size: 15,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Adult - ₹${dryCleanItemModel[index].adultCost} / ${dryCleanItemModel[index].adultType}",
                                                          style: nunitoStyle
                                                              .copyWith(
                                                            color: AppColors
                                                                .whiteColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: width * 0.02,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 4.0),
                                                          child: Icon(
                                                            Icons.child_care,
                                                            color: AppColors
                                                                .neonColor,
                                                            size: 15,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Kids - ₹${dryCleanItemModel[index].kidsCost} / ${dryCleanItemModel[index].kidsType}",
                                                          style: nunitoStyle
                                                              .copyWith(
                                                            color: AppColors
                                                                .whiteColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceAround,
                                          //   children: [
                                          //     Container(
                                          //       decoration: BoxDecoration(
                                          //         color: AppColors.whiteColor,
                                          //         borderRadius:
                                          //             BorderRadius.circular(
                                          //                 25.0),
                                          //       ),
                                          //       child: Icon(
                                          //         Icons.remove,
                                          //         color: Colors.black,
                                          //         size: 20.0,
                                          //       ),
                                          //     ),
                                          //     SizedBox(
                                          //       width: 10.0,
                                          //     ),
                                          //     Text(
                                          //       orderQuantity,
                                          //       style: nunitoStyle.copyWith(
                                          //         fontSize: 14.0,
                                          //         color: Colors.white,
                                          //         fontWeight: FontWeight.bold,
                                          //       ),
                                          //     ),
                                          //     SizedBox(
                                          //       width: 10.0,
                                          //     ),
                                          //     Container(
                                          //       decoration: BoxDecoration(
                                          //         color: AppColors.whiteColor,
                                          //         borderRadius:
                                          //             BorderRadius.circular(
                                          //                 25.0),
                                          //       ),
                                          //       child: Icon(
                                          //         Icons.add,
                                          //         color: Colors.black,
                                          //         size: 20.0,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        height: 0.2,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })),
                ),
              ),
      ],
    );
  }
}

void _showItemDetailsBottomSheet(BuildContext context, DryCleanItemModel item,
    String catID, String categoryName, String categoryImage) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return ItemDetailsBottomSheet(
          item: item,
          catID: catID,
          categoryImage: categoryImage,
          categoryName: categoryName);
    },
  );
}

class _OnOrders extends StatelessWidget {
  const _OnOrders({
    super.key,
    required bool noOrders,
  }) : _noOrders = noOrders;

  final bool _noOrders;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _noOrders,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'There are no order',
              style: nunitoStyle.copyWith(
                  fontSize: 16.0, color: AppColors.textColor),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12.0),
                child: Ink(
                  decoration: BoxDecoration(
                    color: AppColors.blueDarkColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Text(
                      'Start Now',
                      style: nunitoStyle.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.backColor),
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

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
