import 'package:flutter/material.dart';

enum AuthMode { Signup, Login }

class AuthState with ChangeNotifier {
  bool loading = false;
  void setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  AuthMode mode = AuthMode.Login;
  void changeMode(AuthMode mode) {
    this.mode = mode;
    notifyListeners();
  }
}
