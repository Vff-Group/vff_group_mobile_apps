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

class SectionPageOtherService extends StatefulWidget {
  final String catId;
  final String catName;
  final String catImage;

  const SectionPageOtherService(
      {super.key,
      required this.catId,
      required this.catName,
      required this.catImage});

  @override
  State<SectionPageOtherService> createState() =>
      _SectionPageOtherServiceState();
}

class _SectionPageOtherServiceState extends State<SectionPageOtherService> {
  bool _noItemsFound = false, showLoading = true;
  var orderQuantity = "0";

  List<DryCleanItemModel> dryCleanItemModel = []; // Your original list of items
  List<Map<String, dynamic>> selectedItems = []; // List to track selected items
  List<Map<String, dynamic>> selectedItems2 =
      []; // List to track selected items
  List<String> selectedItemsJsonList = []; // List to store JSON strings
  var categoryname = "";
  var categoryImage = "";
  var regularPrice = "";
  var regularType = "";
  var expressPrice = "";
  var expressType = "";
  var offerPrice = "";
  var offerType = "";
  List<String> items = [];
  String selectedItem = '';
  var bookingType = "";
  var typeOf = "";
  var totalQuantity = 0;
  var actualCost = 0.0;
  var totalCost = 0.0;
  TextEditingController quantityController = TextEditingController();

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
          //'section_type': widget.sectionType
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

  Future loadOtherLaundryCategoryItems() async {
    setState(() {
      showLoading = true;
      categoryname = "";
      regularPrice = "";
      regularType = "";
      expressPrice = "";
      expressType = "";
      offerPrice = "";
      offerType = "";
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
      url+="load_category_wise_details/";
      final Map dictMap = {};

      dictMap['cat_id'] = widget.catId;
      // dictMap['pktType'] = "12";
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
          glb.showSnackBar(context, 'Error', 'No Category Details Found');
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showLoading = false;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> dryMap = json.decode(response.body);
            categoryname = dryMap['categoryname'];
            regularPrice = dryMap['regular_price'];
            regularType = dryMap['regular_type'];
            expressPrice = dryMap['express_price'];
            expressType = dryMap['express_type'];
            offerPrice = dryMap['offer_price'];
            offerType = dryMap['offer_type'];
            categoryImage = dryMap['cat_img'];

            setState(() {
              var offer = offerType;
              if (offer == "NA" || offer.isEmpty || offer == '0.0') {
                offer = "No Offers";
              } else {
                offer = '${offerPrice}/${offerType}';
                items.add('Offer-$offer');
              }
              items = [
                'Regular-${regularPrice}/${regularType}',
                'Express-${expressPrice}/${expressType}'
              ];
              selectedItem = 'Regular-${regularPrice}/${regularType}';
              bookingType = 'Regular'; // Initialize with a default value
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

  Future addDryCleanItemToCart() async {
    var quantity = quantityController.text.trim();
    if (quantity.isEmpty) {
      glb.showSnackBar(
          context, 'Alert', 'Please Add Quantity First Before Adding to Cart');
      return;
    }
    setState(() {
      showLoading = true;
    });
    glb.prefs = await SharedPreferences.getInstance();

    var customrid = glb.prefs?.getString('customerid');
    print("customrid::$customrid");

    // Extract subCategoryName and item_quantity and form a list of strings
    // List<String> subCategoryQuantityList = selectedItems
    //     .map((item) => "${item['subCategoryName']} (${item['item_quantity']})")
    //     .toList();
    List<String> subCategoryNameList = selectedItems
        .map((item) => "${item['subCategoryName']} (${item['item_quantity']})")
        .toList();
    List<String> subCatIdlist =
        selectedItems.map((item) => "${item['sub_cat_id']}").toList();
    List<String> subCatImglst =
        selectedItems.map((item) => "${item['sub_cat_img']} ").toList();

    // Create a comma-separated string

    String subCategoryName = glb.makeCommaSepatedList(subCategoryNameList);
    String subCategoryID = subCatIdlist.join(', ');
    String subCategoryImage = glb.makeCommaSepatedList(subCatImglst);
    print("subCategoryName::$subCategoryName");

    totalQuantity = int.parse(quantity);
    if (bookingType.contains('Regular')) {
      totalCost = (double.parse(regularPrice) * (totalQuantity));
      actualCost = double.parse(regularPrice);
      typeOf = regularType;
    } else if (bookingType.contains("Express")) {
      totalCost = (double.parse(expressPrice) * (totalQuantity));
      actualCost = double.parse(expressPrice);
      typeOf = expressType;
    } else {
      totalCost = (double.parse(offerPrice) * (totalQuantity));
      actualCost = double.parse(offerPrice);
      typeOf = offerPrice;
    }
    print("Total Cost::$totalCost");
    print("actualCost::$actualCost");
    print("typeOf::$typeOf");
    try {
      var url = glb.endPoint;
      url+="add_laundry_items_to_cart/";
      final Map dictMap = {};

      dictMap['cat_id'] = widget.catId;
      dictMap['customer_id'] = glb.customerID;
      dictMap['booking_id'] = glb.booking_id;
      dictMap['key'] = 2;
      dictMap['booking_type'] = bookingType;
      dictMap['cat_img'] = widget.catImage;
      dictMap['cat_name'] = widget.catName;

      dictMap['sub_cat_name'] = subCategoryName;
      dictMap['item_quantity'] = totalQuantity;
      dictMap['actual_cost'] = actualCost;
      dictMap['cost'] = totalCost;
      dictMap['type_of'] = typeOf; //Kgs
      dictMap['sub_cat_id'] = subCategoryID;
      dictMap['sub_cat_img'] = subCategoryImage;
      dictMap['section_type'] = "All";

      // dictMap['pktType'] = "14";
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
    // if (glb.orderid.isEmpty) {
    //   glb.showSnackBar(context, 'Alert!', 'Please Select the Active Order');
    //   Navigator.pop(context);
    //   return;
    // }
    var todaysDate = glb.getDateTodays();
    try {
      var url = glb.endPoint;
      url+="load_sub_category_section_wise_details/";
      final Map dictMap = {};

      dictMap['section_type'] = "All";
      // dictMap['pktType'] = "19";
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

            var subCategoryname = dryMap['sub_categoryname'];
            var subcatImg = dryMap['subcat_img'];
            var cost = dryMap['cost'];
            var typeOf = dryMap['type_of'];
            var subCatid = dryMap['sub_catid'];

            List<String> subCatidlst = glb.strToLst2(subCatid);
            List<String> subcatImglst = glb.strToLst2(subcatImg);
            List<String> costLst = glb.strToLst2(cost);
            List<String> typeOfLst = glb.strToLst2(typeOf);
            List<String> subCategorynamelst = glb.strToLst2(subCategoryname);

            for (int i = 0; i < subCatidlst.length; i++) {
              var subCatName = subCategorynamelst.elementAt(i).toString();
              var subCatID = subCatidlst.elementAt(i).toString();
              var subCatImg = subcatImglst.elementAt(i).toString();
              var cost = double.parse(costLst.elementAt(i).toString());
              var typeOf = typeOfLst.elementAt(i).toString();

              dryCleanItemModel.add(DryCleanItemModel(
                  subCategoryID: subCatID,
                  subCategoryName: subCatName,
                  subCategoryImage: subCatImg,
                  cost: cost,
                  typeOf: typeOf,
                  itemCount: 0,
                  sectionType: "All"));
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
    loadOtherLaundryCategoryItems();
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
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Add Quantity in Kgs',
                              style: nunitoStyle.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.backColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: width * 0.03,
                        ),
                        Container(
                          height: 50.0,
                          width: height / 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: AppColors.blueColor, // Border color
                              width: 0.2, // Border width
                            ),
                          ),
                          child: TextFormField(
                            controller: quantityController,
                            style: nunitoStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.backColor,
                                fontSize: 14.0),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              // Update the quantity value as the user types

                              // You can perform actions based on the updated value here
                              print('Quantity changed to: $value');
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.local_laundry_service,
                                    color: AppColors.blueColor,
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.only(top: 16.0),
                                hintText: 'Quantity in Kgs',
                                hintStyle: nunitoStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.backColor.withOpacity(0.5),
                                    fontSize: 12.0)),
                          ),
                        ),
                      
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Laundry Type',
                                style: nunitoStyle.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.backColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: width * 0.03,
                          ),
                          Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: AppColors.blueColor, // Border color
                                width: 0.2, // Border width
                              ),
                            ),
                            child: DropdownButton<String>(
                              dropdownColor: AppColors.lightBlackColor,
                              value: selectedItem,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedItem = newValue!;
                                  bookingType = selectedItem;
                                });
                              },
                              items: items.map((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: height / 5,
                                          child: Text(
                                            item,
                                            style: nunitoStyle.copyWith(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12.0,
                                                color: AppColors.backColor),
                                          )),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                    style: nunitoStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.backColor,
                        fontSize: 14.0),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search,
                            color: AppColors.blueColor,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(top: 16.0),
                        hintText: 'Search Item To Add Item Quantity',
                        hintStyle: nunitoStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.backColor.withOpacity(0.5),
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
                            //'NO Laundry Items found for [${widget.sectionType}]',
                            'NO Laundry Items found for ',
                            style: nunitoStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.backColor,
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
                                                            width: 20,
                                                            height: 20,
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
                                                                  style: nunitoStyle
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .backColor,
                                                                    fontSize:
                                                                        14,
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
                                                          color: AppColors
                                                              .blueColor,
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
                  var quantity = quantityController.text.trim();
                  if(quantity.isEmpty){
                    glb.showSnackBar(context, 'Alert', "Please Add the Laundry Quantity in Kgs");
                    return;
                  }
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
                    // gradient: LinearGradient(colors: [
                    //   Colors.green,
                    //   Colors.blue,
                    // ]),
                    color: AppColors.blueColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 10.0),
                    child: Text(
                      'Add To Cart',
                      style: nunitoStyle.copyWith(
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
