// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vff_group/modals/dry_clean_items_model.dart';
import 'package:vff_group/pages/cart/item_cart_details_dry_clean.dart';
import 'package:vff_group/pages/cart/sections_page_dry_clean.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:http/http.dart' as http;
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:vff_group/widgets/shimmer_card.dart';

class DryCleaningCart extends StatefulWidget {
  final String catId;
  final String catName;
  final String catImage;
  const DryCleaningCart(
      {super.key,
      required this.catId,
      required this.catName,
      required this.catImage});

  @override
  State<DryCleaningCart> createState() => _DryCleaningCartState();
}

class _DryCleaningCartState extends State<DryCleaningCart> {
  bool _noOrders = false, showLoading = true;
  var orderQuantity = "0";
  List<DryCleanItemModel> dryCleanItemModel = [];

  List<String> sub_catidLst = [];
  List<String> subcat_imgLst = [];
  List<String> item_costLst = [];
  List<String> section_typeLst = [];
  List<String> type_ofLst = [];
  List<String> sub_categorynameLst = [];

  Future loadDryCleanItems() async {
    setState(() {
      showLoading = true;
      sub_catidLst = [];
      subcat_imgLst = [];
      item_costLst = [];
      section_typeLst = [];
      type_ofLst = [];
      sub_categorynameLst = [];
    });

    // if (glb.orderid.isEmpty) {
    //   glb.showSnackBar(context, 'Alert!', 'Please Select the Active Order');
    //   Navigator.pop(context);
    //   return;
    // }

    try {
      var url = glb.endPoint;
      url+="load_sub_category_wise_details/";
      final Map dictMap = {};

      dictMap['cat_id'] = widget.catId;
      // dictMap['pktType'] = "13";
      // dictMap['token'] = "vff";
      // dictMap['uid'] = "-1";

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            "Accept": "application/json",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(dictMap));

      if (response.statusCode == 200) {
        var res = response.body;
        if (res.contains("ErrorCode#2")) {
          setState(() {
            showLoading = false;
          });
          glb.showSnackBar(context, 'Error', 'No Category Details Found');

          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showLoading = false;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          //Navigator.pop(context);
          return;
        } else {
          try {
            Map<String, dynamic> dryMap = json.decode(response.body);

            var sub_categoryname = dryMap['sub_categoryname'];
            var subcat_img = dryMap['subcat_img'];
            var item_cost = dryMap['cost'];
            var section_type = dryMap['section_type'];
            var type_of = dryMap['type_of'];

            var sub_catid = dryMap['sub_catid'];

            sub_catidLst = glb.strToLst2(sub_catid);
            subcat_imgLst = glb.strToLst2(subcat_img);
            item_costLst = glb.strToLst2(item_cost);
            section_typeLst = glb.strToLst2(section_type);
            type_ofLst = glb.strToLst2(type_of);
            sub_categorynameLst = glb.strToLst2(sub_categoryname);

            setState(() {
              showLoading = false;
            });
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
            setState(() {
              showLoading = false;
            });
            return "Failed";
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        showLoading = false;
      });
      glb.handleErrors(e, context);
    }
  }

  Future<void> _handleRefresh() async {
    Future.delayed(const Duration(milliseconds: 5));
    loadDryCleanItems();
  }

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('CategoryNamee::${widget.catImage}');
    loadDryCleanItems();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: DefaultTabController(
          length: section_typeLst.length,
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: width * 0.01,
              ),
              ButtonsTabBar(
                backgroundColor: AppColors.blueColor,
                unselectedBackgroundColor: AppColors.lightBlackColor,
                unselectedLabelStyle:
                    nunitoStyle.copyWith(color: AppColors.textColor),
                labelStyle: nunitoStyle.copyWith(color: AppColors.whiteColor),
                tabs: section_typeLst.asMap().entries.map((entry) {
                  int index = entry.key;
                  String catName = entry.value;

                  Tab tabBar;

                  tabBar = Tab(
                    text: catName,
                    // Pass the catId to the Tab
                  );

                  return tabBar;
                }).toList(),
              ),
              Expanded(
                child: TabBarView(
                  children:
                      section_typeLst.asMap().entries.map<Widget>((entry) {
                    int index = entry.key;
                    String catId = entry.value;
                    String sectionType = section_typeLst[index];

                    Widget categoryScreen;

                    categoryScreen = SectionsPageDryClean(
                      catId: widget.catId,
                      catName: widget.catName,
                      catImage: widget.catImage,
                      sectionType: sectionType,
                    );

                    return categoryScreen;
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
