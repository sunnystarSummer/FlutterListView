import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_view/base/base.dart';

// abstract class AbsPage<STW extends StatefulWidget,ST extends State<STW>> extends StatefulWidget{
//   const AbsPage({Key? key}) : super(key: key);
//
//   @override
//   State<STW> createState();
// }

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

abstract class AbsPageViewFactory<P extends AbsPage>
    with IBaseUI, IBaseFactory {
  final PageController controller = PageController();
  int currentPage = 0;

  Text get textViewPageTitle => Text(getPageTitle());


  AbsPageViewFactory(){
    P page = indexPage(currentPage);
    page.onPageChanged?.call();
  }

  String getPageTitle() {
    int index = currentPage;
    P page = indexPage(index);
    return page.title;
  }

  List<P> createPages();

  List<Widget> getPageLayout() {
    List<Widget> layouts = [];

    for (P page in createPages()) {
      layouts.add(page.layout);
    }

    return layouts;
  }

  //索引頁面
  P indexPage(int index) {
    List pages = createPages();
    return pages[index];
  }

  @override
  // TODO: implement layout
  Widget get layout => PageView(
    /// [PageView.scrollDirection] defaults to [Axis.horizontal].
    /// Use [Axis.vertical] to scroll vertically.
    controller: controller,
    onPageChanged: (index) {
      if (currentPage != index) {
        currentPage = index;
        callSetState?.call();
        P page = indexPage(index);
        page.onPageChanged?.call();
      }
    },
    children: getPageLayout(),
  );
}


