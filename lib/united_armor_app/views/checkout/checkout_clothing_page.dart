import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/common/footer_widget.dart';
import 'package:vff_group/utils/app_colors.dart' as AppColor2;

class CheckOutClothingPage extends StatefulWidget {
  const CheckOutClothingPage({super.key});

  @override
  State<CheckOutClothingPage> createState() => _CheckOutClothingPageState();
}

class _CheckOutClothingPageState extends State<CheckOutClothingPage> {
  bool isCheck = false, isSelected = true,defaultAddress=false;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          
          backgroundColor: kDarkBrown,
          centerTitle: true,
          title: IconButton(
              onPressed: () {
                // Navigator.pop(context);
                // Navigator.pushNamed(context, ClothingMainHomeRoute);
              },
              icon: Image.asset(
                "assets/logo/logo_united_armor.png",
                fit: BoxFit.fitHeight,
              ))),
      body: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: media.width * 0.1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Review & Place Order',
                              style: kEncodeSansBold.copyWith(fontSize: 14.0),
                            ),
                            Text(
                              '2/2',
                              style: kEncodeSansBold.copyWith(fontSize: 14.0),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: kGrey,
                        ),
                        Text(
                          'Billing Address',
                          style: kEncodeSansBold.copyWith(fontSize: 14.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    isCheck = !isCheck;
                                  });
                                },
                                icon: Icon(
                                  isCheck
                                      ? Icons.check_box_outline_blank_outlined
                                      : Icons.check_box_outlined,
                                  color: AppColors.grayColor,
                                )),
                            Expanded(
                              child: Text(
                                  "My Billing and shipping address are the same",
                                  style: kEncodeSansRagular.copyWith(
                                    color: AppColors.grayColor,
                                    fontSize: 10,
                                  )),
                            )
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.08,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust border radius as needed
                            border: Border.all(
                              width: 0.5, // Adjust border width here
                              color: Colors.grey, // Set border color
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Shaheed',
                                      style: kEncodeSansBold.copyWith(
                                          fontSize: 12.0),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: media.width * 0.02,
                                ),
                                Text(
                                  'New Vaibhav Nagar',
                                  style: kEncodeSansRagular.copyWith(
                                      fontSize: 10.0),
                                ),
                                SizedBox(
                                  height: media.width * 0.01,
                                ),
                                Text(
                                  'Belgaum',
                                  style: kEncodeSansRagular.copyWith(
                                      fontSize: 10.0),
                                ),
                                SizedBox(
                                  height: media.width * 0.01,
                                ),
                                Text(
                                  'India',
                                  style: kEncodeSansRagular.copyWith(
                                      fontSize: 10.0),
                                ),
                                SizedBox(
                                  height: media.width * 0.01,
                                ),
                                Text(
                                  '590010',
                                  style: kEncodeSansRagular.copyWith(
                                      fontSize: 10.0),
                                ),
                                SizedBox(
                                  height: media.width * 0.01,
                                ),
                                Text(
                                  '8296565587',
                                  style: kEncodeSansRagular.copyWith(
                                      fontSize: 10.0),
                                ),
                                SizedBox(
                                  height: media.width * 0.03,
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Edit',
                                        style: kEncodeSansRagular.copyWith(
                                            fontSize: 12.0,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.width * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    defaultAddress = !defaultAddress;
                                  });
                                },
                                icon: Icon(
                                  defaultAddress
                                      ? Icons.check_box_outline_blank_outlined
                                      : Icons.check_box_outlined,
                                  color: AppColors.grayColor,
                                )),
                            Expanded(
                              child: Text(
                                  "Make this address as my default address",
                                  style: kEncodeSansRagular.copyWith(
                                    color: AppColors.grayColor,
                                    fontSize: 10,
                                  )),
                            )
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        Text(
                          'Payment',
                          style: kEncodeSansBold.copyWith(fontSize: 14.0),
                        ),
                        Divider(
                          color: kGrey,
                        ),
                        Row(
                          children: [
                            Radio<bool>(
                              value: true,
                              groupValue: isSelected,
                              activeColor: kDarkBrown,
                              onChanged: (bool? value) {
                                setState(() {
                                  isSelected = value ?? false;
                                });
                              },
                            ),
                            Column(
                              children: [
                                Text(
                                  'Razorpay',
                                  style:
                                      kEncodeSansBold.copyWith(fontSize: 14.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/payment_modes.jpeg'),
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                              'You may be re-directed to a secure payment window.',
                              style:
                                  kEncodeSansRagular.copyWith(fontSize: 12.0)),
                        ),
                        SizedBox(
                          height: media.width * 0.08,
                        ),
                      ],
                    ),
                  ),
                  Footer_Part(),
                  SizedBox(
                    height: media.width * 0.5,
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          color: kWhite,
          child: Wrap(
            children: [
              SizedBox(
                height: media.width * 0.05,
              ),
              Divider(
                color: kGrey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: kEncodeSansBold.copyWith(fontSize: 16.0),
                    ),
                    Text(
                      '2345',
                      style: kEncodeSansBold.copyWith(fontSize: 16.0),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: media.width * 0.05,
              ),
              Divider(
                color: kGrey,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: GestureDetector(
                  onTap: () {
                    //Navigator.pushNamed(context, ClothingDeliveryAddressRoute);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: AppColor2.AppColors.redColor),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Place Order',
                            style: kEncodeSansBold.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteColor),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
