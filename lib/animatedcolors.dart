import 'package:flutter/material.dart';
import 'package:flutter_app/RandomColors.dart';

class AnimatedColors {
  static final Animatable<Color> circleColor = TweenSequence([
    TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
            begin: CustomColors.priorityOneColor,
            end: CustomColors.priorityTwoColor)),
    TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
            begin: CustomColors.priorityTwoColor,
            end: CustomColors.priorityThreeColor)),
    TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
            begin: CustomColors.priorityThreeColor,
            end: CustomColors.priorityFourColor)),
    TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
            begin: CustomColors.priorityFourColor,
            end: CustomColors.priorityFiveColor))
  ]);
}
