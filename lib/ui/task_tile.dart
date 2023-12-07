import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/data/login.dart';
import 'package:workday/model/task.dart';
import 'package:workday/ui/task_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: GlobalKey(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          task.status = task.status == TaskStatus.done
              ? TaskStatus.open
              : TaskStatus.done;
          task.update(context);
        } else {
          task.assignedTo = Provider.of<Login>(context, listen: false).email;
          task.update(context);
        }
        return false;
      },
      child: ListTile(
        leading: buildStatusPicker(),
        title: Text(task.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var line in task.description) Text(line),
            buildIconRow(
                Icons.person,
                Provider.of<AppData>(context).getUser(task.assignedTo)?.name ??
                    AppLocalizations.of(context)!.noPersonLabel),
            buildIconRow(
                Icons.calendar_today,
                task.due != null
                    ? AppLocalizations.of(context)!
                        .dueOnLabel(DateFormat.d().format(task.due!))
                    : AppLocalizations.of(context)!.noDueDateLabel)
          ],
        ),
        onTap: () async {
          Task? result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => TaskPage(task: task)));
          if (result != null) {
            if (!context.mounted) return;
            task.update(context, result.toMap());
          }
        },
      ),
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

  PopupMenuButton<dynamic> buildStatusPicker() {
    return PopupMenuButton(
      child: task.avatar,
      itemBuilder: (context) {
        List<PopupMenuItem> items = List.empty(growable: true);
        for (int i = 0; i < taskStatusViewStatuses.length; i++) {
          var currentStatus = taskStatusViewStatuses[i];
          items.add(PopupMenuItem(
            value: currentStatus,
            child: ListTile(
              leading: Icon(currentStatus == task.status
                  ? Icons.radio_button_on
                  : Icons.radio_button_off),
              title: Text(taskStatusViewTitles[i]),
              onTap: () {
                task.status = currentStatus;
                task.update(context);
                Navigator.pop(context);
              },
            ),
          ));
        }
        return items;
      },
    );
  }
}
