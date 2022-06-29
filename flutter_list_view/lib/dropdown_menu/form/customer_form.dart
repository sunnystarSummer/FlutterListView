import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_list_view/base/base_padding.dart';
import 'package:flutter_list_view/base/base_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../base/base_factory.dart';
import '../../base/base_state.dart';
import '../../setting_config.dart';
import '../widget/normal.dart';
import 'info_form.dart';

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

class CustomerData {
  String typeCode = '';
  String name = '';
  String uniCode = '';
  bool isVisible = true;
  bool isNameReadOnly = false; //true;
  bool isUniCodeReadOnly = false; //true;
}

class CustomerFormViewHolder extends AbsViewHolder {
  late NormalDropdownMenuFactory factory;
  late TextFormField editTextName;
  late TextFormField editTextUniCode;

  //TextEditingController textEditingControllerName = TextEditingController();
  //TextEditingController textEditingControllerUniCode = TextEditingController();

  late IconButton editNameButton;
  late IconButton editUniCodeButton;
  late IconButton deleteButton;
  late Function onWrapPressed;

  //late InfoForm infoForm;

  bool isVisible = true;

  void setInfoFormOnWrapPressed(bool isVisible,Function onWrapPressed) {
    this.isVisible = isVisible;
    this.onWrapPressed = onWrapPressed;

    //infoForm.setOnWrapPressed(callSetState);

  }

  void initialTypeSelector(
      {required Function callSetState, required String initialCode}) {
    factory = NormalDropdownMenuFactory(callSetState: callSetState);

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
      required isReadOnly,
      required String initialValue}) {
    //https://api.flutter.dev/flutter/material/TextFormField-class.html

    editNameButton = IconButton(
      iconSize: 36,
      icon: const Icon(Icons.edit),
      color: Colors.blue,
      onPressed: onEditPressed,
    );

    editTextName = TextFormField(
      //controller: textEditingControllerName,
      // enabled: isReadOnly,
      readOnly: isReadOnly,
      initialValue: initialValue,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: '請輸入姓名/公司名稱',
      ),
      onChanged: onChanged,
      onSaved: onChanged,
      validator: (String? value) {
        //return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
      },
    );
  }

  /// 統編號碼 UniCode
  void initialUniCode(
      {required onChanged,
      required onEditPressed,
      required isReadOnly,
      required String initialValue}) {
    //https://api.flutter.dev/flutter/material/TextFormField-class.html

    editUniCodeButton = IconButton(
      iconSize: 36,
      icon: const Icon(Icons.edit),
      color: Colors.blue,
      onPressed: onEditPressed,
    );

    editTextUniCode = TextFormField(
      //controller: textEditingControllerUniCode,
      // enabled: isReadOnly,
      readOnly: isReadOnly,
      initialValue: initialValue,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: '請輸入姓名/公司名稱',
      ),
      onChanged: onChanged,
      onSaved: onChanged,
      validator: (String? value) {
        //return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
      },
    );
  }

  void initialDeleteButton({required onPressed}) {
    deleteButton = IconButton(
      iconSize: 36,
      icon: const Icon(Icons.remove_circle),
      color: Colors.redAccent,
      onPressed: onPressed,
    );
  }

  Widget _infoTableLayout() {
    //https://api.flutter.dev/flutter/widgets/Table-class.html
    Table table = Table(
      //border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        // 2: IntrinsicColumnWidth(),
        //2: FixedColumnWidth(64),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(children: <Widget>[
          BasePadding.paddingAll04(const Text('客戶類型：')),
          BasePadding.paddingAll04(factory.generateDropdownButton(true)),
          // BasePadding.paddingAll04(deleteButton),
        ]),
        TableRow(children: <Widget>[
          BasePadding.paddingAll04(const Text('ID/統編：')),
          //Padding(
          //padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          //child:
          BasePadding.paddingAll04(editTextUniCode),
          // BasePadding.paddingAll04(editUniCodeButton),
          // ),
        ]),
        TableRow(children: <Widget>[
          BasePadding.paddingAll04(const Text('姓名/公司名稱：')),
          BasePadding.paddingAll04(editTextName),
          // BasePadding.paddingAll04(editNameButton),
        ]),
      ],
    );

    return BasePadding.paddingAll08(table);
  }

  @override
  Widget getLayout() {
    var body = Stack(
      children: [
        Column(
          children: [
            _infoTableLayout(),
          ],
        ),
        Container(
          alignment: Alignment.topRight,
          child: deleteButton,
        ),
      ],
    );
    var infoForm = InfoForm(
      // body: body,
      //onWrapPressed: callSetState,
    );

    infoForm.setBody(body);
    infoForm.setOnWrapPressed(isVisible,onWrapPressed);

    return infoForm.getLayout();
  }
}

class CustomerFormListViewFactory
    extends AbsListViewFactory<CustomerFormViewHolder, CustomerData> {
  CustomerFormListViewFactory({required super.callSetState});

  @override
  void setOnBindViewHolder(
      CustomerFormViewHolder viewHolder, int position, CustomerData data) {

    bool isVisible = !data.isVisible;


    viewHolder.setInfoFormOnWrapPressed(isVisible,(){
      callSetState.call();
    });

    viewHolder.initialTypeSelector(
        initialCode: data.typeCode,
        callSetState: () {
          getItem(position).typeCode = viewHolder.factory.getCurrentValue();
          callSetState.call();
        });

    //https://stackoverflow.com/questions/68305886/flutter-text-editing-controller-listview-builder
    viewHolder.initialName(
      isReadOnly: false, //true,//data.isNameReadOnly,
      initialValue: data.name,
      onChanged: (text) {
        getItem(position).name = text;
      },
      onEditPressed: () {
        // data.isNameReadOnly = !data.isNameReadOnly;
        // if (data.isNameReadOnly) {
        //   Fluttertoast.showToast(
        //     msg: "isNameReadOnly",
        //   );
        // }

        data.name = 'name_$position';
        callSetState.call();
      },
    );

    viewHolder.initialUniCode(
      isReadOnly: false, //true,//data.isUniCodeReadOnly,
      initialValue: data.uniCode,
      onChanged: (text) {
        getItem(position).uniCode = text;
      },
      onEditPressed: () {
        // data.isUniCodeReadOnly = !data.isUniCodeReadOnly;
        // if (data.isUniCodeReadOnly) {
        //   Fluttertoast.showToast(
        //     msg: "isUniCodeReadOnly",
        //   );
        // }
        data.uniCode = 'uniCode_$position';
        callSetState.call();
      },
    );

    viewHolder.initialDeleteButton(onPressed: () {
      removeItem(position);
      //List<CustomerData> clonedDataList = List.from(dataList);
      //dataList = clonedDataList;
      callSetState.call();
    });
  }

  @override
  CustomerFormViewHolder createViewHolder() => CustomerFormViewHolder();
}
