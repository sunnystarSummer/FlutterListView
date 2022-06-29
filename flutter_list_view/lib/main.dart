import 'package:flutter/material.dart';
import 'package:flutter_list_view/pages_view/example.dart';
import 'package:flutter_list_view/tab_pages_view/example.dart';
import 'dropdown_menu/example.dart';
import 'dropdown_menu/form/customer_form.dart';
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
        routes: {
          '/': (context) => MyCustomerFormScreen(title: '客戶清單程式'),//MyListViewScreen(title: '清單範例程式'),
          '/page_list': (context) => const MyPagesScreen(),
          '/tab_pages': (context) => const MyTabPagesScreen(),
          '/drop_menu': (context) => MyDropdownMenuScreen(title: '下拉式菜單'),
        });
  }
}
