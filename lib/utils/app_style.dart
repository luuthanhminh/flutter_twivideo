import 'package:flutter/cupertino.dart';

TextStyle blackTextStyle(double size, Color color, {double height}) => TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w900,
      color: color,
      height: height,
    );

TextStyle boldTextStyle(double size, Color color, {double height}) => TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
      height: height,
    );

TextStyle semiBoldTextStyle(double size, Color color, {double height}) =>
    TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color,
      height: height,
    );

TextStyle mediumTextStyle(double size, Color color, {double height}) =>
    TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: color,
      height: height,
    );

TextStyle normalTextStyle(double size, Color color, {double height = 1.1}) =>
    TextStyle(
      fontSize: size,
      fontWeight: FontWeight.normal,
      color: color,
      height: height,
    );

TextStyle lightTextStyle(double size, Color color, {double height}) =>
    TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w300,
      color: color,
      height: height,
    );
