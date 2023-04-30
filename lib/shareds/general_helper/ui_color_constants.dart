import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

  Map<int, Color> _color =
{
50:Color.fromRGBO(136,14,79, .1),
100:Color.fromRGBO(136,14,79, .2),
200:Color.fromRGBO(136,14,79, .3),
300:Color.fromRGBO(136,14,79, .4),
400:Color.fromRGBO(136,14,79, .5),
500:Color.fromRGBO(136,14,79, .6),
600:Color.fromRGBO(136,14,79, .7),
700:Color.fromRGBO(136,14,79, .8),
800:Color.fromRGBO(136,14,79, .9),
900:Color.fromRGBO(136,14,79, 1),
};


class UIColorConstant {
  static const Color primaryBlue = Color(0xff6EA9CF);
  static MaterialColor materialPrimaryBlue = MaterialColor(0xff6EA9CF, _color);
  static const Color primaryGreen = Color(0xffC7E1CD);
  static MaterialColor materialPrimaryGreen = MaterialColor(0xff6EA9CF, _color);
  static const Color primaryRed = Color(0xffEA929A);
  static MaterialColor materialPrimaryRed = MaterialColor(0xffEA929A, _color);
  static const Color primaryBlack = Color(0xff000000);
  static const Color accentGrey1 = Color(0xffD9D9D9);
  static const Color accentGrey2 = Color(0xFfFAFAFA);
  static const Color backgroundColorGrey = Color(0xffF9FCFE);
  static Color accentGrey3 = Colors.grey.shade200;
  static const Color nativeGrey = Colors.grey;
  static const Color nativeWhite = Colors.white;
  static const Color nativeBlack = Colors.black;
  static const Color softOrange = Color(0xffFFB322);
}
