import 'package:flutter/material.dart';
import 'package:workday/model/task/task.dart';
import 'package:workday/model/task/task_widget.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  const TaskList({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(child: Text("No tasks to show"));
    }

    return ListView(
      children: tasks.map((e) => TaskWidget(task: e)).toList(),
    );
  }
}
