// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/widgets/custom_radio_btn.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

class PlaceOrderPage extends StatefulWidget {
  final Function(String) updateQuantity;
  final String catId;

  const PlaceOrderPage(
      {super.key, required this.updateQuantity, required this.catId});

  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  bool _isColorColthes = false,
      _isColorWhite = false,
      _dryHeaterOnly = false,
      _scentedDetergentOnly = false,
      _useSoftnerOnly = false;
  TextEditingController quantityController = TextEditingController();
  List<String> items = ['Regular', 'Express', 'Offer'];
  String selectedItem = 'Regular'; // Initialize with a default value
  bool showLoading = true;
  var categoryname = "";
  var categoryImage = "";
  var regularPrice = "";
  var regularType = "";
  var expressPrice = "";
  var expressType = "";
  var offerPrice = "";
  var offerType = "";
  var cat_id = "";
  var sub_cat_id = "";
  var quantity = "";
  var price = "";
  var customer_id = "";
  var order_id = "";
  var order_type = "";
  var total_price = 0.0;
  var actual_cost = 0.0;
  var total_quantity = 0;

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
              order_type = 'Regular'; // Initialize with a default value
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cat_id = widget.catId;
    sub_cat_id = "-1";
    order_id = glb.orderid;

    loadOtherLaundryCategoryItems();
  }

  List<Map<String, dynamic>> createJsonData(laundryQuantity) {
    List<Map<String, dynamic>> selectedItems = [];
    var typeOf = "Kgs";
    print("order_type::$order_type");
    if (order_type.contains('Regular')) {
      total_price = (double.parse(regularPrice) * int.parse(laundryQuantity));
      actual_cost = double.parse(regularPrice);
      typeOf = regularType;
    } else if (order_type.contains("Express")) {
      total_price = (double.parse(expressPrice) * int.parse(laundryQuantity));
      actual_cost = double.parse(expressPrice);
      typeOf = expressType;
    } else {
      total_price = (double.parse(offerPrice) * int.parse(laundryQuantity));
      actual_cost = double.parse(offerPrice);
      typeOf = offerPrice;
    }

    total_quantity = int.parse(laundryQuantity);
    print("total_price::$total_price");
    print("total_quantity::$total_quantity");

    selectedItems.add({
      'subCategoryName': 'NA',
      'item_quantity': total_quantity,
      'sub_cat_name': 'NA',
      'actual_cost': actual_cost,
      'cost': total_price,
      'type_of': typeOf,
      'sub_cat_id': '-1',
      'sub_cat_img': 'NA',
      'section_type': 'NA'
    });
    return selectedItems;
  }

  Future addLaundryItemToCart(String laundryQuantity) async {
    glb.prefs = await SharedPreferences.getInstance();

    var customrid = glb.prefs?.getString('customerid');
    print("customrid::$customrid");
    if (customrid != null) {
      customer_id = customrid;
    } else {
      glb.showSnackBar(
          context, 'Alert', 'Please use valid credentials and Login In Again');
      return;
    }
    var allItemsJson = createJsonData(laundryQuantity);

    try {
      var url = glb.endPoint;
      url+="add_laundry_items_to_cart/";
      final Map dictMap = {};

      dictMap['cat_id'] = cat_id;
      dictMap['sub_cat_id'] = sub_cat_id;
      dictMap['quantity'] = total_quantity;
      dictMap['price'] = total_price;
      dictMap['customer_id'] = glb.customerID;
      dictMap['order_id'] = order_id;
      dictMap['order_type'] = order_type;
      dictMap['all_items'] = allItemsJson;
      dictMap['cat_img'] = categoryImage;
      dictMap['cat_name'] = categoryname;
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
          glb.showSnackBar(context, 'Success', 'Added Successfully to cart ');
          setState(() {
            quantityController.text = '';
          });
          Navigator.pushNamed(context, MyCartRoute);
          return;
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  showLoading
                      ? Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : Container(
                          child: Column(
                            children: [
                              
                             Row(
                              children: [
  Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: AppColors
                                              .blueColor, // Border color
                                          width: 0.2, // Border width
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: quantityController,
                                        style: nunitoStyle.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.whiteColor,
                                            fontSize: 14.0),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          // Update the quantity value as the user types
                                          widget.updateQuantity(value);
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
                                                const EdgeInsets.only(
                                                    top: 16.0),
                                            hintText: 'Quantity in Kgs',
                                            hintStyle: nunitoStyle.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.backColor
                                                    .withOpacity(0.5),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                               border: Border.all(
                                          color: AppColors
                                              .blueColor, // Border color
                                          width: 0.2, // Border width
                                        ),
                                        ),
                                        child: DropdownButton<String>(
                                          dropdownColor:
                                              AppColors.lightBlackColor,
                                          value: selectedItem,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedItem = newValue!;
                                              order_type = selectedItem;
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
                                                        style: nunitoStyle
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 12.0,
                                                                color: AppColors
                                                                    .backColor),
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
                                padding: const EdgeInsets.all(12.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                var quantityLaundry =
                                                    quantityController.text
                                                        .trim();
                                                if (quantityLaundry == null ||
                                                    quantityLaundry.isEmpty) {
                                                  glb.showSnackBar(
                                                      context,
                                                      'Alert',
                                                      "Please add quantity for $categoryname first");
                                                  return;
                                                }

                                                addLaundryItemToCart(
                                                    quantityLaundry);
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      LinearGradient(colors: [
                                                    Colors.green,
                                                    Colors.blue,
                                                  ]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 50.0,
                                                      vertical: 10.0),
                                                  child: Text(
                                                    'Add To Cart',
                                                    style: nunitoStyle.copyWith(
                                                        fontSize: 16.0,
                                                        color: AppColors
                                                            .whiteColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              // const SizedBox(
                              //   height: 10.0,
                              // ),
                              // Container(
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(12.0),
                              //       color: AppColors.whiteColor),
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //         vertical: 20.0, horizontal: 12.0),
                              //     child: Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Text(
                              //           'Color Preferences',
                              //           style: nunitoStyle.copyWith(
                              //               fontSize: 20.0,
                              //               fontWeight: FontWeight.bold,
                              //               color: AppColors.titleTxtColor),
                              //         ),
                              //         Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Row(
                              //             mainAxisAlignment: MainAxisAlignment.start,
                              //             children: [
                              //               CustomRadioButton(
                              //                 label: 'Color Clothes',
                              //                 isSelected:
                              //                     _isColorColthes, // Set to true for the selected option
                              //                 onChanged: (selected) {
                              //                   // Handle option 1 selection
                              //                   setState(() {
                              //                     _isColorColthes = true;
                              //                     _isColorWhite = false;
                              //                   });
                              //                 },
                              //               ),
                              //               const SizedBox(
                              //                   width:
                              //                       20), // Add some spacing between the radio buttons
                              //               CustomRadioButton(
                              //                 label: 'White Clothes',
                              //                 isSelected:
                              //                     _isColorWhite, // Set to true for the selected option
                              //                 onChanged: (selected) {
                              //                   setState(() {
                              //                     _isColorWhite = true;
                              //                     _isColorColthes = false;
                              //                   });
                              //                 },
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),

                              // const SizedBox(
                              //   height: 10.0,
                              // ),
                              // Container(
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(12.0),
                              //       color: AppColors.whiteColor),
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //         vertical: 20.0, horizontal: 12.0),
                              //     child: Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Text(
                              //           'Other',
                              //           style: nunitoStyle.copyWith(
                              //               fontSize: 20.0,
                              //               fontWeight: FontWeight.bold,
                              //               color: AppColors.titleTxtColor),
                              //         ),
                              //         Column(
                              //           children: [
                              //             const SizedBox(height: 10),
                              //             CustomRadioButton(
                              //               label: 'Dry Heater',
                              //               isSelected:
                              //                   _dryHeaterOnly, // Set to true for the selected option
                              //               onChanged: (selected) {
                              //                 if (selected == true) {
                              //                   setState(() {
                              //                     _dryHeaterOnly = true;
                              //                   });
                              //                 } else {
                              //                   setState(() {
                              //                     _dryHeaterOnly = false;
                              //                   });
                              //                 }
                              //               },
                              //             ),
                              //             const SizedBox(
                              //                 height:
                              //                     10), // Add some spacing between the radio buttons
                              //             CustomRadioButton(
                              //               label: 'Scented Detergent',
                              //               isSelected:
                              //                   _scentedDetergentOnly, // Set to true for the selected option
                              //               onChanged: (selected) {
                              //                 if (selected == true) {
                              //                   setState(() {
                              //                     _scentedDetergentOnly = true;
                              //                   });
                              //                 } else {
                              //                   setState(() {
                              //                     _scentedDetergentOnly = false;
                              //                   });
                              //                 }
                              //               },
                              //             ),
                              //             const SizedBox(
                              //                 height:
                              //                     10), // Add some spacing between the radio buttons
                              //             CustomRadioButton(
                              //               label: 'Use Softner',
                              //               isSelected:
                              //                   _useSoftnerOnly, // Set to true for the selected option
                              //               onChanged: (selected) {
                              //                 if (selected == true) {
                              //                   setState(() {
                              //                     _useSoftnerOnly = true;
                              //                   });
                              //                 } else {
                              //                   setState(() {
                              //                     _useSoftnerOnly = false;
                              //                   });
                              //                 }
                              //               },
                              //             ),
                              //           ],
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),

                              // const SizedBox(
                              //   height: 10.0,
                              // ),
                              // Container(
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(12.0),
                              //       color: AppColors.whiteColor),
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //         vertical: 20.0, horizontal: 12.0),
                              //     child: Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Row(
                              //           children: [
                              //             Text(
                              //               'Additional Notes',
                              //               style: nunitoStyle.copyWith(
                              //                   fontSize: 20.0,
                              //                   fontWeight: FontWeight.bold,
                              //                   color: AppColors.titleTxtColor),
                              //             ),
                              //           ],
                              //         ),
                              //         Container(
                              //           height: 100.0,
                              //           width: width,
                              //           decoration: BoxDecoration(
                              //             borderRadius: BorderRadius.circular(8.0),
                              //           ),
                              //           child: TextFormField(
                              //             maxLines: 20,
                              //             style: nunitoStyle.copyWith(
                              //                 fontWeight: FontWeight.w400,
                              //                 color: AppColors.titleTxtColor,
                              //                 fontSize: 14.0),
                              //             keyboardType: TextInputType.text,
                              //             decoration: InputDecoration(
                              //                 border: InputBorder.none,
                              //                 contentPadding:
                              //                     const EdgeInsets.only(top: 16.0),
                              //                 hintText:
                              //                     'Please provide us with any specific instruction which should be followed by us.',
                              //                 hintStyle: nunitoStyle.copyWith(
                              //                     fontWeight: FontWeight.w400,
                              //                     color: AppColors.textColor,
                              //                     fontSize: 12.0)),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),

                              const SizedBox(
                                height: 15.0,
                              ),
                            ],
                          ),
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
