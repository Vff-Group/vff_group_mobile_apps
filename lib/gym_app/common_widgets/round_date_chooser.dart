import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class RoundDateTextField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final String hintText;
  final String icon;
  final TextInputType textInputType;
  final bool isObscureText;
  final Widget? rightIcon;

  const RoundDateTextField({
    Key? key,
    this.textEditingController,
    required this.hintText,
    required this.icon,
    required this.textInputType,
    this.isObscureText = false,
    this.rightIcon,
  }) : super(key: key);

  @override
  _RoundDateTextFieldState createState() => _RoundDateTextFieldState();
}

class _RoundDateTextFieldState extends State<RoundDateTextField> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1945),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.textEditingController?.text =
            "${picked.year}/${picked.month}/${picked.day}"; // Format date as needed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGrayColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: widget.textEditingController,
          keyboardType: widget.textInputType,
          obscureText: widget.isObscureText,
          enabled: false,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            hintText: widget.hintText,
            prefixIcon: Container(
              alignment: Alignment.center,
              width: 20,
              height: 20,
              child: Image.asset(
                widget.icon,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                color: AppColors.grayColor,
              ),
            ),
            suffixIcon: widget.rightIcon,
            hintStyle: TextStyle(fontSize: 12, color: AppColors.grayColor),
          ),
        ),
      ),
    );
  }
}
