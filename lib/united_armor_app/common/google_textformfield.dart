import 'package:flutter/material.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';

class GoogleTextFormField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final String hintText;

  final TextInputType textInputType;

  final String labelText;

  const GoogleTextFormField({
    Key? key,
    this.textEditingController,
    required this.hintText,
    required this.textInputType,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: TextField(
        textInputAction: TextInputAction.done,
        controller: textEditingController,
        keyboardType: textInputType,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          border: const OutlineInputBorder(borderSide: BorderSide(
              width: 0.1, // Adjust the border width here
            ),),
          labelText: labelText,
           labelStyle: TextStyle(
          color: kDarkBrown,
          fontSize: 14,
        ),
          hintText: '',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          
        ),
      ),
    );
  }
}
