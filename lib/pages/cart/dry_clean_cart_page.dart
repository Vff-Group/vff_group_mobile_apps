import 'package:flutter/material.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class DryCleaningCart extends StatefulWidget {
  const DryCleaningCart({super.key});

  @override
  State<DryCleaningCart> createState() => _DryCleaningCartState();
}

class _DryCleaningCartState extends State<DryCleaningCart> {
  final bool _noOrders = false;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                 //Navigator.pushNamed(context, OrderDetailsRoute);
                },
                borderRadius: BorderRadius.circular(8.0),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white, // Container color
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1), // Shadow color
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // Changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/clothes/t_shirt.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'T - Shirt',
                                          style: nunitoStyle.copyWith(
                                            color: AppColors.titleTxtColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Rs.24/-",
                                          style: nunitoStyle.copyWith(
                                            color: AppColors.textColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(25.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0,
                                              3), // changes the position of the shadow
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.grey,
size: 20.0,
                                    ),
                                  ),
                                  SizedBox(width: 10.0,),
                                  Text("1",
                                  style: nunitoStyle.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  SizedBox(width: 10.0,),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(25.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0,
                                              3), // changes the position of the shadow
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.grey,
                                      size: 20.0,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }));
  }
}

class _OnOrders extends StatelessWidget {
  const _OnOrders({
    super.key,
    required bool noOrders,
  }) : _noOrders = noOrders;

  final bool _noOrders;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _noOrders,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'There are no order',
              style: nunitoStyle.copyWith(
                  fontSize: 16.0, color: AppColors.textColor),
            ),
            SizedBox(
              height: 15.0,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12.0),
                child: Ink(
                  decoration: BoxDecoration(
                    color: AppColors.blueDarkColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Text(
                      'Start Now',
                      style: nunitoStyle.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.backColor),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}