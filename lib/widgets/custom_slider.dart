import 'dart:async';

import 'package:flutter/material.dart';
class AutoSlider extends StatefulWidget {
  final List<Widget> slides;
  final Duration autoSlideDuration;

  AutoSlider({
    required this.slides,
    this.autoSlideDuration = const Duration(seconds: 2),
  });

  @override
  _AutoSliderState createState() => _AutoSliderState();
}

class _AutoSliderState extends State<AutoSlider> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    // Start auto-slide timer
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(widget.autoSlideDuration, (timer) {
      if (_currentPage < widget.slides.length - 1) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      } else {
        _currentPage = 0;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 200,
      width: width,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: widget.slides,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
           _buildDotsIndicator(widget.slides.length),
        ],
      ),
    );
  }

    Widget _buildDotsIndicator(int count) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          count,
          (index) {
            return Container(
              width: 18.0,
              height: 5.0,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                shape: BoxShape.rectangle,
                color: _currentPage == index
                    ? Colors.blue
                    : Colors.grey.withOpacity(0.5),
              ),
            );
          },
        ),
      ),
    );
  }
}
