import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/data/login.dart';
import 'package:workday/model/dayinfo/dayinfo.dart';
import 'package:workday/model/task/task.dart';
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
    DayInfo? dayInfo = task.dayInfo;
    return Dismissible(
      key: GlobalKey(),
      background: draggableBackground(
          Colors.green, const Icon(Icons.done), Alignment.centerLeft),
      secondaryBackground: dayInfo == null
          ? draggableBackground(
              Colors.blue, const Icon(Icons.today), Alignment.centerRight)
          : draggableBackground(Colors.red, const Icon(Icons.calendar_today),
              Alignment.centerRight),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          task.status = task.status == TaskStatus.done
              ? TaskStatus.open
              : TaskStatus.done;
          task.update(context);
        } else {
          if (dayInfo != null) {
            dayInfo.destroy();
          } else {
            Provider.of<AppData>(context, listen: false).addToMyDay(
                task: task,
                email: Provider.of<Login>(context, listen: false).email!);
          }
        }
        return false;
      },
      child: ListTile(
        leading: buildStatusPicker(context),
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

  ColoredBox draggableBackground(
      Color color, Widget icon, Alignment alignment) {
    return ColoredBox(
      color: color,
      child: Align(
          alignment: alignment,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: icon,
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
