import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/widgets/custom_radio_btn.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:vff_group/widgets/full_screen_loading.dart';
import 'package:vff_group/widgets/radio_btn_for_extra_item.dart';
import 'package:vff_group/widgets/shimmer_card.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  bool _isColorColthes = false,
      _isColorWhite = false,
      _dryHeaterOnly = false,
      _scentedDetergentOnly = false,
      _useSoftnerOnly = false,
      razorPayLoading = false,
      showLoading = true,
      showProgress = false;
  var totalPrice = 0.0;
  var deliveryDPrice = 0.0;
  var rangeDelivery = 0.0;
  var totalQuantity = 0;
  var selectedIndex = 0;
  var deliveryPrice = 0.0;
  var extraItemPrices = "";
  var razor_pay_id = "";
  var razor_pay_status = "";
  var additionalInstruction = "NA";
  TextEditingController additionalInformationController =
      TextEditingController();
  var _razorpay = Razorpay();

  List<String> itemIDLst = [];
  List<String> itemNameLst = [];
  List<String> priceLst = [];
  bool showFullPageLoading = false;

  Future loadExtraCartItems() async {
    setState(() {
      showLoading = true;
      itemIDLst = [];
      itemNameLst = [];
      priceLst = [];
    });
    final prefs = await SharedPreferences.getInstance();
    var customerid = prefs.getString('customerid');

    var todaysDate = glb.getDateTodays();
    try {
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['order_id'] = glb.orderid;
      dictMap['pktType'] = "17";
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
          // glb.showSnackBar(context, 'Error', 'No Category Details Found');
          //Navigator.pop(context);
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showLoading = false;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          //Navigator.pop(context);
          return;
        } else {
          try {
            Map<String, dynamic> cartMap = json.decode(response.body);
            print("cartMap::$cartMap");
            var itemID = cartMap['itemid'];
            var itemName = cartMap['item_name'];
            var price = cartMap['price'];
            var total_price = cartMap['total_price'];
            var total_quantity = cartMap['total_quantity'];
            var dcharge_id = cartMap['dcharge_id'];
            var delivery_price = cartMap['price_delivery'];
            var range_delivery = cartMap['range_delivery'];

            totalPrice = double.parse(total_price);

            deliveryDPrice = double.parse(delivery_price);
            setState(() {
              rangeDelivery = double.parse(range_delivery);
            });

            if (totalPrice < rangeDelivery) {
              deliveryPrice = deliveryDPrice; //To add delivery Price
              // totalPrice += deliveryPrice;
              // print('totalPrice after delivery price::$totalPrice');
            } else {
              deliveryPrice = 0;
            }
            print('deliveryPrice::::$deliveryPrice');

            totalQuantity = int.parse(total_quantity);

            itemIDLst = glb.strToLst2(itemID);
            itemNameLst = glb.strToLst2(itemName);
            priceLst = glb.strToLst2(price);

            setState(() {
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

  Set<int> selectedIndexes = {};

  List<CustomRadioButton2> generateRadioButtons() {
    List<CustomRadioButton2> radioButtons = [];
    for (int i = 0; i < itemNameLst.length; i++) {
      String label = itemNameLst[i];
      String price = priceLst[i];
      // bool isSelected =
      //     (i == selectedIndex); // Set your logic for initial selection
      bool isSelected = selectedIndexes.contains(i);
      radioButtons.add(
        CustomRadioButton2(
          price: price,
          label: label,
          isSelected: isSelected,
          onChanged: (selected) {
            setState(() {
              if (selected) {
                selectedIndexes.add(i);
                setState(() {
                  var price = double.parse(priceLst[i]);
                  print("price:$price");
                  setState(() {
                    totalPrice += price;
                  });
                  print("totalPrice+:$totalPrice");
                });
              } else {
                selectedIndexes.remove(i);
                setState(() {
                  var price = double.parse(priceLst[i]);
                  print("price:$price");
                  setState(() {
                    totalPrice -= price;
                  });

                  print("totalPrice-:$totalPrice");
                });
              }
            });
          },
        ),
      );
      //Add Space
    }
    return radioButtons;
  }

  String getSelectedItemsText() {
    List<String> selectedItems = [];
    for (int index in selectedIndexes) {
      selectedItems.add(itemNameLst[index]);
    }
    return selectedItems.join(', '); // Comma-separated string of selected items
  }

  String getSelectedItemsID() {
    List<String> selectedItems = [];
    for (int index in selectedIndexes) {
      selectedItems.add(itemIDLst[index]);
    }
    return selectedItems.join(', '); // Comma-separated string of selected items
  }

  String getSelectedItemsPrice() {
    List<String> selectedItems = [];
    for (int index in selectedIndexes) {
      selectedItems.add(priceLst[index]);
    }
    return selectedItems.join(', '); // Comma-separated string of selected items
  }

  List<Map<String, dynamic>> createJsonData(Set<int> selectedIndexes,
      List<String> itemIDLst, List<String> itemNameLst, List<String> priceLst) {
    List<Map<String, dynamic>> selectedItems = [];

    for (int index in selectedIndexes) {
      if (index < itemIDLst.length &&
          index < itemNameLst.length &&
          index < priceLst.length) {
            extraItemPrices = priceLst.elementAt(index);
        selectedItems.add({
          'extra_item_id': itemIDLst.elementAt(index),
          'extra_item_name': itemNameLst.elementAt(index),
          'extra_item_price': priceLst.elementAt(index),
        });
      }
    }
    return selectedItems;
    // Map<String, dynamic> jsonData = {
    //   'selected_items': selectedItems,
    // };

    // return json.encode(jsonData);
  }

  Future savePaymentAndCartDetails() async {
    setState(() {
      showFullPageLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var customerid = prefs.getString('customerid');
    var extraItemJson =
        createJsonData(selectedIndexes, itemIDLst, itemNameLst, priceLst);
    additionalInstruction =
        additionalInformationController.text.trim().toString();
    if (additionalInstruction == null || additionalInstruction.isEmpty) {
      additionalInstruction = "NA";
    }
    print('TotalCost::$totalPrice');
    print('deliveryPrice::$deliveryPrice'); 
    print('FinalTotal::${totalPrice+deliveryPrice}');
    totalPrice = totalPrice+deliveryPrice;
    try {
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['order_id'] = glb.orderid;
      dictMap['customer_id'] = customerid;
      dictMap['total_price'] = totalPrice;
      dictMap['total_items'] = totalQuantity;
      dictMap['order_status'] = "Payment Done";
      dictMap['razor_pay_id'] = razor_pay_id;
      dictMap['payment_status'] = razor_pay_status;
      dictMap['additional_instruction'] = additionalInstruction;
      dictMap['extra_items'] = extraItemJson;
      dictMap['pktType'] = "18";
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
          // glb.showSnackBar(context, 'Error', 'No Category Details Found');
          //Navigator.pop(context);
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showLoading = false;
            showProgress = true;
          });

          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          //Navigator.pop(context);
          return;
        } else {
          //Send to main screen and remove back references
          glb.showSnackBar(context, 'Success', 'Payment Done Successfully');
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, MainRoute);
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print('Success Response::${response.paymentId}');
    var responseID = response.paymentId;
    if (responseID != null && responseID.isNotEmpty) {
      razor_pay_id = response.paymentId!;
    }
    razor_pay_status = "Success";
    savePaymentAndCartDetails();
    setState(() {
      showProgress = false;
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print('Failed Response::$response');
    razor_pay_status = "Failed";
    glb.showSnackBar(context, 'Alert', 'Payment Failed please try again');
    setState(() {
      showProgress = false;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    print('External Wallet Response::$response');
    razor_pay_status = "External Wallet";
    savePaymentAndCartDetails();
    setState(() {
      showProgress = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadExtraCartItems();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Checkout',
            style: ralewayStyle.copyWith(
              color: AppColors.whiteColor,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        ),
        body: SafeArea(
          child: showProgress
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.2),
                  highlightColor: Colors.grey.withOpacity(0.1),
                  enabled: showLoading,
                  child: ListView.separated(
                      itemCount: 10,
                      separatorBuilder: (context, _) =>
                          SizedBox(height: height * 0.02),
                      itemBuilder: ((context, index) {
                        return const ShimmerCardLayout();
                      })),
                )
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: showLoading
                          ? LinearProgressIndicator()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: AppColors.lightBlackColor),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Other',
                                            style: nunitoStyle.copyWith(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.whiteColor),
                                          ),
                                          Column(
                                            children: [
                                              ...generateRadioButtons()
                                              /*  const SizedBox(height: 10),
                                  CustomRadioButton(
                                    label: 'Dry Heater',
                                    isSelected:
                                        _dryHeaterOnly, // Set to true for the selected option
                                    onChanged: (selected) {
                                      if (selected == true) {
                                        setState(() {
                                          _dryHeaterOnly = true;
                                        });
                                      } else {
                                        setState(() {
                                          _dryHeaterOnly = false;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                      height:
                                          10), // Add some spacing between the radio buttons
                                  CustomRadioButton(
                                    label: 'Scented Detergent',
                                    isSelected:
                                        _scentedDetergentOnly, // Set to true for the selected option
                                    onChanged: (selected) {
                                      if (selected == true) {
                                        setState(() {
                                          _scentedDetergentOnly = true;
                                        });
                                      } else {
                                        setState(() {
                                          _scentedDetergentOnly = false;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                      height:
                                          10), // Add some spacing between the radio buttons
                                  CustomRadioButton(
                                    label: 'Use Softner',
                                    isSelected:
                                        _useSoftnerOnly, // Set to true for the selected option
                                    onChanged: (selected) {
                                      if (selected == true) {
                                        setState(() {
                                          _useSoftnerOnly = true;
                                        });
                                      } else {
                                        setState(() {
                                          _useSoftnerOnly = false;
                                        });
                                      }
                                    },
                                  ),
                              */
                                              ,
                                              // Text(
                                              //   'Selected Items: ${getSelectedItemsID()}',
                                              //   style: TextStyle(fontSize: 16),
                                              // ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: AppColors.lightBlackColor),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Additional Notes',
                                                style: nunitoStyle.copyWith(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.whiteColor),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 100.0,
                                            width: width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: TextFormField(
                                              controller:
                                                  additionalInformationController,
                                              maxLines: 20,
                                              style: nunitoStyle.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.whiteColor,
                                                  fontSize: 14.0),
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          top: 16.0),
                                                  hintText:
                                                      'Please provide us with any specific instruction which should be followed by us.',
                                                  hintStyle:
                                                      ralewayStyle.copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColors
                                                              .whiteColor,
                                                          fontSize: 12.0)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.lightBlackColor,
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 12.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Service Cost',
                                                style: nunitoStyle.copyWith(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColors.whiteColor),
                                              ),
                                              Text(
                                                '₹.$totalPrice/-',
                                                style: nunitoStyle.copyWith(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.neonColor),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Delivery',
                                                    style: nunitoStyle.copyWith(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .whiteColor),
                                                  ),
                                                  Text(
                                                    'Free delivery for orders above ₹.$rangeDelivery/- 😊',
                                                    style: nunitoStyle.copyWith(
                                                        fontSize: 10.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: AppColors
                                                            .whiteColor),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '₹.$deliveryPrice/-',
                                                style: nunitoStyle.copyWith(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColors.whiteColor),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Divider(
                                              color: AppColors.whiteColor,
                                              height: 0.1,
                                              thickness: 0.1,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Total',
                                                style: nunitoStyle.copyWith(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.whiteColor),
                                              ),
                                              Text(
                                                '₹.${totalPrice + deliveryPrice}/-',
                                                style: nunitoStyle.copyWith(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.neonColor),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          showProgress = true;
                                        });
                                        //Razor Pay Code
                                        var options = {
                                          'key': 'rzp_test_qtHIWapeUEAAZO',
                                          'amount': (totalPrice +
                                                  deliveryPrice) *
                                              100, //in the smallest currency sub-unit.
                                          'name': 'VFF Group',
                                          'description':
                                              'Laundry service charge',
                                          'timeout': 100, // in seconds
                                        };

                                        //To Open RazorPay Activity
                                        
                                        _razorpay.open(options);
                                      },
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Ink(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            gradient: LinearGradient(colors: [
                                              Colors.green,
                                              Colors.blue,
                                            ]),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30.0,
                                                vertical: 10.0),
                                            child: Text(
                                              'Pay Now',
                                              style: ralewayStyle.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.whiteColor,
                                                  fontSize: 18.0),
                                            ),
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                    )
                  ],
                ),
        ));
  }
}
