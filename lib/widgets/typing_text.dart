import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class TypingText extends StatefulWidget {
  final String text;

  TypingText(this.text);

  @override
  _TypingTextState createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  String _displayedText = '';

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    for (int i = 0; i <= widget.text.length; i++) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          _displayedText = widget.text.substring(0, i);
        });
      });
      Future.delayed(Duration(milliseconds: 100 * (i + 1)), () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: nunitoStyle.copyWith(
          fontWeight: FontWeight.bold, color: AppColors.titleTxtColor),
    );
  }
}
