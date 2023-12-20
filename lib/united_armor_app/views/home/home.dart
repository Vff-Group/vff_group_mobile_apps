import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/common/size_config.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;
import 'package:vff_group/united_armor_app/views/all_products/all_products.dart';
import 'package:vff_group/united_armor_app/views/all_products/models/all_product_item.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List mainCategories = [];
  List mainCategoriesID = [];
  List categories = [];
  List categoriesID = [];
  List sub_categories = [];
  List sub_categoriesID = [];
  String selectedMainCatID = "";
  String selectedCatID = "";
  String selectedSubCatID = "";
  // List<String> icons = [
  //   'all_items_icon',
  //   'hat_icon',
  //   'dress_icon',
  //   'watch_icon',
  //   'watch_icon',

  // ];

  List<String> images = [
    'image-01.png',
    'image-02.png',
    'image-03.png',
    'image-04.png',
    'image-05.jpg',
    'image-06.jpg',
    'image-07.jpg',
    'image-08.jpg',
  ];

  int current = 0;
  int currentCategory = 0;
  int currentSubCategory = 0;
  bool showLoading = false;
  bool showCategoryLoading = false;
  bool showSubCategoryLoading = false;
  bool showProductsLoading = false;
  List<AllProductItems> productItems = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllMainCategoriesAsync();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hello, Welcome 👋',
                      style: kEncodeSansRagular.copyWith(
                        color: kDarkBrown,
                        fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
                      ),
                    ),
                    Text(
                      'Shaheed',
                      style: kEncodeSansBold.copyWith(
                        color: kDarkBrown,
                        fontSize: SizeConfig.blockSizeHorizontal! * 4,
                      ),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, NotificationScreenRoute);
                    },
                    icon: Image.asset(
                      "assets/icons/notification_icon.png",
                      width: 25,
                      height: 25,
                      fit: BoxFit.fitHeight,
                    ))
                // const CircleAvatar(
                //   radius: 20,
                //   backgroundColor: kGrey,
                //   backgroundImage: NetworkImage(
                //       'https://randomuser.me/api/portraits/men/90.jpg'),
                // )
              ],
            ),
          ),
          
          const SizedBox(
            height: 24,
          ),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: showLoading
                ? Center(child: CircularProgressIndicator())
                : mainCategories.length == 0
                    ? Center(child: Text('No Main Category Found'))
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: mainCategories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                current = index;
                                selectedMainCatID = "";
                                selectedMainCatID = mainCategoriesID[index];
                                loadAllCategoriesAsync();
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                left: index == 0 ? kPaddingHorizontal : 15,
                                right: index == mainCategories.length - 1
                                    ? kPaddingHorizontal
                                    : 0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              height: 36,
                              decoration: BoxDecoration(
                                color: current == index ? kBrown : kWhite,
                                borderRadius: BorderRadius.circular(8),
                                border: current == index
                                    ? null
                                    : Border.all(
                                        color: kLightGrey,
                                        width: 1,
                                      ),
                              ),
                              child: Row(
                                children: [
                                  // SvgPicture.asset(current == index
                                  //     ? 'assets/${icons[index]}_selected.svg'
                                  //     : 'assets/${icons[index]}_unselected.svg'),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    mainCategories[index],
                                    style: kEncodeSansMedium.copyWith(
                                      color: current == index
                                          ? kWhite
                                          : kDarkBrown,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal! * 3,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: showCategoryLoading && showLoading == false
                ? Center(child: CircularProgressIndicator())
                : categories.length == 0 && showLoading == false
                    ? Center(child: Text('No Category Item Found'))
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: categories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                currentCategory = index;
                              });
                              selectedCatID = "";
                              selectedCatID = categoriesID[index];
                              loadAllSubCategoriesAsync();
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                left: index == 0 ? kPaddingHorizontal : 15,
                                right: index == categories.length - 1
                                    ? kPaddingHorizontal
                                    : 0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              height: 36,
                              decoration: BoxDecoration(
                                color:
                                    currentCategory == index ? kBrown : kWhite,
                                borderRadius: BorderRadius.circular(8),
                                border: currentCategory == index
                                    ? null
                                    : Border.all(
                                        color: kLightGrey,
                                        width: 1,
                                      ),
                              ),
                              child: Row(
                                children: [
                                  // SvgPicture.asset(current == index
                                  //     ? 'assets/${icons[index]}_selected.svg'
                                  //     : 'assets/${icons[index]}_unselected.svg'),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    categories[index],
                                    style: kEncodeSansMedium.copyWith(
                                      color: currentCategory == index
                                          ? kWhite
                                          : kDarkBrown,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal! * 3,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: categories.length == 0
                ? SizedBox()
                : showSubCategoryLoading && showLoading == false
                    ? Center(child: CircularProgressIndicator())
                    : (sub_categories.length == 0) &&
                            showLoading == false &&
                            showCategoryLoading == false
                        ? Center(child: Text('No Sub Items Found'))
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: sub_categories.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentSubCategory = index;
                                    selectedSubCatID = "";
                                    selectedSubCatID = sub_categoriesID[index];
                                    print(
                                        "selectedSubCatID::$selectedSubCatID");
                                    loadProductDetailsAsync();
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: index == 0 ? kPaddingHorizontal : 15,
                                    right: index == sub_categories.length - 1
                                        ? kPaddingHorizontal
                                        : 0,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: currentSubCategory == index
                                        ? kBrown
                                        : kWhite,
                                    borderRadius: BorderRadius.circular(8),
                                    border: currentSubCategory == index
                                        ? null
                                        : Border.all(
                                            color: kLightGrey,
                                            width: 1,
                                          ),
                                  ),
                                  child: Row(
                                    children: [
                                      // SvgPicture.asset(current == index
                                      //     ? 'assets/${icons[index]}_selected.svg'
                                      //     : 'assets/${icons[index]}_unselected.svg'),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        sub_categories[index],
                                        style: kEncodeSansMedium.copyWith(
                                          color: currentSubCategory == index
                                              ? kWhite
                                              : kDarkBrown,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal! *
                                                  3,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
          SizedBox(
            height: 15,
          ),
          sub_categories.length == 0
              ? SizedBox()
              : showProductsLoading && showSubCategoryLoading == false
                  ? Center(child: CircularProgressIndicator())
                  : productItems.length == 0 && showSubCategoryLoading == false
                      ? Center(child: Text('No Products Found'))
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kPaddingHorizontal,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      style: kEncodeSansRagular.copyWith(
                                        color: kDarkGrey,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal! *
                                                3.5,
                                      ),
                                      controller: TextEditingController(),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 13,
                                        ),
                                        prefixIcon: const IconTheme(
                                          data: IconThemeData(
                                            color: kDarkGrey,
                                          ),
                                          child: Icon(Icons.search),
                                        ),
                                        hintText: 'Search Product',
                                        border: kInputBorder,
                                        errorBorder: kInputBorder,
                                        disabledBorder: kInputBorder,
                                        focusedBorder: kInputBorder,
                                        focusedErrorBorder: kInputBorder,
                                        enabledBorder: kInputBorder,
                                        hintStyle: kEncodeSansRagular.copyWith(
                                          color: kDarkGrey,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal! *
                                                  3.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                      height: 49,
                                      width: 49,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            kBorderRadius),
                                        color: kBlack,
                                      ),
                                      child: const Icon(
                                        Icons.filter_alt_rounded,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            MasonryGridView.count(
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
                                return InkWell(
                                  onTap: () {
                                    // glb.imagePath = 'assets/images/${images[index]}';
                                    //Navigator.pushNamed(context, ProductDetailsRoute);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Positioned(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kBorderRadius),
                                              child: Image.network(
                                                productItems[index]
                                                    .productImage,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 12,
                                            top: 12,
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: SvgPicture.asset(
                                                'assets/favorite_cloth_icon_unselected.svg',
                                              ),
                                            ),
                                          )
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
                                          color: kGrey,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal! *
                                                  3.5,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Rs.${productItems[index].productPrice}/-",
                                            style: kEncodeSansSemibold.copyWith(
                                              color: kDarkBrown,
                                              fontSize: SizeConfig
                                                      .blockSizeHorizontal! *
                                                  3.0,
                                            ),
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
                                                productItems[index]
                                                    .productRating,
                                                style:
                                                    kEncodeSansRagular.copyWith(
                                                  color: kDarkBrown,
                                                  fontSize: SizeConfig
                                                          .blockSizeHorizontal! *
                                                      3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        )
  
        ],
      ),
    );
  }

  Future loadAllMainCategoriesAsync() async {
    setState(() {
      selectedMainCatID = "";

      showLoading = true;
    });
    try {
      var url = glb.endPointClothing;
      url += "get_main_categories/"; // Route Name
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
            print("MainCategoryMap:$MainCategoryMap");
            List<dynamic> queryResult = MainCategoryMap['query_result'];
            for (var feeDetail in queryResult) {
              var main_title_name = feeDetail['main_title_name'].toString();
              var main_cat_id = feeDetail['main_cat_id'].toString();
              mainCategories.add(main_title_name);
              mainCategoriesID.add(main_cat_id);
            }
            loadAllCategoriesAsync();
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

  Future loadAllCategoriesAsync() async {
    setState(() {
      showCategoryLoading = true;
      categories = [];
      categoriesID = [];
      sub_categories = [];
      sub_categoriesID = [];
      selectedCatID = "";
      selectedSubCatID = "";
    });
    try {
      if (mainCategories.length == 0) {
        return;
      }
      if (selectedMainCatID.isEmpty) {
        selectedMainCatID = mainCategoriesID[0];
      }

      var url = glb.endPointClothing;
      url += "get_categories/"; // Route Name

      final Map dictMap = {
        'main_cat_id': selectedMainCatID,
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
          glb.showSnackBar(context, 'Error', 'No Data Found');
          setState(() {
            showCategoryLoading = false;
          });
          return;
        } else if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          setState(() {
            showCategoryLoading = false;
          });
          return;
        } else {
          try {
            Map<String, dynamic> CategoryMap = json.decode(res);
            print("CategoryMap:$CategoryMap");
            List<dynamic> queryResult = CategoryMap['query_result'];
            for (var feeDetail in queryResult) {
              var catid = feeDetail['catid'].toString();
              var cat_name = feeDetail['cat_name'].toString();
              categories.add(cat_name);
              categoriesID.add(catid);
            }
            setState(() {
              showCategoryLoading = false;
            });
            loadAllSubCategoriesAsync();
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
          showCategoryLoading = false;
        });
      }
    } catch (e) {
      print(e);
      glb.handleErrors(e, context);
      setState(() {
        showCategoryLoading = false;
      });
      return;
    }
  }

  Future loadAllSubCategoriesAsync() async {
    setState(() {
      showSubCategoryLoading = true;
      sub_categories = [];
      sub_categoriesID = [];
      productItems = [];
      currentSubCategory = 0;
      selectedSubCatID = "";
    });
    try {
      if (categories.length == 0) {
        setState(() {
          showSubCategoryLoading = false;
        });
        return;
      }
      if (selectedCatID.isEmpty) {
        selectedCatID = categoriesID[0];
      }

      var url = glb.endPointClothing;
      url += "get_sub_categories/"; // Route Name

      final Map dictMap = {
        'cat_id': selectedCatID,
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
          glb.showSnackBar(context, 'Error', 'No Data Found');
          setState(() {
            showSubCategoryLoading = false;
          });
          return;
        } else if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          setState(() {
            showSubCategoryLoading = false;
          });
          return;
        } else {
          try {
            Map<String, dynamic> SubCategoryMap = json.decode(res);
            print("SubCategoryMap:$SubCategoryMap");
            List<dynamic> queryResult = SubCategoryMap['query_result'];
            for (var feeDetail in queryResult) {
              var sub_catid = feeDetail['sub_catid'].toString();
              var sub_cat_name = feeDetail['sub_cat_name'].toString();
              sub_categories.add(sub_cat_name);
              sub_categoriesID.add(sub_catid);
            }
            setState(() {
              showSubCategoryLoading = false;
            });
            loadProductDetailsAsync();
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
          showSubCategoryLoading = false;
        });
      }
    } catch (e) {
      print(e);
      glb.handleErrors(e, context);
      setState(() {
        showSubCategoryLoading = false;
      });
      return;
    }
  }

  Future loadProductDetailsAsync() async {
    setState(() {
      showProductsLoading = true;
      productItems = [];
    });
    try {
      var url = glb.endPointClothing;
      url += "load_all_product_details/"; // Route Name
      if (selectedSubCatID.isEmpty) {
        selectedSubCatID = sub_categoriesID[0];
      }
      final Map dictMap = {
        'sub_cat_id': selectedSubCatID,
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
          glb.showSnackBar(context, 'Error', 'No Data Found');
          setState(() {
            showProductsLoading = false;
          });
          return;
        } else if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          setState(() {
            showProductsLoading = false;
          });
          return;
        } else {
          try {
            Map<String, dynamic> Products_Map = json.decode(res);
            print("Products_Map:$Products_Map");
            List<dynamic> queryResult = Products_Map['query_result'];
            for (var row in queryResult) {
              var productid = row['productid'].toString();
              var product_name = row['product_name'].toString();
              var price = row['price'].toString();
              var image = row['image'].toString();
              var ratings = row['ratings'].toString();
              productItems.add(AllProductItems(
                  productID: productid,
                  productImage: image,
                  productName: product_name,
                  productPrice: price,
                  productRating: ratings));
            }
            setState(() {
              showProductsLoading = false;
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
          showProductsLoading = false;
        });
      }
    } catch (e) {
      print(e);
      glb.handleErrors(e, context);
      setState(() {
        showProductsLoading = false;
      });
      return;
    }
  }

}
