import 'package:flutter/material.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';

enum RoundButtonType { primaryBG, secondaryBG }

class RoundSmallButton extends StatelessWidget {
  final String title;
  
  final Function() onPressed;

  const RoundSmallButton(
      {Key? key,
      required this.title,
      required this.onPressed,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kDarkBrown,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 2, offset: Offset(0, 2))
          ]),
      child: MaterialButton(
        minWidth: double.maxFinite,
        height: 50,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        textColor: AppColors.primaryColor1,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.whiteColor,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
