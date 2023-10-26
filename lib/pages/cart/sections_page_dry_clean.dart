// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vff_group/modals/dry_clean_items_model.dart';
import 'package:vff_group/pages/cart/item_cart_details_dry_clean.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:http/http.dart' as http;
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:vff_group/widgets/shimmer_card.dart';

class SectionsPageDryClean extends StatefulWidget {
  final String catId;
  final String catName;
  final String catImage;
  final String sectionType;
  const SectionsPageDryClean(
      {super.key,
      required this.catId,
      required this.catName,
      required this.catImage,
      required this.sectionType});

  @override
  State<SectionsPageDryClean> createState() => _SectionsPageDryCleanState();
}

class _SectionsPageDryCleanState extends State<SectionsPageDryClean> {
  bool _noItemsFound = false, showLoading = true;
  var orderQuantity = "0";

  List<DryCleanItemModel> dryCleanItemModel = []; // Your original list of items
  List<Map<String, dynamic>> selectedItems = []; // List to track selected items
  List<Map<String, dynamic>> selectedItems2 =
      []; // List to track selected items
  List<String> selectedItemsJsonList = []; // List to store JSON strings

// Function to convert a DryCleanItemModel to a JSON representation
  String dryCleanItemModelToJson(DryCleanItemModel item, int itemCount) {
    var totalCost = item.cost * itemCount;
    print('TotalCost::$totalCost');
   
    return jsonEncode({
      'sub_cat_name': item.subCategoryName,
      'item_quantity': item.itemCount,
      'actual_cost': item.cost,
      'cost': totalCost,
      'type_of': item.typeOf,
      'sub_cat_id': item.subCategoryID,
      'sub_cat_img': item.subCategoryImage,
    });
  }

// Function to update the selected items list and JSON list
  void updateSelectedItems(int index, int itemCount) {
    DryCleanItemModel item = dryCleanItemModel[index];
    String itemJson = dryCleanItemModelToJson(item, itemCount);

    // Check if the item is already in the selectedItems list
    int existingIndex = selectedItems.indexWhere((selectedItem) =>
        selectedItem['subCategoryName'] == item.subCategoryName);

    if (existingIndex != -1) {
      if (itemCount > 0) {
        // Update the existing item
        print('coming here everytine');
        selectedItems[existingIndex]['item_quantity'] = itemCount;
        selectedItems[existingIndex]['cost'] = item.cost * itemCount;
        print('CostLL${selectedItems[existingIndex]['cost']}');
        selectedItemsJsonList[existingIndex] = itemJson;
      } else {
        // If the item count is zero, remove the item
        selectedItems.removeAt(existingIndex);
        selectedItemsJsonList.removeAt(existingIndex);
      }
    } else {
      if (itemCount > 0) {
        // Add the new item

        //var totalCost = (double.parse(item.cost) * itemCount);
        print('coming here');
        selectedItems.add({
          'subCategoryName': item.subCategoryName,
          'item_quantity': itemCount,
          'sub_cat_name': item.subCategoryName,
          'actual_cost': item.cost,
          'cost': item.cost * itemCount,
          'type_of': item.typeOf,
          'sub_cat_id': item.subCategoryID,
          'sub_cat_img': item.subCategoryImage,
          'section_type': widget.sectionType
        });

        selectedItemsJsonList.add(itemJson);
      }
    }
  }

  List<DryCleanItemModel> taskModelCache = [];
  String customer_id = "";

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

  Future addDryCleanItemToCart() async {
    setState(() {
      showLoading = true;
    });
    glb.prefs = await SharedPreferences.getInstance();

    var customrid = glb.prefs?.getString('customerid');
    print("customrid::$customrid");
    if (customrid != null && glb.showPayOption) {
      glb.customerID = customrid;
    } else {

      // glb.showSnackBar(
      //     context, 'Alert', 'Please use valid credentials and Login In Again');
      // return;
    }
    
    try {
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['cat_id'] = widget.catId;
      dictMap['customer_id'] = glb.customerID;
      dictMap['order_id'] = glb.orderid;
      dictMap['order_type'] = "Dry Cleaning";
      dictMap['cat_img'] = widget.catImage;
      dictMap['cat_name'] = widget.catName;
      dictMap['all_items'] = selectedItems;
      dictMap['pktType'] = "14";
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
          glb.showSnackBar(context, 'Success', 'Added Successfully to Cart');
          Navigator.pushNamed(context, MyCartRoute);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      glb.handleErrors(e, context);
    }
  }

  Future loadDryCleanItems() async {
    setState(() {
      showLoading = true;
      dryCleanItemModel = [];
      taskModelCache = [];
      selectedItems = []; // List to track selected items
      selectedItemsJsonList = []; // List to store JSON strings
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

      dictMap['section_type'] = widget.sectionType;
      dictMap['pktType'] = "19";
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
            _noItemsFound = true;
          });
          // glb.showSnackBar(
          //     context, 'Error', 'No Items Found For ${widget.sectionType}');

          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showLoading = false;
            _noItemsFound = true;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');

          return;
        } else {
          try {
            Map<String, dynamic> dryMap = json.decode(response.body);

            var sub_categoryname = dryMap['sub_categoryname'];
            var subcat_img = dryMap['subcat_img'];
            var cost = dryMap['cost'];
            var type_of = dryMap['type_of'];
            var sub_catid = dryMap['sub_catid'];

            List<String> sub_catidLst = glb.strToLst2(sub_catid);
            List<String> subcat_imgLst = glb.strToLst2(subcat_img);
            List<String> costLst = glb.strToLst2(cost);
            List<String> typeOfLst = glb.strToLst2(type_of);
            List<String> sub_categorynameLst = glb.strToLst2(sub_categoryname);

            for (int i = 0; i < sub_catidLst.length; i++) {
              var subCatName = sub_categorynameLst.elementAt(i).toString();
              var subCatID = sub_catidLst.elementAt(i).toString();
              var subCatImg = subcat_imgLst.elementAt(i).toString();
              var cost = double.parse(costLst.elementAt(i).toString());
              var typeOf = typeOfLst.elementAt(i).toString();

              dryCleanItemModel.add(DryCleanItemModel(
                  subCategoryID: subCatID,
                  subCategoryName: subCatName,
                  subCategoryImage: subCatImg,
                  cost: cost,
                  typeOf: typeOf,
                  itemCount: 0,
                  sectionType: widget.sectionType));
            }
            setState(() {
              taskModelCache = List.from(dryCleanItemModel);
              showLoading = false;
              _noItemsFound = false;
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
    FocusManager.instance.primaryFocus?.unfocus();
    loadDryCleanItems();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Stack(
        children: [
          Column(
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
                  : _noItemsFound
                      ? Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Center(
                              child: Text(
                            'NO Laundry Items found for [${widget.sectionType}]',
                            style: ralewayStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.whiteColor,
                            ),
                          )),
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
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          // Container color
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .lightBlackColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Image.network(
                                                            dryCleanItemModel[
                                                                    index]
                                                                .subCategoryImage,
                                                            width: 30,
                                                            height: 30,
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
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
                                                                  style: ralewayStyle
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .whiteColor,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10.0,
                                                                ),
                                                                Text(
                                                                  '₹ ${dryCleanItemModel[index].cost} / ${dryCleanItemModel[index].typeOf}',
                                                                  style: nunitoStyle
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .neonColor,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25.0),
                                                        ),
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              if (dryCleanItemModel[
                                                                          index]
                                                                      .itemCount >
                                                                  0) {
                                                                dryCleanItemModel[
                                                                        index]
                                                                    .itemCount--;
                                                                updateSelectedItems(
                                                                    index,
                                                                    dryCleanItemModel[
                                                                            index]
                                                                        .itemCount);
                                                              }
                                                            });
                                                          },
                                                          child: Icon(
                                                            Icons.remove,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      //adultCount.toString()
                                                      Text(
                                                        dryCleanItemModel[index]
                                                            .itemCount
                                                            .toString(),
                                                        style: nunitoStyle
                                                            .copyWith(
                                                          fontSize: 14.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.green[700],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25.0),
                                                        ),
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              dryCleanItemModel[
                                                                      index]
                                                                  .itemCount++;
                                                              updateSelectedItems(
                                                                  index,
                                                                  dryCleanItemModel[
                                                                          index]
                                                                      .itemCount); // Increment adult count
                                                            });
                                                          },
                                                          child: Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Container(
                                                height: 0.2,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })),
                          ),
                        ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  //  print('Added ${widget.item.subCategoryName} to cart.');
                  if (selectedItemsJsonList.isEmpty) {
                    glb.showSnackBar(context, 'Alert',
                        'Please select the items first to Add to Cart');
                    return;
                  }
                  print("selectedItemsJsonList--------->$selectedItems");

                  // Close the bottom sheet
                  addDryCleanItemToCart();
                  // Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(12.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.green,
                      Colors.blue,
                    ]),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 10.0),
                    child: Text(
                      'Add To Cart',
                      style: ralewayStyle.copyWith(
                          fontSize: 16.0,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
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
