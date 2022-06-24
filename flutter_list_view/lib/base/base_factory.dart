

abstract class AbsFactory {
  ///更新畫面，需要使用此Function
  Function callSetState;
  AbsFactory({required this.callSetState});
  //AbsFactory();
  // void setCallSetState(callSetState){
  //   this.callSetState = callSetState;
  // }

  // getSelf(){
  //   return this;
  // }
}

abstract class AbsListFactory<D> extends AbsFactory{

  AbsListFactory({required super.callSetState});

  List<D> dataList = [];
  void setList(List<D> list) {
    dataList = list;
  }
}