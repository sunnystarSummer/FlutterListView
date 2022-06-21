import 'package:flutter/cupertino.dart';

mixin IBaseUI{
  Widget get layout;
}

mixin IDropMenuUI implements IBaseUI{
  Widget get disableLayout;
}

mixin IBaseFactory{
  Function? callSetState;
  void setState(onPressed) {
    callSetState = onPressed;
  }
}

abstract class AbsListFactory<D> {
  List<D> dataList = [];
  void setList(List<D> list) {
    dataList = list;
  }
}