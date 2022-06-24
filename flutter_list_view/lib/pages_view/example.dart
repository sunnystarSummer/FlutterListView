import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_list_view/pages_view/pages_factory.dart';

import '../base/base_view.dart';
import '../base/base_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var pageListView = const MyPageList();
    return pageListView;
  }
}

class MyPageList extends StatefulWidget {
  const MyPageList({super.key});

  @override
  State<MyPageList> createState() => _MyPageListState();
}

class _MyPageListState extends AbsState<MyPageList> {
  late ExamplePageViewFactory factory;

  _MyPageListState() {
    // factory = ExamplePageViewFactory(callSetState: () {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    //https://material.io/components/tabs/flutter#fixed-tabs
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: factory.getRootView(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    factory.dispose();
  }
}

class ExamplePageViewFactory extends AbsPageViewFactory {

  ExamplePageViewFactory({required super.callSetState});

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
