import 'package:workday/model/dayinfo/quick_info_field.dart';
import 'package:workday/model/division/division.dart';
import 'package:workday/model/task/task.dart';

class DayInfo {
  final String id;
  final Task? task;
  final Division division;

  String? message;

  DayInfo(
      {required this.id,
      required this.task,
      required this.message,
      required this.division});

  QuickInfoField get quickField => QuickInfoField(dayInfo: this);

  void update() {
    //TODO: Create this update method
  }

  void delete() {
    //TODO: Also create this delete method
  }
}
