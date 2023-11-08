import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/model/user.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage accounts'),
      ),
      body: Consumer<AppData>(
        builder: (context, appData, child) {
          List<Widget> items = List.empty(growable: true);

          items.addAll(appData.users.map((e) => ListTile(
                leading: const Icon(Icons.account_box),
                subtitle: Text(e.id ?? "No ID"),
                title: Text(e.name),
              )));

          items.add(const Divider());

          items.add(ListTile(
            onTap: () {
              User user =
                  User(id: Random().nextInt(80000).toString(), name: "User");
              appData.addUser(user);
            },
            leading: const Icon(Icons.add),
            title: const Text('Add account'),
          ));

          return ListView(children: items);
        },
      ),
    );
  }
}
