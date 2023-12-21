import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vff_group/gym_app/common_widgets/round_gradient_button.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/common/footer_widget.dart';
import 'package:vff_group/united_armor_app/common/rounded_button.dart';
import 'package:vff_group/united_armor_app/common/size_config.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;
import 'package:vff_group/widgets/shimmer_card.dart';

class HOmeLatestPage extends StatefulWidget {
  const HOmeLatestPage({super.key});

  @override
  State<HOmeLatestPage> createState() => _HOmeLatestPageState();
}

class _HOmeLatestPageState extends State<HOmeLatestPage> {
  List images = [
    "https://www.underarmour.in/media/wysiwyg/Shop_Men.jpeg",
    "https://www.underarmour.in/media/wysiwyg/cq5dam-230416_FW23_JAYDE_W_AA_13_12735_SCRN-v.jpeg",
    "https://www.underarmour.in/media/wysiwyg/Resized_4.jpg",
    "https://www.underarmour.in/media/wysiwyg/Shop_Shoes.jpeg"
  ];

  List categories_names = ["Shop Men", "Shop Women", "Shop Kids", "Shoes"];

  List mainCategoriesName = [];
  List mainCategoriesID = [];
  List mainCategoriesImages = [];
  bool showLoading = false;
  Future loadAllMainCategoriesAsync() async {
    setState(() {
      showLoading = true;
      mainCategoriesName = [];
      mainCategoriesID = [];
      mainCategoriesImages = [];
    });
    try {
      var url = glb.endPointClothing;
      url += "get_home_main_categories/"; // Route Name
      final Map dictMap = {};

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(dictMap),
      );

      if (response.statusCode == 200) {
        // Handle successful response here
        var res = response.body;
        if (res.contains("ErrorCode#2")) {
          glb.showSnackBar(context, 'Error', 'No Data Found');
          setState(() {
            showLoading = false;
          });
          return;
        } else if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          setState(() {
            showLoading = false;
          });
          return;
        } else {
          try {
            Map<String, dynamic> MainCategoryMap = json.decode(res);
            // print("MainCategoryMap:$MainCategoryMap");
            List<dynamic> queryResult = MainCategoryMap['query_result'];
            for (var feeDetail in queryResult) {
              var main_title_name = feeDetail['main_title_name'].toString();
              var main_cat_id = feeDetail['main_cat_id'].toString();
              var images = feeDetail['images'].toString();
              mainCategoriesName.add(main_title_name);
              mainCategoriesID.add(main_cat_id);
              mainCategoriesImages.add(images);
            }

            setState(() {
              showLoading = false;
            });
            return;
          } catch (e) {
            print(e);
            return "Failed";
          }
        }
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
        setState(() {
          showLoading = false;
        });
      }
    } catch (e) {
      print(e);
      glb.handleErrors(e, context);
      setState(() {
        showLoading = false;
      });
      return;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllMainCategoriesAsync();
  }

  Future<void> _handleRefresh() async {
    loadAllMainCategoriesAsync();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkBrown,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MenuRoute);
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            )),
        actions: [
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
                // Navigator.pushNamed(context, NotificationScreenRoute);
              },
              icon: SvgPicture.asset('assets/favorite_icon_unselected.svg')),
          IconButton(
              onPressed: () {
                // Navigator.pushNamed(context, NotificationScreenRoute);
              },
              icon: SvgPicture.asset('assets/cart_icon_unselected.svg')),
        ],
        title: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, ClothingMainHomeRoute);
            },
                  icon: Image.asset(
              "assets/logo/logo_united_armor.png",
                    
                    fit: BoxFit.fitHeight,
            )),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(children: [
              Image.asset(
                "assets/icons/banner.jpeg",
                width: SizeConfig.screenWidth,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'UA Phantom 3 SE Storm',
                style: poppinsStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'FEEL FRESH. STAY HYDRATED',
                style: poppinsStyle.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'The sink-in feel of UA HOVR cushioning for comfort and water-resistance for any weather.',
                  style: poppinsStyle.copyWith(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
          ),
          SliverToBoxAdapter(
            child: RoundDarkButton(title: 'SHOP NOW', onPressed: () {}),
          ),
          SliverToBoxAdapter(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Put our Newest Gears',
                    style: poppinsStyle.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  showLoading
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey.withOpacity(0.2),
                          highlightColor: Colors.grey.withOpacity(0.1),
                          enabled: showLoading,
                          child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 10,
                              separatorBuilder: (context, _) =>
                                  SizedBox(height: height * 0.02),
                              itemBuilder: ((context, index) {
                                return const ShimmerCardLayout2();
                              })),
                        )
                      : MasonryGridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 23,
                          itemCount: mainCategoriesID.length,
                          padding: const EdgeInsets.symmetric(
                            horizontal: kPaddingHorizontal,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                // glb.imagePath = 'assets/images/${images[index]}';
                          
                                glb.currentSelectedType =
                                    mainCategoriesName[index];
                                glb.currentMainCatId = mainCategoriesID[index];
                                glb.currentSubCatID = "";
                                glb.currentCategoryID = "";
                                glb.currentCategorySelectedName = "";
                                glb.currentSubCategoryName = "";

                                Navigator.pushNamed(context, AllProductsRoute);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Positioned(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              kBorderRadius),
                                          child: Image.network(
                                            mainCategoriesImages[index],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      bottom:
                                          3, // This can be the space you need between text and underline
                                    ),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                      color: Colors.black,
                                      width:
                                          0.5, // This would be the width of the underline
                                    ))),
                                    child: Text(
                                      mainCategoriesName[index],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                  
                  const Footer_Part(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

