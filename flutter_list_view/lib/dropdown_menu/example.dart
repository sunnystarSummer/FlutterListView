import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_list_view/dropdown_menu/widget/normal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../base/base_widget.dart';

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
      home: MyDropdownMenuScreen(title: '下拉式菜單'),
    );
  }
}

class MyDropdownMenuScreen extends StatefulWidget {
  //const MyHomePage({super.key, required this.title});
  final String title;

  MyDropdownMenuScreen({super.key, required this.title}) {
    //螢幕固定翻轉
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
  }

  @override
  State<MyDropdownMenuScreen> createState() => _MyDropdownMenuScreenState();
}

class _MyDropdownMenuScreenState extends AbsState<MyDropdownMenuScreen> {
  late NormalDropdownMenuFactory factory;

  _MyDropdownMenuScreenState() {
    factory = NormalDropdownMenuFactory(callSetState: () {
      setState(() {});
    });
  }

  Widget functionBar() {
    List<NormalMenuData> list = [];

    list.add(NormalMenuData(
      code: '',
      name: '請選擇項目(當選擇項目後，無法回至『提示』項目)',
      isDisable: true,
      isPleaseHintAtFirst: true,
    ));

    list.add(NormalMenuData(
        code: '00',
        name: '項目00',
        onSelect: () {
          //https://pub.dev/packages/fluttertoast
          Fluttertoast.showToast(
            msg: "已selected項目00",
          );
        }));

    list.add(NormalMenuData(code: '01', name: '項目01'));

    list.add(NormalMenuData(
        code: '02',
        name: '項目02(監聽onTouch)',
        isDisable: true,
        onTap: () {
          //https://pub.dev/packages/fluttertoast
          Fluttertoast.showToast(
            msg: "已Touched項目02",
          );
        }));

    list.add(NormalMenuData(code: '03', name: '項目03'));

    list.add(NormalMenuData(
        code: '04',
        name: '項目04',
        onSelect: () {
          //https://pub.dev/packages/fluttertoast
          Fluttertoast.showToast(
            msg: "已selected項目04",
          );
        }));

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
