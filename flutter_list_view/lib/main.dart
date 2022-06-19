import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_list_view/setting_config.dart';

import 'list_view/example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: MyHomePage(title: '清單範例程式'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //const MyHomePage({super.key, required this.title});
  final String title;

  MyHomePage({super.key, required this.title}) {
    //螢幕固定翻轉
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      if (listViewFactory.dataList.isEmpty) {
        _counter = 0;
      }

      _counter++;

      ExampleData data = ExampleData();
      data.label = '$_counter';

      listViewFactory.addItem(data);
      listViewFactory.setBottom();
    });
  }

  ExampleListViewFactory listViewFactory = ExampleListViewFactory();

  Widget functionBar() {
    var button01 = ElevatedButton(
      onPressed: () {
        setState(() {
          listViewFactory.isAnim = true;
          SettingConfig.isGridView = false;
        });
      },
      child: const Text('直列清單'),
    );
    var button02 = ElevatedButton(
      onPressed: () {
        setState(() {
          listViewFactory.isAnim = false;
          SettingConfig.isGridView = true;
        });
      },
      child: const Text('網格清單'),
    );

    var button03 = ElevatedButton(
      onPressed: () {
        setState(() {
          listViewFactory.setTop();
        });
      },
      child: const Text('至頂'),
    );

    var button04 = ElevatedButton(
      onPressed: () {
        setState(() {
          listViewFactory.setBottom();
        });
      },
      child: const Text('至底'),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          button01,
          button02,
          button03,
          button04,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    listViewFactory.isAnim = true;

    //MUST
    listViewFactory.setState(() {
      setState(() {});
    });

    //generate
    var listView = listViewFactory.generateListView(Axis.vertical);

    if (SettingConfig.isGridView == true) {
      listView = listViewFactory
          .generateGridView(const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          functionBar(),
          Expanded(
            child: listView,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
