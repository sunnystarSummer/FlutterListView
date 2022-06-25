import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../base/base_factory.dart';
import '../base/base_state.dart';
import '../base/base_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var pageListView = const MyTabPagesScreen();
    return pageListView;
  }
}

class MyTabPagesScreen extends StatefulWidget {
  const MyTabPagesScreen({super.key});

  @override
  State<MyTabPagesScreen> createState() => _ExamplePagesState();
}

class _ExamplePagesState
    extends TabPagesState<ExampleTabPagesFactory, MyTabPagesScreen> {

  @override
  ExampleTabPagesFactory createFactory() =>
      ExampleTabPagesFactory(callSetState: () {
        setState(() {});
      });
}

class ExampleTabPagesFactory extends AbsTabPageViewFactory {

  ExampleTabPagesFactory({required super.callSetState});

  @override
  List<AbsPage> createPages() {
    return [
      Page01(),
      Page02(),
      Page03(),
      Page04(),
    ];
  }
}

class Page01 extends AbsPage {
  @override
  String get title => '螢幕固定直向(0)';

  @override
  Function? get onPageChanged => () {
        //螢幕固定直向
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      };
}

class Page02 extends AbsPage {
  @override
  String get title => '螢幕固定直向(180)';

  @override
  Function? get onPageChanged => () {
        //螢幕固定直向
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitDown,
        ]);
      };
}

class Page03 extends AbsPage {
  @override
  String get title => '螢幕任意翻轉';

  @override
  Function? get onPageChanged => () {
        //螢幕固定直向
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      };
}

class Page04 extends AbsPage {
  @override
  String get title => '螢幕左右橫向';

  @override
  Function? get onPageChanged => () {
        //螢幕固定直向
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      };
}
