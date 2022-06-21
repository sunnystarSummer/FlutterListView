import 'package:flutter/material.dart';
import 'package:flutter_list_view/base/base.dart';

import '../list_view/factory.dart';

abstract class AbsMenuData<D> {
  bool isPleaseHintAtFirst = false;
  bool isDisable = false;
  String name;
  String code;
  Function? onSelect, onTouch;

  AbsMenuData({
    required this.name,
    required this.code,
    this.isDisable = false,
    this.isPleaseHintAtFirst = false,
    this.onSelect,
    this.onTouch,
  });
}

//Factory
abstract class AbsDropdownMenuFactory<VH extends AbsViewHolder,
    MD extends AbsMenuData> extends AbsListViewFactory<VH, MD> with IBaseUI {
  String code = '';

  String getCurrentValue() {
    if (code.isEmpty) {
      MD data = dataList.first;
      return data.code;
    }
    return code;
  }

  MD? indexMenuDataByCode(String code) {
    for (var data in dataList) {
      if (data.code == code) {
        return data;
      }
    }
    return null;
  }

  List<DropdownMenuItem> menuItems() {
    List<DropdownMenuItem> list = [];

    VH viewHolder = createViewHolder();

    dataList.asMap().forEach((index, data) {
      setOnBindViewHolder(viewHolder, index, data);
      list.add(DropdownMenuItem(
        value: data.code,
        child: viewHolder.layout,
      ));
    });

    return list;
  }

  @override
  DropdownButton get layout => generateDropdownButton(false);

  DropdownButton generateDropdownButton(bool isExpanded) {
    return DropdownButton(
      isExpanded: isExpanded,
      value: getCurrentValue(),
      items: menuItems(),
      onChanged: (value) {
        var menuData = indexMenuDataByCode(value);

        menuData?.onTouch?.call();

        if (code != value) {
          menuData?.onSelect?.call();
        }

        if (menuData?.isDisable == false) {
          code = value;
          callSetState?.call();
        }
      },
    );
  }
}
