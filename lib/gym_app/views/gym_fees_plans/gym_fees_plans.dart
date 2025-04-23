import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/gym_app/views/gym_fees_plans/modals/fees_modal.dart';
import 'package:vff_group/gym_app/views/gym_fees_plans/widgets/price_list.dart';

import '../../common_widgets/round_button.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

class AllGymPlansScreen extends StatefulWidget {
  const AllGymPlansScreen({super.key});

  @override
  State<AllGymPlansScreen> createState() => _AllGymPlansScreenState();
}

class _AllGymPlansScreenState extends State<AllGymPlansScreen> {
  var _razorpay = Razorpay();
  String userName = "", razor_pay_status = "", razor_pay_id = "";
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print('Success Response::${response.paymentId}');
    var responseID = response.paymentId;
    if (responseID != null && responseID.isNotEmpty) {
      razor_pay_id = response.paymentId!;
    }
    razor_pay_status = "Success";
    //savePaymentDetails();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print('Failed Response::$response');
    razor_pay_status = "Failed";
    glb.showSnackBar(context, 'Alert', 'Payment Failed please try again');

    return;
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    print('External Wallet Response::$response');
    print('response.walletName::${response.walletName}');
    razor_pay_status = "External Wallet";
    //savePaymentAndCartDetails();
  }

  List whatArr = [
    {
      "image": "assets/images/what_1.png",
      "title": "Monthly Plan",
      "exercises": "Including All",
      "time": "1 Month",
      "price": "1200/-",
    },
    {
      "image": "assets/images/what_2.png",
      "title": "Quarterly Plan",
      "exercises": "With All Facilities",
      "time": "6 Month",
      "price": "6300/-",
    },
    {
      "image": "assets/images/what_3.png",
      "title": "Yearly Plans ",
      "exercises": "With All Facilities",
      "time": "1 Year",
      "price": "10,000/-",
    }
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFeesPlansDetails();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration:
          BoxDecoration(gradient: LinearGradient(colors: AppColors.primaryG)),
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              // pinned: true,
              title: const Text(
                "GYM FEES PLANS",
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              leading: const SizedBox(),
              expandedHeight: media.height * 0.16,
              flexibleSpace: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: media.width * 0.5,
                  width: double.maxFinite,
                  child: Image.asset('assets/images/detail_top.png')),
            )
          ];
        },
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                          color: AppColors.grayColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(3)),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor2.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "For more details",
                            style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            width: 100,
                            height: 35,
                            child: RoundButton(
                              title: "Contact Us",
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Fee Chart",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                    ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: feesModel.length,
                        itemBuilder: (context, index) {
                          var wObj = feesModel[index];
                          return InkWell(
                              onTap: () {
                                //Show RazorPay Option
                              },
                              child: _feesCard(wObj));
                        }),
                    SizedBox(
                      height: media.width * 0.1,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Container _feesCard(FeesDetailsModal wObj) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColors.primaryColor2.withOpacity(0.3),
              AppColors.primaryColor1.withOpacity(0.3)
            ]),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wObj.title.toString(),
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${wObj.description.toString()} | ${wObj.duration.toString()}",
                      style: TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 100,
                      height: 30,
                      child: RoundButton(
                          title: 'Rs.${wObj.price.toString()}',
                          onPressed: () {}),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor.withOpacity(0.54),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      wObj.image,
                      width: 90,
                      height: 90,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          // tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: AppColors.whiteColor,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 35),
          FlSpot(2, 70),
          FlSpot(3, 40),
          FlSpot(4, 80),
          FlSpot(5, 25),
          FlSpot(6, 70),
          FlSpot(7, 35),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: AppColors.whiteColor.withOpacity(0.5),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
        ),
        spots: const [
          FlSpot(1, 80),
          FlSpot(2, 50),
          FlSpot(3, 90),
          FlSpot(4, 40),
          FlSpot(5, 80),
          FlSpot(6, 35),
          FlSpot(7, 60),
        ],
      );

  Future savePaymentDetailsAsync(paymentID, paymentStatus, totalAmount) async {
    try {
      var url = glb.endPointGym;
      url += "save_payment_details/"; // Route Name
      final prefs = await SharedPreferences.getInstance();
      var memberid = prefs.getString('memberid');
      var nextDueDate = "";
      final Map dictMap = {
        'memberid': memberid,
        'razor_pay_id': paymentID,
        'payment_status': paymentStatus,
        'amount': totalAmount,
        'payment_method': 'Online',
        'next_due_date': nextDueDate,
        // 'recent_cleared_date': previous_fees_date,
        // 'duration': duration_in_months,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(dictMap),
      );

      if (response.statusCode == 200) {
        // Handle successful response here
        var res = response.body;
        if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');

          return;
        } else {
          try {
            Map<String, dynamic> feesMap = json.decode(res);
            print("feesMap:$feesMap");

            return;
          } catch (e) {
            print(e);
            return "Failed";
          }
        }
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      glb.handleErrors(e, context);

      return;
    }
  }

  bool showLoading = true;
  List<FeesDetailsModal> feesModel = [];
  List<String> imagePaths = [
    "assets/images/what_1.png",
    "assets/images/what_2.png",
    "assets/images/what_3.png",
    "assets/images/welcome_promo.png",
    
  ];
  Future getFeesPlansDetails() async {
    setState(() {
      showLoading = true;

      feesModel = [];
    });
    final prefs = await SharedPreferences.getInstance();

    try {
      var url = glb.endPointGym;
      url += "get_fees_chart_details/";
      final Map dictMap = {};

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
          //glb.showSnackBar(context, 'Error', 'No Order Details Found');
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showLoading = false;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> feesDetailsMap = json.decode(response.body);
            if (kDebugMode) {
              print("feesDetailsMap:$feesDetailsMap");
            }
            // Accessing the list of fee details under the key 'query_result'
            List<dynamic> queryResult = feesDetailsMap['query_result'];

            // Inside your loop
            Random random = Random();
            for (var feeDetail in queryResult) {
              var fdetailId = feeDetail['fdetail_id'].toString();
              var title = feeDetail['title'].toString();
              var duration = feeDetail['duration_in_months'].toString();
              var price = feeDetail['price'].toString();
              var description = feeDetail['description'].toString();

              // Generate a random index to select an image path
              int randomIndex = random.nextInt(imagePaths.length);

              // Use the randomly selected image path
              String randomImagePath = imagePaths[randomIndex];
              feesModel.add(FeesDetailsModal(
                  title: title,
                  description: description,
                  duration: duration,
                  price: price,
                  image: randomImagePath));
            }

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
}
