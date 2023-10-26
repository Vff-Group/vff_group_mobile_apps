import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vff_group/animation/scale_and_revert_animation.dart';
import 'package:vff_group/animation/slide_bottom_animation.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
     
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              PageView.builder(
                  itemCount: data.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => SlideFromBottomAnimation(
                        delay: index * 0.5,
                        child: OnBoardContent(
                          image: data[index].image,
                          title: data[index].title,
                          description: data[index].description,
                        ),
                      )),
              Row(
                children: [
                  ...List.generate(
                    data.length,
                    (index) => Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: DotIndicator(
                          isActive: index == _pageIndex,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                          if (_pageIndex == 3) {
                            SharedPreferenceUtils.save_val('firstRun', '1');
                            Navigator.pushReplacementNamed(context, LoginRoute);
                          }
                        },
                        style:
                            ElevatedButton.styleFrom(shape: const CircleBorder()),
                        child: const Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    Key? key,
    this.isActive = false,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 4,
      height: isActive ? 12 : 4,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.blueDarkColor
            : AppColors.blueDarkColor.withOpacity(0.4),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class Onboard {
  final String image, title, description;

  Onboard(
      {required this.image, required this.title, required this.description});
}

final List<Onboard> data = [
  Onboard(
      image: 'assets/logo/logo.png',
      title: 'Welcome to VFF Group Laundry',
      description:
          'Experience seamless and efficient laundry services\n with VFF Group Laundry.\n Let us take care of your laundry needs'),
  Onboard(
      image: 'assets/onboards/board1.png',
      title: 'Pick Up',
      description:
          'With VFF Group Laundry, schedule pickups, track your laundry,\n and set preferences effortlessly.\n Laundry made easy for you.'),
  Onboard(
      image: 'assets/onboards/board2.png',
      title: 'Wash',
      description:
          'Trust VFF Group Laundry to provide top-notch laundry care.\n Your clothes deserve the best treatment, and we deliver just that.'),
  Onboard(
      image: 'assets/onboards/board3.png',
      title: 'Delivery',
      description:
          "Become a part of the VFF Group Laundry family.\n Enjoy a personalized laundry experience and reliable service.\n Let's get started!"),
];

class OnBoardContent extends StatelessWidget {
  const OnBoardContent({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                SharedPreferenceUtils.save_val('firstRun', '1');
                Navigator.pushReplacementNamed(context, LoginRoute);
              },
              child: Text(
                'Skip',
                style: ralewayStyle.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: AppColors.neonColor,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Image.asset(
          image,
          height: 400,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: nunitoStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.neonColor,
            fontSize: 24.0
            ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          description,
          textAlign: TextAlign.center,
          style: nunitoStyle.copyWith(
            color: AppColors.whiteColor,
            
            fontSize: 12.0
            ),
        ),
        const Spacer()
      ],
    );
  }
}
