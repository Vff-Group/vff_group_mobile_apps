import 'package:flutter/material.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class CustomRadioButton2 extends StatelessWidget {
  final String label;
  final String price;
  final bool isSelected;
  final ValueChanged<bool>? onChanged;

  const CustomRadioButton2({
    required this.label,
    required this.isSelected,
    this.onChanged, required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onChanged != null) {
          onChanged!(!isSelected);
        }
      },
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Row(
              children: [
                  Container(
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? AppColors.blueColor : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  color: isSelected ? AppColors.blueColor : Colors.grey,
                ),
                child: Icon(Icons.done_rounded, color: isSelected ? Colors.white : Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(label,
                    style: nunitoStyle.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColors.blueColor
                            : AppColors.textColor)),
              )
            
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('₹ $price',
                    style: nunitoStyle.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColors.blueColor
                            : AppColors.textColor)),
              )
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
