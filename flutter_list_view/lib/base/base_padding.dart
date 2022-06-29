import 'package:flutter/material.dart';

class BasePadding {
  static Widget paddingAll(double value, Widget widget) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: widget,
    );
  }

  static Widget paddingAll04(Widget widget) {
    return paddingAll(4.0,widget);
  }

  static Widget paddingAll08(Widget widget) {
    return paddingAll(8.0,widget);
  }
}
