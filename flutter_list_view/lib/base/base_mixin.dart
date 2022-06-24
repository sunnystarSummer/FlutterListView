import 'package:flutter/cupertino.dart';

mixin MixinLayout{
  /// 取得佈局
  Widget getLayout();
}

mixin MixinDropMenu implements MixinLayout{
  Widget getDisableLayout();
}

mixin MixinPage {
  String get title;
}