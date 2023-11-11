import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workday/model/task.dart';
import 'package:workday/model/user.dart' as workday_user;

class AppData extends ChangeNotifier {
  List<workday_user.User> _users = List.empty(growable: true);
  List<Task> _tasks = List.empty(growable: true);

  AppData.empty();

  List<workday_user.User> get users => _users.cast();
  List<Task> get tasks => _tasks.cast();

  List<Task> get tasksPool =>
      _tasks.where((element) => !element.isAssigned).toList();

  List<Task> getTasksForUser(workday_user.User? user) {
    if (user == null) return List.empty();
    return _tasks
        .where((element) =>
            element.assignedTo == user.email && element.assignedTo != null)
        .toList();
  }

  Future<String> fetchData() async {
    log('Fetching system data');
    if (Supabase.instance.client.auth.currentSession == null) {
      log('Data fetch failed');
      return "Access denied";
    }

    log('Fetching tasks');
    PostgrestList tasksData =
        await Supabase.instance.client.from('tasks').select<PostgrestList>();
    _tasks = Task.parseTaskList(tasksData);

    log('Fetching users');
    PostgrestList usersData = await Supabase.instance.client
        .from('users')
        .select<PostgrestList>('email, name');
    _users = workday_user.User.parseUsersList(usersData);

    notifyListeners();
    return "Success";
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
