import 'package:flutter/material.dart';

class CustomColors {
  // const CustomColors();
  static const priorityOneColor = Color(0xFF45AAF0);
  static const priorityTwoColor =
      Color(0xFF757575); // this is taken directly from material Colors
  static const priorityThreeColor =
      Color(0xFF546E7A); // this is taken directly from material Colors
  static const priorityFourColor = Color(0xFFD89030);
  static const priorityFiveColor = Color(0xFFF42F2F);
  // Color(0xFF0C222D)
  static final backgroundColor = Color(0xFF151515);
  static const List<Color> tileColors = [
    Color(0xFF45AAF0),
    Color(0xFF757575),
    Color(0xFF546E7A),
    Color(0xFFD89030),
    Color(0xFFF42F2F)
  ];
  //old card design with different colors
  // final List<Color> _bottomColors = [
  //   // Colors.blue.shade600,
  //   // Colors.grey.shade700,
  //   // Colors.blueGrey.shade700,
  //   // Color(0xFFD3831A),
  //   // Color(0xFFF71111),
  //   Color(0xFF45AAF0),
  //   Colors.grey.shade600,
  //   Colors.blueGrey.shade600,
  //   Color(0xFFD89030),
  //   Color(0xFFF42F2F),
  // ];

}

enum ColorValue {
  blue,
  grey,
  blueGrey,
  yellow,
  red,
}
