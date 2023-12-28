import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/model/division/division.dart';
import 'package:workday/model/task/task.dart';

class AllTasksFragment extends StatelessWidget {
  final Division div;

  const AllTasksFragment({super.key, required this.div});

  @override
  Widget build(BuildContext context) {
    if (!div.loaded) {
      return FutureBuilder(
        future: div.load(Provider.of<AppData>(context)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return TaskList(tasks: div.tasks ?? []);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    }

    return TaskList(tasks: div.tasks!);
  }
}

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  const TaskList({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(child: Text("No tasks to show"));
    }

    return ListView(
      children: tasks.map((e) => e.view).toList(),
    );
  }
}
