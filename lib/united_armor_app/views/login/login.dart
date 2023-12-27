import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/gym_app/common_widgets/round_gradient_button.dart';
import 'package:vff_group/gym_app/common_widgets/round_textfield.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/notification_services.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/rounded_button.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;
import 'package:vff_group/utils/SharedPreferencesUtils.dart';

class LoginClothingScreen extends StatefulWidget {
  const LoginClothingScreen({super.key});

  @override
  State<LoginClothingScreen> createState() => _LoginClothingScreenState();
}

class _LoginClothingScreenState extends State<LoginClothingScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  TextEditingController mobileNoController = TextEditingController();
  bool passwordToggle = true, showLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    FocusManager.instance.primaryFocus?.unfocus();
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
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Column(
                children: [
                  SizedBox(
                    width: media.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: media.width * 0.03,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Hello again,",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: media.width * 0.01),
                        Row(
                          children: [
                            const Text(
                              "Welcome Back",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 20,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  Image.asset('assets/images/login_clothing.jpg'),

                  SizedBox(height: media.width * 0.05),

                  RoundTextField(
                      textEditingController: emailController,
                      hintText: "Email",
                      icon: "assets/icons/message_icon.png",
                      textInputType: TextInputType.emailAddress),
                  SizedBox(height: media.width * 0.05),
                  RoundTextField(
                    textEditingController: mobileNoController,
                    hintText: "Mobile Number",
                    icon: "assets/icons/telephone.png",
                    textInputType: TextInputType.phone,
                  ),
                  SizedBox(height: media.width * 0.03),
            
                  
                  // const Text("Forgot your password?",
                  //     style: TextStyle(
                  //       color: AppColors.grayColor,
                  //       fontSize: 10,
                  //     )),
                  showLoading
                      ? CircularProgressIndicator()
                      : RoundDarkButton(
                          title: "Login",
                          onPressed: () {
                            var email = emailController.text.trim();
                            if (email.isEmpty) {
                              glb.showSnackBar(context, 'Error',
                                  'Please provide us your email');
                              return;
                            }
                            var mobno = mobileNoController.text.trim();
                            if (mobno.isEmpty) {
                              glb.showSnackBar(context, 'Error',
                                  'Please provide us your registered mobile number');
                              return;
                            }
                            loginAsync(email, mobno);
                            //Navigator.pushNamed(context, ClothingCompleteProfileRoute);
                          },
                        ),
                  SizedBox(height: media.width * 0.01),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        width: double.maxFinite,
                        height: 1,
                        color: AppColors.grayColor.withOpacity(0.5),
                      )),
                      Text("  Or  ",
                          style: TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400)),
                      Expanded(
                          child: Container(
                        width: double.maxFinite,
                        height: 1,
                        color: AppColors.grayColor.withOpacity(0.5),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ClothingRegisterRoute);
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                            children: [
                              const TextSpan(
                                text: "Don’t have an account yet? ",
                              ),
                              TextSpan(
                                  text: "Register",
                                  style: TextStyle(
                                      color: AppColors.secondaryColor1,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ]),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  
  }

  Future loginAsync(email, mobno) async {
    setState(() {
      showLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();

    try {
      var url = glb.endPointClothing;
      url += "login/"; // Route Name
      final Map dictMap = {
        'mobno': mobno,
        'email': email,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(dictMap),
      );

      if (response.statusCode == 200) {
        // Handle successful response here
        var res = response.body;
        if (res.contains("ErrorCode#2")) {
          glb.showSnackBar(context, 'Error',
              'You are not a Registered User.\nPlease Create a new Account.');
          setState(() {
            showLoading = false;
          });
          return;
        } else if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          setState(() {
            showLoading = false;
          });
          return;
        } else {
          try {
            Map<String, dynamic> loginClothingMap = json.decode(res);
            print("loginClothingMap:$loginClothingMap");
            var customer_id = loginClothingMap['customer_id'].toString();
            var customer_name = loginClothingMap['customer_name'].toString();
            var mobile_no = loginClothingMap['mobile_no'].toString();
            var email_id = loginClothingMap['email_id'].toString();
            var password = loginClothingMap['password'].toString();
            SharedPreferenceUtils.save_val("clothing_customer_id", customer_id);
            SharedPreferenceUtils.save_val(
                "clothing_customer_name", customer_name);
            SharedPreferenceUtils.save_val(
                "clothing_customer_mobile_no", mobile_no);
            SharedPreferenceUtils.save_val(
                "clothing_customer_email_id", email_id);
            SharedPreferenceUtils.save_val(
                "clothing_customer_password", password);

            Navigator.pushReplacementNamed(context, ClothingMainHomeRoute);

            setState(() {
              showLoading = false;
            });
            return;
          } catch (e) {
            print(e);
            return "Failed";
          }
        }
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
        setState(() {
          showLoading = false;
        });
      }
    } catch (e) {
      print(e);
      glb.handleErrors(e, context);
      setState(() {
        showLoading = false;
      });
      return;
    }
  }


}
