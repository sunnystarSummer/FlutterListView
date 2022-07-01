import 'package:flutter/cupertino.dart';
import 'package:flutter_list_view/base/base_mixin.dart';

//ViewHolder
abstract class AbsViewHolder<D> with MixinLayout {

  late D statusData;
  void setData(D data){
    statusData = data;
  }
  D getData(){
    return statusData;
  }

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