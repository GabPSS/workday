import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:workday/model/task.dart';
import 'package:workday/model/user.dart' as workday_user;

class AppData extends ChangeNotifier {
  List<workday_user.User> _users = List.empty(growable: true);
  List<Task> _tasks = List.empty(growable: true);
  bool isUpdating = false;

  AppData.empty();

  List<workday_user.User> get users => _users.cast();
  List<Task> get tasks {
    List<Task> cast = _tasks.cast();
    cast.sort((a, b) {
      return a.createdOn == null
          ? -1
          : b.createdOn == null
              ? 1
              : a.createdOn!.compareTo(b.createdOn!);
    });
    cast.sort(
      (a, b) {
        return a.due == null
            ? -1
            : b.due == null
                ? 1
                : a.due!.compareTo(b.due!);
      },
    );
    return cast;
  }

  List<Task> get tasksPool =>
      _tasks.where((element) => !element.isAssigned).toList();

  List<Task> getTasksForUser(workday_user.User? user) {
    if (user == null) return List.empty();
    return _tasks
        .where((element) =>
            element.assignedTo == user.email && element.assignedTo != null)
        .toList();
  }

  Future<String> fetchData([bool sendNotifications = true]) async {
    isUpdating = true;
    if (sendNotifications) notifyListeners();

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
    isUpdating = false;

    if (sendNotifications) notifyListeners();
    return "Success";
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await Supabase.instance.client.from('tasks').insert(task.toMap());
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  workday_user.User? getUser(String? id) {
    if (id == null) return null;
    try {
      return users.firstWhere((element) => element.email == id);
    } catch (e) {
      return null;
    }
  }

  static AppData of(BuildContext context) =>
      Provider.of<AppData>(context, listen: false);
}
