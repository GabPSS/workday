import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:workday/data/app_data.dart';
import 'package:workday/model/organization/organization.dart';
import 'package:workday/model/task/task.dart';
import 'package:workday/model/user.dart';

class Division {
  final String id;
  final String name;
  final Organization parent;

  Division({required this.id, required this.name, required this.parent});

  List<Task> tasks = List.empty(growable: true);
  List<User> friends = List.empty(growable: true);

  Future<void> fetchTasks(AppData appData) async {
    PostgrestList data = await Supabase.instance.client
        .from("tasks")
        .select<PostgrestList>()
        .eq('division_id', id);
    tasks = data
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
  }

  Future<void> fetchFriends() async {
    PostgrestList data = await Supabase.instance.client.rpc(
        "get_division_members",
        params: {'division_id': id}).select<PostgrestList>();
    friends = data
        .map((e) => User(email: e['user_email'], name: e['user_name']))
        .toList();
  }

  User? getFriend(String? email) {
    if (email == null) return null;

    return friends.singleWhere((element) => element.email == email);
  }
}
