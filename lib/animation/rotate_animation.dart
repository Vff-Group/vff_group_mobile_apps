import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { rotation }

class RotateAComeAnimation extends StatelessWidget {
  const RotateAComeAnimation({Key? key, required this.delay, required this.child})
      : super(key: key);

  final double delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MovieTween tween = MovieTween()
      ..scene(
        begin: const Duration(milliseconds: 0),
        end: Duration(milliseconds: 1000.round()),
      ).tween(AniProps.rotation, Tween(begin: 0.0, end: 6.3), curve: Curves.easeOut);

    return PlayAnimationBuilder<Movie>(
      duration: tween.duration,
      delay: Duration(milliseconds: (2500 * delay).round()),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value.get(AniProps.rotation),
          child: child,
        );
      },
      tween: tween,
      child: child,
    );
  }
}