import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/data/login.dart';
import 'package:workday/model/task.dart';

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
              icon: Icon(Icons.assignment_ind), label: 'Today\'s tasks'),
        ],
        currentIndex: selectedPage,
        onTap: (value) => setState(() => selectedPage = value),
      ),
      appBar: AppBar(
        title: const Text('Workday'),
        actions: [
          // const AccountSwitcher(),
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
      body: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<AppData>(context, listen: false).fetchData();
          },
          child: getPage(selectedPage)),
      drawer: NavigationDrawer(children: [
        Consumer<Login>(
          builder: (context, value, child) => UserAccountsDrawerHeader(
              accountName: Text(value.name ?? "No account"),
              accountEmail: Text(value.email ?? "No email")),
        ),
        const ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
        )
      ]),
    );
  }

  Widget getPage(int index) {
    ///0: Task pool
    ///1: My tasks
    ///
    ///TODO: Implement pages
    switch (index) {
      case 0:
        return Consumer<AppData>(
            builder: (context, appData, child) => TaskListView(
                  tasks: appData.tasksPool,
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
      itemBuilder: (context, index) {
        Task task = widget.tasks[index];
        return ListTile(
          title: Text(task.description[0]), //TODO: Safeguard here
          subtitle: Text("User ID: ${task.assignedTo}"),
          onTap: () {
            //TODO: Open task
          },
        );
      },
      itemCount: widget.tasks.length,
    );
  }
}
