import 'package:flutter/cupertino.dart';
import 'package:flutter_list_view/base/base_mixin.dart';

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
abstract class AbsViewHolder with MixinLayout {
  Widget slideInLeft(Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: getLayout(),
    );
  }

  Widget slideOutRight(Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: getLayout(),
    );
  }
}

abstract class AbsPage with MixinLayout, MixinPage {
  Function? onPageChanged;

  //取得頁面標題TextView
  Text get textViewPageTitle => Text(title);

  @override
  //實作頁面畫面
  Widget getLayout() => Center(
    child: textViewPageTitle,
  );
}