import 'package:flutter/material.dart';
import 'package:flutter_list_view/base/base_view.dart';

import '../../base/base_factory.dart';
import '../../base/base_padding.dart';

class IDCard extends AbsViewHolder {
  String title = '';

  Widget getCardLayout() {
    BorderRadius borderRadius = BorderRadius.circular(8);
    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            //border: Border.all(color: Colors.blue),
            borderRadius: borderRadius,
            color: Colors.grey,
          ),
          child: Center(
            child: Text(
              '點擊上傳$title',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getCardWithTitle({required String title}) {
    this.title = title;
    return getLayout();
  }

  @override
  Widget getLayout() {
    Widget titleBar = Center(
      child: Text(title),
    );

    return BasePadding.paddingAll08(SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            BasePadding.paddingAll04(titleBar),
            getCardLayout(),
          ],
        )));
  }
}

class PhotoData {}

class PhotoViewHolder extends AbsViewHolder {
  String title = '';

  Widget getCardLayout() {
    BorderRadius borderRadius = BorderRadius.circular(8);

    return SizedBox(
      width: 100,
      height: 100,
      child: Container(
        decoration: BoxDecoration(
          //border: Border.all(color: Colors.blue),
          borderRadius: borderRadius,
          color: Colors.grey,
        ),
        // child: Center(
        //   child: Text('點擊上傳$title',style: const TextStyle(
        //     color: Colors.white,
        //   ),),
        // ),
      ),
    );
  }

  Widget getCardWithTitle({required String title}) {
    this.title = title;
    return getLayout();
  }

  @override
  Widget getLayout() {
    Widget titleBar = Center(
      child: Text(title),
    );

    return Text('');
  }
}

class PhotoListViewFactory
    extends AbsListViewFactory<PhotoViewHolder, PhotoData> {
  PhotoListViewFactory({required super.callSetState});

  @override
  void setOnBindViewHolder(PhotoViewHolder viewHolder, int position) {
    PhotoData data = dataList[position];

    // viewHolder.setLabelInfo(data.label);
    // viewHolder.setDeleteListener(() {
    //   removeItem(position);
    //   callSetState.call();
    // });
  }

  @override
  PhotoViewHolder createViewHolder() => PhotoViewHolder();
}

///照片瀏覽Gallery
class GalleryViewHolder extends AbsViewHolder {
  late PhotoListViewFactory photoListViewFactory;

  // Widget getListView(Function callSetState) {
  //   photoListViewFactory = PhotoListViewFactory(callSetState: callSetState);
  //   photoListViewFactory.isAnim = false;
  //   //photoListViewFactory.addItem(PhotoData());
  //
  //   var aaa = BasePadding.paddingAll08(
  //       photoListViewFactory.generateListView(Axis.vertical));
  //   //callSetState.call();
  //   return aaa;
  // }

  //https://stackoverflow.com/questions/54074398/nested-listviews-in-flutter-gives-horizontal-viewport-error
  //https://stackoverflow.com/questions/66882184/scrollbar-and-singlechildscrollview-not-working
  Widget getCategoryRows(List<PhotoData> listData,{required String title}) {
    List<Widget> categoryRows = [];
    for (PhotoData category in listData) {
      categoryRows.add(BasePadding.paddingAll04(PhotoViewHolder().getCardLayout()));
    }
    // return Scrollbar(child:


    Widget body = Container(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categoryRows,
        ),
      ),
    );


    return BasePadding.paddingAll04(SizedBox(
        child: Column(
          children: [
            BasePadding.paddingAll04(Text(title)),
            body,
          ],
        )));
  }

  @override
  Widget getLayout() {
    return const Text('');
    // BasePadding.paddingAll08(
    //     photoListViewFactory.generateListView(Axis.horizontal));
  }
}
