import 'package:supabase_flutter/supabase_flutter.dart';

class Task {
  String? id;
  DateTime? createdOn;
  DateTime? due;
  List<String> description = List.empty(growable: true);
  String? assignedTo;
  TaskStatus status = TaskStatus.open;

  Task(
      {this.assignedTo,
      this.createdOn,
      required this.description,
      this.due,
      this.id,
      this.status = TaskStatus.open});

  bool get isAssigned => assignedTo != null;
  bool get isCompleted => status == TaskStatus.done;

  static List<Task> parseTaskList(PostgrestList tasksData) {
    return tasksData.map((taskMap) {
      var id = taskMap['id'] as String;
      var createdAt = taskMap['created_at'] as DateTime?;
      var due = taskMap['due'] as DateTime?;
      var contents = (taskMap['contents'] as List<dynamic>).cast<String>();
      var status = taskMap['status'] as int;
      var assignedTo = taskMap['assigned_to'] as String?;

      return Task(
          id: id,
          createdOn: createdAt,
          due: due,
          description: contents,
          status: intToTaskStatus(status),
          assignedTo: assignedTo);
    }).toList();
  }

  Map<String, Object?> toMap() {
    return {
      'created_at': createdOn?.toUtc().toString(),
      'due': due?.toUtc().toString(),
      'contents': description,
      'status': taskStatusToInt(status),
      'assigned_to': assignedTo
    };
  }
}

enum TaskStatus { open, started, pending, done }

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
