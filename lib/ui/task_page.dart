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
            TextFormField(
              initialValue: task.title,
              decoration: const InputDecoration(hintText: 'Title'),
              style: const TextStyle(
                fontSize: 48,
              ),
              onChanged: (value) {
                task.title = value.trim();
              },
            ),
            DropdownButtonFormField<String?>(
              decoration: const InputDecoration(
                  labelText: "Assigned to",
                  icon: Icon(
                    Icons.person,
                  )),
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
          ],
        ));
  }
}
