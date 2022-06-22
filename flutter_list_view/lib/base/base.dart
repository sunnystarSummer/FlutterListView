import 'package:flutter/cupertino.dart';

mixin IBaseUI{
  Widget get layout;
}

mixin IDropMenuUI implements IBaseUI{
  Widget get disableLayout;
}

abstract class AbsFactory {
  Function callSetState;
  AbsFactory({required this.callSetState});
}

abstract class AbsListFactory<D> extends AbsFactory{

  AbsListFactory({required super.callSetState});

  List<D> dataList = [];
  void setList(List<D> list) {
    dataList = list;
  }
}