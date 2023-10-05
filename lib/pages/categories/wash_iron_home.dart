import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class WashAndIronScreenMain extends StatefulWidget {
  const WashAndIronScreenMain({super.key});

  @override
  State<WashAndIronScreenMain> createState() => _WashAndIronScreenMainState();
}

class _WashAndIronScreenMainState extends State<WashAndIronScreenMain> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _TitleLayout(
            width: width,
          )
        ],
      )),
    );
  }
}

class _TitleLayout extends StatelessWidget {
  const _TitleLayout({
    Key? key,
    required this.width,
  }) : super(key: key);
  final double width;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(12.0),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.blueDarkColor,
                  size: 22.0,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Wash and Iron',
              style: nunitoStyle.copyWith(
                color: AppColors.blueDarkColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Spacer()
      ],
    );
  }
}
