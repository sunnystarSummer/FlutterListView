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

//ViewHolder
abstract class AbsViewHolder with IBaseUI {
  Widget slideInLeft(Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: layout,
    );
  }

  Widget slideOutRight(Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: layout,
    );
  }
}

mixin IPage {
  String get title;
}

abstract class AbsPage with IBaseUI, IPage {
  Function? onPageChanged;

  //取得頁面標題TextView
  Text get textViewPageTitle => Text(title);

  @override
  //實作頁面畫面
  Widget get layout => Center(
    child: textViewPageTitle,
  );
}