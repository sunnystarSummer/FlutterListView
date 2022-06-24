import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../base/base.dart';
import 'dropdown_menu_factory.dart';

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
      home: MyHomePage(title: '下拉式菜單'),
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
  late ExampleDropdownMenuFactory factory;// = ExampleDropdownMenuFactory(this);

  _MyHomePageState(){
    factory = ExampleDropdownMenuFactory(callSetState:(){
      setState((){});
    });
  }

  Widget functionBar() {

    List<ExampleMenuData> list = [];

    list.add(ExampleMenuData(
      code: '',
      name: '請選擇項目(當選擇項目後，無法回至『提示』項目)',
      isDisable: true,
      isPleaseHintAtFirst: true,
    ));

    list.add(ExampleMenuData(
      code: '00',
      name: '項目00',
      onSelect: (){
        //https://pub.dev/packages/fluttertoast
        Fluttertoast.showToast(
          msg: "已selected項目00",
        );
      }
    ));

    list.add(ExampleMenuData(code: '01', name: '項目01'));

    list.add(ExampleMenuData(
      code: '02',
      name: '項目02(監聽onTouch)',
      isDisable: true,
      onTap: (){
        //https://pub.dev/packages/fluttertoast
        Fluttertoast.showToast(
            msg: "已Touched項目02",
        );
      }
    ));

    list.add(ExampleMenuData(code: '03', name: '項目03'));

    list.add(ExampleMenuData(
        code: '04',
        name: '項目04',
        onSelect: (){
          //https://pub.dev/packages/fluttertoast
          Fluttertoast.showToast(
            msg: "已selected項目04",
          );
        }
    ));

    factory.setList(list);

    return factory.generateDropdownButton(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          functionBar(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    factory.dispose();
  }
}

class ExampleMenuData extends AbsMenuData {
  ExampleMenuData({
    required super.name,
    required super.code,
    super.isDisable = false,
    super.isPleaseHintAtFirst = false,
    super.onSelect,
    super.onTap,
  });
}

class ExampleMenuViewHolder extends AbsViewHolder {
  late Text label;

  setPleaseHint(String text) {
    label = Text(
      text,
      style: const TextStyle(
        color: Colors.redAccent,
      ),
    );
  }

  setLabelInfo(bool isDisable, String text) {
    if (isDisable) {
      label = Text(
        text,
        style: const TextStyle(
          color: Colors.grey,
        ),
      );
    } else {
      label = Text(text);
    }
  }

  @override
  Widget getLayout() {
    return Row(
      children: [label],
    );
  }
}

class ExampleDropdownMenuFactory
    extends AbsDropdownMenuFactory<ExampleMenuViewHolder, ExampleMenuData> {

  ExampleDropdownMenuFactory({required super.callSetState});

  @override
  void setOnBindViewHolder(
      ExampleMenuViewHolder viewHolder, int position, ExampleMenuData data) {
    if (data.isPleaseHintAtFirst) {
      viewHolder.setPleaseHint(data.name);
    } else {
      viewHolder.setLabelInfo(data.isDisable, data.name);
    }
  }

  @override
  ExampleMenuViewHolder createViewHolder() => ExampleMenuViewHolder();

}
