import 'package:bill_splitter/main.dart';
import 'package:flutter/material.dart';

class UserList extends ChangeNotifier {
  final List<UserData> _userList = [];

  List<UserData> get userList => _userList;

  addData(UserData user) {
    _userList.insert(0, user);
    notifyListeners();
  }

  removeData(int index) {
    _userList.removeAt(index);
    notifyListeners();
  }
}
