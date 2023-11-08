import 'package:flutter/material.dart';
import 'package:workday/model/user.dart';

class UserData extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  set currentUser(User? value) {
    _currentUser = value;
    notifyListeners();
  }

  bool get loggedIn => _currentUser != null;

  DateTime viewingDay = DateTime.now();

  UserData.empty();
}
