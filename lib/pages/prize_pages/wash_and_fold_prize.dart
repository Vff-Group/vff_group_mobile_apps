import 'package:flutter/material.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class WashFoldPrizePage extends StatefulWidget {
  const WashFoldPrizePage({super.key});

  @override
  State<WashFoldPrizePage> createState() => _WashFoldPrizePageState();
}

class _WashFoldPrizePageState extends State<WashFoldPrizePage> {
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