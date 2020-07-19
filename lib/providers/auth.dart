import 'package:apptware/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  FirebaseUser _firebaseUser;
  FirebaseUser get user => _firebaseUser;

  void setUser(FirebaseUser user) {
    _firebaseUser = user;
    notifyListeners();
  }

  Future<void> login(User user, Auth auth) async {
    try {
      AuthResult response = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: user.email, password: user.password)
          .catchError((err) {
        print(err.toString());
      });
      if (response != null) {
        FirebaseUser firebaseUser = response.user;
        if (firebaseUser != null) {
          print("Login successfull ${firebaseUser.email}");
          auth.setUser(firebaseUser);
        }
      }
    } catch (e) {}
  }

  Future<void> sigup(User user, Auth auth) async {
    try {
      AuthResult response = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password)
          .catchError((onError) {
        print(onError.toString());
      });
      if (response != null) {
        UserUpdateInfo updateInfo = UserUpdateInfo();
        updateInfo.displayName = user.name;
        FirebaseUser firebaseUser = response.user;

        if (firebaseUser != null) {
          await firebaseUser.updateProfile(updateInfo);
          await firebaseUser.reload();
          print('Signup success ${firebaseUser.email}');
          FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
          auth.setUser(currentUser);
        }
      }
    } catch (e) {}
  }

  Future<void> signOut(Auth auth) async {
    try {
      await FirebaseAuth.instance.signOut().catchError((onError) {
        print(onError.toString());
        auth.setUser(null);
        notifyListeners();
      });
    } catch (e) {}
  }
}
