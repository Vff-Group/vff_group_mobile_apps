import 'package:flutter/material.dart';

class FullScreenShimmer extends StatelessWidget {
  const FullScreenShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          height: 10.0,
          color: Colors.white,
        ),
        Container(
          width: double.infinity,
          height: 10.0,
          color: Colors.white,
        ),
        Container(
          width: double.infinity,
          height: 10.0,
          color: Colors.white,
        ),
        Container(
          width: double.infinity,
          height: 10.0,
          color: Colors.white,
        ),
        Container(
          width: double.infinity,
          height: 10.0,
          color: Colors.white,
        ),
        Container(
          width: double.infinity,
          height: 10.0,
          color: Colors.white,
        ),
      ]),
    );
  }
}
