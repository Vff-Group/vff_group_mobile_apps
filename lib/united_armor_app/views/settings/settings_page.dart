import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:vff_group/gym_app/common_widgets/round_button.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/gym_app/views/setttings/widgets/setting_row.dart';
import 'package:vff_group/gym_app/views/setttings/widgets/title_subtitle_cell.dart';
import 'package:vff_group/united_armor_app/common/rounded_small_button.dart';

class ClothingSettingsPage extends StatefulWidget {
  const ClothingSettingsPage({super.key});

  @override
  State<ClothingSettingsPage> createState() => _ClothingSettingsPageState();
}

class _ClothingSettingsPageState extends State<ClothingSettingsPage> {
    bool positive = false;

  List accountArr = [
    
    {"image": "assets/icons/p_achi.png", "name": "Track Order", "tag": "2"},
    {
      "image": "assets/icons/p_activity.png",
      "name": "Order History",
      "tag": "3"
    },
    {
      "image": "assets/icons/p_workout.png",
      "name": "My Reviews",
      "tag": "4"
    }
  ];

  List otherArr = [
    {"image": "assets/icons/p_contact.png", "name": "Contact Us", "tag": "5"},
    {"image": "assets/icons/p_privacy.png", "name": "Privacy Policy", "tag": "6"},
    
  ];

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
              fontSize: 16,
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
                          "Shahid",
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "+91-829",
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
                    child: RoundSmallButton(
                      title: "Edit",
                      
                      onPressed: () {

                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 55,
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: accountArr.length,
                      itemBuilder: (context, index) {
                        var iObj = accountArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {},
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Other",
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: otherArr.length,
                      itemBuilder: (context, index) {
                        var iObj = otherArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {},
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}