import 'package:flutter/material.dart';
import '../pages_view/pages_factory.dart';

abstract class AbsTabPageViewFactory<P extends AbsPage>
    extends AbsPageViewFactory<P> {


  AbsTabPageViewFactory({required super.callSetState});

  Widget getDefaultTabController(context,vsync) {
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
