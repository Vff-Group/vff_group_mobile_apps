import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_left_animation.dart';
import 'package:vff_group/modals/branches_model.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;
import 'package:vff_group/widgets/shimmer_card.dart';

class AllBranchesPage extends StatefulWidget {
  const AllBranchesPage({super.key});

  @override
  State<AllBranchesPage> createState() => _AllBranchesPageState();
}

class _AllBranchesPageState extends State<AllBranchesPage> {
  bool showLoading = true;
  List<BranchModel> branchModel = [];

  @override
  void initState() {
    super.initState();
    allBranchesAsync();
    setState(() {
      glb.justSaveAddress = true;
    });
  }

  Future allBranchesAsync() async {
    setState(() {
      showLoading = true;
      branchModel = [];
    });
    try {
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['pktType'] = "29";
      dictMap['token'] = "vff";
      dictMap['uid'] = "-1";

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            "Accept": "application/json",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(dictMap));

      if (response.statusCode == 200) {
        var res = response.body;
        if (res.contains("ErrorCode#2")) {
          glb.showSnackBar(context, 'Error', 'No Categories Found');
          return;
        } else if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> branchMap = json.decode(response.body);
            if (kDebugMode) {
              print("branchMap:$branchMap");
            }
            var branch_id = branchMap['branch_id'];
            var branch_name = branchMap['branch_name'];
            var address = branchMap['address'];
            var city = branchMap['city'];
            var state = branchMap['state'];
            var pincode = branchMap['pincode'];

            List<String> branch_idLst = glb.strToLst2(branch_id);
            List<String> branch_nameLst = glb.strToLst2(branch_name);
            List<String> addressLst = glb.strToLst2(address);
            List<String> citylst = glb.strToLst2(city);
            List<String> statelst = glb.strToLst2(state);
            List<String> pincodelst = glb.strToLst2(pincode);

            for (int i = 0; i < branch_idLst.length; i++) {
              var branchID = branch_idLst.elementAt(i).toString();
              var branchName = branch_nameLst.elementAt(i).toString();
              var branchAddress = addressLst.elementAt(i).toString();
              var branchCity = citylst.elementAt(i).toString();
              var branchState = statelst.elementAt(i).toString();
              var branchPincode = pincodelst.elementAt(i).toString();

              branchModel.add(BranchModel(
                  branchID: branchID,
                  branchName: branchName,
                  branchAddress: branchAddress,
                  branchCity: branchCity,
                  branchState: branchState,
                  branchPincode: branchPincode));
            }

            setState(() {
              showLoading = false;
            });
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
            return "Failed";
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      glb.handleErrors(e, context);
    }
  }

  Future<void> _handleRefresh() async {
    allBranchesAsync();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: FadeAnimation(
            delay: 0.3,
            child: Text('Our Branches',
                style: nunitoStyle.copyWith(
                    fontSize: 20.0,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1)),
          )),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showLoading
                ? Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.2),
                      highlightColor: Colors.grey.withOpacity(0.1),
                      enabled: showLoading,
                      child: RefreshIndicator(
                        onRefresh: _handleRefresh,
                        child: ListView.separated(
                            itemCount: 10,
                            separatorBuilder: (context, _) =>
                                SizedBox(height: height * 0.02),
                            itemBuilder: ((context, index) {
                              return const ShimmerCardLayout();
                            })),
                      ),
                    ),
                  )
                : Expanded(
                    child: RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: ListView.builder(
                          itemCount: branchModel.length,
                          itemBuilder: ((context, index) {
                            Color randomColor =
                                glb.generateRandomColorWithOpacity();
                            return SlideFromLeftAnimation(
                              delay: 0.8,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      //Send to Request PickUp Page
                                      glb.branch_id = "";
                                      glb.branch_id =
                                          branchModel[index].branchID;
                                      Navigator.pushNamed(
                                          context, DeliveryAddressRoute);
                                    },
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: AppColors.lightBlackColor,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60,
                                                  height: 60,
                                                      decoration:
                                                          BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    8.0),
                                                        color: glb
                                                            .generateRandomColorWithOpacity(),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Text(
                                                            branchModel[index].branchID,
                                                            style: nunitoStyle
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: AppColors
                                                                        .backColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0,
                                                          left: 8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          branchModel[index]
                                                              .branchName,
                                                          style: nunitoStyle
                                                              .copyWith(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: AppColors
                                                                      .backColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1)),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Text(
                                                            '${branchModel[index].branchAddress} ${branchModel[index].branchCity}\n${branchModel[index].branchState}-${branchModel[index].branchPincode}',
                                                            style: nunitoStyle.copyWith(
                                                                fontSize: 10.0,
                                                                color: AppColors
                                                                    .textColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    1)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })),
                    ),
                  )
          ],
        ),
      )),
    );
  }
}
