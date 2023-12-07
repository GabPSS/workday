import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/data/login.dart';
import 'package:workday/model/task.dart';
import 'package:workday/ui/task_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int selectedPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Consumer<AppData>(
        builder: (context, value, child) => FloatingActionButton(
          onPressed: () async {
            Task? result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const TaskPage()));
            if (result != null) {
              if (!mounted) return;
              Provider.of<AppData>(context, listen: false).addTask(result);
            }
          },
          tooltip: AppLocalizations.of(context)!.addTaskFunction,
          child: const Icon(Icons.add_task),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.list),
              label: AppLocalizations.of(context)!.allTasksNavMenuLabel),
          BottomNavigationBarItem(
              icon: const Icon(Icons.assignment_ind),
              label: AppLocalizations.of(context)!.todayTasksNavMenuLabel),
        ],
        currentIndex: selectedPage,
        onTap: (value) => setState(() => selectedPage = value),
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          IconButton(
            onPressed: () {
              AppData.of(context).fetchData();
            },
            icon: Consumer<AppData>(
                builder: (context, value, child) => value.isUpdating
                    ? const Icon(Icons.cloud_sync)
                    : const Icon(Icons.cloud_done)),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'about',
                child: Text(AppLocalizations.of(context)!.aboutAppMenuLabel),
              )
            ],
            onSelected: (value) {
              switch (value) {
                case 'about':
                  showAboutDialog(context: context);
                  break;
              }
            },
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<AppData>(context, listen: false).fetchData();
          },
          child: getPage(selectedPage)),
      drawer: NavigationDrawer(children: [
        Consumer<Login>(
          builder: (context, value, child) => UserAccountsDrawerHeader(
              accountName: Text(value.name ??
                  AppLocalizations.of(context)!.noAccountPlaceholder),
              accountEmail: Text(value.email ??
                  AppLocalizations.of(context)!.noEmailPlaceholder)),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: Text(AppLocalizations.of(context)!.homePageMenuLabel),
        )
      ]),
    );
  }

  Widget getPage(int index) {
    ///0: Task poola
    ///1: My tasks
    ///
    ///TODO: Implement pages
    switch (index) {
      case 0:
        return Consumer<AppData>(
            builder: (context, appData, child) => TaskListView(
                  tasks: appData.tasks,
                  appData: appData,
                ));
      case 1:
        // return Consumer2<AppData, UserData>(
        //     builder: (context, appData, userData, child) => TaskListView(
        //           tasks: appData.getTasksForUser(userData.currentUser),
        //           appData: appData,
        //           userData: userData,
        //         ));
        return const Placeholder();
      default:
        throw UnimplementedError();
    }
  }
}

class TaskListView extends StatefulWidget {
  final List<Task> tasks;
  final AppData appData;

  const TaskListView({
    required this.tasks,
    required this.appData,
    super.key,
  });

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => widget.tasks[index].tile,
      itemCount: widget.tasks.length,
    );
  }
}
