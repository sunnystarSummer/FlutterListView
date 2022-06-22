import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_list_view/tab_pages_view/tab_pages_factory.dart';
import '../base/base.dart';

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

class _MyPageListState extends State<MyPageList> with TickerProviderStateMixin {

  late ExampleTabPagesFactory factory; // = ExampleTabPagesFactory();

  _MyPageListState() {
    factory = ExampleTabPagesFactory(
      callSetState: () {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //https://material.io/components/tabs/flutter#fixed-tabs

    factory.build(vsync: this);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: factory.getDefaultTabController(context,'TabBarView'),
    );
  }

  @override
  void dispose() {
    super.dispose();
    factory.dispose();
  }
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
