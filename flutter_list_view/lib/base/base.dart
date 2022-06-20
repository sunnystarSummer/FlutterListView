import 'package:flutter/cupertino.dart';

mixin IBaseUI{
  Widget get layout;
}

mixin IBaseFactory{
  late Function callSetState;
  void setState(onPressed) {
    callSetState = onPressed;
  }
}