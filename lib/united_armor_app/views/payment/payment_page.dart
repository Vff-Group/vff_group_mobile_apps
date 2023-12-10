import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/common/rounded_button.dart';
import 'package:vff_group/united_armor_app/common/size_config.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;

class PaymentPageClothing extends StatefulWidget {
  const PaymentPageClothing({super.key});

  @override
  State<PaymentPageClothing> createState() => _PaymentPageClothingState();
}

class _PaymentPageClothingState extends State<PaymentPageClothing> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(color: kDarkBrown),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Container(
                      height: SizeConfig.blockSizeVertical! * 4,
                      width: SizeConfig.blockSizeVertical! * 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kWhite,
                        boxShadow: [
                          BoxShadow(
                            color: kBrown.withOpacity(0.11),
                            spreadRadius: 0.0,
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          'assets/arrow_back_icon.svg',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                "Payment Details",
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700),
              ),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        height: media.width * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "United Armor: Fortify Your Transactions - Seamless Payments, Unmatched Security.",
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColors.lightGrayColor,
                                  borderRadius: BorderRadius.circular(12.0)),
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
                                          'Sub Total',
                                          style: nunitoStyle.copyWith(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.blackColor),
                                        ),
                                        Text(
                                          '₹.2000/-',
                                          style: nunitoStyle.copyWith(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor1),
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
                                              'Shipping and Handling Total',
                                              style: nunitoStyle.copyWith(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.blackColor),
                                            ),
                                            Text(
                                              'Free delivery for orders above ₹./- 😊',
                                              style: nunitoStyle.copyWith(
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: AppColors.blackColor),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '₹.0/-',
                                          style: nunitoStyle.copyWith(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primaryColor1),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Divider(
                                        color: AppColors.grayColor,
                                        height: 0.1,
                                        thickness: 0.1,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Grand Total',
                                          style: nunitoStyle.copyWith(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor1),
                                        ),
                                        Text(
                                          '₹.2000/-',
                                          style: nunitoStyle.copyWith(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor1),
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
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 16.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Text(
                                          'Select Payment Method',
                                          style: nunitoStyle.copyWith(
                                            color: AppColors.blackColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              'Online',
                                              style: nunitoStyle.copyWith(
                                                color: AppColors.primaryColor1,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  glb.paymentType = 'Online';
                                                });
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: glb.paymentType ==
                                                            'Online'
                                                        ? AppColors
                                                            .primaryColor1
                                                        : AppColors.lightGrayColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              color: AppColors
                                                                  .whiteColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Icon(
                                                              Icons.payment,
                                                              color: AppColors
                                                                  .primaryColor1,
                                                            ),
                                                          )),
                                                      Text(
                                                        'UPI/Online/Card',
                                                        style: nunitoStyle
                                                            .copyWith(
                                                          color: glb.paymentType ==
                                                                  'Online'
                                                              ? AppColors
                                                                  .whiteColor
                                                              : AppColors
                                                                  .primaryColor1,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              'Cash',
                                              style: nunitoStyle.copyWith(
                                                color: AppColors.primaryColor1,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  glb.paymentType = 'Cash';
                                                });
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                    color: glb.paymentType ==
                                                            "Cash"
                                                        ? AppColors
                                                            .primaryColor1
                                                        : AppColors.lightGrayColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              color: AppColors
                                                                  .whiteColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Icon(
                                                              Icons.money,
                                                              color: AppColors
                                                                  .primaryColor1,
                                                            ),
                                                          )),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Text(
                                                        'By Cash On Delivery',
                                                        style: nunitoStyle
                                                            .copyWith(
                                                          color: glb.paymentType ==
                                                                  "Cash"
                                                              ? AppColors
                                                                  .whiteColor
                                                              : AppColors
                                                                  .primaryColor1,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
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
                                // Add to cart button
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.1,
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundDarkButton(
                          title: "Pay Now",
                          onPressed: () {
                            Navigator.pushNamed(context, PaymentSuccessRoute);
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
