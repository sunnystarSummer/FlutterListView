//https://material.io/components/backdrop
//https://medium.com/@CORDEA/implement-backdrop-with-flutter-73b4c61b1357
import 'package:flutter/material.dart';
import 'package:flutter_list_view/base/base_mixin.dart';

import '../base/base.dart';

abstract class AbsBackDropFactory<VH extends AbsViewHolder, D>
    extends AbsFactory with MixinLayout {
  //圓角
  get radius16 => const Radius.circular(16.0);
  static const panelHeight = 32.0;

  AbsBackDropFactory({required super.callSetState});

  late D data;
  setData(D data) {
    this.data = data;
  }

  //產生ViewHolder
  VH createViewHolder();

  void setOnBindViewHolder(VH viewHolder, D data);

  Widget buildPanel() {
    VH viewHolder = createViewHolder();
    setOnBindViewHolder(viewHolder, data);
    return viewHolder.getLayout();
  }

  // @override
  // Widget getLayout(){
  //
  //   return Material(
  //     borderRadius: BorderRadius.only(
  //       topLeft: radius16,
  //       topRight: radius16,
  //     ),
  //     elevation: 12.0,
  //     child: Column(children: const <Widget>[
  //       SizedBox(
  //         height: panelHeight,
  //         child: Center(child: Text("panel")),
  //       ),
  //       buildPanel(),
  //       //Expanded(child: Center(child: Text("content"))),
  //       //Expanded(child: buildPanel()),
  //     ]),
  //   );
  // }
}
