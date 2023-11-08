import 'package:flutter/material.dart';
import 'package:workday/model/task.dart';
import 'package:workday/model/user.dart';

class AppData extends ChangeNotifier {
  final List<User> _users = List.empty(growable: true);
  final List<Task> _tasks = List.empty(growable: true);

  AppData.empty();

  List<User> get users => _users.cast();
  List<Task> get tasks => _tasks.cast();

  List<Task> get tasksPool =>
      _tasks.where((element) => !element.isAssigned).toList();

  //TODO: Make this interact with a backend

  List<Task> getTasksForUser(User? user) {
    if (user == null) return List.empty();
    return _tasks
        .where((element) =>
            element.assignedTo == user.id && element.assignedTo != null)
        .toList();
  }

  void addUser(User user) {
    users.add(user);
    notifyListeners();
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
