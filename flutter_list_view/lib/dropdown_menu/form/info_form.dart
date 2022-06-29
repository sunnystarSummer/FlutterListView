import 'package:flutter/material.dart';
import 'package:flutter_list_view/base/base_padding.dart';
import 'package:flutter_list_view/base/base_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InfoForm extends AbsViewHolder {
  bool isBodyVisible = true;
  Widget? body;
  Function? onWrapPressed;

  // InfoForm({
  //   required this.body, required this.onWrapPressed,
  // });

  // InfoForm({
  //   required this.body,
  // });

  Widget _titleBar() {
    //8,42
    BorderRadius borderRadius;
    if (isBodyVisible == false) {
      borderRadius = BorderRadius.circular(8);
    } else {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
        bottomLeft: Radius.circular(0),
        bottomRight: Radius.circular(0),
      );
    }

    IconButton wrapButton = IconButton(
      iconSize: 36,
      icon: isBodyVisible
          ? const Icon(Icons.arrow_downward)
          : const Icon(Icons.arrow_forward),
      color: Colors.white,
      onPressed: (){
        onWrapPressed?.call();
      },
    );

    //https://www.geeksforgeeks.org/align-widget-in-flutter/
    //不能用Stack
    var bar = SizedBox(
      width: double.infinity,
      height: 42,
      child:
          // Stack(children: [
          Material(
        color: Colors.blue,
        borderRadius: borderRadius,
      ),
      // Align(alignment: Alignment.centerRight,
      //   child: wrapButton,)
      // ],
      // ),
    );

    return Stack(
      children: [
        bar,
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: wrapButton,
        // ),
      ],
    );
  }

  Widget _body() {
    //https://stackoverflow.com/questions/58350235/add-border-to-a-container-with-borderradius-in-flutter
    //8,42
    BorderRadius borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(0),
      topRight: Radius.circular(0),
      bottomLeft: Radius.circular(8),
      bottomRight: Radius.circular(8),
    );

    return SizedBox(
      width: double.infinity,
      //height: 100,
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
          child: body),
    );
  }

  void setOnWrapPressed(bool isVisible,Function onWrapPressed) {
    this.onWrapPressed = () {
      isBodyVisible = !isVisible;
      Fluttertoast.showToast(
        msg: "isBodyVisible:$isBodyVisible",
      );
      onWrapPressed.call();
    };
  }

  @override
  Widget getLayout() {
    if (isBodyVisible) {
      return BasePadding.paddingAll08(Column(
        children: [
          _titleBar(),
          _body(),
        ],
      ));
    } else {
      return BasePadding.paddingAll08(Column(
        children: [
          _titleBar(),
        ],
      ));
    }
  }

  void setBody(Widget body) {
    this.body = body;
  }
}
