import 'package:flutter/material.dart';
import '../base/base.dart';
import '../pages_view/pages_factory.dart';

abstract class AbsTabPageViewFactory<P extends AbsPage>
    extends AbsPageViewFactory<P> {
  late TabController tabController;

  build({required TickerProvider vsync}){

    tabController = TabController(
      vsync: vsync,
      length: createPages().length,
      initialIndex: currentPage,
    );

    P page = indexPage(currentPage);
    page.onPageChanged?.call();

    //tabController.animateTo(currentPage);

    tabController.addListener(() {
      currentPage = tabController.index;
      P page = indexPage(currentPage);
      page.onPageChanged?.call();
      callSetState.call();
      if (tabController.indexIsChanging) {
        //P page = indexPage(currentPage);
        //page.onPageChanged?.call();
        // tabController.animateTo(currentPage,
        //     duration: const Duration(milliseconds: 200));
        //callSetState.call();
      }
    });
  }

  AbsTabPageViewFactory({
    required super.callSetState,
  }) {



  }

  Widget getDefaultTabController(context,title) {
    var color = Theme.of(context).primaryColor;

    return DefaultTabController(
      length: createPages().length,
      child: Scaffold(
        appBar: AppBar(
          title: textViewPageTitle,//Text(title),
          automaticallyImplyLeading: false,
          backgroundColor: color, //Color(0xff5808e5),
          bottom: getTabLayout(tabController),
        ),
        body: getLayout(tabController),
      ),
    );
  }

  TabBar getTabLayout(TabController tabController) {
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
      // onTap: (index) {
      //   currentPage = index;
      // },
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

  @override
  void dispose() {
    tabController.dispose();
  }
}
