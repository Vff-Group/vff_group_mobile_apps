import 'package:flutter/material.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/widgets/custom_radio_btn.dart';
import 'package:vff_group/global/vffglb.dart' as glb;

class PlaceOrderPage extends StatefulWidget {
  final Function(String) updateQuantity;
  final String catId;

  const PlaceOrderPage(
      {super.key, required this.updateQuantity, required this.catId});

  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  bool _isColorColthes = false,
      _isColorWhite = false,
      _dryHeaterOnly = false,
      _scentedDetergentOnly = false,
      _useSoftnerOnly = false;
  TextEditingController quantityController = TextEditingController();
  List<String> items = ['Regular', 'Express', 'Offer'];
  String selectedItem = 'Regular'; // Initialize with a default value
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantityController.text = widget.catId;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Add Quantity in Kgs',
                                  style: nunitoStyle.copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.whiteColor),
                                ),
                                // InkWell(
                                //   onTap: () {
                                //     print('Add item to cart');
                                //   },
                                //   child: Text(
                                //     'Add to cart',
                                //     style: nunitoStyle.copyWith(
                                //         fontSize: 16.0,
                                //         fontWeight: FontWeight.bold,
                                //         color: AppColors.blueColor),
                                //   ),
                                // ),
                             
                              ],
                            ),
                            SizedBox(
                              height: width * 0.03,
                            ),
                            Container(
                              height: 50.0,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: AppColors.whiteColor, // Border color
                                  width: 0.2, // Border width
                                ),
                              ),
                              child: TextFormField(
                                controller: quantityController,
                                style: nunitoStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.whiteColor,
                                    fontSize: 14.0),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  // Update the quantity value as the user types
                                  widget.updateQuantity(value);
                                  // You can perform actions based on the updated value here
                                  print('Quantity changed to: $value');
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.local_laundry_service,color: Colors.white,),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.only(top: 16.0),
                                    hintText: 'Quantity in Kgs',
                                    hintStyle: ralewayStyle.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.whiteColor
                                            .withOpacity(0.5),
                                        fontSize: 12.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Laundry Type',
                                  style: nunitoStyle.copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.whiteColor),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: width * 0.03,
                            ),
                            Container(
                              height: 50.0,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: DropdownButton<String>(
                                dropdownColor: AppColors.lightBlackColor,
                                value: selectedItem,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedItem = newValue!;
                                  });
                                },
                                items: items.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            width: width - 80,
                                            child: Text(item,style: ralewayStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.whiteColor
                                            ),)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                
                      // const SizedBox(
                      //   height: 10.0,
                      // ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(12.0),
                      //       color: AppColors.whiteColor),
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         vertical: 20.0, horizontal: 12.0),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           'Color Preferences',
                      //           style: nunitoStyle.copyWith(
                      //               fontSize: 20.0,
                      //               fontWeight: FontWeight.bold,
                      //               color: AppColors.titleTxtColor),
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             children: [
                      //               CustomRadioButton(
                      //                 label: 'Color Clothes',
                      //                 isSelected:
                      //                     _isColorColthes, // Set to true for the selected option
                      //                 onChanged: (selected) {
                      //                   // Handle option 1 selection
                      //                   setState(() {
                      //                     _isColorColthes = true;
                      //                     _isColorWhite = false;
                      //                   });
                      //                 },
                      //               ),
                      //               const SizedBox(
                      //                   width:
                      //                       20), // Add some spacing between the radio buttons
                      //               CustomRadioButton(
                      //                 label: 'White Clothes',
                      //                 isSelected:
                      //                     _isColorWhite, // Set to true for the selected option
                      //                 onChanged: (selected) {
                      //                   setState(() {
                      //                     _isColorWhite = true;
                      //                     _isColorColthes = false;
                      //                   });
                      //                 },
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                
                      // const SizedBox(
                      //   height: 10.0,
                      // ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(12.0),
                      //       color: AppColors.whiteColor),
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         vertical: 20.0, horizontal: 12.0),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           'Other',
                      //           style: nunitoStyle.copyWith(
                      //               fontSize: 20.0,
                      //               fontWeight: FontWeight.bold,
                      //               color: AppColors.titleTxtColor),
                      //         ),
                      //         Column(
                      //           children: [
                      //             const SizedBox(height: 10),
                      //             CustomRadioButton(
                      //               label: 'Dry Heater',
                      //               isSelected:
                      //                   _dryHeaterOnly, // Set to true for the selected option
                      //               onChanged: (selected) {
                      //                 if (selected == true) {
                      //                   setState(() {
                      //                     _dryHeaterOnly = true;
                      //                   });
                      //                 } else {
                      //                   setState(() {
                      //                     _dryHeaterOnly = false;
                      //                   });
                      //                 }
                      //               },
                      //             ),
                      //             const SizedBox(
                      //                 height:
                      //                     10), // Add some spacing between the radio buttons
                      //             CustomRadioButton(
                      //               label: 'Scented Detergent',
                      //               isSelected:
                      //                   _scentedDetergentOnly, // Set to true for the selected option
                      //               onChanged: (selected) {
                      //                 if (selected == true) {
                      //                   setState(() {
                      //                     _scentedDetergentOnly = true;
                      //                   });
                      //                 } else {
                      //                   setState(() {
                      //                     _scentedDetergentOnly = false;
                      //                   });
                      //                 }
                      //               },
                      //             ),
                      //             const SizedBox(
                      //                 height:
                      //                     10), // Add some spacing between the radio buttons
                      //             CustomRadioButton(
                      //               label: 'Use Softner',
                      //               isSelected:
                      //                   _useSoftnerOnly, // Set to true for the selected option
                      //               onChanged: (selected) {
                      //                 if (selected == true) {
                      //                   setState(() {
                      //                     _useSoftnerOnly = true;
                      //                   });
                      //                 } else {
                      //                   setState(() {
                      //                     _useSoftnerOnly = false;
                      //                   });
                      //                 }
                      //               },
                      //             ),
                      //           ],
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                
                      // const SizedBox(
                      //   height: 10.0,
                      // ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(12.0),
                      //       color: AppColors.whiteColor),
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         vertical: 20.0, horizontal: 12.0),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Row(
                      //           children: [
                      //             Text(
                      //               'Additional Notes',
                      //               style: nunitoStyle.copyWith(
                      //                   fontSize: 20.0,
                      //                   fontWeight: FontWeight.bold,
                      //                   color: AppColors.titleTxtColor),
                      //             ),
                      //           ],
                      //         ),
                      //         Container(
                      //           height: 100.0,
                      //           width: width,
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(8.0),
                      //           ),
                      //           child: TextFormField(
                      //             maxLines: 20,
                      //             style: nunitoStyle.copyWith(
                      //                 fontWeight: FontWeight.w400,
                      //                 color: AppColors.titleTxtColor,
                      //                 fontSize: 14.0),
                      //             keyboardType: TextInputType.text,
                      //             decoration: InputDecoration(
                      //                 border: InputBorder.none,
                      //                 contentPadding:
                      //                     const EdgeInsets.only(top: 16.0),
                      //                 hintText:
                      //                     'Please provide us with any specific instruction which should be followed by us.',
                      //                 hintStyle: ralewayStyle.copyWith(
                      //                     fontWeight: FontWeight.w400,
                      //                     color: AppColors.textColor,
                      //                     fontSize: 12.0)),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                
                      const SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
