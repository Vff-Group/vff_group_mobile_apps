import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;
import 'package:vff_group/gym_app/common_widgets/round_gradient_button.dart';
import 'package:vff_group/gym_app/common_widgets/round_textfield.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/notification_services.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/rounded_button.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';

import '../../../gym_app/common_widgets/round_date_chooser.dart';

class CompleteClothingProfilePage extends StatefulWidget {
  const CompleteClothingProfilePage({super.key});

  @override
  State<CompleteClothingProfilePage> createState() =>
      _CompleteClothingProfilePageState();
}

class _CompleteClothingProfilePageState
    extends State<CompleteClothingProfilePage> {
  String deviceToken = "";
  bool showLoading = false;
  NotificationServices notificationServices = NotificationServices();
  TextEditingController userNameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();

  void getDefaultData() async {
    notificationServices.requestNotificationPermissions();
    notificationServices.foregroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefreshedClothingApp();

    glb.prefs = await SharedPreferences.getInstance();
    var notificationToken =
        glb.prefs?.getString('clothingAPPNotificationToken');
    print('clothingNotificationToken::$notificationToken');
    if (notificationToken == null || notificationToken.isEmpty) {
      notificationServices.getDeviceToken().then((value) => {
            deviceToken = value.toString().replaceAll(':', '__colon__'),
            SharedPreferenceUtils.save_val(
                'clothingAPPNotificationToken', deviceToken),
            print('DeviceToken:$value')
          });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDefaultData();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: Column(
              children: [
                SvgPicture.asset('assets/images/profile_complete.svg'),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Let’s complete your profile",
                  style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 5),
                Text(
                  "It will help us to know more about you!",
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 12,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 25),
                RoundTextField(
                  textEditingController: userNameController,
                  hintText: "Enter Your Name",
                  icon: "assets/icons/user_icon.png",
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 15),
                RoundTextField(
                  textEditingController: mobileNoController,
                  hintText: "Enter Your Mobile Number",
                  icon: "assets/icons/phone_call.png",
                  textInputType: TextInputType.phone,
                ),
                SizedBox(height: 105),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: showLoading
          ? CircularProgressIndicator()
          : RoundDarkButton(
              title: "Get Started",
              onPressed: () {
                var name = userNameController.text.trim();
                if (name.isEmpty) {
                  glb.showSnackBar(
                      context, 'Error', 'Please provide us your name');
                  return;
                }
                var mobile_no = mobileNoController.text.trim();
                if (mobile_no.isEmpty) {
                  glb.showSnackBar(
                      context, 'Error', 'Please provide us your mobile number');
                  return;
                }
              
                
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }


}
