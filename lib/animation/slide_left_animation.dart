import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { opacity, translateX }

class SlideFromLeftAnimation extends StatelessWidget {
  const SlideFromLeftAnimation({Key? key, required this.delay, required this.child})
      : super(key: key);

  final double delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MovieTween tween = MovieTween()
      ..scene(
        begin: const Duration(milliseconds: 0),
        end: Duration(milliseconds: 500.round()),
      ).tween(AniProps.opacity, Tween(begin: 0.0, end: 1.0))
      ..scene(
        begin: const Duration(milliseconds: 0),
        end: Duration(milliseconds: 500.round()),
      ).tween(AniProps.translateX, Tween(begin: -MediaQuery.of(context).size.width, end: 0.0),
          curve: Curves.easeOut);

    return PlayAnimationBuilder<Movie>(
      duration: tween.duration,
      delay: Duration(milliseconds: (500 * delay).round()),
      builder: (context, value, child) {
        return Opacity(
          opacity: value.get(AniProps.opacity),
          child: Transform.translate(
            offset: Offset(value.get(AniProps.translateX), 0),
            child: child,
          ),
        );
      },
      tween: tween,
      child: child,
    );
  }
}
