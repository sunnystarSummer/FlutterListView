import 'package:flutter/material.dart';
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
      theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true),
      home: const MyHomePage(title: '清單範例程式'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

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


  Widget functionBar(){
    var button01 = ElevatedButton(
      onPressed: () {
        setState(() {
          SettingConfig.isGridView = false;
        });
      },
      child: const Text('直列清單'),
    );
    var button02 = ElevatedButton(
      onPressed: () {
        setState(() {
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
      child: Row(children: [
        button01,
        button02,
        button03,
        button04,

      ],),
    );
  }



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    //adapter.setList(_dataList);
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
