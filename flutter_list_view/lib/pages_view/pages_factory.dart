import 'package:flutter/material.dart';
import 'package:flutter_list_view/base/base_view.dart';
import 'package:flutter_list_view/base/base_mixin.dart';
import '../base/base_factory.dart';

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
