import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';


class SnapShotWidget extends StatefulWidget {
  const SnapShotWidget({super.key});

  @override
  State<SnapShotWidget> createState() => _SnapShotWidgetState();
}

class _SnapShotWidgetState extends State<SnapShotWidget> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: 120,
      child: ScrollSnapList(
        scrollDirection: Axis.horizontal,
        itemSize: 220,
        dynamicItemSize: true,
        reverse: false,
        itemCount: 3,
        onItemFocus: (index) {},
        itemBuilder: ((context, index) {
          return _TodoContainer(
            height: height,
            width: width,
          );
        }),
      ),
    );
  }
}

class _TodoContainer extends StatelessWidget {
  const _TodoContainer({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.whiteColor),
          child: Stack(children: [
            Positioned(
              child: Container(
                width: 10.0,
                height: 50.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                    color: Colors.orange),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 5.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Setup PC',
                              style: ralewayStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: AppColors.blueDarkColor),
                            ),
                            Text(
                              'Need to do this on Top Priority',
                              style: ralewayStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0,
                                  color: AppColors.textColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.mainBlueColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.today_outlined,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Text(
                      'Go To Task - >',
                      style: ralewayStyle.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainBlueColor),
                    )
                  ]),
            ),
          ]),
        ),
        SizedBox(
          width: width * 0.04,
        ),
      ],
    );
  }
}
