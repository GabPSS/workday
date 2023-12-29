import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/data/login.dart';
import 'package:workday/model/division/division.dart';
import 'package:workday/model/division/division_widget.dart';
import 'package:workday/model/organization/organization.dart';
import 'package:workday/model/task/task_editor_widget.dart';
import 'package:workday/model/task/task_page.dart';
import 'package:workday/ui/about_dialog.dart';
import 'package:workday/ui/login_page.dart';

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
  bool get isDivision => selectedDivision != null;

  @override
  Widget build(BuildContext context) {
    Widget scaffold = Scaffold(
      appBar: AppBar(
        title: isDivision
            ? Text(selectedDivision!.name)
            : Text(AppLocalizations.of(context)!.appTitle),
      ),
      body: !isDivision
          ? HomeFragment(
              onDivSelected: (div) => setState(() => selectedDivision = div),
            )
          : buildDivisionFragment(),
      floatingActionButton: buildFab(context),
      drawer: buildDrawer(),
    );

    if (isDivision) {
      scaffold = DefaultTabController(length: 2, child: scaffold);
    }
    return scaffold;
  }

  bool get desktopStyle => MediaQuery.of(context).size.width >= 840;
  bool get largeStyle => MediaQuery.of(context).size.width >= 1200;

  Widget buildDivisionFragment() {
    return desktopStyle
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: !largeStyle
                ? buildDivisionListDetailCombo
                : [
                    SizedBox(
                        width: 1200,
                        child: Row(
                          children: buildDivisionListDetailCombo,
                        ))
                  ],
          )
        : buildDivisionView();
  }

  List<Widget> get buildDivisionListDetailCombo {
    return [
      Expanded(
        child: buildDivisionView(),
      ),
      const Expanded(
        child: TaskEditorWidget(),
      )
    ];
  }

  Column buildDivisionView() {
    return Column(
      children: [
        buildTabBar(),
        Expanded(
          child: TabBarView(children: [
            AllTasksFragment(div: selectedDivision!),
            TodayFragment(div: selectedDivision!)
          ]),
        ),
      ],
    );
  }

  Widget buildTabBar() {
    return const TabBar(tabs: [
      Tab(text: "All tasks"),
      Tab(text: "My day"),
    ]);
  }

  FloatingActionButton buildFab(BuildContext context) {
    return isDivision
        ? FloatingActionButton(
            child: const Icon(Icons.add_task),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskPage(),
                  ));
            },
          )
        : FloatingActionButton(
            child: const Icon(Icons.domain_add),
            onPressed: () {
              throw UnimplementedError(
                  "Adding organizations not implemented"); //TODO: Implement adding and managing organizations
            },
          );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: Consumer<AppData>(
        builder: (context, data, child) => Column(
          children: [
            Consumer<Login>(
                builder: (context, login, child) => UserAccountsDrawerHeader(
                    accountName: Text(login.name ?? "Unknown account"),
                    accountEmail: Text(login.email ??
                        "Unknown email"))), //TODO: Localize these

            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text("Home"), //TODO: Localize this as well
              onTap: () {
                setState(() => selectedDivision = null);
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: ListView(
                children: [
                  for (Organization org in data.organizations)
                    Column(
                      children: [
                        ListTile(
                          title: Text(org.name,
                              style: TextStyle(
                                  color: Theme.of(context).disabledColor)),
                        ),
                        for (Division div in org.getDivisions(data))
                          DivisionWidget(
                              div: div,
                              onSelected: () {
                                setState(() => selectedDivision = div);
                                Navigator.pop(context);
                              })
                      ],
                    )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline_outlined),
              title: const Text("About app"),
              onTap: () => showWorkdayAboutDialog(context),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Sign out"),
              onTap: () {
                Login.signOut();
                Navigator.pushReplacement(
                    context,
                    DialogRoute(
                      context: context,
                      builder: (context) => const LoginPage(),
                    ));
              },
            )
          ],
        ),
      ),
    );
  }
}
