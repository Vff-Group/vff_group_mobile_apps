// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';
import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

class LoginScreenGym extends StatefulWidget {
  const LoginScreenGym({super.key});

  @override
  State<LoginScreenGym> createState() => _LoginScreenGymState();
}

class _LoginScreenGymState extends State<LoginScreenGym> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordToggle = true, showLoading = false;

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
                SizedBox(
                  width: media.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: media.width * 0.03,
                      ),
                      const Text(
                        "Hey there,",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: media.width * 0.01),
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
                      Image.asset(
                        'assets/images/detail_top.png',
                        height: media.width * 0.5,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: media.width * 0.05),
        
                RoundTextField(
                    textEditingController: emailController,
                    hintText: "Email",
                    icon: "assets/icons/message_icon.png",
                    textInputType: TextInputType.emailAddress),
                SizedBox(height: media.width * 0.05),
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
                SizedBox(height: media.width * 0.3),
                // const Text("Forgot your password?",
                //     style: TextStyle(
                //       color: AppColors.grayColor,
                //       fontSize: 10,
                //     )),
                // SizedBox(height: media.width*0.01),
                
               showLoading ? CircularProgressIndicator(color: AppColors.primaryColor1,)
                :RoundGradientButton(
                  title: "Login",
                  onPressed: () {
                    var email = emailController.text.trim();
                    var password = passwordController.text.trim();
                    if (email.isEmpty) {
                      glb.showSnackBar(
                          context, 'Alert', 'Please Provide Your Email ID');
                      return;
                    }
                    if (email.contains('@') == false) {
                      glb.showSnackBar(
                          context, 'Alert', 'Please Provide a Valid Email ID');
                      return;
                    }
                    if (password.isEmpty) {
                      glb.showSnackBar(
                          context, 'Alert', 'Please Provide Your Password');
                      return;
                    }
                    loginAsync(email,password);
                    //Navigator.pushNamed(context, CompleteProfileScreenRoute);
                  },
                ),
                SizedBox(height: media.width * 0.01),
        
                const SizedBox(
                  height: 20,
                ),
                // TextButton(
                //     onPressed: () {
                //       Navigator.pushNamed(context, SignupScreenRoute);
                //     },
                //     child: RichText(
                //       textAlign: TextAlign.center,
                //       text: TextSpan(
                //           style: TextStyle(
                //               color: AppColors.blackColor,
                //               fontSize: 14,
                //               fontWeight: FontWeight.w400),
                //           children: [
                //             const TextSpan(
                //               text: "Don’t have an account yet? ",
                //             ),
                //             TextSpan(
                //                 text: "Register",
                //                 style: TextStyle(
                //                     color: AppColors.secondaryColor1,
                //                     fontSize: 14,
                //                     fontWeight: FontWeight.w500)),
                //           ]),
                //     )),
              
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future loginAsync(email_id, password) async {
    setState(() {
      showLoading = true;
    });
    try {
      var url = glb.endPointGym;
      url += "login/"; // Route Name
      final Map dictMap = {
        'password': password,
        'email_id': email_id,
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
          glb.showSnackBar(context, 'Error', 'You are not registered');
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
            Map<String, dynamic> loginMap = json.decode(res);
            print("loginMap:$loginMap");
            var usrid = loginMap['usrid'].toString();
            var email_id = loginMap['email_id'].toString();
            var memberid = loginMap['memberid'].toString();
            var usrname = loginMap['usrname'].toString();
            var mobno = loginMap['mobno'].toString();
            var gymid = loginMap['gymid'].toString();
            SharedPreferenceUtils.save_val("gym_usrid", usrid);
            SharedPreferenceUtils.save_val("gym_email_id", email_id);
            SharedPreferenceUtils.save_val("memberid", memberid);
            SharedPreferenceUtils.save_val("gym_usrname", usrname);
            SharedPreferenceUtils.save_val("gym_mobno", mobno);
            SharedPreferenceUtils.save_val("gymid", gymid);
            Navigator.pushReplacementNamed(context, CompleteProfileScreenRoute);
            
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
