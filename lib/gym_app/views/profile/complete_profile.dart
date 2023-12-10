// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/gym_app/common_widgets/round_date_chooser.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';

import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

class CompleteGymProfile extends StatefulWidget {
  const CompleteGymProfile({super.key});

  @override
  State<CompleteGymProfile> createState() => _CompleteGymProfileState();
}

class _CompleteGymProfileState extends State<CompleteGymProfile> {
  String genderValue = "Choose Gender";
  bool showLoading = false;
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

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
                Image.asset("assets/images/gym_profile.png",
                    width: media.width),
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
                                genderValue = value;
                              }
                            });
                          },
                          isExpanded: true,
                          hint: Text(genderValue,
                              style: const TextStyle(
                                  color: AppColors.grayColor, fontSize: 12)),
                        ),
                      )),
                      SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15),
                RoundDateTextField(
                  textEditingController: dateOfBirthController,
                  hintText: "Date of Birth",
                  icon: "assets/icons/calendar_icon.png",
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 15),
                RoundTextField(
                  textEditingController: weightController,
                  hintText: "Your Weight in kgs",
                  icon: "assets/icons/weight_icon.png",
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 15),
                RoundTextField(
                  textEditingController: heightController,
                  hintText: "Your Height in feet",
                  icon: "assets/icons/swap_icon.png",
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 15),
                showLoading ?CircularProgressIndicator():
                RoundGradientButton(
                  title: "Next >",
                  onPressed: () {
                    if(genderValue=="Choose Gender"){
                      glb.showSnackBar(context, 'Error', 'Please Choose the gender');
                      return;
                    }
                    var date_of_birth = dateOfBirthController.text.trim();
                    if(date_of_birth.isEmpty){
                      glb.showSnackBar(context, 'Error', 'Please Choose Date of Birth');
                      return;
                    }
                    var weight = weightController.text.trim();
                    if(weight.isEmpty){
                      glb.showSnackBar(context, 'Error', 'Please provide us your weight in kgs');
                      return;
                    }
                    var height = heightController.text.trim();
                    if(height.isEmpty){
                      glb.showSnackBar(context, 'Error', 'Please provide us your height in feet');
                      return;
                    }
                    profileAsync(genderValue, date_of_birth, height, weight);
                    //Navigator.pushNamed(context, YourGoalScreenRoute);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future profileAsync(gender, date_of_birth,height,weight) async {
    setState(() {
      showLoading = true;
    });
    
    final prefs = await SharedPreferences.getInstance();
    var memberid = prefs.getString('memberid');

    try {
      var url = glb.endPointGym;
      url += "complete_profile/"; // Route Name
      final Map dictMap = {
        'gender': gender,
        'date_of_birth': date_of_birth,
        'weight': weight,
        'height': height,
        'memberid': memberid,
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
        } else {
          try {
            Map<String, dynamic> profileMap = json.decode(res);
            print("profileMap:$profileMap");
            
            SharedPreferenceUtils.save_val("my_gender",gender);
            SharedPreferenceUtils.save_val("my_date_of_birth", date_of_birth);
            SharedPreferenceUtils.save_val("my_height", height);
            SharedPreferenceUtils.save_val("my_weight", weight);
            SharedPreferenceUtils.save_val("gym_profile_completed", "1");
            Navigator.pushReplacementNamed(context, YourGoalScreenRoute);

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
