import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/widgets/toolbar_custom.dart';

class GoogleVerificationPage extends StatefulWidget {
  const GoogleVerificationPage({super.key});

  @override
  State<GoogleVerificationPage> createState() => _GoogleVerificationPageState();
}

class _GoogleVerificationPageState extends State<GoogleVerificationPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Number Verification',
            style: nunitoStyle.copyWith(
              color: AppColors.backColor,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: AppColors.secondaryBackColor,
        body: Container(
          width: width,
          height: height,
          child: Stack(
            children: [
              Positioned(
                top: 20,
                child: Container(
                  color: Colors.white,
                  height: height,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Hey Shaheed ,",
                            style: nunitoStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                                fontSize: 16.0, color: AppColors.backColor),
                          ),
                        ),
                        SizedBox(
                          height: width * 0.05,
                        ),
                         Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "You're almost in.\nPlease provide you phone number\n for verification purpose",
                            style: nunitoStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                                fontSize: 14.0, color: AppColors.backColor),
                          ),
                        ),
                        SizedBox(
                          height: width * 0.1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'ENTER VERIFICATION CODE',
                            style: nunitoStyle.copyWith(
                                fontSize: 12.0, color: AppColors.textColor),
                          ),
                        ),
                        SizedBox(
                          height: width * 0.02,
                        ),
                         Container(
                          height: 50.0,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.blue, // Border color
                              width: 0.2, // Border width
                            ),
                          ),
                          child: TextFormField(
                            style: nunitoStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.backColor,
                                fontSize: 14.0),
                            keyboardType: TextInputType.phone,
                            cursorColor: Colors.blue,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.phone,
                                    color: Colors.blue,
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.only(top: 16.0),
                                hintText: '+91-',
                                hintStyle: nunitoStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.backColor.withOpacity(0.5),
                                    fontSize: 12.0)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Text(
                            "We'll send verification codeon above given number",
                            style: nunitoStyle.copyWith(
                                fontSize: 10.0,
                                fontWeight: FontWeight.normal,
                                color: AppColors.textColor.withOpacity(0.5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              Positioned(
                bottom: kToolbarHeight,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, VerificationRoute);
                    },
                    child: Container(
                      width: width,
                      color: AppColors.buttonColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Continue',
                          style: nunitoStyle.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.whiteColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
