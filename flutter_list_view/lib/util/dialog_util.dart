import 'package:flutter/material.dart';
import 'package:flutter_list_view/base/base_padding.dart';

class DialogUtil {
  BuildContext context;


  DialogUtil({required this.context});

  Future<void> showTwoOptionDialog(
      {required initialLayout, onPressedOK, onPressedCancel}) async {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    Widget bodyLayout = initialLayout;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState){
          return AlertDialog(
            title: const Text('AlertDialog Title'),
            content: SingleChildScrollView(
              child: BasePadding.paddingAll08(
                SizedBox(
                  width: width,
                  child: bodyLayout,
                ),
              ),

              // ListBody(
              //   children: <Widget>[
              //     bodyLayout,
              //     //Text('This is a demo alert dialog.'),
              //     //Text('Would you like to approve of this message?'),
              //   ],
              // ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onPressedCancel.call();
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onPressedOK.call();
                },
              ),
            ],
          );
        },);
      },
    );
  }
}

class AbsDialog {
  String title;
  BuildContext context;

  AbsDialog({required this.title,required this.context});

  Function? callSetState;

  Future<void> showTwoOptionDialog(
      {required initialLayout, onPressedOK, onPressedCancel}) async {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    Widget bodyLayout = initialLayout;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState){




          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: BasePadding.paddingAll08(
                SizedBox(
                  width: width,
                  child: bodyLayout,
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onPressedCancel.call();
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onPressedOK.call();
                },
              ),
            ],
          );
        },);
      },
    );
  }
}
