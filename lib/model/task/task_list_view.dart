import 'package:flutter/material.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/model/task/task.dart';

class TaskListView extends StatefulWidget {
  final List<Task> tasks;
  final AppData appData;

  const TaskListView({
    required this.tasks,
    required this.appData,
    super.key,
  });

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => widget.tasks[index].tile,
      itemCount: widget.tasks.length,
    );
  }
}
