import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/model/task/task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskPage extends StatefulWidget {
  final Task? task;
  final bool widgetOnly;

  const TaskPage({super.key, this.task, this.widgetOnly = false});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  bool newTask = false;
  late Task task;

  @override
  void initState() {
    if (widget.task == null) {
      task = Task(
          appData: Provider.of<AppData>(context, listen: false),
          description: []);
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

    ListView content = ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: task.title,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.taskTitle),
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
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.assignedTo,
                icon: const Icon(Icons.person_outline)),
            value: task.getAssignedToUser(context)?.email,
            items: [
              DropdownMenuItem(
                  value: null,
                  child: Text(AppLocalizations.of(context)!.noPerson)),
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
            decoration: InputDecoration(
              icon: const Icon(Icons.date_range_outlined),
              labelText: AppLocalizations.of(context)!.createdOn,
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
            decoration: InputDecoration(
              icon: const Icon(Icons.date_range_outlined),
              labelText: AppLocalizations.of(context)!.dueOn,
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
            decoration: InputDecoration(
              icon: const Icon(Icons.auto_graph_outlined),
              labelText: AppLocalizations.of(context)!.progress,
            ),
            items: taskStatusViewStatuses
                .map((e) => DropdownMenuItem<TaskStatus>(
                    value: e,
                    child: Text(
                        getTaskStatusViewTitles(context)[taskStatusToInt(e)])))
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
            decoration: InputDecoration(
              icon: const Icon(Icons.description_outlined),
              labelText: AppLocalizations.of(context)!.comments,
            ),
            maxLines: 5,
            onChanged: (value) {
              task.description =
                  value.split('\n').map((e) => e.trim()).toList();
            },
          ),
        ),
      ],
    );

    return widget.widgetOnly
        ? content
        : Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () async {
                      bool? result = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Remove task?"),
                          content: Text(
                              "You can't recover this task once it's been deleted"),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text("Cancel")),
                            TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text("Delete"))
                          ],
                        ),
                      );

                      if (result == true) {
                        if (!mounted) return;
                        widget.task?.delete(context);
                        Navigator.pop(context);
                      }
                    },
                    icon: Icon(Icons.delete)),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, task);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.saveFunction,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ))
              ],
            ),
            body: content);
  }
}
