// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;
import 'package:vff_group/utils/SharedPreferencesUtils.dart';
import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isCheck = false, passwordToggle = true;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
String gymName = "Choose Gym Branch";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
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
                    "Hey there,",
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
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
                    textEditingController: firstNameController,
                    hintText: "First Name",
                    icon: "assets/icons/profile_icon.png",
                    textInputType: TextInputType.name,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RoundTextField(
                      textEditingController: lastNameController,
                      hintText: "Last Name",
                      icon: "assets/icons/profile_icon.png",
                      textInputType: TextInputType.name),
                  SizedBox(
                    height: 15,
                  ),
                  RoundTextField(
                      textEditingController: mobileNoController,
                      hintText: "Mobile Number",
                      icon: "assets/icons/incoming_call.png",
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
                   Container(
                  decoration: BoxDecoration(
                      color: AppColors.lightGrayColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Image.asset(
                            "assets/icons/gender_icon.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            color: AppColors.grayColor,
                          )),
                      Expanded(
                          child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: ["Male", "Female"]
                              .map((name) => DropdownMenuItem(
                                  value: name,
                                  child: Text(
                                    name,
                                    style: const TextStyle(
                                        color: AppColors.grayColor,
                                        fontSize: 14),
                                  )))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              if (value != null) {
                                gymName = value;
                              }
                            });
                          },
                          isExpanded: true,
                          hint: Text(gymName,
                              style: const TextStyle(
                                  color: AppColors.grayColor, fontSize: 16)),
                        ),
                      )),
                      SizedBox(
                        width: 8,
                      )
                    ],
                  ),
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
                        child: Text(
                            "By continuing you accept our Privacy Policy and\nTerm of Use",
                            style: TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 10,
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RoundGradientButton(
                    title: "Register",
                    onPressed: () {
                      var firstName = firstNameController.text.trim();
                      var lastName = lastNameController.text.trim();
                      var mobileno = mobileNoController.text.trim();
                      var email = emailController.text.trim();
                      var password = passwordController.text.trim();
                      if (firstName.isEmpty) {
                        glb.showSnackBar(
                            context, 'Alert', 'Please Provide Your First Name');
                        return;
                      }
                      if (lastName.isEmpty) {
                        glb.showSnackBar(
                            context, 'Alert', 'Please Provide Your Last Name');
                        return;
                      }
                      if (mobileno.isEmpty) {
                        glb.showSnackBar(context, 'Alert',
                            'Please Provide Your Mobile Number');
                        return;
                      }
                      if (email.isEmpty) {
                        glb.showSnackBar(
                            context, 'Alert', 'Please Provide Your Email ID');
                        return;
                      }
                      if (email.contains('@') == false) {
                        glb.showSnackBar(context, 'Alert',
                            'Please Provide a Valid Email ID');
                        return;
                      }
                      if (password.isEmpty) {
                        glb.showSnackBar(
                            context, 'Alert', 'Please Provide Your Password');
                        return;
                      }
                      registerAccountAsync(
                          firstName, lastName, mobileno, email, password);
                      // Navigator.pushNamed(context, CompleteProfileScreenRoute);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
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
      ),
    );
  }

  bool showLoading = false;
  Future registerAccountAsync(
      firstName, lastName, mobileno, email_id, password) async {
    setState(() {
      showLoading = true;
    });
    try {
      var url = glb.endPointGym;
      url += "register/"; // Route Name
      final Map dictMap = {
        'password': password,
        'mobno': mobileno,
        'name': firstName + " " + lastName,
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
        } else if (res.contains("AlreadyExists")) {
          glb.showSnackBar(context, 'Alert',
              'You Already Exists with this mobile number. So please login');
          setState(() {
            showLoading = false;
          });
          return;
        } else {
          try {
            Map<String, dynamic> registerMap = json.decode(res);
            print("registerMap:$registerMap");
            var usrid = registerMap['usrid'];
            var email_id = registerMap['email_id'];
            var memberid = registerMap['memberid'];
            var usrname = registerMap['usrname'];
            var mobno = registerMap['mobno'];
            SharedPreferenceUtils.save_val("gym_usrid", usrid);
            SharedPreferenceUtils.save_val("gym_email_id", email_id);
            SharedPreferenceUtils.save_val("memberid", memberid);
            SharedPreferenceUtils.save_val("gym_usrname", usrname);
            SharedPreferenceUtils.save_val("gym_mobno", mobno);
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
