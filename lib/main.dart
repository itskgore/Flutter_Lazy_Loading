import 'package:apptware/functions/initalUser.dart';
import 'package:apptware/providers/authState.dart';
import 'package:apptware/providers/dog.dart';
import 'package:apptware/screens/home_screen.dart';
import 'package:apptware/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'providers/authen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: AuthState()),
        ChangeNotifierProvider.value(value: Authen()),
        ChangeNotifierProxyProvider<Auth, Dog>(
          create: (_) => Dog(),
          update: (_, auth, dog) => dog..upate(auth),
        ),
      ],
      child: Consumer<Authen>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Lazy Load',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? Home()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? Container()
                          : Login(),
                ),
        ),
      ),
    );
  }
}
