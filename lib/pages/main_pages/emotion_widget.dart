import 'package:flutter/material.dart';
import 'package:vff_group/utils/app_styles.dart';

class EmotionFace extends StatelessWidget {
  final String emotionFace;
  const EmotionFace({Key? key, required this.emotionFace}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12.0),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.blue[600],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Text(
            emotionFace,
            style: nunitoStyle.copyWith(
              fontSize: 28,
            ),
          ),
        ),
      ),
    );
  }
}
