import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/data/login.dart';
import 'package:workday/model/division/division.dart';
import 'package:workday/model/organization/organization.dart';

import 'all_tasks_fragment.dart';
import 'home_fragment.dart';
import 'today_fragment.dart';

class WorkdayApp extends StatefulWidget {
  const WorkdayApp({super.key});

  @override
  State<WorkdayApp> createState() => _WorkdayAppState();
}

class _WorkdayAppState extends State<WorkdayApp> {
  Division? selectedDivision;

  @override
  Widget build(BuildContext context) {
    Widget scaffold = Scaffold(
      appBar: AppBar(
        title: selectedDivision != null
            ? Text(selectedDivision!.name)
            : Text(AppLocalizations.of(context)!.appTitle),
        bottom: selectedDivision != null
            ? const TabBar(tabs: [
                Tab(text: "All tasks"),
                Tab(text: "My day"),
              ])
            : null,
      ),
      body: selectedDivision == null
          ? HomeFragment(
              onDivSelected: (div) => setState(() => selectedDivision = div),
            )
          : TabBarView(children: [
              AllTasksFragment(div: selectedDivision!),
              TodayFragment(div: selectedDivision!)
            ]),
      drawer: Drawer(
        child: Consumer<AppData>(
          builder: (context, data, child) => ListView(
            children: [
              Consumer<Login>(
                  builder: (context, login, child) => UserAccountsDrawerHeader(
                      accountName: Text(login.name ?? "Unknown account"),
                      accountEmail: Text(login.email ??
                          "Unknown email"))), //TODO: Localize these

              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"), //TODO: Localize this as well
                onTap: () => setState(() => selectedDivision = null),
              ),

              for (Organization org in data.organizations)
                Column(
                  children: [
                    ListTile(
                      title: Text(org.name,
                          style: TextStyle(
                              color: Theme.of(context).disabledColor)),
                    ),
                    for (Division div in org.getDivisions(data))
                      ListTile(
                        leading:
                            const CircleAvatar(child: Icon(Icons.work_outline)),
                        title: Text(div.name),
                        onTap: () {
                          setState(() => selectedDivision = div);
                          Navigator.pop(context);
                        },
                      )
                  ],
                )
            ],
          ),
        ),
      ),
    );

    if (selectedDivision != null) {
      scaffold = DefaultTabController(length: 2, child: scaffold);
    }
    return scaffold;
  }
}
