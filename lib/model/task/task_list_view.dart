import 'package:flutter/material.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/model/task/task.dart';
import 'package:workday/model/task/task_tile.dart';

class TaskListView extends StatefulWidget {
  final List<Task> tasks;
  final List<Task> selectedTasks;
  final AppData appData;
  final Function(Task)? onTaskTapped;

  const TaskListView({
    required this.tasks,
    required this.appData,
    super.key,
    this.onTaskTapped,
    this.selectedTasks = const [],
  });

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        Task task = widget.tasks[index];
        return TaskTile(
          task: task,
          selected: widget.selectedTasks.contains(task),
          onTap: widget.onTaskTapped != null
              ? () => widget.onTaskTapped?.call(task)
              : null,
        );
      },
      itemCount: widget.tasks.length,
    );
  }
}
