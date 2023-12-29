import 'package:flutter/material.dart';
import 'package:workday/model/task/task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskPage extends StatelessWidget {
  final Task? task;
  final Function()? onCreate;
  bool get isAdding => task == null;

  const TaskPage({
    super.key,
    this.task,
    this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                onCreate?.call();
              },
              child: Text(
                AppLocalizations.of(context)!.saveFunction,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              )),
        ],
      ),
    );
  }
}
