import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/common/size_config.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;
import 'package:vff_group/united_armor_app/views/all_products/models/all_product_item.dart';
import 'package:vff_group/widgets/segments_tab.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key, required this.productItems});
  final List<AllProductItems> productItems;
  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  bool showLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('widget.productItems[index].productImage::${widget.productItems[0].productImage}');
  }
  @override
  Widget build(BuildContext context) {
    return Column(
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
                    fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
                  ),
                  controller: TextEditingController(),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
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
                      fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
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
                    borderRadius: BorderRadius.circular(kBorderRadius),
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
          itemCount: widget.productItems.length,
          padding: const EdgeInsets.symmetric(
            horizontal: kPaddingHorizontal,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // glb.imagePath = 'assets/images/${images[index]}';
                Navigator.pushNamed(context, ProductDetailsRoute);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Positioned(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                          child: Image.network(
                            widget.productItems[index].productImage,
                            
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
                    widget.productItems[index].productName,
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
                      Text(
                        widget.productItems[index].productPrice,
                        style: kEncodeSansSemibold.copyWith(
                          color: kDarkBrown,
                          fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
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
                            widget.productItems[index].productRating,
                            style: kEncodeSansRagular.copyWith(
                              color: kDarkBrown,
                              fontSize: SizeConfig.blockSizeHorizontal! * 3,
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
    );
  
  }
}
