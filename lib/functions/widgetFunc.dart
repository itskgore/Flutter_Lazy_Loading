import 'package:apptware/navigator/fadeNavigator.dart';
import 'package:apptware/providers/auth.dart';
import 'package:apptware/providers/authen.dart';
import 'package:apptware/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showSnack(
    BuildContext context, stringList, GlobalKey<ScaffoldState> _scaffoldkey) {
  _scaffoldkey.currentState.showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    content: Text(
      stringList,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.red),
    ),
    duration: Duration(seconds: 2),
    backgroundColor: Colors.black87,
  ));
}

SizedBox buildSizedBox(double height, double value) {
  return SizedBox(
    height: height * value,
  );
}

SizedBox buildSizedBoxWidth(double width, double value) {
  return SizedBox(
    width: width * value,
  );
}

double buildWidth(BuildContext context) => MediaQuery.of(context).size.width;

double buildHeight(BuildContext context) => MediaQuery.of(context).size.height;

AppBar buildAppBar(BuildContext context, title, home) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    actions: <Widget>[
      home
          ? IconButton(
              icon: Icon(
                Icons.highlight_off,
                color: Colors.white,
              ),
              onPressed: () async {
                final auth = Provider.of<Authen>(context, listen: false);
                await auth.logout();
                Navigator.pushReplacement(
                    context, FadeNavigation(widget: Login()));
              },
            )
          : Container()
    ],
    title: Text(
      '$title',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.black,
  );
}
