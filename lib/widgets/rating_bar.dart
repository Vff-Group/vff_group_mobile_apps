import 'package:flutter/material.dart';

class RatingBar extends StatefulWidget {
  final int initialRating;
  final int maxRating;

  RatingBar({this.initialRating = 0, this.maxRating = 5});

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  late int rating;

  @override
  void initState() {
    super.initState();
    rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];

    for (int i = 1; i <= widget.maxRating; i++) {
      IconData iconData = i <= rating ? Icons.star : Icons.star_border;
      stars.add(
        GestureDetector(
          onTap: () {
            setState(() {
              rating = i;
            });
          },
          child: Icon(
            iconData,
            color: Colors.amber,
          ),
        ),
      );
    }

    return Row(
      children: stars,
    );
  }
}
