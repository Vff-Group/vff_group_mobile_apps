import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vff_group/united_armor_app/categories/categories_page.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/views/sub_categories/sub_categories_page.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

class MainCategoryPage extends StatefulWidget {
  const MainCategoryPage({super.key});

  @override
  State<MainCategoryPage> createState() => _MainCategoryPageState();
}

class _MainCategoryPageState extends State<MainCategoryPage> {
  List mainCategories = [];
  List mainCategoriesID = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllMainCategoriesAsync();
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
              Icon(
                Icons.abc,
                color: Colors.white,
              ),
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
          SizedBox(
            height: 20,
          ),
          ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: mainCategoriesID.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        glb.currentMainCatId = mainCategoriesID[index];
                        glb.currentMainCategoryName = mainCategories[index];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoriesPage(
                              main_cat_id: mainCategoriesID[index],
                              main_cat_name: mainCategories[index],
                            ),
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
                                  mainCategories[index],
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

  bool showLoading = false;
  Future loadAllMainCategoriesAsync() async {
    setState(() {
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
            // print("MainCategoryMap:$MainCategoryMap");
            List<dynamic> queryResult = MainCategoryMap['query_result'];
            for (var feeDetail in queryResult) {
              var main_title_name = feeDetail['main_title_name'].toString();
              var main_cat_id = feeDetail['main_cat_id'].toString();
              mainCategories.add(main_title_name);
              mainCategoriesID.add(main_cat_id);
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