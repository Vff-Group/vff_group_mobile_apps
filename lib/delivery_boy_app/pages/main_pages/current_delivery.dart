import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/widgets/dotted_line.dart';
import 'package:vff_group/widgets/rating_bar.dart';

class CurrentDeliveryPage extends StatefulWidget {
  const CurrentDeliveryPage({super.key});

  @override
  State<CurrentDeliveryPage> createState() => _CurrentDeliveryPageState();
}

class _CurrentDeliveryPageState extends State<CurrentDeliveryPage> {
  bool isOrderDelivered = false,
      isOrderPickup = false,
      isOrderProcessing = false;
  bool showData = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark
        ),
          actions: [
            InkWell(
              onTap: () {
                _showPopup(context, isOrderPickup, isOrderProcessing,
                    isOrderDelivered);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.update_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          title: Text(
            'CURRENT DELIVERY',
            style: ralewayStyle.copyWith(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: showData
            ? Center(
              child: Text(
                  'No Orders Assigned',
                  style: ralewayStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: AppColors.whiteColor),
                ),
            )
            : Visibility(
                visible: true,
                child: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.lightBlackColor,
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              color: Colors.deepOrange,
                                              borderRadius:
                                                  BorderRadius.circular(25.0)),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Order Recieved',
                                            style: ralewayStyle.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.whiteColor),
                                          ),
                                          const SizedBox(
                                            height: 2.0,
                                          ),
                                          Text(
                                            '10:30 AM',
                                            style: nunitoStyle.copyWith(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12.0,
                                                color: AppColors.whiteColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                FadeAnimation(
                                  delay: 0.5,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 28),
                                    child: DottedVerticalLine(
                                      height: 30.0,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.lightBlackColor,
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      child: const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Icon(
                                            Icons.pin_drop_rounded,
                                            color: Colors.deepPurple,
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Pickup',
                                            style: ralewayStyle.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.whiteColor),
                                          ),
                                          const SizedBox(
                                            height: 2.0,
                                          ),
                                          Text(
                                            '10:30 AM',
                                            style: nunitoStyle.copyWith(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12.0,
                                                color: AppColors.whiteColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                FadeAnimation(
                                  delay: 1,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 28),
                                    child: DottedVerticalLine(
                                      height: 30.0,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.lightBlackColor,
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      child: const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Icon(
                                            Icons.local_laundry_service,
                                            color: Colors.blue,
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Processing',
                                            style: ralewayStyle.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.whiteColor),
                                          ),
                                          const SizedBox(
                                            height: 2.0,
                                          ),
                                          Text(
                                            '10:30 AM',
                                            style: nunitoStyle.copyWith(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12.0,
                                                color: AppColors.whiteColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                FadeAnimation(
                                  delay: 1.5,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 28),
                                    child: DottedVerticalLine(
                                      height: 30.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.lightBlackColor,
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      child: const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Icon(
                                            Icons.delivery_dining_sharp,
                                            color: Colors.green,
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Order Delivered',
                                            style: ralewayStyle.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.whiteColor),
                                          ),
                                          const SizedBox(
                                            height: 2.0,
                                          ),
                                          Text(
                                            '01:30 PM',
                                            style: nunitoStyle.copyWith(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12.0,
                                                color: AppColors.whiteColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )),
                    Positioned(
                      bottom: 100,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 200,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.green,
                            Colors.blue
                          ]),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(26.0),
                              topRight: Radius.circular(26.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            child: Image.network(
                                              'https://media.istockphoto.com/id/1369503274/photo/delivery-boy-on-scooter-seraching-for-address-by-asking-with-customer-on-mobile-phone-concept.jpg?s=612x612&w=0&k=20&c=7z9m8OoW5Hkuyy6toBWqRnRJ4k7UhuK07I0gi-mRdDQ=',
                                              fit: BoxFit.fill,
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: width - 200,
                                              child: Text(
                                                'Rohit ',
                                                style: ralewayStyle.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              'Delivery Boy',
                                              style: ralewayStyle.copyWith(
                                                  color: Colors.white60,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14.0),
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: 10,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: 10,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: 10,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: 10,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        color: Colors.orange),
                                    child: const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.lightBlackColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(26.0),
                              topRight: Radius.circular(26.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        color: Colors.orange[50]),
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Icon(
                                        Icons.location_city,
                                        color: Colors.orange,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Address',
                                          style: ralewayStyle.copyWith(
                                              fontSize: 12.0,
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        SizedBox(
                                          width: width - 100,
                                          child: Text(
                                            'New Vaibhav Nagar ,6th cross Belgaum',
                                            style: ralewayStyle.copyWith(
                                                fontSize: 14.0,
                                                color: AppColors.whiteColor,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        color: Colors.green[50]),
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Icon(
                                        Icons.watch_later_outlined,
                                        color: Colors.green,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Delivery Start Time',
                                          style: ralewayStyle.copyWith(
                                              fontSize: 12.0,
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          '12:35 AM',
                                          style: nunitoStyle.copyWith(
                                              fontSize: 14.0,
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        color: Colors.pink[50]),
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Icon(
                                        Icons.location_city,
                                        color: Colors.pink,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Order ID ',
                                          style: ralewayStyle.copyWith(
                                              fontSize: 12.0,
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(
                                          '#1234',
                                          style: nunitoStyle.copyWith(
                                              fontSize: 14.0,
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ));
  }

  void _showPopup(BuildContext context, bool isOrderPickup,
      bool isOrderProcessing, bool isOrderDelivered) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: 450,
                width: 200,
                child: Column(
                  children: [
                    Text(
                      'Update Order Status',
                      style: ralewayStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: AppColors.whiteColor),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Radio(
                                      value: true,
                                      groupValue: true,
                                      onChanged: (value) {
                                        // Implement radio button selection logic here
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order Recieved',
                                        style: ralewayStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.whiteColor),
                                      ),
                                      const SizedBox(
                                        height: 2.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            FadeAnimation(
                              delay: 0.5,
                              child: Container(
                                padding: const EdgeInsets.only(left: 25),
                                child: DottedVerticalLine(
                                  height: 30.0,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.deepPurple[50],
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Radio(
                                      activeColor: Colors.deepPurple,
                                      toggleable: true,
                                      value: isOrderPickup,
                                      groupValue: true,
                                      onChanged: (value) {
                                        // Implement radio button selection logic here
                                        setState(() {
                                          isOrderPickup = !isOrderPickup;
                                          isOrderProcessing = false;
                                          isOrderDelivered = false;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pickup',
                                        style: ralewayStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.whiteColor),
                                      ),
                                      const SizedBox(
                                        height: 2.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            FadeAnimation(
                              delay: 1,
                              child: Container(
                                padding: const EdgeInsets.only(left: 25),
                                child: DottedVerticalLine(
                                  height: 30.0,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Radio(
                                      toggleable: true,
                                      value: isOrderProcessing,
                                      groupValue: true,
                                      onChanged: (value) {
                                        // Implement radio button selection logic here
                                        setState(() {
                                          isOrderProcessing =
                                              !isOrderProcessing;
                                          if (isOrderPickup == false) {
                                            isOrderProcessing = false;
                                          }
                                          isOrderDelivered = false;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Processing',
                                        style: ralewayStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.whiteColor),
                                      ),
                                      const SizedBox(
                                        height: 2.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            FadeAnimation(
                              delay: 1.5,
                              child: Container(
                                padding: const EdgeInsets.only(left: 25),
                                child: DottedVerticalLine(
                                  height: 30.0,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Radio(
                                      toggleable: true,
                                      value: isOrderDelivered,
                                      groupValue: true,
                                      onChanged: (value) {
                                        // Implement radio button selection logic here
                                        setState(() {
                                          isOrderDelivered = !isOrderDelivered;
                                          if (isOrderProcessing == false ||
                                              isOrderPickup == false) {
                                            isOrderDelivered = false;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order Delivered',
                                        style: ralewayStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.whiteColor),
                                      ),
                                      const SizedBox(
                                        height: 2.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SlideFromBottomAnimation(
                              delay: 0.5,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12.0),
                                      onTap: () {},
                                      child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: Colors.deepOrange),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            'Update Status',
                                            style: ralewayStyle.copyWith(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
