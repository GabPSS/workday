import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider, User;
import 'package:workday/data/app_data.dart';
import 'package:workday/model/user.dart';
import 'package:workday/ui/task_tile.dart';

class Task {
  String? id;
  DateTime? createdOn;
  DateTime? due;
  String title = "";
  List<String> description = List.empty(growable: true);
  String? assignedTo;
  TaskStatus status = TaskStatus.open;

  Task(
      {this.assignedTo,
      this.createdOn,
      required this.description,
      this.due,
      this.id,
      this.title = "",
      this.status = TaskStatus.open});

  bool get isAssigned => assignedTo != null;
  bool get isCompleted => status == TaskStatus.done;

  TaskTile get tile => TaskTile(task: this);

  User? getAssignedToUser(BuildContext context) {
    try {
      return Provider.of<AppData>(context, listen: false)
          .users
          .firstWhere((element) => element.email == assignedTo);
    } catch (e) {
      return null;
    }
  }

  CircleAvatar get avatar {
    return CircleAvatar(
      backgroundColor: taskStatusViewColors[taskStatusToInt(status)],
      child: Icon(
          status == TaskStatus.done ? Icons.task_alt : Icons.radio_button_off),
    );
  }

  static List<Task> parseTaskList(PostgrestList tasksData) {
    return tasksData.map((taskMap) {
      // var id = taskMap['id'] as String;
      // var createdAt = DateTime.tryParse(taskMap['created_at'] as String);
      // var due = taskMap['due'] as DateTime?;
      // var contents = (taskMap['contents'] as List<dynamic>).cast<String>();
      // var status = taskMap['status'] as int;
      // var assignedTo = taskMap['assigned_to'] as String?;
      // var title = taskMap['title'] as String;

      // return Task(
      //     id: id,
      //     createdOn: createdAt,
      //     due: due,
      //     description: contents,
      //     status: intToTaskStatus(status),
      //     assignedTo: assignedTo,
      //     title: title);
      return Task.fromMap(taskMap);
    }).toList();
  }

  factory Task.fromMap(Map<String, Object?> map) {
    var id = map['id'] as String?;
    var createdAt = DateTime.tryParse(map['created_at'] as String? ?? "");
    var due = DateTime.tryParse(map['due'] as String? ?? "");
    var contents = (map['contents'] as List<dynamic>).cast<String>();
    var status = map['status'] as int;
    var assignedTo = map['assigned_to'] as String?;
    var title = map['title'] as String;

    return Task(
        id: id,
        createdOn: createdAt,
        due: due,
        description: contents,
        status: intToTaskStatus(status),
        assignedTo: assignedTo,
        title: title);
  }

  Task clone() => Task.fromMap(toMap());

  Future<void> update(BuildContext context,
      [Map<String, Object?>? data]) async {
    log('Updating task');
    await Supabase.instance.client.from('tasks').update(data ?? toMap()).eq(
        'id',
        id); //TODO: Could bring an error here? Yes it does! Task ID is null so nothing gets updated (???)
    if (!context.mounted) return;
    Provider.of<AppData>(context, listen: false).fetchData();
  }

  Map<String, Object?> toMap() {
    return {
      if (createdOn != null) 'created_at': createdOn?.toUtc().toString(),
      'due': due?.toUtc().toString(),
      'contents': description,
      'status': taskStatusToInt(status),
      'assigned_to': assignedTo,
      'title': title
    };
  }
}

enum TaskStatus { open, started, pending, done }

const List<String> taskStatusViewTitles = [
  "Open",
  "Started",
  "Pending",
  "Done"
];
const List<TaskStatus> taskStatusViewStatuses = [
  TaskStatus.open,
  TaskStatus.started,
  TaskStatus.pending,
  TaskStatus.done
];
const List<Color> taskStatusViewColors = [
  Colors.grey,
  Colors.blue,
  Colors.red,
  Colors.green
];

TaskStatus intToTaskStatus(int value) {
  switch (value) {
    case 0:
      return TaskStatus.open;
    case 1:
      return TaskStatus.started;
    case 2:
      return TaskStatus.pending;
    case 3:
      return TaskStatus.done;
    default:
      return TaskStatus.open;
  }
}

int taskStatusToInt(TaskStatus status) {
  switch (status) {
    case TaskStatus.open:
      return 0;
    case TaskStatus.started:
      return 1;
    case TaskStatus.pending:
      return 2;
    case TaskStatus.done:
      return 3;
  }
}
