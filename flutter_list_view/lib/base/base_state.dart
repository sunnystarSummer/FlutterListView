import 'package:flutter/material.dart';
import '../list_view/list_view_factory.dart';
import '../tab_pages_view/tab_pages_factory.dart';
import 'base_widget.dart';


abstract class ListState<F extends AbsListViewFactory,S extends StatefulWidget> extends AbsState<S>{

  late F listViewFactory;
  F createFactory();

  ListState() {
    listViewFactory = createFactory();
    listViewFactory.isAnim = true;
  }
}

abstract class PagesState<F extends AbsTabPageViewFactory,S extends StatefulWidget> extends AbsState<S>{

  late F _factory;///晚初始化
  F createFactory();

  PagesState(){
    _factory = createFactory();
  }

  @override
  Widget build(BuildContext context) {
    //https://material.io/components/tabs/flutter#fixed-tabs

    // _factory.setCallSetState((){
    //   setState(() {});
    // });

    _factory.build(vsync: this);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: _factory.getDefaultTabController(context, 'TabBarView'),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _factory.dispose();
  }
}
