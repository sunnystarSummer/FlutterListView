import 'package:flutter/cupertino.dart';

abstract class AbsStatefulWidget extends StatefulWidget {
  const AbsStatefulWidget({Key? key}) : super(key: key);
}

abstract class AbsState<T extends StatefulWidget> extends State<T> with TickerProviderStateMixin {

}