import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workday/model/task/task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:workday/model/task/task_page.dart';

class TaskWidget extends StatelessWidget {
  final Task task;

  const TaskWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: buildStatusPicker(context),
      title: Text(task.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var line in task.description) Text(line),
          buildIconRow(
              Icons.person,
              task.assignedTo?.name ??
                  AppLocalizations.of(context)!.noPersonLabel),
          buildIconRow(
              Icons.calendar_today,
              task.due != null
                  ? AppLocalizations.of(context)!
                      .dueOnLabel(DateFormat.d().format(task.due!))
                  : AppLocalizations.of(context)!.noDueDateLabel)
        ],
      ),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskPage(task: task),
          )),
    );
  }

  Row buildIconRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
          child: Text(text),
        )
      ],
    );
  }

  PopupMenuButton buildStatusPicker(BuildContext context) {
    return PopupMenuButton<TaskStatus>(
      child: task.avatar,
      onSelected: (value) {
        task.status = value;
        task.update(context);
      },
      itemBuilder: (context) {
        List<PopupMenuItem<TaskStatus>> items = List.empty(growable: true);
        for (int i = 0; i < taskStatusViewStatuses.length; i++) {
          var currentStatus = taskStatusViewStatuses[i];
          items.add(PopupMenuItem<TaskStatus>(
            value: currentStatus,
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: Icon(currentStatus == task.status
                  ? Icons.radio_button_on
                  : Icons.radio_button_off),
              title: Text(getTaskStatusViewTitles(context)[i]),
            ),
          ));
        }
        return items;
      },
    );
  }
}
