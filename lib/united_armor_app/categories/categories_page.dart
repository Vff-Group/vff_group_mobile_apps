import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/views/sub_categories/sub_categories_page.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

class CategoriesPage extends StatefulWidget {
  const CategoriesPage(
      {super.key, required this.main_cat_id, required this.main_cat_name});
  final String main_cat_id;
  final String main_cat_name;
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List categories = [];
  List categoriesID = [];

  bool showCategoryLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllCategoriesAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Divider(
            color: AppColors.greyColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      "assets/logo/logo_united_armor.png",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
          Divider(
            color: AppColors.greyColor,
          ),
          InkWell(
            onTap: () {
              glb.currentSelectedType = widget.main_cat_name;
              glb.currentMainCatId = widget.main_cat_id;
              glb.currentCategoryID = "";
              glb.currentSubCatID = "";
              glb.currentSubCategoryName = "";
              glb.currentCategorySelectedName = "";
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushNamed(context, AllProductsRoute);
            },
            child: Ink(
              color: AppColors.lightGreyColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'All ${widget.main_cat_name}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: categoriesID.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        glb.currentSelectedType = categories[index];
                        glb.currentMainCatId = widget.main_cat_id;
                        glb.currentCategoryID = categoriesID[index];
                        glb.currentSubCatID = "";
                        glb.currentSubCategoryName = "";
                        glb.currentCategorySelectedName = categories[index];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubCategoryPage(
                                cat_id: categoriesID[index],
                                cat_name: categories[index]),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16.0),
                      child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  categories[index],
                                  style: nunitoStyle.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: AppColors.greyColor,
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                );
              })
        ],
      )),
    );
  }

  Future loadAllCategoriesAsync() async {
    setState(() {
      showCategoryLoading = true;
      categories = [];
      categoriesID = [];
    });
    try {
      var url = glb.endPointClothing;
      url += "get_categories/"; // Route Name

      final Map dictMap = {
        'main_cat_id': widget.main_cat_id,
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

}
