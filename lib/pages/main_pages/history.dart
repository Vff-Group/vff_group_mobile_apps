import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}
Future<void> _handleRefresh() async {
  Future.delayed(Duration(milliseconds: 5));
}
class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backColor,
         extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('History',
                    style: ralewayStyle.copyWith(
                        fontSize: 25.0,
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1)),
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 0.1 * kToolbarHeight, 0, 20),
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: Column(
              children: [
                
                Expanded(
                  child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: AppColors.lightBlackColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.0),
                                              color: AppColors.hisColor,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Text(
                                                'WF',
                                                style: ralewayStyle.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Wash and Fold laundry',
                                                  style: ralewayStyle.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.whiteColor),
                                                ),
                                                SizedBox(
                                                  height: 2.0,
                                                ),
                                                Text(
                                                  'Delivery in the next 24 hrs',
                                                  style: nunitoStyle.copyWith(
                                                      color: AppColors.whiteColor,
                                                      fontSize: 10.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.circular(4.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18.0, vertical: 4.0),
                                            child: Text(
                                              'In Progress',
                                              style: ralewayStyle.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.whiteColor,
                                                  fontSize: 10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(4.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18.0, vertical: 4.0),
                                            child: Text(
                                              'Completed',
                                              style: ralewayStyle.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.whiteColor,
                                                  fontSize: 10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: true,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(4.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18.0, vertical: 4.0),
                                            child: Text(
                                              'Cancelled',
                                              style: ralewayStyle.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.whiteColor,
                                                  fontSize: 10.0),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Divider(
                                      color: AppColors.whiteColor,
                                      height: 0.2,
                                      thickness: 0.2,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'March 18, 2023',
                                        style: nunitoStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0,
                                            color: AppColors.whiteColor),
                                      ),
                                      Icon(Icons.more_horiz,color: Colors.white,)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
                ),
            
              ],
            ),
          ),
        ));
  }
}
