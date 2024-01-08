import 'dart:convert';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vff_group/gym_app/common_widgets/round_textfield.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/common/footer_widget.dart';
import 'package:vff_group/united_armor_app/common/rounded_button.dart';
import 'package:vff_group/united_armor_app/common/size_config.dart';
import 'package:vff_group/united_armor_app/utils/animated_heart.dart';
import 'package:vff_group/united_armor_app/views/product_details/models/all_model.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;
import 'package:vff_group/widgets/shimmer_card.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  List<String> imagePaths = [];
  int currentPageIndex = 0;
  int selectedColorIndex = 0;
  int selectedSizeIndex = 0;
  int selectedQuantity = 1;
  bool isFavorite = false;
  List<DropdownMenuItem<int>> items = [];
  String productOfferPrice = "",
      productName = "",
      productActualPrice = "",
      productPath = "",
      whatItDoesDsc = "";
  List<String> specifications = [];
  bool isExpanded = false;
  List<String> fitAndCareSpecs = [];

  bool isExpandedFitAndCare = false;
  List<ProductColorModel> colorModel = [];
  List<ProductSizeModel> sizeModel = [];
  TextEditingController checkDeliveryController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProductDetailsAsync();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showLoading
        ? Scaffold(
            body: Center(
              child: Lottie.asset('assets/images/loading_animation.json'),
            ),
          )
        : Scaffold(
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(18.0),
        child: GestureDetector(
          onTap: (){
                  Navigator.pushNamed(context, CartItemsClothingRoute);
                  //TODO:Async to add it to cart table
                  setState(() {
                    showLoading = true;
                  });
                  // Adding a delay of 2 seconds before setting showLoading back to false
                  // Future.delayed(Duration(seconds: 2), () {
                  //   setState(() {
                  //     showLoading = false;
                  //   });
                  // });
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: AppColors.redColor),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add to Bag',
                    style: kEncodeSansBold.copyWith(
                        fontWeight: FontWeight.bold, color: AppColors.whiteColor),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
     
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: SizeConfig.blockSizeVertical! * 50,
                      child: imagePaths.isNotEmpty
                          ? Stack(
                              children: [
                                PageView.builder(
                                  itemCount: imagePaths.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      currentPageIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        imagePaths[index],
                                        height:
                                            SizeConfig.blockSizeVertical! * 50,
                                        width: double.infinity,
                                      ),
                                    );
                                  },
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: DotsIndicator(
                                      dotsCount: imagePaths.length,
                                      position: currentPageIndex,
                                      decorator: DotsDecorator(
                                        color:
                                            Colors.grey, // Inactive dot color
                                        activeColor:
                                            Colors.white, // Active dot color
                                        size: const Size.square(8.0),
                                        activeSize: const Size(20.0, 8.0),
                                        spacing: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        activeShape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height:
                                            SizeConfig.blockSizeVertical! * 4,
                                        width:
                                            SizeConfig.blockSizeVertical! * 4,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kDarkBrown,
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
                                        child: SvgPicture.asset(
                                          'assets/arrow_back_icon.svg',
                                          color: kWhite,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: SizeConfig.blockSizeVertical! * 4,
                                      width: SizeConfig.blockSizeVertical! * 4,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kDarkBrown,
                                        boxShadow: [
                                          BoxShadow(
                                            color: kBrown.withOpacity(0.11),
                                            spreadRadius: 0.0,
                                            blurRadius: 12,
                                            offset: const Offset(0, 5),
                                          )
                                        ],
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/cart_icon_unselected.svg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Visibility(
                                    visible: isFavorite,
                                    child: AnimatedHeart(),
                                  ),
                                ),
                              ],
                            )
                          : Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.2),
                              highlightColor: Colors.grey.withOpacity(0.1),
                              enabled: showLoading,
                              child: PageView.builder(
                                itemCount: 10,
                                onPageChanged: (index) {
                                  setState(() {
                                    currentPageIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return ShimmerPaginationLayout();
                                },
                              ),
                            )),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(productPath),
                        SizedBox(
                          height: 15,
                        ),
                        Stack(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width - 100,
                                child: Text(
                                  productName,
                                  style: kEncodeSansBold.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                )),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isFavorite = !isFavorite;

                                        if (isFavorite) {
                                          addToWishlistAsync(glb.productID);
                                        } else {
                                          removeFromWishlistAsync(
                                              glb.productID);
                                        }
                                      });
                                    },
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
                                      child: Center(
                                        child: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border_outlined,
                                          color: isFavorite ? Colors.red : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text.rich(
                          TextSpan(
                            text: productActualPrice,
                            style: kEncodeSansSemibold.copyWith(
                              color: AppColors.greyColor,
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
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(productOfferPrice),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text("(Inclusive of all taxes)"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                              itemCount: colorModel.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedColorIndex =
                                          index; // Update selected index
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Text(colorModel[index].colorName),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          padding: EdgeInsets.all(
                                              4), // Padding for border
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                border: Border.all(
                                                  color: selectedColorIndex ==
                                                          index
                                                      ? Colors.deepOrangeAccent
                                                      : Colors.transparent,
                                                  width: 2,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                child: Container(
                                                  color: colorModel[index]
                                                      .colorCode,
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            'Size & Fit',
                            style: kEncodeSansBold.copyWith(
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                              itemCount: sizeModel.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                bool isSelected = selectedSizeIndex == index;
                                Color borderColor = isSelected
                                    ? Colors.deepOrangeAccent
                                    : Colors.grey;
                                Color textColor = isSelected
                                    ? Colors.deepOrangeAccent
                                    : Colors.grey;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedSizeIndex =
                                          index; // Update selected index
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border:
                                              Border.all(color: borderColor)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            sizeModel[index].sizeValues,
                                            style: kEncodeSansBold.copyWith(
                                                fontSize: 10.0,
                                                color: textColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Divider(
                          color: AppColors.greyColor,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Row(
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: DropdownButton<int>(
                                  iconSize: 16,
                                  value: selectedQuantity,
                                  items: items,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedQuantity = value!;
                                    });
                                  },
                                  isExpanded: true,
                                  underline: Container(),
                                  isDense:
                                      true, // Aligns text and icon horizontally centered
                                  icon: Icon(Icons.keyboard_arrow_down_rounded),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Check Delivery',
                              style: kEncodeSansBold.copyWith(fontSize: 14.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 7, // 70% width
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: 8.0), // Padding between elements
                                child: RoundTextField(
                                  textEditingController:
                                      checkDeliveryController,
                                  hintText: "Enter Pin Code",
                                  icon: "assets/icons/search_icon.png",
                                  textInputType: TextInputType.number,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3, // 30% width
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: kDarkBrown,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Center(
                                    child: Text(
                                      'Check',
                                      style: kEncodeSansBold.copyWith(
                                          fontSize: 12.0,
                                          color: AppColors.whiteColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What's it do?",
                          style: kEncodeSansRagular.copyWith(fontSize: 14.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          whatItDoesDsc,
                          style: kEncodeSansRagular.copyWith(fontSize: 12.0),
                        )
                      ],
                    ),
                  ),
                  ExpansionTile(
                    title: Text(
                      'Specifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    initiallyExpanded: isExpanded,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        isExpanded = expanded;
                      });
                    },
                    children: [
                      if (isExpanded)
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              for (var spec in specifications)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '• ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          spec.trim(),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      'Fit and Care Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    initiallyExpanded: isExpandedFitAndCare,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        isExpandedFitAndCare = expanded;
                      });
                    },
                    children: [
                      if (isExpandedFitAndCare)
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              for (var desc in fitAndCareSpecs)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '• ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          desc.trim(),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: const Footer_Part(),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 150,
              ),
            )
          ],
        ),
      ),
    );
  }

  bool showLoading = false;
  Future loadProductDetailsAsync() async {
    setState(() {
      showLoading = true;
    });
    try {
      var url = glb.endPointClothing;
      url += "load_single_product_details/"; // Route Name

      final Map dictMap = {
        'product_id': glb.productID,
      };
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
          glb.showSnackBar(context, 'Error', 'No Products Found');
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
            Map<String, dynamic> productMap = json.decode(res);
            // print("productMap:$productMap");
            List<dynamic> queryResult = productMap['query_result'];
            List<dynamic> imagesResult = productMap['images'];
            List<dynamic> colorsResult = productMap['colors'];
            List<dynamic> sizesResult = productMap['sizes'];
            List<dynamic> isMarkedWishlistResult =
                productMap['isMarkedWishlist'];
            print('queryResult::$queryResult');
            print('imagesResult::$imagesResult');
            print('colorsResult::$colorsResult');
            print('sizesResult::$sizesResult');
            imagePaths = [];
            productOfferPrice = "";
            productName = "";
            productActualPrice = "";
            productPath = "";
            setState(() {
              productName = queryResult[0]['product_name'].toString();
              var main_title_name =
                  queryResult[0]['main_title_name'].toString();
              var cat_name = queryResult[0]['cat_name'].toString();
              var sub_cat_name = queryResult[0]['sub_cat_name'].toString();
              var product_category_name =
                  queryResult[0]['product_category_name'].toString();
              productPath =
                  "$main_title_name / $cat_name / $sub_cat_name / $product_category_name";

              var offerPrice = queryResult[0]['offer_price'].toString();
              productOfferPrice = "MRP $offerPrice";

              var actualPrice = queryResult[0]['price'].toString();

              whatItDoesDsc = queryResult[0]['what_it_does'].toString();

              var specificationsString =
                  queryResult[0]['specifications'].toString();
              specifications = specificationsString
                  .split('.')
                  .where((s) => s.isNotEmpty)
                  .toList();

              var fitAndCareDesc =
                  queryResult[0]['fit_and_care_desc'].toString();
              fitAndCareSpecs =
                  fitAndCareDesc.split('.').where((s) => s.isNotEmpty).toList();

              var max_checkout_qty =
                  int.parse(queryResult[0]['max_checkout_qty'].toString());
              items = List.generate(
                max_checkout_qty,
                (index) => DropdownMenuItem<int>(
                  value: index + 1,
                  child: SizedBox(
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        (index + 1).toString(),
                        style: kEncodeSansRagular.copyWith(fontSize: 12.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
              );
              productActualPrice = "MRP $actualPrice";

              //To check if marked Favorite
              if (isMarkedWishlistResult.isNotEmpty) {
                var ifFavorite =
                    isMarkedWishlistResult[0]['wishlistid'].toString();
                if (ifFavorite.isNotEmpty) {
                  setState(() {
                    isFavorite = true;
                  });
                } else {
                  setState(() {
                    isFavorite = false;
                  });
                }
              }
            });

            //Initial Image to show
            for (var image in imagesResult) {
              var image_url = image['image_url'].toString();
              imagePaths.add(image_url);
            }

            //All Colors
            for (var i = 0; i < colorsResult.length; i++) {
              var colors = colorsResult[i];
              var colorsID = colors['colorsid'].toString();
              var colorName = colors['color_name'].toString();
              var colorCode = colors['color_code'].toString();
              Color myColor = Color(int.parse("0xFF$colorCode"));

              String suffix = i == colorsResult.length - 1 ? '' : ' / ';
              colorName = '$colorName$suffix'; // Modified here

              colorModel.add(ProductColorModel(
                  colorID: colorsID, colorName: colorName, colorCode: myColor));
            }

            //All Sizes
            for (var sizes in sizesResult) {
              var sizeID = sizes['sizesid'].toString();
              var sizeValue = sizes['size_value'].toString();
              sizeModel.add(
                  ProductSizeModel(sizeIDs: sizeID, sizeValues: sizeValue));
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

  Future addToWishlistAsync(product_id) async {
    try {
      var url = glb.endPointClothing;
      url += "add_to_wishlist/"; // Route Name
      final Map dictMap = {
        'product_id': product_id,
      };

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
        if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');

          return;
        } else {
          try {
            Map<String, dynamic> addMap = json.decode(res);
            print("addMap:$addMap");

            return;
          } catch (e) {
            print(e);
            return "Failed";
          }
        }
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      glb.handleErrors(e, context);

      return;
    }
  }

  Future removeFromWishlistAsync(product_id) async {
    try {
      var url = glb.endPointClothing;
      url += "delete_from_wishlist/"; // Route Name
      final Map dictMap = {
        'product_id': product_id,
      };

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
        if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');

          return;
        } else {
          try {
            Map<String, dynamic> removeMap = json.decode(res);
            print("removeMap:$removeMap");

            return;
          } catch (e) {
            print(e);
            return "Failed";
          }
        }
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      glb.handleErrors(e, context);

      return;
    }
  }

}
