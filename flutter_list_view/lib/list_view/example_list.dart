import 'package:flutter/material.dart';

import 'base.dart';

class ExampleData {
  String label = 'default';
}

class ExampleViewHolder<ExampleData> extends AbsViewHolder {
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
  Widget get layout {
    return Row(
      children: [label, button],
    );
  }
}

class ExampleListViewFactory extends AbsListViewFactory<ExampleViewHolder, ExampleData> {
  late Function callSetState;

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
  dynamic createViewHolder() => ExampleViewHolder();

  void setState(onPressed) {
    callSetState = onPressed;
  }
}
