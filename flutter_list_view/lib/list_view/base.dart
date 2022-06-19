import 'package:flutter/material.dart';

//ViewHolder
abstract class ViewHolder {
  Widget get layout;

  Widget slideInLeft(Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: layout,
    );
  }

  Widget slideOutRight(Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: layout,
    );
  }
}

//Factory
abstract class ListViewFactory<VH extends ViewHolder, D> {
  bool isAnim = false;

  List<D> dataList = [];

  // The key of the list
  GlobalKey<AnimatedListState> keyList = GlobalKey();

  //清單滑動當前位置
  double currentPosition = 0;
  ScrollController scrollController = ScrollController();

  // ListViewFactory(){
  //
  // }

  void setList(List<D> list) {
    dataList = list;
  }

  void addItem(D data) {
    int last = dataList.length;
    dataList.insert(last, data);
    if (isAnim == true) {
      keyList.currentState!
          .insertItem(last, duration: const Duration(milliseconds: 200));
    }
  }

  void removeItem(int index) {
    D data = dataList[index];
    VH viewHolder = createViewHolder();

    setOnBindViewHolder(viewHolder, index, data);

    if (isAnim == true) {
      keyList.currentState!.removeItem(
          index, (_, animation) => viewHolder.slideOutRight(animation),
          duration: const Duration(milliseconds: 200));
    }
    dataList.removeAt(index);
  }

  //產生ViewHolder
  dynamic createViewHolder();

  void setOnBindViewHolder(VH viewHolder, int position, D data);

  /// 新增項目畫面
  Widget addItemView(context, index, {animation}) {
    VH viewHolder = createViewHolder();
    D data = dataList[index];
    setOnBindViewHolder(viewHolder, index, data);

    if (isAnim) {
      return viewHolder.slideInLeft(animation);
    }
    return viewHolder.layout;
  }

  void setTop() {
    setScrollPosition(scrollController.position.minScrollExtent);
  }

  void setBottom() {
    setScrollPosition(scrollController.position.maxScrollExtent);
  }

  void setScrollPosition(double position) {
    scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
    );
  }

  /// 產生直列清單
  Widget generateListView(scrollDirection) {
    //Axis.horizontal
    scrollController = ScrollController(initialScrollOffset: currentPosition);
    scrollController.addListener(() {
      currentPosition = scrollController.position.pixels;
    });

    if (isAnim == false) {
      return ListView.builder(
        key: keyList,
        itemCount: dataList.length,
        scrollDirection: scrollDirection,
        controller: scrollController,
        itemBuilder: (context, index) {
          return addItemView(context, index);
        },
      );
    }

    //https://medium.com/flutter-community/how-to-animate-items-in-list-using-animatedlist-in-flutter-9b1a64e9aa16
    return AnimatedList(
      key: keyList,
      initialItemCount: dataList.length,
      scrollDirection: scrollDirection,
      controller: scrollController,
      itemBuilder: (context, index, animation) {
        return addItemView(context, index, animation: animation);
      },
    );
  }

  /// 產生網格清單
  Widget generateGridView(var gridDelegate) {
    //https://api.flutter.dev/flutter/widgets/GridView-class.html
    //Axis.horizontal

    isAnim = false;

    scrollController = ScrollController(initialScrollOffset: currentPosition);
    scrollController.addListener(() {
      currentPosition = scrollController.position.pixels;
    });

    return GridView.builder(
        gridDelegate: gridDelegate,
        itemCount: dataList.length,
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            //color: Colors.transparent,
            child: Center(child: addItemView(context, index)),
          );
        });
  }
}
