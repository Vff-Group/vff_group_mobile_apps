import 'package:flutter/material.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class CustomRadioButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool>? onChanged;

  const CustomRadioButton({
    required this.label,
    required this.isSelected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onChanged != null) {
          onChanged!(!isSelected);
        }
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2,vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppColors.blueColor : Colors.white,
              ),
              borderRadius: BorderRadius.circular(50),
              color: isSelected ? AppColors.blueColor : Colors.white,
            ),
            child: Icon(Icons.done_rounded,color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Text(label,style: nunitoStyle.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppColors.blueColor : AppColors.whiteColor)),
          )
        ],
      ),
    );
  }
}
