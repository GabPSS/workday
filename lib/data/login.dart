import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workday/model/user.dart' as wday;

class Login extends ChangeNotifier {
  String? _email;
  String? _name;

  String? get email => _email;
  String? get name => _name;

  wday.User? get user => email != null
      ? name != null
          ? wday.User(email: email!, name: name!)
          : null
      : null;

  Login({String? email, String? token, String? name})
      : _name = name,
        _email = email;

  Future<bool> fetch([String? emailOnFail, String? passwordOnFail]) async {
    log('Retrieving session');

    var session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      log('Session found');
      _email = session.user.email;
      _name = await getName(_email);
      return _name != null;
    } else {
      log('No logged in session');
      return trySignIn(emailOnFail, passwordOnFail);
    }
  }

  Future<bool> trySignIn(String? email, String? password) async {
    if (email == null || password == null) return false;
    log('Attempting login');
    AuthResponse response;
    try {
      response = await Supabase.instance.client.auth
          .signInWithPassword(password: password, email: email);
    } catch (x) {
      log('Login Failed, check credentials');
      return false;
    }

    if (response.session != null && response.user != null) {
      log('Login successful, retrieving user data');
      var email = response.user!.email;

      String? name = await getName(email);

      log('SUCCESS');
      _email = email;
      _name = name;
      return true;
    }
    log('Login FAILED');
    return false;
  }

  static Future<String?> getName(String? email) async {
    PostgrestList nameRow = await Supabase.instance.client
        .from('users')
        .select<PostgrestList>('name')
        .eq('email', email);

    if (nameRow.isEmpty) log('Name fetch returned EMPTY');

    var name = nameRow.singleOrNull?['name'] as String?;
    log('Welcome, $name');
    return name;
  }

  static Future<void> signOut() async =>
      await Supabase.instance.client.auth.signOut();
}
