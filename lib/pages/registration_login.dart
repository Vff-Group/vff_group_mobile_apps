import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/widgets/toolbar_custom.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

class RegistrationLoginPage extends StatefulWidget {
  const RegistrationLoginPage({super.key});

  @override
  State<RegistrationLoginPage> createState() => _RegistrationLoginPageState();
}

class _RegistrationLoginPageState extends State<RegistrationLoginPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  bool showLoading = false;

  Future<void> _OpenBrowser(String url) async {
    final Uri launchUri = Uri.parse(url);
    try {
      await launchUrl(launchUri);
    } catch (e) {
      glb.showSnackBar(context, 'Alert', 'Currently under maintenance');
      print(e);
    }
  }

  RegExp mobileNumberPattern = RegExp(r'^[0-9]{10}$');
  bool isMobileNumberValid(String input) {
    return mobileNumberPattern.hasMatch(input);
  }

  Future loginAsync(String phoneNo,emailStr,name) async {

    setState(() {
      showLoading = true;
    });
    try {
      var url = glb.endPoint;
      url+="login/";
      final Map dictMap = {};
      // dictMap['mobno'] = "+91$phoneNo";
      dictMap['mobno'] = phoneNo;
      dictMap['email_id'] = emailStr;
      dictMap['usrname'] = name;
      dictMap['user_token'] = 'abcd';
      dictMap['lat'] = 0;
      dictMap['lng'] = 0;
      dictMap['profile_img'] = "NA";
      // dictMap['pktType'] = "1";
      // dictMap['token'] = "vff";
      // dictMap['uid'] = "-1";

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            "Accept": "application/json",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(dictMap));

      if (response.statusCode == 200) {
        var res = response.body;
        if (res.contains("ErrorCode#2")) {
          // Navigator.pop(context);
          glb.showSnackBar(context, 'Error', 'You are not registered');
          return;
        } else if (res.contains("ErrorCode#8")) {
          //Navigator.pop(context);
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> userMap = json.decode(response.body);
            print("userMap:$userMap");
            var usrid = userMap['usrid'];
            var usrname = userMap['usrname'];
            var customer_id = userMap['customer_id'];
            var gender = userMap['gender'];
            var user_token = userMap['user_token'];
            var created_at = userMap['created_at'];
            var profile_img = userMap['profile_img'];
            var email = userMap['email'];

            print("profile_img_url::$profile_img");
            SharedPreferenceUtils.save_val('usrid', usrid);
            SharedPreferenceUtils.save_val('usrname', usrname);
            SharedPreferenceUtils.save_val('customerid', customer_id);
            //SharedPreferenceUtils.save_val('notificationToken', user_token);
            SharedPreferenceUtils.save_val('profile_img', profile_img);
            SharedPreferenceUtils.save_val('email', email);
            glb.profileImage = profile_img;
            glb.usrid = usrid;
            // List<String> usridLst = glb.strToLst2(usrid);
            // List<String> usrNameLst = glb.strToLst2(usrname);
            SharedPreferenceUtils.save_val("notificationToken", "");
            Navigator.pushReplacementNamed(context, MainRoute);
          } catch (e) {
            print(e);
            return "Failed";
          }
        }
      }
    } catch (e) {
      print(e);
      //Navigator.pop(context);
      glb.handleErrors(e, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Register',
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
                            'FULL NAME',
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
                            controller: fullNameController,
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
                                    Icons.person_3,
                                    color: Colors.blue,
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.only(top: 16.0),
                                hintText: 'Enter Full Name',
                                hintStyle: nunitoStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.backColor.withOpacity(0.5),
                                    fontSize: 12.0)),
                          ),
                        ),
                        SizedBox(
                          height: width * 0.05,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'EMAIL ADDRESS',
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
                            controller: emailController,
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
                                    Icons.email,
                                    color: Colors.blue,
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.only(top: 16.0),
                                hintText: 'name@example.com',
                                hintStyle: nunitoStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.backColor.withOpacity(0.5),
                                    fontSize: 12.0)),
                          ),
                        ),
                        SizedBox(
                          height: width * 0.05,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'PHONE NUMBER',
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
                            controller: mobileNoController,
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
                child: InkWell(
                  onTap: () {
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
            ],
          ),
        ));
  }
}
