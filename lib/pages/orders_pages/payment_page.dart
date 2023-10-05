import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
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
            child: Text('Payment',
                style: ralewayStyle.copyWith(
                    fontSize: 20.0,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1)),
          )),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text('Select Pick Up & Delivery Address',
                            style: ralewayStyle.copyWith(
                                fontSize: 14.0,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w200,
                                letterSpacing: 1)),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: AppColors.blueColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 45.0,
                                top: 22.0,
                                bottom: 22.0,
                                left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.home_filled,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text('Home',
                                    style: ralewayStyle.copyWith(
                                      fontSize: 20.0,
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text('Enter Address Details',
                            style: ralewayStyle.copyWith(
                                fontSize: 20.0,
                                color: AppColors.titleTxtColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1)),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Column(
                          children: [
                            Container(
                              height: 60.0,
                              width: width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: AppColors.whiteColor),
                              child: TextFormField(
                                style: nunitoStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.titleTxtColor,
                                    fontSize: 14.0),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.only(top: 16.0),
                                    hintText: ' Building/Society Name & Number',
                                    hintStyle: ralewayStyle.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textColor
                                            .withOpacity(0.5),
                                        fontSize: 14.0)),
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              height: 60.0,
                              width: width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: AppColors.whiteColor),
                              child: TextFormField(
                                style: nunitoStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.titleTxtColor,
                                    fontSize: 14.0),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.only(top: 16.0),
                                    hintText: ' Street Address, Landmark etc.',
                                    hintStyle: ralewayStyle.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textColor
                                            .withOpacity(0.5),
                                        fontSize: 14.0)),
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: AppColors.whiteColor),
                                    child: TextFormField(
                                      style: nunitoStyle.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.titleTxtColor,
                                          fontSize: 14.0),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.only(top: 16.0),
                                          hintText: ' City',
                                          hintStyle: ralewayStyle.copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.textColor
                                                  .withOpacity(0.5),
                                              fontSize: 14.0)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 60.0,
                                    width: width,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: AppColors.whiteColor),
                                    child: TextFormField(
                                      style: nunitoStyle.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.titleTxtColor,
                                          fontSize: 14.0),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.only(top: 16.0),
                                          hintText: ' Zip Code',
                                          hintStyle: ralewayStyle.copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.textColor
                                                  .withOpacity(0.5),
                                              fontSize: 14.0)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SlideFromBottomAnimation(
                        delay: 0.5,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              //Send to Address Page
                            },
                            borderRadius: BorderRadius.circular(16.0),
                            child: Ink(
                              padding: const EdgeInsets.all(18.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  gradient: LinearGradient(colors: [
                                    AppColors.blueColor,
                                    Colors.blue
                                  ])),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Continue',
                                    style: nunitoStyle.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.whiteColor,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_right_outlined,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
