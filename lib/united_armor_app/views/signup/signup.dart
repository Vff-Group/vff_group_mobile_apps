import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/gym_app/common_widgets/round_gradient_button.dart';
import 'package:vff_group/gym_app/common_widgets/round_textfield.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/rounded_button.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;
import 'package:vff_group/utils/SharedPreferencesUtils.dart';

class SignUpClothingScreen extends StatefulWidget {
  const SignUpClothingScreen({super.key});

  @override
  State<SignUpClothingScreen> createState() => _SignUpClothingScreenState();
}

class _SignUpClothingScreenState extends State<SignUpClothingScreen> {
  bool isCheck = false, passwordToggle = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                
                Text(
                  "Create an Account",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                RoundTextField(
                  textEditingController: userNameController,
                  hintText: "Full Name",
                  icon: "assets/icons/profile_icon.png",
                  textInputType: TextInputType.name,
                ),
                SizedBox(
                  height: 15,
                ),
                RoundTextField(
                    textEditingController: mobileNoController,
                    hintText: "Mobile Number",
                    icon: "assets/icons/telephone.png",
                    textInputType: TextInputType.phone),
                SizedBox(
                  height: 15,
                ),
                RoundTextField(
                    textEditingController: emailController,
                    hintText: "Email",
                    icon: "assets/icons/message_icon.png",
                    textInputType: TextInputType.emailAddress),
                SizedBox(
                  height: 15,
                ),
                RoundTextField(
                  textEditingController: passwordController,
                  hintText: "Password",
                  icon: "assets/icons/lock_icon.png",
                  textInputType: TextInputType.text,
                  isObscureText: passwordToggle,
                  rightIcon: TextButton(
                      onPressed: () {
                        setState(() {
                          if (passwordToggle) {
                            passwordToggle = false;
                          } else {
                            passwordToggle = true;
                          }
                        });
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: 20,
                          height: 20,
                          child: passwordToggle
                              ? Image.asset(
                                  "assets/icons/hide_pwd_icon.png",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                  color: AppColors.grayColor,
                                )
                              : Icon(
                                  Icons.remove_red_eye,
                                  color: AppColors.grayColor,
                                  size: 20,
                                ))),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isCheck = !isCheck;
                          });
                        },
                        icon: Icon(
                          isCheck
                              ? Icons.check_box_outline_blank_outlined
                              : Icons.check_box_outlined,
                          color: AppColors.grayColor,
                        )),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                            "By continuing you accept our Privacy Policy and\nTerm of Use",
                            style: TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 10,
                            )),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                showLoading
                    ? CircularProgressIndicator()
                    : RoundDarkButton(
                  title: "Register",
                  onPressed: () {
                          var name = userNameController.text.trim();
                          if (name.isEmpty) {
                            glb.showSnackBar(context, 'Error',
                                'Please provide us your name');
                            return;
                          }
                          var mobile_no = mobileNoController.text.trim();
                          if (mobile_no.isEmpty) {
                            glb.showSnackBar(context, 'Error',
                                'Please provide us your mobile number');
                            return;
                          }
                          var email = emailController.text.trim();
                          if (email.isEmpty) {
                            glb.showSnackBar(context, 'Error',
                                'Please provide us your email');
                            return;
                          }
                          var password = passwordController.text.trim();
                          if (password.isEmpty) {
                            glb.showSnackBar(
                                context, 'Error', 'Please provide password');
                            return;
                          }
                          registerAsync(email, mobile_no, name, password);
                    // Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
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
                SizedBox(
                  height: 20,
                ),
                
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, ClothingLoginRoute);
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
                              text: "Already have an account? ",
                            ),
                            TextSpan(
                                text: "Login",
                                style: TextStyle(
                                    color: AppColors.secondaryColor1,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800)),
                          ]),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
bool showLoading = false;
  Future registerAsync(email, mobno, customer_name, password) async {
    setState(() {
      showLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();

    try {
      var url = glb.endPointClothing;
      url += "register/"; // Route Name
      final Map dictMap = {
        'customer_name': customer_name,
        'mobno': mobno,
        'password': password,
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
        if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          setState(() {
            showLoading = false;
          });
          return;
        } else if (res.contains("Already")) {
          glb.showSnackBar(context, 'Error',
              'You are already registered user with this mobile number');
          setState(() {
            showLoading = false;
          });
          return;
        } else {
          try {
            Map<String, dynamic> registrationMap = json.decode(res);
            print("registrationMap:$registrationMap");

            var customer_id = registrationMap['customer_id'].toString();
            var customer_name = registrationMap['customer_name'].toString();
            var mobile_no = registrationMap['mobile_no'].toString();
            var email_id = registrationMap['email_id'].toString();
            var password = registrationMap['password'].toString();
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
