import 'package:flutter/material.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';


class GoogleDropDownTextFormField extends StatelessWidget {
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?>? onChanged;
  final String labelText;

  const GoogleDropDownTextFormField({
    Key? key,
    this.value,
    required this.items,
    this.onChanged,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.1, // Adjust the border width here
            ),
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            color: kDarkBrown,
            fontSize: 14,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            items: items,
            onChanged: onChanged,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 20,
            elevation: 1,
            style: TextStyle(
              color: Colors.black, // Customize the dropdown text color if needed
              fontSize: 14,
            ),
            selectedItemBuilder: (BuildContext context) {
              return items.map<Widget>((DropdownMenuItem<String> item) {
                return Text(
                  item.value!,
                  style: TextStyle(color: kDarkBrown), // Customize selected item color
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
