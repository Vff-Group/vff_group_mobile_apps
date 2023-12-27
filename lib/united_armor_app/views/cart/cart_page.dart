import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vff_group/gym_app/common_widgets/round_gradient_button.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/common/footer_widget.dart';
import 'package:vff_group/united_armor_app/common/rounded_button.dart';
import 'package:vff_group/united_armor_app/common/size_config.dart';
import 'package:vff_group/utils/app_colors.dart' as AppColor2;
class CartItemsClothingPage extends StatefulWidget {
  const CartItemsClothingPage({super.key});

  @override
  State<CartItemsClothingPage> createState() => _CartItemsClothingPageState();
}

class _CartItemsClothingPageState extends State<CartItemsClothingPage> {
  List<DropdownMenuItem<int>> items = [];
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
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kDarkBrown,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MenuRoute);
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, NotificationScreenRoute);
                  },
                  icon: Image.asset(
                    "assets/icons/notification_icon.png",
                    width: 20,
                    height: 20,
                    color: Colors.white,
                    fit: BoxFit.fitHeight,
                  )),
              IconButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    // Navigator.pushNamed(context, ClothingMainHomeRoute);
                  },
                  icon: Image.asset(
                    "assets/logo/logo_united_armor.png",
                    fit: BoxFit.fitHeight,
                  )),
              IconButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, NotificationScreenRoute);
                  },
                  icon:
                      SvgPicture.asset('assets/favorite_icon_unselected.svg')),
              IconButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, NotificationScreenRoute);
                  },
                  icon: SvgPicture.asset('assets/cart_icon_unselected.svg')),
            ],
          )),
      body: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: media.width * 0.1,
                        ),
                        Row(
                          
                          children: [
                            Text(
                              'Your Bag (3 Items)',
                              style: kEncodeSansBold.copyWith(fontSize: 14.0),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: kGrey,
                        ),
                        Text(
                          'Shipping',
                          style: kEncodeSansBold.copyWith(fontSize: 14.0),
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
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: IconTitleNextRow(
                                    icon: "assets/icons/time_icon.png",
                                    title: "Schedule Workout",
                                    time: "5/27, 09:00 AM",
                                    color: AppColors.primaryColor2
                                        .withOpacity(0.3),
                                        items:items,
                                    onPressed: () {
                                      // Navigator.pushNamed(context, WorkoutScheduleView.routeName);
                                    }),
                              );
                            }),
                        SizedBox(
                          height: media.width * 0.1,
                        ),
                        Text(
                          'Orders Summary',
                          style: kEncodeSansBold.copyWith(fontSize: 16.0),
                        ),
                      SizedBox(
                        height: media.width * 0.1,
                      ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SubTotal(3):',
                              style: kEncodeSansBold.copyWith(fontSize: 14.0),
                            ),
                            Text(
                              'MRP 2345',
                              style: kEncodeSansBold.copyWith(fontSize: 14.0),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Estimated Shipping:',
                              style:
                                  kEncodeSansRagular.copyWith(fontSize: 14.0),
                            ),
                            Text(
                              'Free',
                              style:
                                  kEncodeSansRagular.copyWith(fontSize: 14.0),
                            )
                          ],
                        ),
                        Divider(
                          color: kGrey,
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: kEncodeSansBold.copyWith(fontSize: 16.0),
                            ),
                            Text(
                              '2345',
                              style: kEncodeSansBold.copyWith(fontSize: 16.0),
                            )
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Divider(
                          color: kGrey,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, ClothingMainHomeRoute);
                          },
                          child: Text(
                            'Continue Shopping',
                            style: kEncodeSansMedium.copyWith(
                                fontSize: 14.0,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                      ],
                    ),
                  ),
                  Footer_Part(),
                  SizedBox(
                    height: media.width * 0.5,
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          color: kWhite,
          child: Wrap(
            children: [
              SizedBox(
                height: media.width * 0.05,
              ),
              Divider(
                color: kGrey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: kEncodeSansBold.copyWith(fontSize: 16.0),
                    ),
                    Text(
                      '2345',
                      style: kEncodeSansBold.copyWith(fontSize: 16.0),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: media.width * 0.05,
              ),
              Divider(
                color: kGrey,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ClothingDeliveryAddressRoute);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: AppColor2.AppColors.redColor),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Proceed',
                            style: kEncodeSansBold.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteColor),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
      
    );
  
  }
}

class IconTitleNextRow extends StatelessWidget {
  final String icon;
  final String title;
  final String time;
  final List<DropdownMenuItem<int>> items;
  final VoidCallback onPressed;
  final Color color;
  
  const IconTitleNextRow(
      {Key? key,
      required this.icon,
      required this.title,
      required this.time,
      required this.onPressed,
      required this.color, required this.items})
      : super(key: key);

@override
Widget build(BuildContext context) {
  return InkWell(
    onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Container(
          decoration: BoxDecoration(
          
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                child: Image.network(
                  "https://www.underarmour.in/media/catalog/product/cache/fe00ef9a43201311b84f219ced64b808/1/3/1377380-414-MD-120230714204908871.jpg",
                  width: 100,
                  height: 100,
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
                        "Product Name skdahdkjashdsahd",
                        maxLines: 2,
                        style: kEncodeSansBold.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Product ID',
                        style: kEncodeSansRagular.copyWith(
                          fontSize: 10.0,
                        ),
                      ),
                      SizedBox(height: 4),
                      // Quantity, Size, and Color Text
                      Text(
                        "Color: Black-001 ",
                        style: kEncodeSansRagular.copyWith(
                          fontSize: 10.0,
                        ),
                      ),
                      SizedBox(height: 4),
                      // Quantity, Size, and Color Text
                      Text(
                        "Size: L ",
                        style: kEncodeSansRagular.copyWith(
                          fontSize: 10.0,
                        ),
                      ),
                      SizedBox(height: 4),
                      // Quantity, Size, and Color Text
                      Row(
                        children: [
                          Text(
                            "₹4444",
                            style: kEncodeSansBold.copyWith(
                              fontSize: 12.0,
                            ),
                          
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Text.rich(
                            TextSpan(
                              text: '₹5400',
                              style: kEncodeSansSemibold.copyWith(
                                color: Colors.redAccent,
                                fontSize: SizeConfig.blockSizeHorizontal! * 3.0,
                                decoration: TextDecoration
                                    .lineThrough, // Add strike-through decoration
                                decorationColor: Colors
                                    .red, // Color for the strike-through line
                                decorationThickness:
                                    5, // Adjust thickness of the strike-through line
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                      Container(
                            width: 100,
                        decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  child: Text(
                                    'Qty',
                                    style: kEncodeSansRagular.copyWith(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: DropdownButton<int>(
                                    iconSize: 16,
                                    items: items,
                                    onChanged: (value) {},
                                    isExpanded: true,
                                    underline: Container(),
                                    isDense:
                                        true, // Aligns text and icon horizontally centered
                                    icon: Icon(
                                        Icons.keyboard_arrow_down_rounded),
                                    iconEnabledColor: Colors.black,
                                    iconDisabledColor: Colors.black,
                                    alignment: Alignment
                                        .centerRight, // Aligns icon to the right
                                  ),
                                ),
                              ],
                        ),
                      ),
                        ],
                      ),
                 
                      SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Save Later',
                            style: kEncodeSansBold.copyWith(
                                decoration: TextDecoration.underline,
                                fontSize: 12.0,
                                color: AppColors.grayColor),
                          ),
                          Text(
                            'Remove',
                            style: kEncodeSansBold.copyWith(
                                decoration: TextDecoration.underline,
                                fontSize: 12.0,
                                color: Colors.redAccent),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            
            ],
          ),
      ),
    ),
  );
}

}
