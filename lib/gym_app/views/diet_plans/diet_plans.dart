import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/gym_app/views/gym_fees_plans/modals/fees_modal.dart';

import '../../common_widgets/round_button.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

class DietPlanScreen extends StatefulWidget {
  const DietPlanScreen({super.key});

  @override
  State<DietPlanScreen> createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDietPlansDetails();
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
                "DIET PLANS",
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
                  child: Image.asset('assets/images/diet_plan.png')),
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
                          "Diet Chart",
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
                        itemCount: dietPlanModel.length,
                        itemBuilder: (context, index) {
                          var wObj = dietPlanModel[index];
                          return InkWell(
                              onTap: () {
                                //Show RazorPay Option
                              },
                              child: _dietCard(wObj));
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

  bool showLoading = true;
  List<DietPlansModal> dietPlanModel = [];

  Future getDietPlansDetails() async {
    setState(() {
      showLoading = true;

      dietPlanModel = [];
    });
    final prefs = await SharedPreferences.getInstance();

    try {
      var url = glb.endPointGym;
      url += "get_diet_chart_details/";
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
            Map<String, dynamic> dietPlanDetailsMap =
                json.decode(response.body);
            if (kDebugMode) {
              print("dietPlanDetailsMap:$dietPlanDetailsMap");
            }
            // Accessing the list of fee details under the key 'query_result'
            List<dynamic> queryResult = dietPlanDetailsMap['query_result'];

            for (var feeDetail in queryResult) {
              var fdetailId = feeDetail['diet_chart_id'].toString();
              var name = feeDetail['name'].toString();
              var validity_in_days = feeDetail['validity_in_days'].toString();
              var price = feeDetail['price'].toString();
              var description = feeDetail['description'].toString();
              var image = feeDetail['image'].toString();

              dietPlanModel.add(DietPlansModal(
                  title: name,
                  description: description,
                  duration: validity_in_days,
                  price: price,
                  image: image));
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

Container _dietCard(DietPlansModal wObj) {
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
                        title: 'Rs.${wObj.price.toString()}', onPressed: () {}),
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
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    wObj.image,
                    width: 90,
                    height: 90,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
}
