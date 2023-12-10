import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vff_group/gym_app/common_widgets/round_gradient_button.dart';
import 'package:vff_group/gym_app/common_widgets/round_textfield.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/common/app_styles.dart';
import 'package:vff_group/united_armor_app/common/rounded_button.dart';
import 'package:vff_group/united_armor_app/common/size_config.dart';

class ClothingDeliveryAddressPage extends StatefulWidget {
  const ClothingDeliveryAddressPage({super.key});

  @override
  State<ClothingDeliveryAddressPage> createState() =>
      _ClothingDeliveryAddressPageState();
}

class _ClothingDeliveryAddressPageState
    extends State<ClothingDeliveryAddressPage> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(color: kDarkBrown),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Container(
                      height: SizeConfig.blockSizeVertical! * 4,
                      width: SizeConfig.blockSizeVertical! * 4,
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
                      padding: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          'assets/arrow_back_icon.svg',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                "Delivery Information",
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700),
              ),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 4,
                            decoration: BoxDecoration(
                                color: AppColors.grayColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(3)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Enable hassle-free deliveries by securely adding and managing your preferred delivery addresses with our intuitive address management feature",
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            RoundTextField(
                              hintText: "First Name",
                              icon: "assets/icons/profile_icon.png",
                              textInputType: TextInputType.name,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            RoundTextField(
                                hintText: "Last Name",
                                icon: "assets/icons/profile_icon.png",
                                textInputType: TextInputType.name),
                            SizedBox(
                              height: 15,
                            ),
                            RoundTextField(
                                hintText: "Email",
                                icon: "assets/icons/message_icon.png",
                                textInputType: TextInputType.emailAddress),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.1,
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundDarkButton(title: "CHECKOUT", onPressed: () {
                        Navigator.pushNamed(context, PaymentClothingRoute);
                      })
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
