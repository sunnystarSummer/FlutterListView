import 'package:flutter/cupertino.dart';

mixin MixinLayout{
  Widget getLayout();
}

mixin MixinDropMenu implements MixinLayout{
  Widget getDisableLayout();
}

mixin MixinPage {
  String get title;
}