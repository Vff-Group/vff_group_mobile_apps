import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/gym_app/views/setttings/widgets/setting_row.dart';
import 'package:vff_group/gym_app/views/setttings/widgets/title_subtitle_cell.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:vff_group/routings/route_names.dart';
import '../../common_widgets/round_button.dart';

class SettingsGym extends StatefulWidget {
  const SettingsGym({super.key});

  @override
  State<SettingsGym> createState() => _SettingsGymState();
}

class _SettingsGymState extends State<SettingsGym> {
  bool positive = false;

  List accountArr = [
    {
      "image": "assets/icons/p_personal.png",
      "name": "Personal Data",
      "tag": "1"
    },
    {"image": "assets/icons/p_achi.png", "name": "Achievement", "tag": "2"},
    {
      "image": "assets/icons/p_activity.png",
      "name": "Activity History",
      "tag": "3"
    },
    {
      "image": "assets/icons/p_workout.png",
      "name": "Workout Progress",
      "tag": "4"
    }
  ];

  List otherArr = [
    {"image": "assets/icons/p_contact.png", "name": "Contact Us", "tag": "5"},
    {
      "image": "assets/icons/p_privacy.png",
      "name": "Privacy Policy",
      "tag": "6"
    },
    {"image": "assets/icons/p_setting.png", "name": "Setting", "tag": "7"},
  ];

  var memberID = "";
  var emailID = "";
  var userName = "";
  var mobNo = "";
  var gymID = "";
  var myHeight = "";
  var myWeight = "";
  var myAge = "";
  var myGymGoal = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDefaultAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 18,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      "assets/images/user.png",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          myGymGoal,
                          style: TextStyle(
                            color: AppColors.grayColor,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 25,
                    child: RoundButton(
                      title: "Edit",
                      type: RoundButtonType.primaryBG,
                      onPressed: () {
                        Navigator.pushNamed(context, CompleteProfileScreenRoute);
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: TitleSubtitleCell(
                      title: myHeight,
                      subtitle: "Height",
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: myWeight,
                      subtitle: "Weight",
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: myAge,
                      subtitle: "Age",
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              // Container(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              //   decoration: BoxDecoration(
              //     color: AppColors.primaryColor2.withOpacity(0.3),
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Row(
              //         children: [
              //           Icon(
              //             Icons.verified,
              //             color: AppColors.primaryColor1,
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(left: 8.0),
              //             child: Text(
              //               "Current Diet Plan",
              //               style: TextStyle(
              //                   color: AppColors.blackColor,
              //                   fontSize: 14,
              //                   fontWeight: FontWeight.w700),
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         width: 100,
              //         height: 35,
              //         child: RoundButton(
              //           title: "View",
              //           onPressed: () {},
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              
              const SizedBox(
                height: 25,
              ),
              // Container(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              //   decoration: BoxDecoration(
              //       color: AppColors.whiteColor,
              //       borderRadius: BorderRadius.circular(15),
              //       boxShadow: const [
              //         BoxShadow(color: Colors.black12, blurRadius: 2)
              //       ]),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Other",
              //         style: TextStyle(
              //           color: AppColors.blackColor,
              //           fontSize: 16,
              //           fontWeight: FontWeight.w700,
              //         ),
              //       ),
              //       const SizedBox(
              //         height: 8,
              //       ),
              //       // ListView.builder(
              //       //   physics: const NeverScrollableScrollPhysics(),
              //       //   padding: EdgeInsets.zero,
              //       //   shrinkWrap: true,
              //       //   itemCount: otherArr.length,
              //       //   itemBuilder: (context, index) {
              //       //     var iObj = otherArr[index] as Map? ?? {};
              //       //     return SettingRow(
              //       //       icon: iObj["image"].toString(),
              //       //       title: iObj["name"].toString(),
              //       //       onPressed: () {},
              //       //     );
              //       //   },
              //       // )
              //     ],
              //   ),
              // )
           
            ],
          ),
        ),
      ),
    );
  }

  Future getDefaultAsync() async {
    final prefs = await SharedPreferences.getInstance();
    var memberid = prefs.getString('memberid');
    var gym_email_id = prefs.getString('gym_email_id');
    var gym_usrname = prefs.getString('gym_usrname');
    var gym_mobno = prefs.getString('gym_mobno');
    var gymid = prefs.getString('gymid');
    var my_height = prefs.getString('my_height');
    var my_weight = prefs.getString('my_weight');
    var my_gym_goal = prefs.getString('my_gym_goal');
    var my_date_of_birth = prefs.getString('my_date_of_birth');
    print('my_date_of_birth::$my_date_of_birth');
    // Parsing the date string into DateTime object
    // Replace '/' with '-' in the date string
    // my_date_of_birth = my_date_of_birth!.replaceAll('/', '-');
    DateTime dob = parseDateOfBirth(my_date_of_birth!);
    int age = calculateAge(dob);

   
    setState(() {
      emailID = gym_email_id!;
      userName = gym_usrname!;
      mobNo = gym_mobno!;
      gymID = gymid!;
      myGymGoal = my_gym_goal!;
      myHeight = my_height! + " Ft";
      myWeight = my_weight! + " Kgs";
      myAge = '$age Yo';
    });
  }

 
}

 DateTime parseDateOfBirth(String dobString) {
    // Assuming the date format is yyyy/m/dd
    List<String> parts = dobString.split('/');
    if (parts.length == 3) {
      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int day = int.parse(parts[2]);
      if (year != null && month != null && day != null) {
        return DateTime(year, month, day);
      }
    }
    // Return a default date or handle error based on your requirement
    return DateTime(2000, 1, 1); // Default date if parsing fails
  }

  int calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

//  String calculateAge(DateTime birthDate) {
//     DateTime currentDate = DateTime.now();
//     int age = currentDate.year - birthDate.year;
//     int month1 = currentDate.month;
//     int month2 = birthDate.month;
//     if (month2 > month1) {
//       age--;
//     } else if (month1 == month2) {
//       int day1 = currentDate.day;
//       int day2 = birthDate.day;
//       if (day2 > day1) {
//         age--;
//       }
//     }
//     return age.toString();
//   }
