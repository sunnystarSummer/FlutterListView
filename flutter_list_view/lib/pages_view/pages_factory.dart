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
    extends AbsFactory with IBaseUI{
  final PageController pageController = PageController();
  int currentPage = 0;

  Text get textViewPageTitle => Text(getPageTitle());

  AbsPageViewFactory({required super.callSetState}){
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

  Widget getRootView() {
    return Scaffold(
      appBar: AppBar(
        title: textViewPageTitle,
      ),
      body: layout,
    );
  }

  @override
  Widget get layout => PageView(
        /// [PageView.scrollDirection] defaults to [Axis.horizontal].
        /// Use [Axis.vertical] to scroll vertically.
        controller: pageController,
        onPageChanged: (index) {
          if (currentPage != index) {
            currentPage = index;
            callSetState.call();
            P page = indexPage(index);
            page.onPageChanged?.call();
          }
        },
        children: getPageLayout(),
      );
}

abstract class AbsTabPagesFactory<P extends AbsPage>
    extends AbsPageViewFactory<P> {


  AbsTabPagesFactory({required super.callSetState});


  DefaultTabController getDefaultTabController(context, vsync) {
    TabController tabController = TabController(
      vsync: vsync,
      length: createPages().length,
      initialIndex: currentPage,
    );

    tabController.animateTo(currentPage);

    return DefaultTabController(
      length: createPages().length,
      child: Scaffold(
        appBar: AppBar(
          title: textViewPageTitle,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor, //Color(0xff5808e5),
          bottom: getTabLayout(tabController),
        ),
        body: layout,
      ),
    );
  }

  TabBar getTabLayout(tabController) {
    //https://material.io/components/tabs/flutter#fixed-tabs

    List<Tab> tabs = [];
    for (P page in createPages()) {
      var tab = Tab(
        text: page.title,
      );
      tabs.add(tab);
    }

    return TabBar(
      controller: tabController,
      isScrollable: true,
      indicatorColor: Colors.white,
      tabs: tabs,
    );
  }

  Widget getLayout(tabController) {
    return TabBarView(
      /// [PageView.scrollDirection] defaults to [Axis.horizontal].
      /// Use [Axis.vertical] to scroll vertically.
      controller: tabController,
      children: getPageLayout(),
    );
  }
}
