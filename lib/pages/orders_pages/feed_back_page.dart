import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vff_group/animation/fade_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class FeedBackPage extends StatefulWidget {
  const FeedBackPage({super.key});

  @override
  State<FeedBackPage> createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  TextEditingController feedBackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          backgroundColor: AppColors.backColor,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: FadeAnimation(
                delay: 0.3,
                child: Text('Feedback 😊',
                    style: ralewayStyle.copyWith(
                        fontSize: 20.0,
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1)),
              )),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15.0,
                              ),
                              Text(
                                  'At VelVet Wash, we are dedicated to providing you with the best laundry service experience. Your feedback is incredibly important to us, as it helps us enhance our services and better meet your needs',
                                  style: ralewayStyle.copyWith(
                                    fontSize: 14.0,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w200,
                                  )),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: AppColors.blueColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 45.0,
                                      top: 22.0,
                                      bottom: 22.0,
                                      left: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.feedback_outlined,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text('Feedback',
                                          style: ralewayStyle.copyWith(
                                            fontSize: 20.0,
                                            color: AppColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text('Enter your valuable feedback',
                                  style: ralewayStyle.copyWith(
                                      fontSize: 20.0,
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1)),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 150.0,
                                    width: width,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: AppColors.lightBlackColor),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        maxLines: 50,
                                        style: nunitoStyle.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.whiteColor,
                                            fontSize: 14.0),
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    top: 16.0),
                                            hintText:
                                                "Let us know how we've met your expectations in terms of laundry quality and cleanliness.",
                                            hintStyle: ralewayStyle.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.whiteColor,
                                                fontSize: 12.0)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SlideFromBottomAnimation(
                            delay: 0.5,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(16.0),
                                child: Ink(
                                  padding: const EdgeInsets.all(18.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      gradient: const LinearGradient(colors: [
                                        AppColors.blueColor,
                                        Colors.blue
                                      ])),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Submit',
                                        style: nunitoStyle.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.whiteColor,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_right_outlined,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
