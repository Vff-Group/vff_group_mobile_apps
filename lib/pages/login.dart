// ignore_for_file: unused_local_variable, use_build_context_synchronously, non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/rotate_animation.dart';
import 'package:vff_group/animation/scale_and_revert_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/animation/slide_left_animation.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/utils/responsive_widget.dart';
import 'package:vff_group/widgets/textwidget.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  bool _showPassword = true, borderDanger = false;
  bool showLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: height * 0.05),
                  SizedBox(
                    width: width,
                    height: 200,
                    child: FadeAnimation(
                        delay: 0.1, child: Image.asset('assets/logo/logo.png')),
                  ),
                  Text(
                    'Please enter your valid Mobile Number',
                    style: nunitoStyle.copyWith(
                      color: AppColors.whiteColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.014,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(26.0),
                    child: Container(
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
                        controller: phoneController,
                        style: nunitoStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.whiteColor,
                            fontSize: 14.0),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(top: 16.0),
                            hintText: 'Mobile Number',
                            hintStyle: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.whiteColor.withOpacity(0.5),
                                fontSize: 12.0)),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: height * 0.04,
                  // ),
                  // Container(
                  //   height: 50.0,
                  //   width: width - 35.0,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(8.0),
                  //     border: borderDanger ? Border.all(
                  //       color: Colors.red, // Border color
                  //       width: 0.4, // Border width
                  //     ) :Border.all(
                  //       color: AppColors.textColor, // Border color
                  //       width: 0.2, // Border width
                  //     ),
                  //   ),
                  //   child: TextFormField(
                  //     controller: passwordController,
                  //     style: ralewayStyle.copyWith(
                  //         fontWeight: FontWeight.w400,
                  //         color: AppColors.titleTxtColor,
                  //         fontSize: 14.0),
                  //     keyboardType: TextInputType.text,
                  //     obscureText: _showPassword,
                  //     decoration: InputDecoration(
                  //         border: InputBorder.none,
                  //         suffixIcon: IconButton(
                  //             onPressed: () {
                  //               if (_showPassword == true) {
                  //                 setState(() {
                  //                   _showPassword = false;
                  //                 });
                  //               } else {
                  //                 setState(() {
                  //                   _showPassword = true;
                  //                 });
                  //               }
                  //             },
                  //             icon: _showPassword
                  //                 ? const Icon(Icons.remove_red_eye)
                  //                 : const Icon(Icons
                  //                     .no_encryption_gmailerrorred_outlined)),
                  //         prefixIcon: IconButton(
                  //           onPressed: () {},
                  //           icon: const Icon(Icons.security),
                  //         ),
                  //         contentPadding: const EdgeInsets.only(top: 16.0),
                  //         hintText: 'Password',
                  //         hintStyle: ralewayStyle.copyWith(
                  //             fontWeight: FontWeight.w400,
                  //             color: AppColors.textColor.withOpacity(0.5),
                  //             fontSize: 12.0)),
                  //   ),
                  // ),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //       onPressed: () {},
                  //       child: Text(
                  //         'Forgot Password?',
                  //         style: ralewayStyle.copyWith(
                  //           fontSize: 12.0,
                  //           color: AppColors.mainBlueColor,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       )),
                  // ),
                  FadeAnimation(
                    delay: 0.5,
                    child: Text(
                      'By clicking Continue, you agree to ',
                      style: nunitoStyle.copyWith(
                          fontSize: 14.0, fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  InkWell(
                    onTap: () {
                      print('Send to Privacy Policy Page');
                    },
                    child: FadeAnimation(
                      delay: 0.6,
                      child: Text(
                        'Terms and Conditions',
                        style: nunitoStyle.copyWith(
                            fontSize: 14.0,
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.06),
                  showLoading
                      ? CircularProgressIndicator()
                      : SlideFromBottomAnimation(
                          delay: 0.5,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                var phoneNo = phoneController.text.trim();
                                // var password = passwordController.text.trim();

                                if (phoneNo.isEmpty) {
                                  glb.showSnackBar(context, 'Alert!',
                                      'Please Provide Phone Number');
                                  return;
                                } else {
                                  loginAsync(phoneNo);
                                }
                              },
                              borderRadius: BorderRadius.circular(16.0),
                              child: Ink(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 70.0, vertical: 18.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    gradient: LinearGradient(colors: [
                                      Colors.green,
                                      Colors.blue,
                                    ])),
                                child: Text(
                                  'Continue',
                                  style: ralewayStyle.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.whiteColor,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future loginAsync(String phoneNo) async {
    setState(() {
      showLoading = true;
    });
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        glb.showSnackBar(context, 'Invalid Credentials',
            'Please login using your valid Email ID');
        setState(() {
          showLoading = false;
        });
        return;
      }
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credentials);

      var emailStr = _user!.email;
      var name = _user!.displayName;
      var photoUrl = _user!.photoUrl;

      print(name);
      print(emailStr);
      print(photoUrl);
      var url = glb.endPoint;
      final Map dictMap = {};
      // dictMap['mobno'] = "+91$phoneNo";
      dictMap['mobno'] = phoneNo;
      dictMap['email_id'] = emailStr;
      dictMap['usrname'] = name;
      dictMap['user_token'] = 'abcd';
      dictMap['lat'] = 0;
      dictMap['lng'] = 0;
      dictMap['profile_img'] = photoUrl;
      dictMap['pktType'] = "1";
      dictMap['token'] = "vff";
      dictMap['uid'] = "-1";

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
            glb.account_created_date = created_at;
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
}
