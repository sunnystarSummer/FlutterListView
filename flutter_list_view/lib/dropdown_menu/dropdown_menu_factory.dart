import 'package:flutter/material.dart';
import 'package:flutter_list_view/base/base_view.dart';
import 'package:flutter_list_view/base/base_mixin.dart';
import '../list_view/list_view_factory.dart';

abstract class AbsMenuData<D> {
  bool isPleaseHintAtFirst = false;
  bool isDisable = false;
  String name;
  String code;
  Function? onSelect, onTap;

  AbsMenuData({
    required this.name,
    required this.code,
    this.isDisable = false,
    this.isPleaseHintAtFirst = false,
    this.onSelect,
    this.onTap,
  });
}

//Factory
abstract class AbsDropdownMenuFactory<VH extends AbsViewHolder,
    MD extends AbsMenuData> extends AbsListViewFactory<VH, MD> with MixinLayout {
  String code = '';

  //Init GlobalKey, allows to close the DropdownButton
  //GlobalKey dropdownKey = GlobalKey();
  //FocusNode dropdown = FocusNode();

  AbsDropdownMenuFactory({required super.callSetState});

  // PagesState(){
  //   _factory = createFactory();
  // }

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
      //GlobalKey dropdownKey = GlobalKey();

      setOnBindViewHolder(viewHolder, index, data);
      list.add(DropdownMenuItem(
        //key: dropdownKey,
        value: data.code,
        child: viewHolder.getLayout(),

        // GestureDetector(
        //   onTap: () {
        //     //Navigator.pop(dropdownKey.currentContext); // Closes the dropdown
        //     //Navigator.push(context, MaterialPageRoute(builder: (context) => BoatForm(CreationState.edit, _boat)));
        //   },
        //   child: viewHolder.layout,
        // ),
      ));
    });

    return list;
  }

  @override
  DropdownButton getLayout() => generateDropdownButton(false);

  DropdownButton generateDropdownButton(bool isExpanded) {
    //https://stackoverflow.com/questions/67439716/flutter-close-dropdownbutton-dropdownmenu

    // GlobalKey dropdownKey = GlobalKey();
    // FocusNode dropdown = FocusNode();

    return DropdownButton(
      // key: dropdownKey,
      // focusNode: dropdown,
      isExpanded: isExpanded,
      value: getCurrentValue(),
      items: menuItems(),
      onChanged: (value) {
        var menuData = indexMenuDataByCode(value);

        menuData?.onTap?.call();

        if (code != value) {
          menuData?.onSelect?.call();
        }

        if (menuData?.isDisable == false) {
          code = value;
          callSetState.call();
        }
      },
    );
  }
}
