import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/model/task.dart';

class TaskPage extends StatefulWidget {
  final Task? task;

  const TaskPage({super.key, this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ElevatedButton(
          onPressed: () {
            if (widget.task == null) {
              Provider.of<AppData>(context, listen: false)
                  .addTask(Task(description: ['Hello']));
              Navigator.pop(context);
            }
          },
          child: const Text('Add task')),
    );
  }
}
