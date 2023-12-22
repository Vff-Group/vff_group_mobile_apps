import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/categories/categories_page.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/common/common_app_car.dart';
import 'package:vff_group/united_armor_app/common/footer_widget.dart';
import 'package:vff_group/united_armor_app/common/rounded_button.dart';
import 'package:vff_group/united_armor_app/common/size_config.dart';
import 'package:vff_group/united_armor_app/views/all_products/models/all_product_item.dart';
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
  List images = [
    "https://underarmour.scene7.com/is/image/Underarmour/V5-1388408-390_FC?rp=standard-0pad%7CgridTileDesktop&scl=1&fmt=jpg&qlt=30&resMode=sharp2&cache=on%2Con&bgc=F0F0F0&wid=512&hei=640&size=512%2C640",
    "https://underarmour.scene7.com/is/image/Underarmour/V5-1373880-012_FC?rp=standard-0pad%7CgridTileDesktop&scl=1&fmt=jpg&qlt=30&resMode=sharp2&cache=on%2Con&bgc=F0F0F0&wid=512&hei=640&size=512%2C640",
    "https://underarmour.scene7.com/is/image/Underarmour/V5-1373359-001_FC?rp=standard-0pad%7CgridTileDesktop&scl=1&fmt=jpg&qlt=30&resMode=sharp2&cache=on%2Con&bgc=F0F0F0&wid=512&hei=640&size=512%2C640",
    "https://underarmour.scene7.com/is/image/Underarmour/V5-1373357-014_FC?rp=standard-0pad%7CgridTileDesktop&scl=1&fmt=jpg&qlt=30&resMode=sharp2&cache=on%2Con&bgc=F0F0F0&wid=512&hei=640&size=512%2C640",
    "https://underarmour.scene7.com/is/image/Underarmour/V5-1366072-100_FC?rp=standard-0pad%7CgridTileDesktop&scl=1&fmt=jpg&qlt=30&resMode=sharp2&cache=on%2Con&bgc=F0F0F0&wid=512&hei=640&size=512%2C640"
  ];

  List item_names = [
    "Men's UA Icon Charged Cotton® Short Sleeve",
    "Men's UA Essential Fleece Hoodie",
    "Men's Armour Fleece® Twist ¼ Zip",
    "Men's Armour Fleece® Full-Zip Hoodie",
    "Men's ColdGear® Compression Mock"
  ];

  List item_prices = [
    "₹6,999",
    "₹3,799",
    "₹2,499",
    "₹3,499",
    "₹4,299",
  ];

  List item_rating = ["4", "5", "4.5", "4.3", "5"];

  Map<String, bool> _filterOptions = {
    'Clothing': false,
    'Shoes': false,

    // Add more filter categories here
  };
  bool isFavorite = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Navigator.pop(context);
  }
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
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: kDarkBrown,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MenuRoute);
            },
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            )),
          actions: [
            
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
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Clear All',
                        style: nunitoStyle.copyWith(
                            fontSize: 12, decoration: TextDecoration.underline),
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
                Expanded(
                  child: ListView(
                    children: [
                      ExpansionTile(
                        title: const Text('Product Category'),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filterOptions.length,
                            itemBuilder: (context, index) {
                              String key = _filterOptions.keys.elementAt(index);
                              return CheckboxListTile(
                                activeColor: kDarkBrown,
                                title: Text(key),
                                value: _filterOptions[key],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _filterOptions[key] = value!;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: const Text('Product Type'),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filterOptions.length,
                            itemBuilder: (context, index) {
                              String key = _filterOptions.keys.elementAt(index);
                              return CheckboxListTile(
                                activeColor: kDarkBrown,
                                title: Text(key),
                                value: _filterOptions[key],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _filterOptions[key] = value!;
                                  });
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
                            itemCount: _filterOptions.length,
                            itemBuilder: (context, index) {
                              String key = _filterOptions.keys.elementAt(index);
                              return CheckboxListTile(
                                activeColor: kDarkBrown,
                                title: Text(key),
                                value: _filterOptions[key],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _filterOptions[key] = value!;
                                  });
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
                            itemCount: _filterOptions.length,
                            itemBuilder: (context, index) {
                              String key = _filterOptions.keys.elementAt(index);
                              return CheckboxListTile(
                                activeColor: kDarkBrown,
                                title: Text(key),
                                value: _filterOptions[key],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _filterOptions[key] = value!;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: const Text('Prices'),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filterOptions.length,
                            itemBuilder: (context, index) {
                              String key = _filterOptions.keys.elementAt(index);
                              return CheckboxListTile(
                                activeColor: kDarkBrown,
                                title: Text(key),
                                value: _filterOptions[key],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _filterOptions[key] = value!;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: const Text('Fit'),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filterOptions.length,
                            itemBuilder: (context, index) {
                              String key = _filterOptions.keys.elementAt(index);
                              return CheckboxListTile(
                                activeColor: kDarkBrown,
                                title: Text(key),
                                value: _filterOptions[key],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _filterOptions[key] = value!;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
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
            padding: const EdgeInsets.only(left:26.0,top: 10.0),
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
                  fontWeight: FontWeight.bold,fontSize: 18.0,color: Colors.black
                ),),
                SizedBox(height: 5.0,),
                    Text("(${productItems.length} items)"),
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
                return InkWell(
                  onTap: () {
                    // glb.imagePath = 'assets/images/${images[index]}';
                    //Navigator.pushNamed(context, ProductDetailsRoute);
                  },
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
                              onTap: () {},
                                  child: SvgPicture.asset(
                                    isFavorite
                                        ? 'assets/favorite_cloth_icon_selected.svg' // Path to selected icon
                                        : 'assets/favorite_cloth_icon_unselected.svg', // Path to unselected icon
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
                              color: kDarkBrown,
                          fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                              Column(
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text:
                                          '₹${productItems[index].productPrice}',
                                      style: kEncodeSansSemibold.copyWith(
                                        color: AppColors.grayColor,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal! *
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
                                          SizeConfig.blockSizeHorizontal! * 3.0,
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
                                      SizeConfig.blockSizeHorizontal! * 3,
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
          ),
        ),
          SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 15.0,),
              
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
            print("productMap:$productMap");
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

}
