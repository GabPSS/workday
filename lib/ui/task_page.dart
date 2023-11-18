import 'package:date_field/date_field.dart';
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
  bool newTask = false;
  late Task task;

  @override
  void initState() {
    if (widget.task == null) {
      task = Task(description: []);
      newTask = true;
    } else {
      task = widget.task!.clone();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Iterable<DropdownMenuItem<String>> userItems =
        Provider.of<AppData>(context, listen: false)
            .users
            .map((e) => DropdownMenuItem(
                  value: e.email,
                  child: Text(e.name),
                ));
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, task);
                },
                child: Text(
                  'SAVE',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ))
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: task.title,
                decoration: const InputDecoration(hintText: 'Title'),
                style: const TextStyle(
                  fontSize: 48,
                ),
                onChanged: (value) {
                  task.title = value.trim();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: DropdownButtonFormField<String?>(
                decoration: const InputDecoration(
                    labelText: "Assigned to", icon: Icon(Icons.person_outline)),
                value: task.getAssignedToUser(context)?.email,
                items: [
                  const DropdownMenuItem(value: null, child: Text("None")),
                  for (var item in userItems) item,
                ],
                onChanged: (value) {
                  setState(() {
                    task.assignedTo = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: DateTimeField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.date_range_outlined),
                  labelText: 'Created on',
                ),
                onDateSelected: (value) {
                  setState(() {
                    task.createdOn = value;
                  });
                },
                selectedDate: task.createdOn,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: DateTimeField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.date_range_outlined),
                  labelText: 'Due',
                ),
                onDateSelected: (value) {
                  setState(() {
                    task.due = value;
                  });
                },
                selectedDate: task.due,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: DropdownButtonFormField<TaskStatus>(
                value: task.status,
                decoration: const InputDecoration(
                  icon: Icon(Icons.auto_graph_outlined),
                  labelText: "Progress",
                ),
                items: taskStatusViewStatuses
                    .map((e) => DropdownMenuItem<TaskStatus>(
                        value: e,
                        child: Text(taskStatusViewTitles[taskStatusToInt(e)])))
                    .toList(),
                onChanged: (value) {
                  task.status = value ?? TaskStatus.open;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: TextFormField(
                initialValue: task.description.join('\n'),
                decoration: const InputDecoration(
                  icon: Icon(Icons.description_outlined),
                  labelText: 'Comments',
                ),
                maxLines: 5,
                onChanged: (value) {
                  task.description =
                      value.split('\n').map((e) => e.trim()).toList();
                },
              ),
            ),
          ],
        ));
  }
}
