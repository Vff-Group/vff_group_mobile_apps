import 'package:flutter/material.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';

class RoundDarkButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  const RoundDarkButton(
      {Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          textColor: AppColors.primaryColor1,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.whiteColor,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
