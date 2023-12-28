import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:workday/data/app_data.dart';
import 'package:workday/model/dayinfo/dayinfo.dart';
import 'package:workday/model/organization/organization.dart';
import 'package:workday/model/task/task.dart';
import 'package:workday/model/user.dart';

class Division {
  final String id;
  final String name;
  final Organization parent;

  Division({required this.id, required this.name, required this.parent});

  List<Task>? tasks;
  List<User>? friends;
  List<DayInfo>? dayinfos;

  bool get loaded => tasks != null && friends != null && dayinfos != null;

  Future<void> load(AppData appData) async {
    log("Fetching data for division ($name)");

    log("[$name] Fetching coworkers");
    PostgrestList friendsData = await Supabase.instance.client.rpc(
        "get_division_members",
        params: {'division': id}).select<PostgrestList>();
    friends = friendsData
        .map((e) => User(email: e['user_email'], name: e['user_name']))
        .toList();

    log("[$name] Fetching tasks");
    PostgrestList taskData = await Supabase.instance.client
        .from("tasks")
        .select<PostgrestList>()
        .eq('division_id', id);
    tasks = taskData
        .map((e) => Task(
              appData: appData,
              id: e['id'] as String?,
              createdOn: DateTime.tryParse(e['created_at'] as String? ?? ""),
              due: DateTime.tryParse(e['due'] as String? ?? ""),
              description: (e['contents'] as List<dynamic>).cast<String>(),
              status: intToTaskStatus(e['status'] as int),
              assignedTo: getFriend(e['assigned_to'] as String?),
              title: e['title'] as String,
              division: this,
            ))
        .toList();

    log("[$name] Fetching day info");
    PostgrestList dayinfoData = await Supabase.instance.client
        .from("dayinfo")
        .select<PostgrestList>()
        .eq("day", DateTime.now())
        .eq("division", id);
    dayinfos = dayinfoData
        .map((e) => DayInfo(
              id: e["id"] as String,
              task: getTask(e["task_id"]),
              message: e["message"],
              division: this,
            ))
        .toList();

    log("[$name] Done");
  }

  User? getFriend(String? email) {
    if (email == null) return null;

    return friends?.singleWhere((element) => element.email == email);
  }

  Task? getTask(String? id) {
    if (id == null) return null;

    return tasks?.singleWhere((element) => element.id == id);
  }
}
