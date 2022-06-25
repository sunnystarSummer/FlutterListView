import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../base/base_factory.dart';
import '../base/base_state.dart';
import '../setting_config.dart';
import '../base/base_view.dart';

class MyListViewScreen extends StatefulWidget {
  //const MyHomePage({super.key, required this.title});
  final String title;

  MyListViewScreen({super.key, required this.title}) {
    //螢幕固定翻轉
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
  }

  @override
  State<MyListViewScreen> createState() => _MyListViewScreenState();
}

class _MyListViewScreenState extends ListState<ExampleListViewFactory, MyListViewScreen> {
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
    // listViewFactory.setState(() {
    //   setState(() {});
    // });

    //generate
    var listView = listViewFactory.generateListView(Axis.vertical);

    if (SettingConfig.isGridView == true) {
      listView = listViewFactory
          .generateGridView(portraitCont: 2,landScapeCont: 3);
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

  @override
  ExampleListViewFactory createFactory() =>
      ExampleListViewFactory(callSetState: () {
        setState(() {});
      });
}

class ExampleData {
  String label = 'default';
}

class ExampleViewHolder extends AbsViewHolder {
  late Text label;
  late ElevatedButton button;

  setLabelInfo(String text) {
    label = Text(text);
  }

  void setDeleteListener(onPressed) {
    button = ElevatedButton(
      onPressed: onPressed,
      child: const Text('Delete'),
    );
  }

  @override
  Widget getLayout() {
      return Row(
        children: [label, button],
      );
  }
}

class ExampleListViewFactory extends AbsListViewFactory<ExampleViewHolder, ExampleData> {

  ExampleListViewFactory({required super.callSetState});

  @override
  void setOnBindViewHolder(
      ExampleViewHolder viewHolder, int position, ExampleData data) {
    viewHolder.setLabelInfo(data.label);
    viewHolder.setDeleteListener(() {
      removeItem(position);
      callSetState.call();
    });
  }

  @override
  ExampleViewHolder createViewHolder() => ExampleViewHolder();

}
