import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vff_group/gym_app/common_widgets/round_gradient_button.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/common/rounded_button.dart';
import 'package:vff_group/united_armor_app/common/size_config.dart';

class CartItemsClothingPage extends StatefulWidget {
  const CartItemsClothingPage({super.key});

  @override
  State<CartItemsClothingPage> createState() => _CartItemsClothingPageState();
}

class _CartItemsClothingPageState extends State<CartItemsClothingPage> {
  List exercisesArr = [
    {
      "name": "Set 1",
      "set": [
        {
          "image": "assets/images/img_1.png",
          "title": "Warm Up",
          "value": "05:00"
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Jumping Jack",
          "value": "12x"
        },
        {
          "image": "assets/images/img_1.png",
          "title": "Skipping",
          "value": "15x"
        },
        {"image": "assets/images/img_2.png", "title": "Squats", "value": "20x"},
        {
          "image": "assets/images/img_1.png",
          "title": "Arm Raises",
          "value": "00:53"
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Rest and Drink",
          "value": "02:00"
        },
      ],
    },
    {
      "name": "Set 2",
      "set": [
        {
          "image": "assets/images/img_1.png",
          "title": "Warm Up",
          "value": "05:00"
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Jumping Jack",
          "value": "12x"
        },
        {
          "image": "assets/images/img_1.png",
          "title": "Skipping",
          "value": "15x"
        },
        {"image": "assets/images/img_2.png", "title": "Squats", "value": "20x"},
        {
          "image": "assets/images/img_1.png",
          "title": "Arm Raises",
          "value": "00:53"
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Rest and Drink",
          "value": "02:00"
        },
      ],
    }
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(color: kDarkBrown),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Container(
                      height: SizeConfig.blockSizeVertical! * 4,
                      width: SizeConfig.blockSizeVertical! * 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kWhite,
                        boxShadow: [
                          BoxShadow(
                            color: kBrown.withOpacity(0.11),
                            spreadRadius: 0.0,
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          'assets/arrow_back_icon.svg',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                "Cart Items",
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700),
              ),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 4,
                            decoration: BoxDecoration(
                                color: AppColors.grayColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(3)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: exercisesArr.length,
                          itemBuilder: (context, index) {
                            var sObj = exercisesArr[index] as Map? ?? {};
                            return Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconTitleNextRow(
                                    icon: "assets/icons/time_icon.png",
                                    title: "Schedule Workout",
                                    time: "5/27, 09:00 AM",
                                    color: Colors.blue
                                        .withOpacity(0.3),
                                    onPressed: () {
                                      // Navigator.pushNamed(context, WorkoutScheduleView.routeName);
                                    }),
                              ),
                            );
                          }),
                      SizedBox(
                        height: media.width * 0.1,
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundDarkButton(title: "PROCEED", onPressed: () {
                        Navigator.pushNamed(context, ClothingDeliveryAddressRoute);
                      })
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IconTitleNextRow extends StatelessWidget {
  final String icon;
  final String title;
  final String time;
  final VoidCallback onPressed;
  final Color color;
  const IconTitleNextRow(
      {Key? key,
      required this.icon,
      required this.title,
      required this.time,
      required this.onPressed,
      required this.color})
      : super(key: key);

@override
Widget build(BuildContext context) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrayColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: Image.network(
              "https://underarmour.scene7.com/is/image/Underarmour/V5-1373880-012_FC?rp=standard-0pad%7CgridTileDesktop&scl=1&fmt=jpg&qlt=30&resMode=sharp2&cache=on%2Con&bgc=F0F0F0&wid=512&hei=640&size=512%2C640",
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name Text
                  Text(
                    "Product Name",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  // Quantity, Size, and Color Text
                  Text(
                    "Quantity: 1 | Size: L ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                        // Color Indicator Circle
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color, // Use the provided color here
                          ),
                        ),
                ],
              ),
            ),
          ),
          // Delete Icon
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.delete,color: Colors.redAccent,),
          ),
        ],
      ),
    ),
  );
}

}
