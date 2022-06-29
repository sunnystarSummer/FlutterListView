import 'package:flutter/material.dart';
import '../../base/base_factory.dart';
import '../../base/base_view.dart';

class NormalMenuData extends AbsMenuData {
  NormalMenuData({
    required super.name,
    required super.code,
    super.isDisable = false,
    super.isPleaseHintAtFirst = false,
    super.onSelect,
    super.onTap,
  });
}

class NormalMenuViewHolder extends AbsViewHolder {
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

class NormalDropdownMenuFactory
    extends AbsDropdownMenuFactory<NormalMenuViewHolder, NormalMenuData> {
  NormalDropdownMenuFactory({required super.callSetState});

  @override
  void setOnBindViewHolder(
      NormalMenuViewHolder viewHolder, int position, NormalMenuData data) {
    if (data.isPleaseHintAtFirst) {
      viewHolder.setPleaseHint(data.name);
    } else {
      viewHolder.setLabelInfo(data.isDisable, data.name);
    }
  }

  @override
  NormalMenuViewHolder createViewHolder() => NormalMenuViewHolder();
}