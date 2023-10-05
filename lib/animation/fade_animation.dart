import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';


enum AniProps{opacity,translateY}

class  FadeAnimation extends StatelessWidget {
  const  FadeAnimation({super.key, required this.delay, required this.child});
  final double delay;
  final Widget child;
  @override
  Widget build(BuildContext context) {
   

final MovieTween tween = MovieTween()
      ..scene(
              begin: const Duration(milliseconds: 0),
              end:  Duration(milliseconds: 500.round()))
          .tween(AniProps.opacity, Tween(begin: 0.0, end: 1.0))
      ..scene(
              begin: const Duration(milliseconds: 0),
              end:  Duration(milliseconds: 500.round()))
          .tween(AniProps.translateY, Tween(begin: -30.0, end: 0.0),curve: Curves.easeOut,);
    return PlayAnimationBuilder<Movie>(
      duration: tween.duration, 
            delay: Duration(milliseconds: (500 * delay).round()),
            builder: (context, value, child) {
              return Opacity(
          opacity: value.get(AniProps.opacity),
          child: Transform.translate(offset: Offset(0, value.get(AniProps.translateY))
          ,child: child,),
          );
            },
            tween: tween,
      child: child, 
          );
        
  }
}