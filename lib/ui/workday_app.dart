import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/data/login.dart';
import 'package:workday/model/dayinfo/dayinfolist.dart';
import 'package:workday/model/task/task.dart';
import 'package:workday/ui/about_dialog.dart';
import 'package:workday/ui/login_page.dart';
import 'package:workday/ui/share_page.dart';
import 'package:workday/ui/task_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/task/task_list_view.dart';

class WorkdayApp extends StatefulWidget {
  const WorkdayApp({super.key});

  @override
  State<WorkdayApp> createState() => _WorkdayAppState();
}

class _WorkdayAppState extends State<WorkdayApp> {
  int selectedPage = 1;

  DesignLayout get currentLayout {
    Size size = MediaQuery.of(context).size;
    if (size.width < 600) {
      return DesignLayout.small;
    } else if (size.width >= 600 && size.width < 840) {
      return DesignLayout.medium;
    } else {
      return DesignLayout.large;
    }
  }

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
      bottomNavigationBar: currentLayout == DesignLayout.small
          ? BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(Icons.list),
                    label: AppLocalizations.of(context)!.allTasksNavMenuLabel),
                BottomNavigationBarItem(
                    icon: Consumer<AppData>(
                      builder: (context, value, child) => Badge.count(
                        count: value.dayInfos.length,
                        child: const Icon(Icons.today),
                      ),
                    ),
                    label:
                        AppLocalizations.of(context)!.todayTasksNavMenuLabel),
              ],
              currentIndex: selectedPage,
              onTap: (value) => setState(() => selectedPage = value),
            )
          : null,
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
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const Dialog.fullscreen(
                    child: ShareDialog(),
                  ),
                );
              },
              icon: const Icon(Icons.share)),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'about',
                child: Text(AppLocalizations.of(context)!.aboutAppMenuLabel),
              ),
              PopupMenuItem(
                  value: 'signout',
                  child: Text(AppLocalizations.of(context)!.signOutMenuLabel))
            ],
            onSelected: (value) {
              switch (value) {
                case 'about':
                  showWorkdayAboutDialog(context);
                  break;
                case 'signout':
                  Login.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                  break;
              }
            },
          )
        ],
      ),
      body: Row(
        children: [
          if (currentLayout.index > 0)
            NavigationRail(
              destinations: [
                NavigationRailDestination(
                    icon: const Icon(Icons.list),
                    label: Text(
                        AppLocalizations.of(context)!.allTasksNavMenuLabel)),
                NavigationRailDestination(
                    icon: Consumer<AppData>(
                      builder: (context, value, child) => Badge.count(
                        count: value.dayInfos.length,
                        child: const Icon(Icons.today),
                      ),
                    ),
                    label: Text(
                        AppLocalizations.of(context)!.todayTasksNavMenuLabel)),
              ],
              selectedIndex: selectedPage,
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: (value) =>
                  setState(() => selectedPage = value),
            ),
          Expanded(
            child: RefreshIndicator(
                onRefresh: () async {
                  await Provider.of<AppData>(context, listen: false)
                      .fetchData();
                },
                child: getPage(selectedPage)),
          ),
          if (currentLayout == DesignLayout.large)
            Expanded(child: getTaskPage())
        ],
      ),
    );
  }

  Widget getPage(int index) {
    ///0: Tasks
    ///1: My day
    switch (index) {
      case 0:
        return Consumer<AppData>(
            builder: (context, appData, child) => TaskListView(
                  tasks: appData.tasks,
                  appData: appData,
                  onTaskTapped: currentLayout == DesignLayout.large
                      ? (task) {
                          setState(() {
                            selectedTask = task == selectedTask ? null : task;
                            toggleTaskSelection(task);
                          });
                        }
                      : null,
                ));
      case 1:
        return Consumer<AppData>(
            builder: (context, value, child) =>
                DayInfoList(dayInfos: value.dayInfos));
      default:
        throw UnimplementedError();
    }
  }

  void toggleTaskSelection(Task task) {
    if (selectedTasks.contains(task)) {
      selectedTasks.remove(task);
    } else {
      selectedTasks.add(task);
    }
  }

  List<Task> selectedTasks = List.empty(growable: true);
  Task? selectedTask;

  Widget getTaskPage() {
    if (selectedTask == null) {
      return const Center(
        child: Text("Select a task from the left"),
      );
    }

    return TaskPage(
      //TODO: setState doesn't update the page's fields, plus saving doesn't work
      task: selectedTask,
      widgetOnly: true,
    );
  }
}

enum DesignLayout { small, medium, large }
