import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/common/rounded_button.dart';
import 'package:vff_group/united_armor_app/common/size_config.dart';
import 'package:vff_group/utils/app_styles.dart';

class PaymentSuccessPage extends StatefulWidget {
  const PaymentSuccessPage({super.key});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(color: kDarkBrown),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
           
          ];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 4,
                            decoration: BoxDecoration(
                                color: AppColors.grayColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(3)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.5,
                      ),
                      
                      Center(
                        child: Column(
                          children: [
                            Image.asset('assets/images/order_success.gif'),
                            Text(
                              'ORDER CONFIRMED',
                              style: TextStyle(
                                  color: kDarkBrown,
                                  fontSize: 22,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundDarkButton(
                          title: "Continue Shopping", onPressed: () {
                            Navigator.pushReplacementNamed(context, ClothingDashboardRoute);
                          })
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
