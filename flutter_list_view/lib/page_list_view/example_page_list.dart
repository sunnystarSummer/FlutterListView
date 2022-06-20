import 'package:flutter/material.dart';

import 'base.dart';

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

class _MyPageListState extends State<MyPageList> {
  ExamplePageViewFactory examplePageViewFactory = ExamplePageViewFactory();

  _MyPageListState() {
    examplePageViewFactory.setState(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: examplePageViewFactory.textViewPageTitle),
        body: examplePageViewFactory.layout,
      ),
    );
  }
}

class ExamplePageViewFactory extends AbsPageViewFactory {
  @override
  List<AbsPage> createPages() {
    return [
      Page01(),
      Page02(),
      Page03(),
    ];
  }
}

class Page01 extends AbsPage {
  @override
  String get title => 'First Page';
}

class Page02 extends AbsPage {
  @override
  String get title => 'Second Page';
}

class Page03 extends AbsPage {
  @override
  String get title => 'Third Page';
}
