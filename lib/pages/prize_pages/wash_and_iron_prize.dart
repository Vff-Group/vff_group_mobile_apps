import 'package:flutter/material.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class WashIronPrizePage extends StatefulWidget {
  const WashIronPrizePage({super.key});

  @override
  State<WashIronPrizePage> createState() => _WashIronPrizePageState();
}

class _WashIronPrizePageState extends State<WashIronPrizePage> {
  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Prize not found',
              style: nunitoStyle.copyWith(
                  fontSize: 16.0, color: AppColors.textColor),
            ),
            const SizedBox(
              height: 15.0,
            ),
             ],
        ),
      );
  }
}