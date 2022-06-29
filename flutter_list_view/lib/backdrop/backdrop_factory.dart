import 'package:flutter/material.dart';
import 'package:flutter_list_view/base/base_mixin.dart';

import '../base/base_view.dart';
import '../base/base_factory.dart';

//https://material.io/components/backdrop
//https://medium.com/@CORDEA/implement-backdrop-with-flutter-73b4c61b1357

abstract class AbsBackDropFactory<VH extends AbsViewHolder, D>
    extends AbsFactory with MixinLayout {
  //圓角
  get radius16 => const Radius.circular(16.0);
  static const panelHeight = 32.0;

  late AnimationController controller;

  AbsBackDropFactory({required super.callSetState});

  build({required vsync}) {
    controller = AnimationController(
        duration: const Duration(milliseconds: 100), value: 1.0, vsync: vsync);
  }

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

  Widget showBackDrop(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    // return PositionedTransition(
    //   rect: animation,
    //   child: getLayout(),
    // );

    return Stack(
      children: <Widget>[
        const Center(
          child: Text("base"),
        ),
        PositionedTransition(
          rect: animation,
          child: getLayout(),
        ),
      ],
    );
  }

  @override
  Widget getLayout() {
    return Material(
      borderRadius: BorderRadius.only(
        topLeft: radius16,
        topRight: radius16,
      ),
      elevation: 12.0,
      child: Column(children: <Widget>[
        const SizedBox(
          height: panelHeight,
          child: Center(child: Text("panel")),
        ),
        buildPanel(),
      ]),
    );
  }

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double height = constraints.biggest.height;
    final double top = height - panelHeight;
    const double bottom = -panelHeight;
    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
      end: const RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
  }

  bool get isPanelVisible {
    final AnimationStatus status = controller.status;
    return status == AnimationStatus.completed||status == AnimationStatus.forward;
  }

  void dispose() {
    controller.dispose();
  }
}

class ExampleBackDropViewHolder extends AbsViewHolder {
  @override
  Widget getLayout() {
    return const Expanded(child: Center(child: Text("content")));
  }
}

class ExampleBackDropData {}

class ExampleBackDropFactory
    extends AbsBackDropFactory<ExampleBackDropViewHolder, ExampleBackDropData> {
  ExampleBackDropFactory({required super.callSetState});

  @override
  ExampleBackDropViewHolder createViewHolder() => ExampleBackDropViewHolder();

  @override
  void setOnBindViewHolder(
      ExampleBackDropViewHolder viewHolder, ExampleBackDropData data) {
    // TODO: implement setOnBindViewHolder
  }
}
