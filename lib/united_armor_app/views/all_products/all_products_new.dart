import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/common/common_app_car.dart';
import 'package:vff_group/united_armor_app/common/footer_widget.dart';
import 'package:vff_group/united_armor_app/common/size_config.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;

class AllNewProductsPage extends StatefulWidget {
  const AllNewProductsPage({super.key});

  @override
  State<AllNewProductsPage> createState() => _AllNewProductsPageState();
}

class _AllNewProductsPageState extends State<AllNewProductsPage> {
String pathName="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(glb.currentMainCatId.isNotEmpty && glb.currentCategoryID.isNotEmpty && glb.currentSubCatID.isNotEmpty){
      
      pathName = "${glb.currentMainCategoryName}/${glb.currentCategorySelectedName}/${glb.currentSubCategoryName}";
    }else if(glb.currentMainCatId.isNotEmpty && glb.currentCategoryID.isEmpty){
      pathName = "${glb.currentMainCategoryName}";
    }else if(glb.currentMainCatId.isNotEmpty && glb.currentCategoryID.isNotEmpty && glb.currentSubCatID.isEmpty){
      pathName = "${glb.currentMainCategoryName}/${glb.currentCategorySelectedName}";
    }else{
      pathName = "${glb.currentMainCategoryName}";
    }
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      home: Scaffold(
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
                child: Container(
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
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
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
                          fontSize: 12,
                          fontWeight: FontWeight.bold
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
                
                Text(pathName),
                SizedBox(height: 10.0,),
                Text("United Armor's ${glb.currentCategorySelectedName}",style: poppinsStyle.copyWith(
                  fontWeight: FontWeight.bold,fontSize: 18.0,color: Colors.black
                ),),
                SizedBox(height: 5.0,),

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
              itemCount: 10,
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
                                'https://underarmour.scene7.com/is/image/Underarmour/V5-1373359-001_FC?rp=standard-0pad%7CpdpMainDesktop&scl=1&fmt=jpg&qlt=75&resMode=sharp2&cache=on%2Con&bgc=F0F0F0&wid=566&hei=708&size=566%2C708',
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
                        'Name',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: kEncodeSansSemibold.copyWith(
                          color: kGrey,
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
                            "Rs.12/-",
                            style: kEncodeSansSemibold.copyWith(
                              color: kDarkBrown,
                              fontSize:
                                  SizeConfig.blockSizeHorizontal! * 3.0,
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
                                '4',
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
}
