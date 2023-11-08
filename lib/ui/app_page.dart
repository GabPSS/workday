import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/data/user_data.dart';
import 'package:workday/model/task.dart';
import 'package:workday/model/user.dart';
import 'package:workday/ui/manage_users_page.dart';

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
          onPressed: () {
            value.addTask(Task(
              description: [
                'Test',
                'test'
              ], /*value.users[Random().nextInt(value.users.length)].id*/
            ));
          },
          tooltip: 'Add task',
          child: const Icon(Icons.add_task),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind), label: 'My tasks'),
        ],
        currentIndex: selectedPage,
        onTap: (value) => setState(() => selectedPage = value),
      ),
      appBar: AppBar(
        title: const Text('Workday'),
        actions: [
          const AccountSwitcher(),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'about',
                child: Text('About app'),
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
      body: getPage(selectedPage),
    );
  }

  Widget getPage(int index) {
    ///0: Task pool
    ///1: My tasks
    ///
    ///TODO: Implement pages
    switch (index) {
      case 0:
        return Consumer2<AppData, UserData>(
            builder: (context, appData, userData, child) => TaskListView(
                  tasks: appData.tasksPool,
                  appData: appData,
                  userData: userData,
                ));
      case 1:
        return Consumer2<AppData, UserData>(
            builder: (context, appData, userData, child) => TaskListView(
                  tasks: appData.getTasksForUser(userData.currentUser),
                  appData: appData,
                  userData: userData,
                ));
      default:
        throw UnimplementedError();
    }
  }
}

class TaskListView extends StatefulWidget {
  final List<Task> tasks;
  final AppData appData;
  final UserData? userData;

  const TaskListView({
    required this.tasks,
    required this.appData,
    this.userData,
    super.key,
  });

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        Task task = widget.tasks[index];
        return ListTile(
          title: Text(task.description[0]), //TODO: Safeguard here
          subtitle: Text("User ID: ${task.assignedTo}"),
          onTap: () {
            if (widget.userData != null) {
              setState(
                  () => task.assignedTo = widget.userData!.currentUser?.id);
            }
          },
        );
      },
      itemCount: widget.tasks.length,
    );
  }
}

class AccountSwitcher extends StatelessWidget {
  const AccountSwitcher({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserData, AppData>(
      builder: (context, userData, appData, child) {
        User manageAccountsPlaceholder = User.placeholder();
        User signOutPlaceholder = User.placeholder();
        return PopupMenuButton<User?>(
          tooltip: 'Switch accounts',
          icon: Icon(
              userData.loggedIn ? Icons.account_circle : Icons.no_accounts),
          itemBuilder: (context) {
            List<PopupMenuEntry<User?>> entries = List.empty(growable: true);

            if (appData.users.isNotEmpty) {
              entries.addAll(appData.users.map((e) => PopupMenuItem(
                    value: e,
                    child: Text(e.name),
                  )));

              entries.add(const PopupMenuDivider());
            }

            entries.add(PopupMenuItem(
                value: manageAccountsPlaceholder,
                child: const ListTile(
                  title: Text('Manage accounts'),
                  leading: Icon(Icons.manage_accounts),
                )));
            if (userData.loggedIn) {
              entries.add(PopupMenuItem(
                  value: signOutPlaceholder,
                  child: const ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Sign out'),
                  )));
            }

            return entries;
          },
          onSelected: (value) {
            if (value == manageAccountsPlaceholder) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ManageUsersPage()));
              return;
            }
            if (value == signOutPlaceholder) {
              userData.currentUser = null;
              return;
            }
            userData.currentUser = value;
          },
        );
      },
    );
  }
}
