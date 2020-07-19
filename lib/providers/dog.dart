import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'auth.dart';

class Dog with ChangeNotifier {
  List<String> dogData = new List<String>();
  bool isLoading = false;
  Auth auth;
  void upate(Auth auth) {
    this.auth = auth;
  }

  List<String> get getDogData {
    return [...dogData];
  }

  void loading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  Future<Map<String, dynamic>> getData() async {
    Map<String, dynamic> res = {'status': false, 'msg': ''};
    try {
      // https://5f13232ecbf15a0016f4e57b.mockapi.io/getData
      final response =
          await http.get('https://dog.ceo/api/breeds/image/random');

      if (response.statusCode == 200) {
        for (int i = 0; i < 5; i++) {
          dogData.add(json.decode(response.body)['message']);
          notifyListeners();
        }
      } else {
        res['status'] = false;
        res['msg'] = 'Something went wrong please try again!';
        return res;
      }
    } catch (e) {
      print(e.toString());
      res['status'] = false;
      res['msg'] = 'Something went wrong please try again!';
      return res;
    } finally {
      loading(false);
    }
  }
}
