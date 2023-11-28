// ignore_for_file: unused_local_variable, use_build_context_synchronously, non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/rotate_animation.dart';
import 'package:vff_group/animation/scale_and_revert_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/animation/slide_left_animation.dart';
import 'package:vff_group/animation/slideright_animation.dart';
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
  TextEditingController nameController = TextEditingController();
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
    return SafeArea(
      left: false,
      right: false,
      top: false,
      bottom: false,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                width: width,
                height: height,
                color: AppColors.loginBackColor,
                child: Stack(
                  children: [
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SlideFromLeftAnimation(
                          delay: 0.5,
                          child: Image.asset(
                            'assets/logo/logo.png',
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                    ),
                    // Positioned(
                    //   top: 260,
                    //   left: 0,
                    //   right: 0,
                    //   child: SlideFromRightAnimation(
                    //     delay: 1,
                    //     child: Text(
                    //       'Ve7Vet Wash',
                    //       style: nunitoStyle.copyWith(
                    //           color: AppColors.backColor,
                    //           fontSize: 22,
                    //           letterSpacing: 2,
                    //           fontWeight: FontWeight.bold,
                    //           decoration: TextDecoration.none),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      top: 260,
                      child: Container(
                          color: AppColors.whiteColor,
                          width: width,
                          height: 50,
                          child: Material(
                            child: TextFormField(
                              controller: nameController,
                              style: nunitoStyle.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.backColor,
                                  fontSize: 14.0),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.person,
                                      color: AppColors.blueColor,
                                    ),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(top: 16.0),
                                  hintText: 'Display Name',
                                  hintStyle: nunitoStyle.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color:
                                          AppColors.blueColor.withOpacity(0.5),
                                      fontSize: 12.0)),
                            ),
                          )),
                    ),
                    Positioned(
                      top: 320,
                      child: Container(
                        width: width,
                        height: 50,
                        color: AppColors.whiteColor,
                      ),
                    ),

                    Positioned(
                      top: 330,
                      right: 10,
                      child: Material(
                        child: InkWell(
                          onTap: () {
                            // Navigator.pushNamed(context, RegistationRoute);
                            var phoneNo = phoneController.text.trim();
                            var name = nameController.text.trim();
                            if (name.isEmpty) {
                              glb.showSnackBar(context, 'Alert',
                                  'Please provide the Display Name first');
                              return;
                            }
                            if (phoneNo.isEmpty) {
                              glb.showSnackBar(context, 'Alert',
                                  'Please provide your valid mobile number');
                              return;
                            }
                            if(phoneNo.length < 10 || phoneNo.length > 10){
                              glb.showSnackBar(context, 'Alert',
                                  'Please provide your valid 10 Digits mobile number.\nThank You');
                              return;
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              showLoading = true;
                            });
                            typeLogin = '';//
                            loginAsync(phoneNo,name);
                          },
                          borderRadius: BorderRadius.circular(26.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26.0),
                              color: AppColors.buttonColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  'Continue',
                                  style: nunitoStyle.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.whiteColor,
                                      fontSize: 12.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 320,
                      child: Container(
                          color: AppColors.whiteColor,
                          width: width - 100,
                          height: 50,
                          child: Material(
                            child: TextFormField(
                              controller: phoneController,
                              style: nunitoStyle.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.backColor,
                                  fontSize: 14.0),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.phone,
                                      color: AppColors.blueColor,
                                    ),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(top: 16.0),
                                  hintText: 'Mobile Number',
                                  hintStyle: nunitoStyle.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color:
                                          AppColors.blueColor.withOpacity(0.5),
                                      fontSize: 12.0)),
                            ),
                          )),
                    ),
                    showLoading
                        ? Positioned(
                            top: 380,
                            left: 0,
                            right: 0,
                            child: LinearProgressIndicator())
                        : Visibility(
                          visible: false,
                          child: Positioned(
                              top: 390,
                              left: 0,
                              right: 0,
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  'Or',
                                  style: nunitoStyle.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.backColor,
                                      fontSize: 16.0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ),

                    Positioned(
                      top: 420,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            var phoneNo = phoneController.text.trim();
                            var name = nameController.text.trim();
                            // if (name.isEmpty) {
                            //   glb.showSnackBar(context, 'Alert',
                            //       'Please provide the Display Name first');
                            //   return;
                            // }
                            if (phoneNo.isEmpty) {
                              glb.showSnackBar(context, 'Alert',
                                  'Please provide your valid mobile number to provide you better service even if you are using Google Sign In.');
                              return;
                            }
                            if(phoneNo.length < 10 || phoneNo.length > 10){
                              glb.showSnackBar(context, 'Alert',
                                  'Please provide your valid 10 Digits mobile number.\nThank You');
                              return;
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              showLoading = true;
                            });
                            typeLogin = 'Google';
                            loginAsync(phoneNo,name);
                            //Navigator.pushNamed(context, GoogleVerificationRoute);
                          },
                          child: Container(
                            width: width,
                            height: 60,
                            color: Colors.white,
                            child: Material(
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/logo/google.png',
                                        height: 30,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        'Continue with',
                                        style: nunitoStyle.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: AppColors.backColor,
                                            fontSize: 16.0),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        ' Google',
                                        style: nunitoStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.backColor,
                                            fontSize: 16.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 500,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            var phoneNo = phoneController.text.trim();
                            var name = nameController.text.trim();
                            if (name.isEmpty) {
                              glb.showSnackBar(context, 'Alert',
                                  'Please provide the Display Name first to have Correct Name By which we can address you');
                              return;
                            }
                            if (phoneNo.isEmpty) {
                              glb.showSnackBar(context, 'Alert',
                                  'Please provide your valid mobile number to provide you a better service. Even though you are using Apple ID to Login.\nThank You');
                              return;
                            }
                            if(phoneNo.length < 10 || phoneNo.length > 10){
                              glb.showSnackBar(context, 'Alert',
                                  'Please provide your valid 10 Digits mobile number.\nThank You');
                              return;
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              showLoading = true;
                            });
                            typeLogin = 'Apple';
                            loginAsync(phoneNo,name);
                            //Navigator.pushNamed(context, GoogleVerificationRoute);
                          },
                          child: Container(
                            width: width,
                            height: 60,
                            color: Colors.white,
                            child: Material(
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/logo/apple_logo.png',
                                        height: 30,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        'Continue with',
                                        style: nunitoStyle.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: AppColors.backColor,
                                            fontSize: 16.0),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        ' Apple ID',
                                        style: nunitoStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.backColor,
                                            fontSize: 16.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 540,
                      child: Image.asset(
                        'assets/images/login_illustration.png',
                        width: width,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String typeLogin = '';
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

  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(appleProvider);
  }

  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await googleSignIn.signIn();

    final googleAuth = await googleUser!.authentication;

    final credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credentials);
  }

  Future loginAsync(String phoneNo,String displayName) async {
    var emailStr = '';
    var name = '';
    var photoUrl = 'https://vff-group.com/static/img/demouser.jpeg';
    setState(() {
      showLoading = true;
    });

    try {
       //For Demo Login Purpose
      if (phoneNo == "8000000000") {
        name = 'demo';
        emailStr = 'demo@gmail.com';
        photoUrl =
            "https://vff-group.com/static/img/demouser.jpeg";
      }else{
        if (typeLogin == 'Google') {
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

        emailStr = _user!.email;
        name = _user!.displayName!;
        photoUrl = _user!.photoUrl!;
        if (name == null || name.isEmpty || name == 'None') {
          setState(() {
            showLoading = false;
          });
          glb.showSnackBar(context, 'Invalid Credentials',
              'Please login using your valid Email ID');
          return;
        }
        print(name);
        print(emailStr);
        print(photoUrl);
      }else if(typeLogin == 'Apple'){
        var auth = await signInWithApple();
        if (auth.user == null){
          setState(() {
            showLoading = false;
          });
          glb.showSnackBar(context, 'Invalid Credentials',
              'Please login using your valid Apple ID');
          return;
        }

        if (auth.user!= null){
          print('auth.user::${auth.user}');
          name = displayName;
          emailStr = "appleid@icloud.com";
          photoUrl = "https://vff-group.com/static/img/demouser.jpeg";
        }
      }
      }
      
     

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
            SharedPreferenceUtils.save_val('umobno', phoneNo);
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
