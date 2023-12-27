import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vff_group/gym_app/common_widgets/round_gradient_button.dart';
import 'package:vff_group/gym_app/common_widgets/round_textfield.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/common/footer_widget.dart';
import 'package:vff_group/united_armor_app/common/google_textfield_phone.dart';
import 'package:vff_group/united_armor_app/common/google_textformfield.dart';
import 'package:vff_group/united_armor_app/common/rounded_button.dart';
import 'package:vff_group/united_armor_app/common/size_config.dart';
import 'package:vff_group/utils/app_colors.dart' as AppColor2;

class ClothingDeliveryAddressPage extends StatefulWidget {
  const ClothingDeliveryAddressPage({super.key});

  @override
  State<ClothingDeliveryAddressPage> createState() =>
      _ClothingDeliveryAddressPageState();
}

class _ClothingDeliveryAddressPageState
    extends State<ClothingDeliveryAddressPage> {
  
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, CartItemsClothingRoute);
                },
                icon: SvgPicture.asset('assets/cart_icon_unselected.svg')),
          ],
          
          backgroundColor: kDarkBrown,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    // Navigator.pushNamed(context, ClothingMainHomeRoute);
                  },
                  icon: Image.asset(
                    "assets/logo/logo_united_armor.png",
                    fit: BoxFit.fitHeight,
                  )),
            ],
          )),
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
                              'Shipping',
                              style: kEncodeSansBold.copyWith(fontSize: 14.0),
                            ),
                            Text(
                              '1/2',
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
                          'Shipping Address',
                          style: kEncodeSansBold.copyWith(fontSize: 14.0),
                        ),
                        SizedBox(
                          height: media.width * 0.08,
                        ),
                        GoogleTextFormField(
                            textEditingController: fullNameController,
                            hintText: '',
                            textInputType: TextInputType.text,
                            labelText: "Full Name *"),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        GoogleTextFormFieldPhone(
                            textEditingController: mobileNoController,
                            hintText: '',
                            textInputType: TextInputType.phone,
                            labelText: "Mobile Number *"),
                        SizedBox(
                          height: media.width * 0.08,
                        ),
                        GoogleTextFormField(
                            textEditingController: pinCodeController,
                            hintText: '',
                            textInputType: TextInputType.text,
                            labelText: "Pin Code *"),
                        SizedBox(
                          height: media.width * 0.08,
                        ),
                        GoogleTextFormField(
                            textEditingController: addressOneController,
                            hintText: '',
                            textInputType: TextInputType.text,
                            labelText: "Address One *"),
                        SizedBox(
                          height: media.width * 0.08,
                        ),
                        GoogleTextFormField(
                            textEditingController: addressTwoController,
                            hintText: '',
                            textInputType: TextInputType.text,
                            labelText: "Address Two "),
                        SizedBox(
                          height: media.width * 0.08,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(
                              width: 0.8, // Adjust the border width here
                              color:
                                  Colors.grey, // Set the desired border color
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                color: kDarkBrown, // Text color
                                fontSize: 14,
                              ),
                              hint: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Choose State'),
                              ), // Placeholder text
                              value: selectedState, // Currently selected state
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedState =
                                      newValue; // Update selected state on change
                                });
                              },
                              items: [
                                for (String state in indianStates)
                                  DropdownMenuItem(
                                    value: state,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(state),
                                    ),
                                  ),
                              ],
                            ),
                          ),
),
                        SizedBox(
                          height: media.width * 0.08,
                        ),
                        GoogleTextFormField(
                            textEditingController: cityNameController,
                            hintText: '',
                            textInputType: TextInputType.text,
                            labelText: "City / District / Town *"),
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
                    Navigator.pushNamed(context, ClothingCheckoutPageRoute);
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
                            'Checkout',
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

TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController addressOneController = TextEditingController();
  TextEditingController addressTwoController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();
  String? selectedState;
  List<String> indianStates = [
    'Choose State',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

}
