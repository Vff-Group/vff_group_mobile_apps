import 'package:flutter/material.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class AllBookingSequencePage extends StatefulWidget {
  const AllBookingSequencePage({super.key});

  @override
  State<AllBookingSequencePage> createState() => _AllBookingSequencePageState();
}

class _AllBookingSequencePageState extends State<AllBookingSequencePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: FadeAnimation(
            delay: 0.3,
            child: Text('How Our System Works?',
                style: nunitoStyle.copyWith(
                    fontSize: 20.0,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1)),
          )),
      body: ListView.builder(
      itemCount: steps.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              title: Text(
                steps[index],
                style: ralewayStyle.copyWith(fontSize: 12.0),
              ),
            ),
            Divider(),
          ],
        );
      },
    ),
    floatingActionButton: Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AllBranchesRoute);
                  },
                  borderRadius: BorderRadius.circular(12.0),
                  child: Ink(
                    decoration: BoxDecoration(
                      // gradient: LinearGradient(colors: [
                      //   Colors.green,
                      //   Colors.blue,
                      // ]),
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 10.0),
                      child: Text(
                        'Book Now',
                        style: nunitoStyle.copyWith(
                            fontSize: 16.0,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,    
    );
  }

   final List<String> steps = [
    
    "Step 1: Booking Initiated: 🧺 Customer schedules laundry service. By Selecting the Branch and providing the Address.",
    "Step 2: Assignment to Delivery Personnel: 🚚 A delivery executive is assigned.",
    "Step 3: Pickup Processed: 📦 Laundry items are collected.",
    "Step 4: Service Duration Calculated: 💰 Pricing calculated based on item type and service duration.",
    "Step 5: Service Processing Initiated: 🔄 Laundry items begin the cleaning process.",
    "Step 6: Payment Mode Selection: 💳 Customer prompted for payment method (📱 UPI, 💳 Net Banking, etc.). For online payments, a payment request is forwarded to the registered UPI.",
    "Step 7: Payment Confirmation: ✅ After successful payment, the delivery personnel is dispatched with the customer's parcel.",
    "Step 8: Quality Verification and OTP: 🕵️‍♂️ Customer verifies laundry quality upon delivery. Delivery personnel generates and shares an OTP. Customer validates the laundry quality with the received OTP.",
    "Step 9: Delivery or Return: 🚪 Completed orders are delivered while a rare few might require a return.",
    
  ];
}