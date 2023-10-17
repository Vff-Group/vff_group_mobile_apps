// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/rotate_animation.dart';
import 'package:vff_group/animation/scale_and_revert_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start the animation
    _animateContainer();
  }

  void _animateContainer() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _delaySplash(); // Update the width for the animation
      });
    });
  }

  void _delaySplash() async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.setString('usrid', "");
    var firstRun = prefs.getString('firstRun');
    // SharedPreferenceUtils.save_val('firstRun', '');
    var usrid = prefs.getString('usrid');
    if (usrid != null && usrid.toString().isEmpty == false) {
      var defaultRoute = prefs?.getString('AppPreference');
      print("defaultRoute:$defaultRoute");
      if (defaultRoute != null &&
          defaultRoute.isEmpty == false &&
          defaultRoute == "MainRoute") {
        Navigator.pushReplacementNamed(context, MainRoute);
      } else if (defaultRoute != null &&
          defaultRoute.isEmpty == false &&
          defaultRoute == "DMainRoute") {
        Navigator.pushReplacementNamed(context, DMainRoute);
      }else{
        Navigator.pushReplacementNamed(context, MainRoute);
      }
    } else if (firstRun != null && firstRun.toString().isEmpty == false) {
      Navigator.pushReplacementNamed(context, OnBoardRoute);
    } else {
      Navigator.pushReplacementNamed(context, OnBoardRoute);
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (context) => const OnBoardingPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      top: false,
      bottom: false,
      child: Container(
        color: AppColors.backColor,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RotateAndScaleAnimation(
                  delay: 0.1,
                  child: Image.asset(
                    'assets/logo/logo.png',
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              child: SlideFromBottomAnimation(
                delay: 1,
                child: Text(
                  'Copyright © VFF Group',
                  style: ralewayStyle.copyWith(
                      color: AppColors.greyColor,
                      fontSize: 18,
                      decoration: TextDecoration.none),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
