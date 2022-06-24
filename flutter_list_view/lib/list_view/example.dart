import 'package:flutter/material.dart';
import 'list_view_factory.dart';
import '../base/base_view.dart';


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
