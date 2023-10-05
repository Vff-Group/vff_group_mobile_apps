import 'package:flutter/material.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/pages/orders_pages/cancelled_order.dart';
import 'package:vff_group/pages/orders_pages/completed_order.dart';
import 'package:vff_group/pages/orders_pages/ongoing_order.dart';
import 'package:vff_group/pages/prize_pages/dry_cleaning_prize.dart';
import 'package:vff_group/pages/prize_pages/wash_and_fold_prize.dart';
import 'package:vff_group/pages/prize_pages/wash_and_iron_prize.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class PrizeChartPage extends StatefulWidget {
  const PrizeChartPage({super.key});

  @override
  State<PrizeChartPage> createState() => _PrizeChartPageState();
}

class _PrizeChartPageState extends State<PrizeChartPage> {
  @override
  Widget build(BuildContext context) {
   double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return  DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title:  Text('Prize Chart',
          style: nunitoStyle.copyWith(
            fontSize: 24.0,
            fontWeight: FontWeight.bold
          ),),
          bottom:  TabBar(
            unselectedLabelColor: AppColors.backColor.withOpacity(0.4),
            tabs: [
              Tab(icon: Row(
                children: [
                  Icon(Icons.wash),
                  SizedBox(width: 10,),
                  Text('Wash & Fold',
                  style: nunitoStyle.copyWith(
                    fontSize: 12.5
                  ),)
                ],
              ),),
              Tab(icon: Row(
                children: [
                  Icon(Icons.iron),
                  SizedBox(width: 10,),
                  Text('Wash & Iron',
                  style: nunitoStyle.copyWith(
                    fontSize: 12.5
                  ),)
                ],
              ),),
              Tab(icon: Row(
                children: [
                  Icon(Icons.dry),
                  SizedBox(width: 10,),
                  Text('Dry Cleaning',
                  style: nunitoStyle.copyWith(
                    fontSize: 12.5
                  ),)
                ],
              ),),
              
             
            ],
          ),
        ),
        body:  const TabBarView(
          children: [
            WashFoldPrizePage(),
            WashIronPrizePage(),
            DryCleaningPrizePage()
          ],
        ),
      ),
    );
  }
}