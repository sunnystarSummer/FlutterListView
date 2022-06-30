import 'package:backdrop/backdrop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_list_view/base/base_padding.dart';
import 'package:flutter_list_view/base/base_view.dart';
import 'package:flutter_list_view/util/dialog_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../base/base_factory.dart';
import '../../base/base_state.dart';
import '../../setting_config.dart';
import '../widget/normal.dart';
import 'info_form.dart';

void main() {
  runApp(const MyApp());

  //https://pub.dev/packages/provider
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (_) => CustomerFormListViewFactory()),
  //       //ChangeNotifierProvider(create: (context) => CartModel()),
  //       //Provider(create: (context) => SomeOtherClass()),
  //     ],
  //     child: const MyApp(),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => MyCustomerFormScreen(title: '客戶清單程式'),
        });
  }
}

class MyCustomerFormScreen extends StatefulWidget {
  //const MyHomePage({super.key, required this.title});
  final String title;

  MyCustomerFormScreen({super.key, required this.title}) {
    //螢幕固定翻轉
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }

  @override
  State<MyCustomerFormScreen> createState() => _MyCustomerFormScreenState();
}

class _MyCustomerFormScreenState
    extends ListState<CustomerFormListViewFactory, MyCustomerFormScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      if (listViewFactory.dataList.isEmpty) {
        _counter = 0;
      }

      _counter++;

      CustomerData data = CustomerData();
      //data.label = '$_counter';

      listViewFactory.addItem(data);
      listViewFactory.selectedPosition = -1;
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

    listViewFactory.setBuildContext(context);

    //generate
    var listView = listViewFactory.generateListView(Axis.vertical);

    if (SettingConfig.isGridView == true) {
      listView =
          listViewFactory.generateGridView(portraitCont: 2, landScapeCont: 3);
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
  CustomerFormListViewFactory createFactory() =>
      CustomerFormListViewFactory(callSetState: () {
        setState(() {});
      });
}

class CustomerData with MixinInfo {
  String typeCode = '';
  //String name = '';
  //String uniCode = '';
  bool isNameReadOnly = false; //true;
  bool isUniCodeReadOnly = false; //true;

  TextEditingController textEditingControllerName =
      TextEditingController(text: '');
  TextEditingController textEditingControllerUniCode =
      TextEditingController(text: '');
}

class CustomerFormViewHolder extends AbsViewHolder {
  late NormalDropdownMenuFactory factory;
  late TextFormField editTextName;
  late TextFormField editTextUniCode;

  late IconButton editNameButton;
  late IconButton editUniCodeButton;
  late IconButton deleteButton;
  late IconButton confirmButton;
  late Function onWrapPressed;

  late CustomerData data;
  late bool isEditable = true;
  late bool isReadOnly = !isEditable; //false;

  void setInfoFormOnWrapPressed(CustomerData data, Function onWrapPressed) {
    this.data = data;
    this.onWrapPressed = onWrapPressed;

    //infoForm.setOnWrapPressed(callSetState);
  }

  /// 初始客戶型態
  void initialTypeSelector(
      {required Function callSetState, required String initialCode}) {
    factory = NormalDropdownMenuFactory(callSetState: callSetState);
    factory.isEditable = isEditable;

    List<NormalMenuData> list = [];

    list.add(NormalMenuData(
      code: '',
      name: '請選擇客戶類型',
      isDisable: true,
      isPleaseHintAtFirst: true,
    ));

    list.add(NormalMenuData(code: '01', name: '個X戶'));
    list.add(NormalMenuData(code: '02', name: '公X戶'));
    list.add(NormalMenuData(code: '03', name: '外XX士'));
    factory.setList(list);
    factory.setCurrentValue(initialCode);
  }

  /// 姓名/公司名稱
  void initialName(
      {required onChanged,
      required onEditPressed,
      required TextEditingController controller}) {
    //https://api.flutter.dev/flutter/material/TextFormField-class.html

    editTextName = TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: '請輸入姓名/公司名稱',
      ),
      onChanged: onChanged,
      onSaved: onChanged,
      validator: (String? value) {
        //return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
      },
      onTap: _onTapListener,
    );
  }

  /// 統編號碼 UniCode
  void initialUniCode(
      {required onChanged,
      required onEditPressed,
      required TextEditingController controller}) {
    //https://api.flutter.dev/flutter/material/TextFormField-class.html

    editUniCodeButton = IconButton(
      iconSize: 36,
      icon: const Icon(Icons.edit),
      color: Colors.blue,
      onPressed: onEditPressed,
    );

    editTextUniCode = TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: '請輸入ID/統編',
      ),
      onChanged: onChanged,
      onSaved: onChanged,
      validator: (String? value) {
        //return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
      },
      onTap: _onTapListener,
    );
  }

  void initialDeleteButton({required onPressed}) {
    deleteButton = IconButton(
      iconSize: 36,
      //icon: const Icon(Icons.remove_circle),
      icon: const Icon(Icons.delete),
      color: Colors.red,
      onPressed: onPressed,
    );
  }

  void initialConfirmButton({required onPressed}) {
    confirmButton = IconButton(
      iconSize: 36,
      //icon: const Icon(Icons.remove_circle),
      icon: const Icon(Icons.check_circle),
      color: Colors.green,
      onPressed: onPressed,
    );
  }

  Widget infoTableLayout({required isEditMode}) {
    //https://api.flutter.dev/flutter/widgets/Table-class.html
    Table table;
    if (isEditMode) {
      table = Table(
        //border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(),
          //2: IntrinsicColumnWidth(),
          //2: FixedColumnWidth(64),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <TableRow>[
          TableRow(children: <Widget>[
            BasePadding.paddingAll04(const Text('客戶類型：')),
            BasePadding.paddingAll04(factory.generateDropdownButton(true)),
          ]),
          TableRow(children: <Widget>[
            BasePadding.paddingAll04(const Text('ID/統編：')),
            BasePadding.paddingAll04(editTextUniCode),
          ]),
          TableRow(children: <Widget>[
            BasePadding.paddingAll04(const Text('姓名/公司名稱：')),
            BasePadding.paddingAll04(editTextName),
          ]),
        ],
      );
    } else {
      table = Table(
        //border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <TableRow>[
          TableRow(children: <Widget>[
            BasePadding.paddingAll04(const Text('客戶類型：')),
            BasePadding.paddingAll04(factory.generateDropdownButton(true)),
          ]),
          TableRow(children: <Widget>[
            BasePadding.paddingAll04(const Text('ID/統編：')),
            BasePadding.paddingAll04(editTextUniCode),
          ]),
          TableRow(children: <Widget>[
            BasePadding.paddingAll04(const Text('姓名/公司名稱：')),
            BasePadding.paddingAll04(editTextName),
          ]),
        ],
      );
    }

    return BasePadding.paddingAll08(table);
  }

  dynamic _onTapListener;

  /// 選擇項目
  void setOnTapListener({required onTap}) {
    _onTapListener = onTap;
  }

  @override
  Widget getLayout() {

    Widget body = Stack(
      children: [
        Column(
          children: [
            infoTableLayout(isEditMode: isEditable),
          ],
        ),
      ],
    );

    BorderRadius borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(8),
      topRight: Radius.circular(8),
      bottomLeft: Radius.circular(8),
      bottomRight: Radius.circular(8),
    );

    Widget option = BasePadding.paddingAll04(SizedBox(
      child: Container(
          //margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: borderRadius,
            color: Colors.white,
            // boxShadow: const [
            //   BoxShadow(color: Colors.green, spreadRadius: 3),
            // ],
          ),
          child: Column(
            children: [deleteButton, confirmButton],
          )),
    ));

    // if(isEditable){
    //   body = Row(children: [body,option],);
    // }

    var infoForm = InfoForm();

    infoForm.setBody(body);
    infoForm.setBodyVisible(data.isInfoBodyVisible);
    infoForm.setOnWrapPressed(onWrapPressed);

    Table table;
    if (isEditable) {
      table = Table(
        //border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(),
          1: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <TableRow>[
          TableRow(children: <Widget>[
            infoForm.getLayout(),
            option,
          ]),
        ],
      );
    } else {
      table = Table(
        //border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(),
          //1: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <TableRow>[
          TableRow(children: <Widget>[
            infoForm.getLayout(),
            //option,
          ]),
        ],
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTapListener,
      child: table, //infoForm.getLayout(),
    );
  }
}

class CustomerFormListViewFactory
    extends AbsListViewFactory<CustomerFormViewHolder, CustomerData>
    with ChangeNotifier {
  CustomerFormListViewFactory({required super.callSetState});

  @override
  void setOnBindViewHolder(CustomerFormViewHolder viewHolder, int position) {
    CustomerData data = dataList[position];

    if (selectedPosition == position) {
      viewHolder.isEditable = true;
    } else {
      viewHolder.isEditable = false;
    }

    viewHolder.setInfoFormOnWrapPressed(data, () {
      data.isInfoBodyVisible = !data.isInfoBodyVisible;
      callSetState.call();
    });

    viewHolder.initialTypeSelector(
        initialCode: data.typeCode,
        callSetState: () {
          getItem(position).typeCode = viewHolder.factory.getCurrentValue();
          callSetState.call();
        });

    //https://stackoverflow.com/questions/68305886/flutter-text-editing-controller-listview-builder

    String onChangeTextName = data.textEditingControllerName.text;
    viewHolder.initialName(
      controller: data.textEditingControllerName,
      onChanged: (text) {
        //getItem(position).name = text;
        onChangeTextName = text;
      },
      onEditPressed: () {
        callSetState.call();
      },
    );

    String onChangeTextUniCode = data.textEditingControllerUniCode.text;
    viewHolder.initialUniCode(
      controller: data.textEditingControllerUniCode,
      onChanged: (text) {
        //getItem(position).uniCode = text;
        onChangeTextUniCode = text;
      },
      onEditPressed: () {
        callSetState.call();
      },
    );

    viewHolder.initialDeleteButton(onPressed: () {
      removeItem(position);
      selectedPosition = -1;
      callSetState.call();
    });

    viewHolder.initialConfirmButton(onPressed: () {
      selectedPosition = -1;

      data.textEditingControllerName.text = onChangeTextName;
      data.textEditingControllerUniCode.text = onChangeTextUniCode;

      callSetState.call();
    });

    viewHolder.setOnTapListener(onTap: () {
      selectedPosition = position;
      Fluttertoast.showToast(msg: 'selected $position');
      callSetState.call();
    });
  }

  @override
  CustomerFormViewHolder createViewHolder() => CustomerFormViewHolder();
}
