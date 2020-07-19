import 'package:apptware/functions/widgetFunc.dart';
import 'package:apptware/models/user.dart';
import 'package:apptware/navigator/fadeNavigator.dart';
import 'package:apptware/providers/auth.dart';
import 'package:apptware/providers/authState.dart';
import 'package:apptware/providers/authen.dart';
import 'package:apptware/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  User user = User();

  Future<void> submit(BuildContext con) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    final auth = Provider.of<Authen>(context, listen: false);
    final authState = Provider.of<AuthState>(context, listen: false);
    if (authState.mode == AuthMode.Login) {
      authState.setLoading(true);
      final res = await auth.authenticate(user, 'verifyPassword');
      authState.setLoading(false);
      if (!res['status']) {
        showSnack(con, res['msg'], _scaffoldkey);
        return;
      }
      showSnack(con, 'User Authenticated', _scaffoldkey);
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(con, FadeNavigation(widget: Home()));
      });
    } else {
      authState.setLoading(true);
      final res = await auth.authenticate(user, 'signupNewUser');
      authState.setLoading(false);
      if (!res['status']) {
        showSnack(con, res['msg'], _scaffoldkey);
        return;
      }
      showSnack(con, 'User Authenticated', _scaffoldkey);
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(con, FadeNavigation(widget: Home()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Consumer<AuthState>(
          builder: (con, state, _) => Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(242, 242, 242, 100),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200],
                  spreadRadius: 5,
                  blurRadius: 2,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
              border: Border.all(color: Colors.grey[400]),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ListView(
              primary: false,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                              left: 25, top: buildHeight(context) * 0.10),
                          child: Text(
                            state.mode == AuthMode.Login
                                ? 'Sign In'
                                : 'Sign Up \nCreate a new account',
                            style: TextStyle(
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color.fromRGBO(110, 42, 104, 1)),
                          )),
                      Form(
                        key: _formKey,
                        child: Container(
                          margin:
                              EdgeInsets.only(top: buildHeight(context) * 0.05),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white60,
                                    prefixIcon: Icon(Icons.mail),
                                    hintText: 'Email-Id',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                110, 42, 104, 1)))),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  value = value.trim();
                                  bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value);
                                  if (!emailValid) {
                                    return 'Invalid email!';
                                  }
                                  if (value.isEmpty || !value.contains('@')) {
                                    return 'Invalid email!';
                                  }
                                },
                                onSaved: (value) {
                                  user.email = value.trim();
                                  // _authData2['email'] = value;
                                },
                              ),
                              buildSizedBox(buildHeight(context), 0.02),
                              TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white60,
                                    prefixIcon: Icon(Icons.lock),
                                    hintText: 'Password',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                110, 42, 104, 1)))),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  value = value.trim();
                                  if (value.isEmpty || value.length < 5) {
                                    return 'Password is too short!';
                                  }
                                },
                                onSaved: (value) {
                                  user.password = value;
                                  // _authData2['password'] = value;
                                },
                              ),
                              buildSizedBox(buildHeight(context), 0.05),
                              state.loading
                                  ? CupertinoActivityIndicator()
                                  : Container(
                                      width: double.infinity,
                                      child: RaisedButton(
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () {
                                          submit(context);
                                        },
                                        padding:
                                            EdgeInsets.symmetric(vertical: 13),
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(10.0),
                                        ),
                                        child: Text(
                                          state.mode == AuthMode.Login
                                              ? 'Sign In'
                                              : 'Sign Up',
                                          style: TextStyle(
                                            letterSpacing: 1,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                              buildSizedBox(buildHeight(context), 0.01),
                              Container(
                                width: double.infinity,
                                child: FlatButton(
                                  onPressed: () {
                                    state.mode == AuthMode.Login
                                        ? state.changeMode(AuthMode.Signup)
                                        : state.changeMode(AuthMode.Login);
                                  },
                                  padding: EdgeInsets.symmetric(vertical: 13),
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    state.mode == AuthMode.Login
                                        ? 'Sign Up'
                                        : 'Sign In',
                                    style: TextStyle(
                                      letterSpacing: 1,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              buildSizedBox(buildHeight(context), 0.05),
                              RichText(
                                text: TextSpan(
                                    text: 'By signing you agree with our',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 11),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' Terms & conditions',
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 11),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
