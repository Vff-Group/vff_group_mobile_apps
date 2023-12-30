import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:vff_group/animation/slide_left_animation.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/routings/router.dart';
import 'package:vff_group/united_armor_app/categories/categories_page.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/common/common_app_car.dart';
import 'package:vff_group/united_armor_app/common/footer_widget.dart';
import 'package:vff_group/united_armor_app/common/rounded_button.dart';
import 'package:vff_group/united_armor_app/common/size_config.dart';
import 'package:vff_group/united_armor_app/utils/animated_heart.dart';
import 'package:vff_group/united_armor_app/views/all_products/models/all_filters_model.dart';
import 'package:vff_group/united_armor_app/views/all_products/models/all_product_item.dart';
import 'package:vff_group/united_armor_app/views/product_details/product_details.dart';
import 'package:vff_group/united_armor_app/views/sub_categories/sub_categories_page.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

class AllNewProductsPage extends StatefulWidget {
  const AllNewProductsPage({super.key});

  @override
  State<AllNewProductsPage> createState() => _AllNewProductsPageState();
}

class _AllNewProductsPageState extends State<AllNewProductsPage> {
String pathName = "", categorySelected = "";
List<bool> isCategoriesCheckedList = [];
  List<bool> isCategoryTypeCheckedList = [];
  List<bool> isColorsCheckedList = [];
  List<bool> isSizesCheckedList = [];
  List<bool> isFittingsCheckedList = [];

List<String> selectedItems = []; // To store selected filters to show in badge

  List<ProductCategoryFilterModel> productCategoryFilterModel = [];
  List<ProductTypeFilterModel> productTypeFilterModel = [];
  List<ProductColorFilterModel> productColorFilterModel = [];
  List<ProductSizeFilterModel> productSizeFilterModel = [];
  List<ProductFittingFilterModel> productFittingFilterModel = [];
            

  // Map<String, bool> _filterOptions = {
  //   'Clothing': false,
  //   'Shoes': false,

  //   // Add more filter categories here
  // };
  bool isFavorite = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(glb.currentMainCatId.isNotEmpty && glb.currentCategoryID.isNotEmpty && glb.currentSubCatID.isNotEmpty){
      
      pathName =
          "${glb.currentMainCategoryName} / ${glb.currentCategorySelectedName} / ${glb.currentSubCategoryName}";
      categorySelected =
          "${glb.currentMainCategoryName}-${glb.currentCategorySelectedName}";
    }else if(glb.currentMainCatId.isNotEmpty && glb.currentCategoryID.isEmpty){
      pathName = "${glb.currentMainCategoryName}";
      categorySelected = "${glb.currentMainCategoryName}";
    }else if(glb.currentMainCatId.isNotEmpty && glb.currentCategoryID.isNotEmpty && glb.currentSubCatID.isEmpty){
      pathName =
          "${glb.currentMainCategoryName} / ${glb.currentCategorySelectedName}";
      categorySelected =
          "${glb.currentMainCategoryName}-${glb.currentCategorySelectedName}";
    }else{
      pathName = "${glb.currentMainCategoryName}";
      categorySelected = "${glb.currentMainCategoryName}";
    }

    loadAllProductsDetailsAsync();
    getAllFiltersAsync();
  }

  // Future<void> _handleRefresh() async {
  //   if (glb.currentMainCatId.isNotEmpty &&
  //       glb.currentCategoryID.isNotEmpty &&
  //       glb.currentSubCatID.isNotEmpty) {
  //     pathName =
  //         "${glb.currentMainCategoryName} / ${glb.currentCategorySelectedName} / ${glb.currentSubCategoryName}";
  //     categorySelected =
  //         "${glb.currentMainCategoryName}-${glb.currentCategorySelectedName}";
  //   } else if (glb.currentMainCatId.isNotEmpty &&
  //       glb.currentCategoryID.isEmpty) {
  //     pathName = "${glb.currentMainCategoryName}";
  //     categorySelected = "${glb.currentMainCategoryName}";
  //   } else if (glb.currentMainCatId.isNotEmpty &&
  //       glb.currentCategoryID.isNotEmpty &&
  //       glb.currentSubCatID.isEmpty) {
  //     pathName =
  //         "${glb.currentMainCategoryName} / ${glb.currentCategorySelectedName}";
  //     categorySelected =
  //         "${glb.currentMainCategoryName}-${glb.currentCategorySelectedName}";
  //   } else {
  //     pathName = "${glb.currentMainCategoryName}";
  //     categorySelected = "${glb.currentMainCategoryName}";
  //   }

  //   loadAllProductsDetailsAsync();
  //   getAllFiltersAsync();
  // }
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return showLoading
        ? Scaffold(
            body: Center(
              child: Lottie.asset('assets/images/loading_animation.json'),
            ),
          )
        : Material(
      child: Scaffold(
        key: _scaffoldKey,
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
                    icon: SvgPicture.asset(
                        'assets/favorite_icon_unselected.svg')),
                IconButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, NotificationScreenRoute);
                    },
                    icon: SvgPicture.asset('assets/cart_icon_unselected.svg')),
              ],
            )),
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedItems = [];
                            isCategoriesCheckedList = List.generate(
                              isCategoriesCheckedList.length,
                              (index) => false,
                            );
                            isCategoryTypeCheckedList = List.generate(
                              isCategoryTypeCheckedList.length,
                              (index) => false,
                            );
                            isColorsCheckedList = List.generate(
                              isColorsCheckedList.length,
                              (index) => false,
                            );
                            isSizesCheckedList = List.generate(
                              isSizesCheckedList.length,
                              (index) => false,
                            );
                            isFittingsCheckedList = List.generate(
                              isFittingsCheckedList.length,
                              (index) => false,
                            );
                          });
                        },
                        child: Text(
                          'Clear All',
                          style: nunitoStyle.copyWith(
                              fontSize: 12,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      Text(
                        "Filter's",
                        style: nunitoStyle.copyWith(
                            fontSize: 18,
                            color: kDarkBrown,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          _scaffoldKey.currentState!.closeDrawer();
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.grayColor,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                selectedItems.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildBadge(),
                      )
                    : SizedBox(),
                Expanded(
                  child: ListView(
                    children: [
                      ExpansionTile(
                        title: const Text('Product Category'),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: productCategoryFilterModel.length,
                            itemBuilder: (context, index) {
                              String catId = productCategoryFilterModel[index]
                                  .productCatID;
                              String categoryName =
                                  productCategoryFilterModel[index]
                                      .productCatName;
                              return CheckboxListTile(
                                activeColor: Colors.brown,
                                title: Text(categoryName),
                                value: isCategoriesCheckedList[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    isCategoriesCheckedList[index] =
                                        value ?? false;
                                  });
                                  if (value == true) {
                                    // Store the selected category name
                                    setState(() {
                                      if (!selectedItems
                                          .contains(categoryName)) {
                                        selectedItems.add(categoryName);
                                      }
                                    });
                                  } else {
                                    // Remove the category name if unchecked
                                    setState(() {
                                      selectedItems.remove(categoryName);
                                    });
                                  }
                                  print("Selected items: $selectedItems");

                                  
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: const Text('Product Types'),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: productTypeFilterModel.length,
                            itemBuilder: (context, index) {
                              String typeId =
                                  productTypeFilterModel[index].productTypeID;
                              String typeName =
                                  productTypeFilterModel[index].productTypeName;
                              return CheckboxListTile(
                                activeColor: Colors.brown,
                                title: Text(typeName),
                                value: isCategoryTypeCheckedList[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    isCategoryTypeCheckedList[index] =
                                        value ?? false;
                                  });
                                  if (value == true) {
                                    // Store the selected ptoduct type name
                                    setState(() {
                                      if (!selectedItems.contains(typeName)) {
                                        selectedItems.add(typeName);
                                      }
                                    });
                                  } else {
                                    // Remove the category name if unchecked
                                    setState(() {
                                      selectedItems.remove(typeName);
                                    });
                                  }
                                  print("Selected items: $selectedItems");

                            
                                },
                              );
                            },
                          ),
                        ],
                      ),
               
                      ExpansionTile(
                        title: const Text('Colors'),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: productColorFilterModel.length,
                            itemBuilder: (context, index) {
                              String typeId =
                                  productColorFilterModel[index].colorID;
                              String colorName =
                                  productColorFilterModel[index].colorName;
                              return CheckboxListTile(
                                activeColor: Colors.brown,
                                title: Text(colorName),
                                value: isColorsCheckedList[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    isColorsCheckedList[index] = value ?? false;
                                  });
                                  if (value == true) {
                                    // Store the selected ptoduct type name
                                    setState(() {
                                      if (!selectedItems.contains(colorName)) {
                                        selectedItems.add(colorName);
                                      }
                                    });
                                  } else {
                                    // Remove the category name if unchecked
                                    setState(() {
                                      selectedItems.remove(colorName);
                                    });
                                  }
                                  print("Selected items: $selectedItems");

                            
                                },
                              );
                            },
                          ),
                        ],
                      ),
               
                      ExpansionTile(
                        title: const Text('Sizes'),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: productSizeFilterModel.length,
                            itemBuilder: (context, index) {
                              String sizeID =
                                  productSizeFilterModel[index].sizeID;
                              String sizeValue =
                                  productSizeFilterModel[index].sizeValue;
                              return CheckboxListTile(
                                activeColor: Colors.brown,
                                title: Text(sizeValue),
                                value: isSizesCheckedList[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    isSizesCheckedList[index] = value ?? false;
                                  });
                                  if (value == true) {
                                    // Store the selected Size name
                                    setState(() {
                                      if (!selectedItems.contains(sizeValue)) {
                                        selectedItems.add(sizeValue);
                                      }
                                    });
                                  } else {
                                    // Remove the category name if unchecked
                                    setState(() {
                                      selectedItems.remove(sizeValue);
                                    });
                                  }
                                  print("Selected items: $selectedItems");

                            
                                },
                              );
                            },
                          ),
                        ],
                      ),
               
                    ],
                  ),
                ),
                
                Visibility(
                  visible: false,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(),
                          onPressed: () {
                            // Save filter logic
                          },
                          child: Text('Save Filter'),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        endDrawerEnableOpenDragGesture:
            false, // Prevents the drawer from opening by swiping
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              pinned: true,
              snap: false,
              toolbarHeight: 50,
              flexibleSpace: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        //Send it to Category Screen Menu
                        if (glb.currentMainCatId.isNotEmpty &&
                            glb.currentCategoryID.isEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoriesPage(
                                main_cat_id: glb.currentMainCatId,
                                main_cat_name: glb.currentMainCategoryName,
                              ),
                            ),
                          );
                        } else if (glb.currentMainCatId.isNotEmpty &&
                            glb.currentCategoryID.isNotEmpty &&
                            glb.currentSubCatID.isEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubCategoryPage(
                                  cat_id: glb.currentCategoryID,
                                  cat_name: glb.currentCategorySelectedName),
                            ),
                          );
                        }
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.grayColor,
                            width: 0.1,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              glb.currentSelectedType,
                              style: nunitoStyle.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.grayColor,
                            width: 0.1,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Filter / Sort',
                              style: nunitoStyle.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 26.0, top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pathName,
                      style: nunitoStyle.copyWith(fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "United Armor's ${categorySelected}",
                      style: poppinsStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, ProductDetailedRoute);
                        },
                        child: Text("(${productItems.length} items)")),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: MasonryGridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 23,
                  itemCount: productItems.length,
                  padding: const EdgeInsets.symmetric(
                    horizontal: kPaddingHorizontal,
                  ),
                  itemBuilder: (context, index) {
                    return SlideFromLeftAnimation(
                      delay: 0.5,
                      child: Builder(builder: (context) {
                        return InkWell(
                          onTap: () {
                            glb.productID = productItems[index].productID;
                            print('productID::${glb.productID}');
                            Navigator.pushNamed(context, ProductDetailedRoute);
                          },
                          child: Ink(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Positioned(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(kBorderRadius),
                                        child: Image.network(
                                          productItems[index].productImage,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 12,
                                      top: 12,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            var productID =
                                                productItems[index].productID;
                                            isFavorite = !isFavorite;
                    
                                            if (isFavorite) {
                                              addToWishlistAsync(productID);
                                            } else {
                                              removeFromWishlistAsync(productID);
                                            }
                                          });
                                        },
                                        child: Container(
                                          height:
                                              SizeConfig.blockSizeVertical! * 4,
                                          width:
                                              SizeConfig.blockSizeVertical! * 4,
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
                                                  : Icons
                                                      .favorite_border_outlined,
                                              color:
                                                  isFavorite ? Colors.red : null,
                                            ),
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
                                ),
                    
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  productItems[index].productName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: kEncodeSansSemibold.copyWith(
                                    color: kDarkBrown,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal! * 3.5,
                                  ),
                                ),
                                // Text(
                                //   'Dress modern',
                                //   maxLines: 1,
                                //   overflow: TextOverflow.ellipsis,
                                //   style: kEncodeSansRagular.copyWith(
                                //     color: kGrey,
                                //     fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            text:
                                                '₹${productItems[index].productPrice}',
                                            style: kEncodeSansSemibold.copyWith(
                                              color: Colors.redAccent,
                                              fontSize: SizeConfig
                                                      .blockSizeHorizontal! *
                                                  3.0,
                                              decoration: TextDecoration
                                                  .lineThrough, // Add strike-through decoration
                                              decorationColor: Colors
                                                  .red, // Color for the strike-through line
                                              decorationThickness:
                                                  5, // Adjust thickness of the strike-through line
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '₹${productItems[index].productOfferPrice}',
                                          style: kEncodeSansSemibold.copyWith(
                                            color: kDarkBrown,
                                            fontSize:
                                                SizeConfig.blockSizeHorizontal! *
                                                    3.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: kYellow,
                                          size: 16,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          productItems[index].productRating,
                                          style: kEncodeSansRagular.copyWith(
                                            color: kDarkBrown,
                                            fontSize:
                                                SizeConfig.blockSizeHorizontal! *
                                                    3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: const Footer_Part(),
            )
          ],
        ),
      ),
    );
  }
bool showLoading = false;
  List<AllProductItems> productItems = [];
  Future loadAllProductsDetailsAsync() async {
    setState(() {
      showLoading = true;
      productItems.length = 0;
      productItems = [];
    });
    try {
      var url = glb.endPointClothing;
      url += "load_all_product_details/"; // Route Name
      var currentID = "", currentKey = "";
      if (glb.currentMainCatId.isNotEmpty && glb.currentCategoryID.isEmpty) {
        currentID = glb.currentMainCatId;
        currentKey = 'main_cat_id';
      } else if (glb.currentMainCatId.isNotEmpty &&
          glb.currentCategoryID.isNotEmpty &&
          glb.currentSubCatID.isEmpty) {
        currentID = glb.currentCategoryID;
        currentKey = 'cat_id';
      } else {
        currentID = glb.currentSubCatID;
        currentKey = 'sub_cat_id';
      }
      final Map dictMap = {
        currentKey: currentID,
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
            for (var ret in queryResult) {
              var productid = ret['productid'].toString();
              var product_name = ret['product_name'].toString();
              var fitting_type = ret['fitting_type'].toString();
              var fitting_id = ret['fitting_id'].toString();
              var main_title_name = ret['main_title_name'].toString();
              var cat_name = ret['cat_name'].toString();
              var sub_cat_name = ret['sub_cat_name'].toString();
              var product_catid = ret['product_catid'].toString();
              var product_category_name =
                  ret['product_category_name'].toString();
              var product_type_id = ret['product_type_id'].toString();
              var roduct_type_name = ret['product_type_name'].toString();
              var price = ret['price'].toString();
              var main_cat_id = ret['main_cat_id'].toString();
              var cat_id = ret['cat_id'].toString();
              var sub_catid = ret['sub_catid'].toString();
              var offer_price = ret['offer_price'].toString();
              var image = ret['image'].toString();
              var size = ret['size'].toString();
              var ratings = ret['ratings'].toString();
              var default_color_id = ret['default_color_id'].toString();
              var color_name = ret['color_name'].toString();
              var color_code = ret['color_code'].toString();

              productItems.add(AllProductItems(
                  productID: productid,
                  productImage: image,
                  productName: product_name,
                  productPrice: price,
                  productOfferPrice: offer_price,
                  productRating: ratings,
                  productCategoryID: product_catid,
                  productFittingID: fitting_id,
                  productFittingType: fitting_type,
                  productMainCatID: main_cat_id,
                  productCatID: cat_id,
                  productSubCatID: sub_catid,
                  productColorID: default_color_id,
                  productColor: color_name,
                  productColorCode: color_code,
                  productColorName: color_name,
                  productSize: size,
                  productMainCatTitle: main_title_name,
                  productCatTitle: cat_name,
                  productSubCatTitle: sub_cat_name));
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

  Future getAllFiltersAsync() async {
    
    try {
      var url = glb.endPointClothing;
      url += "get_all_filters/"; // Route Name

      final Map dictMap = {
        'key': 'value',
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
          glb.showSnackBar(context, 'Error', 'No Filters Found');

          return;
        } else if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');

          return;
        } else {
          try {
            Map<String, dynamic> productMap = json.decode(res);
            // print("productMap:$productMap");
            List<dynamic> productCategoryResult =
                productMap['product_category_data'];
            List<dynamic> productTypeResult = productMap['product_type_data'];
            List<dynamic> colorsResult = productMap['colors'];
            List<dynamic> sizesResult = productMap['sizes'];
            List<dynamic> fittingDataResult = productMap['fitting_data'];

            setState(() {
              productCategoryFilterModel = [];
              productTypeFilterModel = [];
              productColorFilterModel = [];
              productSizeFilterModel = [];
              productFittingFilterModel = [];

              for (var cat in productCategoryResult) {
                var catID = cat['product_catid'].toString();
                var catName = cat['product_category_name'].toString();
                productCategoryFilterModel.add(ProductCategoryFilterModel(
                    productCatID: catID, productCatName: catName));
              }

              isCategoriesCheckedList = List.generate(
                productCategoryFilterModel.length,
                (index) => false,
              );

              for (var type in productTypeResult) {
                var typeID = type['product_type_id'].toString();
                var typeName = type['product_type_name'].toString();
                productTypeFilterModel.add(ProductTypeFilterModel(
                    productTypeID: typeID, productTypeName: typeName));
              }

              isCategoryTypeCheckedList = List.generate(
                productTypeFilterModel.length,
                (index) => false,
              );

              for (var color in colorsResult) {
                var colorID = color['colorsid'].toString();
                var colorName = color['color_name'].toString();
                productColorFilterModel.add(ProductColorFilterModel(
                    colorID: colorID, colorName: colorName));
              }

              isColorsCheckedList = List.generate(
                productColorFilterModel.length,
                (index) => false,
              );

              for (var size in sizesResult) {
                var sizeID = size['sizesid'].toString();
                var sizeValue = size['size_value'].toString();
                productSizeFilterModel.add(ProductSizeFilterModel(
                    sizeID: sizeID, sizeValue: sizeValue));
              }

              isSizesCheckedList = List.generate(
                productSizeFilterModel.length,
                (index) => false,
              );

              for (var fitting in fittingDataResult) {
                var fittingID = fitting['fittingid'].toString();
                var fittingType = fitting['fit_type'].toString();
                productFittingFilterModel.add(ProductFittingFilterModel(
                    fittingID: fittingID, fittingType: fittingType));
              }

              isFittingsCheckedList = List.generate(
                productFittingFilterModel.length,
                (index) => false,
              );
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
      }
    } catch (e) {
      print(e);
      glb.handleErrors(e, context);

      return;
    }
  }

// Badge widget
  Widget buildBadge() {
    return Wrap(
      spacing: 8.0, // Adjust spacing between chips
      runSpacing: 4.0, // Adjust spacing between chip rows
      children: selectedItems.map((itemName) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: kDarkBrown,
            borderRadius: BorderRadius.circular(
                4), // Adjust border radius for the rectangle
          ),
          child: Text(
            itemName,
            style: TextStyle(color: Colors.white, fontSize: 8.0),
          ),
        );
      }).toList(),
    );
  }

}
