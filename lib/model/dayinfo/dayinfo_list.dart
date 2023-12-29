import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/data/login.dart';
import 'package:workday/model/dayinfo/dayinfo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:workday/model/task/task_widget.dart';

class DayInfoList extends StatelessWidget {
  final List<DayInfo> dayInfos;

  List<DayInfo> get taskDayInfos =>
      dayInfos.where((element) => element.task != null).toList();

  List<DayInfo> get quickDayInfos =>
      dayInfos.where((element) => element.task == null).toList();

  const DayInfoList({super.key, required this.dayInfos});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (taskDayInfos.isNotEmpty)
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.task_alt),
                title:
                    Text(AppLocalizations.of(context)!.tasksMyDaySectionTitle),
              ),
              for (var taskInfo in taskDayInfos)
                TaskWidget(task: taskInfo.task!)
            ],
          ),
        Column(children: [
          ListTile(
            leading: const Icon(Icons.notes),
            title:
                Text(AppLocalizations.of(context)!.quickNotesMyDaySectionTitle),
            trailing: IconButton(
                onPressed: () {
                  Provider.of<AppData>(context).addToMyDay(
                      email: Provider.of<Login>(context, listen: false).email!,
                      message: "");
                },
                icon: const Icon(Icons.add)),
          ),
          for (var quickInfo in quickDayInfos) quickInfo.quickField
        ]),
      ],
    );
  }
}
