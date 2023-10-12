import 'package:flutter/material.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/widgets/custom_radio_btn.dart';

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
      _useSoftnerOnly = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColors.backColor,
        appBar: AppBar(
          backgroundColor: AppColors.blueColor,
          title: Text('Checkout'),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: AppColors.whiteColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Other',
                              style: nunitoStyle.copyWith(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.titleTxtColor),
                            ),
                            Column(
                              children: [
                                const SizedBox(height: 10),
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
                          borderRadius: BorderRadius.circular(12.0),
                          color: AppColors.whiteColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Additional Notes',
                                  style: nunitoStyle.copyWith(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.titleTxtColor),
                                ),
                              ],
                            ),
                            Container(
                              height: 100.0,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: TextFormField(
                                maxLines: 20,
                                style: nunitoStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.titleTxtColor,
                                    fontSize: 14.0),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.only(top: 16.0),
                                    hintText:
                                        'Please provide us with any specific instruction which should be followed by us.',
                                    hintStyle: ralewayStyle.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textColor,
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
                          color: AppColors.whiteColor,
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
                                  'Service Cost',
                                  style: nunitoStyle.copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor),
                                ),

                                Text(
                                  '₹.500/-',
                                  style: nunitoStyle.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Delivery',
                                      style: nunitoStyle.copyWith(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textColor),
                                    ),
                                    
                                    Text(
                                      'Free delivery for orders above ₹.500/- 😊',
                                      style: nunitoStyle.copyWith(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.normal,
                                          color: AppColors.textColor),
                                    ),
                                  ],
                                ),

                                Text(
                                  '₹.50/-',
                                  style: nunitoStyle.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor),
                                ),
                              ],
                            ),
                          SizedBox(height: 10.0,),
                          const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(
                            color: AppColors.textColor,
                            height: 0.1,
                            thickness: 0.1,
                          ),
                        ),
                        Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: nunitoStyle.copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor),
                                ),

                                Text(
                                  '₹.550/-',
                                  style: nunitoStyle.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.blueColor),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: AppColors.blueColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                          child: Text(
                            'Pay Now',
                            style: ralewayStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteColor,
                                fontSize: 18.0),
                          ),
                        ))
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
