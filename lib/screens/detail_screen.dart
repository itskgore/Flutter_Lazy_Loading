import 'package:apptware/functions/widgetFunc.dart';
import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  String imgUrl;
  int heroId;
  Details({Key key, this.imgUrl, this.heroId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Dog Description', false),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Hero(
            tag: heroId,
            child: Container(
              height: buildHeight(context) * 0.30,
              width: double.infinity,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      image: NetworkImage(imgUrl), fit: BoxFit.cover)),
            ),
          ),
          Center(
            child: Text('Desciption Screen'),
          )
        ],
      )),
    );
  }
}
