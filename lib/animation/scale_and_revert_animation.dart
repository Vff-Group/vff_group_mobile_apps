import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { scale, rotation }

class RotateAndScaleAnimation extends StatelessWidget {
  const RotateAndScaleAnimation({Key? key, required this.delay, required this.child})
      : super(key: key);

  final double delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MovieTween tween = MovieTween()
      ..scene(
        begin: const Duration(milliseconds: 0),
        end: Duration(milliseconds: 1000.round()),
      ).tween(AniProps.scale, Tween(begin: 0.2, end: 1.0), curve: Curves.easeOut)
      ..scene(
        begin: const Duration(milliseconds: 0),
        end: Duration(milliseconds: 1000.round()),
      ).tween(AniProps.rotation, Tween(begin: -0.5, end: 0.0), curve: Curves.easeOut);

    return PlayAnimationBuilder<Movie>(
      duration: tween.duration,
      delay: Duration(milliseconds: (2000 * delay).round()),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value.get(AniProps.scale),
          child: Transform.rotate(
            angle: value.get(AniProps.rotation),
            child: child,
          ),
        );
      },
      tween: tween,
      child: child,
    );
  }
}
