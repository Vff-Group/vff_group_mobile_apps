import 'package:flutter/material.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class ToolBarWidget extends StatelessWidget {
  const ToolBarWidget({
    super.key,
    required this.screenName,
  });
  final String screenName;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Row(
          children: [
            SizedBox(
              width: 10.0,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              screenName,
              style: nunitoStyle.copyWith(
                color: AppColors.backColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
