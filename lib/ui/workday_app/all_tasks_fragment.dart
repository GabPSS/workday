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
            return buildTaskList(div.tasks ?? []);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    }

    return buildTaskList(div.tasks!);
  }

  ListView buildTaskList(List<Task> tasks) {
    return ListView(
      children: tasks.map((e) => e.view).toList(),
    );
  }
}
