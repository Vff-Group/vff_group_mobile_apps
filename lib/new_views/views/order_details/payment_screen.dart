import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/new_views/widgets/footer_widget.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import '../../../utils/app_colors.dart';
import 'package:http/http.dart' as http;

class PaymentScreenNew extends StatefulWidget {
  const PaymentScreenNew({super.key, required this.totalPrice});
  final String totalPrice;
  @override
  State<PaymentScreenNew> createState() => _PaymentScreenNewState();
}

class _PaymentScreenNewState extends State<PaymentScreenNew> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    glb.paymentType = "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        foregroundColor: AppColors.backColor,
        centerTitle: true,
        title: Text(
          'Payments',
          style: ralewayStyle.copyWith(
            color: AppColors.backColor,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Choose Payment \n Option',
                      style: nunitoStyle.copyWith(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          glb.paymentType = 'Debit Card';
                        });
                      },
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: glb.paymentType == 'Debit Card'
                                ? AppColors.blueColor
                                : AppColors.secondaryBackColor,
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Debit Card',
                                style: nunitoStyle.copyWith(
                                  color: glb.paymentType == 'Debit Card'
                                      ? AppColors.whiteColor
                                      : AppColors.backColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset('assets/icons/debit_card_icon.png',width: 25,height: 25,)
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          glb.paymentType = 'Internet Banking';
                        });
                      },
                      borderRadius: BorderRadius.circular(12.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            color: glb.paymentType == "Internet Banking"
                                ? AppColors.blueColor
                                : AppColors.secondaryBackColor,
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              
                              
                              Text(
                                'Internet Banking',
                                style: nunitoStyle.copyWith(
                                  color: glb.paymentType == "Internet Banking"
                                      ? AppColors.whiteColor
                                      : AppColors.backColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset('assets/icons/bank_transfer.png',width: 25,height: 25,)
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          glb.paymentType = 'UPI';
                        });
                      },
                      borderRadius: BorderRadius.circular(12.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            color: glb.paymentType == "UPI"
                                ? AppColors.blueColor
                                : AppColors.secondaryBackColor,
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              
                              Text(
                                'UPI',
                                style: nunitoStyle.copyWith(
                                  color: glb.paymentType == "UPI"
                                      ? AppColors.whiteColor
                                      : AppColors.backColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset('assets/icons/upi_icon.png',width: 25,height: 25,)
                                  )),
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 15.0,
                  // ),
                  // Material(
                  //   color: Colors.transparent,
                  //   child: InkWell(
                  //     onTap: () {
                  //       setState(() {
                  //         glb.paymentType = 'Cash';
                  //       });
                  //     },
                  //     borderRadius: BorderRadius.circular(12.0),
                  //     child: Ink(
                  //       decoration: BoxDecoration(
                  //           color: glb.paymentType == "Cash"
                  //               ? AppColors.blueColor
                  //               : AppColors.secondaryBackColor,
                  //           borderRadius: BorderRadius.circular(12.0)),
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(16.0),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                              
                  //             Text(
                  //               'Cash',
                  //               style: nunitoStyle.copyWith(
                  //                 color: glb.paymentType == "Cash"
                  //                     ? AppColors.whiteColor
                  //                     : AppColors.backColor,
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),

                  //             Container(
                  //                 decoration: BoxDecoration(
                  //                     color: AppColors.whiteColor,
                  //                     borderRadius:
                  //                         BorderRadius.circular(25.0)),
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Icon(
                  //                     Icons.money,
                  //                     color: AppColors.blueColor,
                  //                   ),
                  //                 )),
                              
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.lightBlackColor,
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total to Pay',
                                style: nunitoStyle.copyWith(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.backColor),
                              ),
                              Text(
                                '₹.${widget.totalPrice}/-',
                                style: nunitoStyle.copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.blueColor),
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
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (glb.paymentType.isEmpty) {
                            glb.showSnackBar(context, 'Alert',
                                'Please Choose Payment Option.\nBy Clicking on it.');
                            return;
                          }
                          double amount = 0;
                          setState(() {
                            showProgress = true;
                            amount = double.parse(widget.totalPrice) * 100;
                          });
                          //Razor Pay Code
                          if (glb.paymentType == "Debit Card" ||
                              glb.paymentType == "Internet Banking" ||
                              glb.paymentType == "UPI") {
                            var options = {
                              'key': 'rzp_live_SeGnLgb5JnY8Id',
                              'amount':
                                  amount, //in the smallest currency sub-unit.
                              'name': 'VFF Group',
                              'image':
                                  'https://vff-group.com/static/images/logo.png',
                              'description': 'Laundry service charge',
                              'timeout': 100, // in seconds
                            };
                  
                            //To Open RazorPay Activity
                  
                            _razorpay.open(options);
                          } else {
                            razor_pay_status = "Cash";
                            razor_pay_id = "-1";
                            //savePaymentAndCartDetails();
                          }
                        },
                        borderRadius: BorderRadius.circular(12.0),
                        child: Ink(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: AppColors.blueColor
                                // gradient: LinearGradient(colors: [
                                //   Colors.green,
                                //   Colors.blue,
                                // ]),
                                ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10.0),
                              child: Text(
                                'Pay Now',
                                style: nunitoStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.whiteColor,
                                    fontSize: 18.0),
                              ),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Footer_Part(),
          )
        ],
      ),
    );
  }

  bool _isColorColthes = false,
      _isColorWhite = false,
      _dryHeaterOnly = false,
      _scentedDetergentOnly = false,
      _useSoftnerOnly = false,
      razorPayLoading = false,
      showLoading = true,
      showFullPageLoading = false,
      showProgress = false;
  var _razorpay = Razorpay();
  var razor_pay_id = "";
  var razor_pay_status = "";
  Future savePaymentAndCartDetails() async {
    setState(() {
      showFullPageLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var customerid = prefs.getString('customerid');

    try {
      var url = glb.endPoint;
      url+="load_selected_order_items_order_detail/";
      final Map dictMap = {};

      dictMap['order_id'] = glb.orderid;
      dictMap['total_price'] = customerid;

      // dictMap['pktType'] = "35";
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
    return;
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    print('External Wallet Response::$response');
    print('response.walletName::${response.walletName}');
    razor_pay_status = "External Wallet";
    //savePaymentAndCartDetails();
    setState(() {
      showProgress = false;
    });
  }
}
