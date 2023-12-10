import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';

import '../../common_widgets/round_gradient_button.dart';

class WelcomeScreenGymScreen extends StatefulWidget {
  const WelcomeScreenGymScreen({super.key});

  @override
  State<WelcomeScreenGymScreen> createState() => _WelcomeScreenGymScreenState();
}

class _WelcomeScreenGymScreenState extends State<WelcomeScreenGymScreen> {
  String userName = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDefaultsAsync();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset("assets/images/welcome_gym.jpg",
                  width: media.width * 0.75, fit: BoxFit.fitWidth),
              SizedBox(height: media.width * 0.05),
               Text(
                userName,
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: media.width * 0.01),
              const Text(
                "You are all set now, let’s reach your\ngoals together with us",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.grayColor,
                  fontSize: 12,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              RoundGradientButton(
                title: "Go To Home",
                onPressed: () {
                  SharedPreferenceUtils.save_val("welcome_done", "1");
                  Navigator.pushNamed(context, DashboardScreenGymRoute);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future loadDefaultsAsync() async {
    final prefs = await SharedPreferences.getInstance();
    var gym_usrname = prefs.getString('gym_usrname');
    setState(() {
      userName = gym_usrname!;
    });
  }
}
