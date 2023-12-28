import 'package:workday/data/app_data.dart';
import 'package:workday/model/division/division.dart';

class Organization {
  final String id;
  final String name;

  Organization({required this.id, required this.name});

  List<Division> getDivisions(AppData appData) =>
      appData.divisions.where((element) => element.parent == this).toList();
}
