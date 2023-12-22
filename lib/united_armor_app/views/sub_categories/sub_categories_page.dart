import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/views/all_products/all_products.dart';
import 'package:vff_group/utils/app_colors.dart';

import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

class SubCategoryPage extends StatefulWidget {
  const SubCategoryPage(
      {super.key, required this.cat_id, required this.cat_name});
  final String cat_id;
  final String cat_name;
  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  List sub_categories = [];
  List sub_categoriesID = [];
  bool showSubCategoryLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllSubCategoriesAsync();
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
              glb.currentSelectedType = widget.cat_name;
              glb.currentCategoryID = widget.cat_id;
              glb.currentSubCatID = "";
              glb.currentSubCategoryName = "";
              glb.currentCategoryID = widget.cat_id;
              Navigator.pop(context);
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
                      'All ${widget.cat_name}',
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
              itemCount: sub_categoriesID.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        glb.currentSelectedType = sub_categories[index];
                        glb.currentCategoryID = widget.cat_id;
                        glb.currentSubCatID = sub_categoriesID[index];
                        glb.currentSubCategoryName = sub_categories[index];

                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AllProductsRoute);
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
                                  sub_categories[index],
                                  style: nunitoStyle.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
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

  Future loadAllSubCategoriesAsync() async {
    setState(() {
      showSubCategoryLoading = true;
      sub_categories = [];
      sub_categoriesID = [];
    });
    try {
      var url = glb.endPointClothing;
      url += "get_sub_categories/"; // Route Name

      final Map dictMap = {
        'cat_id': widget.cat_id,
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
}
