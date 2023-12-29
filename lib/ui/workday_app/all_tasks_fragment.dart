import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/model/division/division.dart';

import '../../model/task/task_list.dart';

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
