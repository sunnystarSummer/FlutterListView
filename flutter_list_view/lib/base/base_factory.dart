import 'package:flutter/material.dart';

import 'base_mixin.dart';
import 'base_view.dart';

abstract class AbsFactory {
  late BuildContext buildContext;

  ///更新畫面，需要使用此Function
  Function callSetState;

  bool isEditable = true;

  AbsFactory({required this.callSetState});

  void setBuildContext(BuildContext context) {
    buildContext = context;
  }

  BuildContext getBuildContext() {
    return buildContext;
  }
}

abstract class AbsFactory02 {
  late BuildContext buildContext;

  void setBuildContext(BuildContext context) {
    buildContext = context;
  }

  BuildContext getBuildContext() {
    return buildContext;
  }
}

abstract class AbsListFactory<D> extends AbsFactory {
  int selectedPosition = -1;

  AbsListFactory({required super.callSetState});

  List<D> dataList = [];

  void setList(List<D> list) {
    dataList = list;
  }
}

abstract class AbsListViewFactory<VH extends AbsViewHolder, D>
    extends AbsListFactory<D> {
  bool isAnim = false;

  // The key of the list
  GlobalKey<AnimatedListState> keyList = GlobalKey();

  //清單滑動當前位置
  double currentPosition = 0;
  ScrollController scrollController = ScrollController();

  AbsListViewFactory({required super.callSetState});

  void addItem(D data) {
    int last = dataList.length;
    dataList.insert(last, data);
    if (isAnim == true) {
      keyList.currentState!
          .insertItem(last, duration: const Duration(milliseconds: 200));
    }
  }

  void removeItem(int index) {
    D data = dataList[index];
    VH viewHolder = createViewHolder();

    setOnBindViewHolder(viewHolder, index);

    if (isAnim == true) {
      keyList.currentState!.removeItem(
          index, (_, animation) => viewHolder.slideOutRight(animation),
          duration: const Duration(milliseconds: 200));
    }
    dataList.removeAt(index);
  }

  D getItem(int index) {
    return dataList[index];
  }

  //產生ViewHolder
  VH createViewHolder();

  //void setOnBindViewHolder(VH viewHolder, int position,D data);
  void setOnBindViewHolder(VH viewHolder, int position);

  /// 新增項目畫面
  Widget addItemView(context, index, {animation}) {
    D data = dataList[index];

    VH viewHolder = createViewHolder();
    setOnBindViewHolder(viewHolder, index);
    Widget layout = viewHolder.getLayout();

    if (isAnim) {
      return viewHolder.slideInLeft(animation);
    }
    return viewHolder.getLayout();
  }

  void setTop() {
    setScrollPosition(scrollController.position.minScrollExtent);
  }

  void setBottom() {
    setScrollPosition(scrollController.position.maxScrollExtent);
  }

  void setScrollPosition(double position) {
    scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
    );
  }

  /// 產生直列清單
  Widget generateListView(scrollDirection) {
    //Axis.horizontal
    scrollController = ScrollController(initialScrollOffset: currentPosition);
    scrollController.addListener(() {
      currentPosition = scrollController.position.pixels;
    });

    if (isAnim == false) {
      return ListView.builder(
        key: keyList,
        itemCount: dataList.length,
        scrollDirection: scrollDirection,
        controller: scrollController,
        itemBuilder: (context, index) {
          return addItemView(context, index);
        },
      );
    }

    //https://medium.com/flutter-community/how-to-animate-items-in-list-using-animatedlist-in-flutter-9b1a64e9aa16
    return AnimatedList(
      key: keyList,
      initialItemCount: dataList.length,
      scrollDirection: scrollDirection,
      controller: scrollController,
      itemBuilder: (context, index, animation) {
        return addItemView(context, index, animation: animation);
      },
    );
  }

  /// 產生網格清單
  Widget generateGridView({required portraitCont, required landScapeCont}) {
    //https://api.flutter.dev/flutter/widgets/GridView-class.html
    //Axis.horizontal

    isAnim = false;

    scrollController = ScrollController(initialScrollOffset: currentPosition);
    scrollController.addListener(() {
      currentPosition = scrollController.position.pixels;
    });

    return OrientationBuilder(builder: (context, orientation) {
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: orientation == Orientation.portrait
                ? portraitCont
                : landScapeCont,
          ),
          itemCount: dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              //color: Colors.transparent,
              child: Center(child: addItemView(context, index)),
            );
          });
    });

    // return GridView.builder(
    //     gridDelegate: gridDelegate,
    //     itemCount: dataList.length,
    //     controller: scrollController,
    //     itemBuilder: (BuildContext context, int index) {
    //       return Card(
    //         //color: Colors.transparent,
    //         child: Center(child: addItemView(context, index)),
    //       );
    //     });
  }

  void dispose() {
    scrollController.dispose();
  }
}

abstract class AbsPageViewFactory<P extends AbsPage> extends AbsFactory
    with MixinLayout {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  Text get textViewPageTitle => Text(_pageTitle);

  AbsPageViewFactory({required super.callSetState}) {
    P page = indexPage(currentIndex);
    page.onPageChanged?.call();
  }

  // AbsPageViewFactory() {
  //   P page = indexPage(currentIndex);
  //   page.onPageChanged?.call();
  // }

  String get _pageTitle => _currentPage.title;

  List<P> createPages();

  P get _currentPage => indexPage(currentIndex);

  List<Widget> getPageLayout() {
    List<Widget> layouts = [];

    for (P page in createPages()) {
      layouts.add(page.getLayout());
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
      body: getLayout(),
    );
  }

  @override
  Widget getLayout() {
    return PageView(
      /// [PageView.scrollDirection] defaults to [Axis.horizontal].
      /// Use [Axis.vertical] to scroll vertically.
      controller: _pageController,
      onPageChanged: (index) {
        if (currentIndex != index) {
          currentIndex = index;
          callSetState.call();
          P page = indexPage(index);
          page.onPageChanged?.call();
        }
      },
      children: getPageLayout(),
    );
  }

  void dispose() {
    _pageController.dispose();
  }
}

abstract class AbsTabPageViewFactory<P extends AbsPage>
    extends AbsPageViewFactory<P> {
  late TabController tabController;

  AbsTabPageViewFactory({required super.callSetState});

  build({required TickerProvider vsync}) {
    tabController = TabController(
      vsync: vsync,
      length: createPages().length,
      initialIndex: currentIndex,
    );

    P page = indexPage(currentIndex);
    page.onPageChanged?.call();

    //tabController.animateTo(currentPage);

    tabController.addListener(() {
      currentIndex = tabController.index;
      P page = indexPage(currentIndex);
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

  // AbsTabPageViewFactory({
  //   required super.callSetState,
  // });

  Widget getDefaultTabController(context, title) {
    var color = Theme.of(context).primaryColor;

    return DefaultTabController(
      length: createPages().length,
      child: Scaffold(
        appBar: AppBar(
          title: textViewPageTitle, //Text(title),
          automaticallyImplyLeading: false,
          backgroundColor: color, //Color(0xff5808e5),
          bottom: getTabLayout(tabController),
        ),
        body: getLayout(),
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

  @override
  Widget getLayout() {
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

/// 下拉式菜單工廠
abstract class AbsDropdownMenuFactory<VH extends AbsViewHolder,
        MD extends AbsMenuData> extends AbsListViewFactory<VH, MD>
    with MixinLayout {
  String code = '';

  //Init GlobalKey, allows to close the DropdownButton
  //GlobalKey dropdownKey = GlobalKey();
  //FocusNode dropdown = FocusNode();

  AbsDropdownMenuFactory({required super.callSetState});

  // PagesState(){
  //   _factory = createFactory();
  // }

  void setCurrentValue(String code) {
    this.code = code;
  }

  String getCurrentValue() {
    if (code.isEmpty) {
      MD data = dataList.first;
      return data.code;
    }
    return code;
  }

  MD? indexMenuDataByCode(String code) {
    for (var data in dataList) {
      if (data.code == code) {
        return data;
      }
    }
    return null;
  }

  List<DropdownMenuItem> menuItems() {
    List<DropdownMenuItem> list = [];

    VH viewHolder = createViewHolder();

    dataList.asMap().forEach((index, data) {
      //GlobalKey dropdownKey = GlobalKey();

      setOnBindViewHolder(viewHolder, index);
      list.add(DropdownMenuItem(
        //key: dropdownKey,
        value: data.code,
        child: viewHolder.getLayout(),

        // GestureDetector(
        //   onTap: () {
        //     //Navigator.pop(dropdownKey.currentContext); // Closes the dropdown
        //     //Navigator.push(context, MaterialPageRoute(builder: (context) => BoatForm(CreationState.edit, _boat)));
        //   },
        //   child: viewHolder.layout,
        // ),
      ));
    });

    return list;
  }

  @override
  DropdownButton getLayout() => generateDropdownButton(false);

  DropdownButton generateDropdownButton(bool isExpanded) {
    //https://stackoverflow.com/questions/67439716/flutter-close-dropdownbutton-dropdownmenu

    // GlobalKey dropdownKey = GlobalKey();
    // FocusNode dropdown = FocusNode();

    return DropdownButton(
      // key: dropdownKey,
      // focusNode: dropdown,
      isExpanded: isExpanded,
      value: getCurrentValue(),
      items: menuItems(),

      //2022-06-30_Jason
      //增加可不可編輯模式
      onChanged: isEditable == false
          ? null
          : (value) {
              var menuData = indexMenuDataByCode(value);

              menuData?.onTap?.call();

              if (code != value) {
                menuData?.onSelect?.call();
              }

              if (menuData?.isDisable == false) {
                code = value;
                callSetState.call();
              }
            },
    );
  }
}

/// 下拉式菜單資料
abstract class AbsMenuData<D> {
  bool isPleaseHintAtFirst = false;
  bool isDisable = false;
  String name;
  String code;
  Function? onSelect, onTap;

  AbsMenuData({
    required this.name,
    required this.code,
    this.isDisable = false,
    this.isPleaseHintAtFirst = false,
    this.onSelect,
    this.onTap,
  });
}
