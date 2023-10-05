import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class WashAndFoldScreenMain extends StatefulWidget {
  const WashAndFoldScreenMain({super.key});

  @override
  State<WashAndFoldScreenMain> createState() => _WashAndFoldScreenMainState();
}

class _WashAndFoldScreenMainState extends State<WashAndFoldScreenMain> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
          child: Column(
            
            children: [_TitleLayout(width: width)],
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
              'Wash and Fold',
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
