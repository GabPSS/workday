import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/model/dayinfo/quick_info_field.dart';
import 'package:workday/model/task/task.dart';

class DayInfo {
  final String? id;
  final String? taskId;
  final DateTime day;
  String? message;

  final AppData _appData;
  Task? get task => _appData.tasks
      .where((element) => element.id == taskId && element.id != null)
      .singleOrNull;

  DayInfo(
      {required AppData appData,
      this.id,
      required this.day,
      this.taskId,
      this.message})
      : _appData = appData;

  static DayInfo? fromId(String id, AppData appData) =>
      appData.dayInfos.where((element) => element.id == id).singleOrNull;

  QuickInfoField get quickField => QuickInfoField(dayInfo: this);

  static List<DayInfo> parseDayInfoList(
          PostgrestList data, AppData appData) =>
      data
          .map((e) => DayInfo(
              appData: appData,
              id: e['id'],
              day: DateTime.parse(e['day']).toLocal(),
              message: e['message'],
              taskId: e['task_id']))
          .toList();

  Map<String, dynamic> toMap([String? email]) {
    return {
      if (email != null) 'email': email,
      'task_id': taskId,
      'day': day.toString(),
      'message': message,
    };
  }

  Future<void> create(String email) async {
    await Supabase.instance.client.from('dayinfo').upsert(toMap(email));
    await _appData.fetchData();
  }

  Future<void> destroy() async {
    if (id == null) return;
    await Supabase.instance.client.from('dayinfo').delete().eq('id', id);
    await _appData.fetchData();
  }

  Future<void> update() async {
    await Supabase.instance.client.from('dayinfo').update(toMap()).eq('id', id);
    await _appData.fetchData();
  }
}
