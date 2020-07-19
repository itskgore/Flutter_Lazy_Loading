import 'package:apptware/functions/widgetFunc.dart';
import 'package:apptware/navigator/fadeNavigator.dart';
import 'package:apptware/providers/dog.dart';
import 'package:apptware/screens/detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  // ScrollController _scrollController = new ScrollController();
  Future<void> getData() async {
    final dogProvider = Provider.of<Dog>(context, listen: false);
    await dogProvider.getData();
  }

  Future<void> loadMore() async {
    final dogProvider = Provider.of<Dog>(context, listen: false);
    dogProvider.loading(true);
    await dogProvider.getData();
    Future.delayed(Duration(seconds: 4), () {
      //  Display purpose:: To display scroller [Not required in real time]
      dogProvider.loading(false);
    });
  }

  @override
  void initState() {
    super.initState();
    // first way to archive it
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     // if we are the  end
    //     getData();
    //     print('asdas');
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    // _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Home Screen', true),
      key: _scaffoldkey,
      body: SafeArea(
          child: FutureBuilder(
        future: getData(),
        builder: (con, snap) => snap.connectionState == ConnectionState.waiting
            ? Center(
                child: CupertinoActivityIndicator(
                  radius: 20,
                ),
              )
            : Consumer<Dog>(builder: (con, dog, _) {
                return LazyLoadScrollView(
                  isLoading: loading,
                  onEndOfPage: () => loadMore(), // 2nd way to archieve it
                  child: ListView.builder(
                      // Another way (check at the end for code) is to wrap this widget in NotificationListener<ScrollNotification>( and then listen to the end of the scroll view and call loadMore()
                      // controller: _scrollController,
                      itemCount: dog.getDogData.length,
                      itemBuilder: (con, i) {
                        if (dog.isLoading && i == dog.getDogData.length - 1) {
                          return Center(
                            child: CupertinoActivityIndicator(
                              radius: 20,
                            ),
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                FadeNavigation(
                                    widget: Details(
                                  heroId: i,
                                  imgUrl: dog.getDogData[i],
                                )));
                          },
                          child: Hero(
                            tag: i,
                            child: Container(
                              height: buildHeight(context) * 0.30,
                              width: double.infinity,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                      image: NetworkImage(dog.getDogData[i]),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        );
                      }),
                );
              }),
      )),
    );
  }
}

// 3rd way to archieve this
// NotificationListener<ScrollNotification>(
//   onNotificationL(ScrollNotification scrol) {
//     if( !dog.isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
//       dog.loading(true);
//       loadMore();
//       dog.loading(false);
//     }
//   }
// )
