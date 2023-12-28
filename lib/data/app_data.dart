import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:workday/model/dayinfo/dayinfo.dart';
import 'package:workday/model/organization/organization.dart';
import 'package:workday/model/user.dart';

import '../model/division/division.dart';

class AppData extends ChangeNotifier {
  List<Organization> organizations = List.empty(growable: true);
  List<Division> divisions = List.empty(growable: true);

  User? me;

  AppData({this.me});

  Future<void> fetchData() async {
    log("Fetching user data (${me?.email})");
    PostgrestList list = await Supabase.instance.client.rpc("get_user_info",
        params: {'email': me?.email}).select<PostgrestList>();

    for (PostgrestMap divisionData in list) {
      _getOrAddDivision(
          divisionData["division_id"],
          divisionData["division_name"],
          _getOrAddOrganization(
              divisionData["org_id"], divisionData["org_name"]));
    }

    //TODO: Fetch dayinfos
  }

  Future<void> updateAll() async {
    await fetchData();
    notifyListeners();
  }

  Organization _getOrAddOrganization(String id, String name) =>
      organizations.singleWhere(
        (element) => element.id == id,
        orElse: () {
          Organization organization = Organization(id: id, name: name);
          organizations.add(organization);
          return organization;
        },
      );

  Division _getOrAddDivision(
      String id, String name, Organization organization) {
    return divisions.singleWhere(
      (element) => element.id == id,
      orElse: () => _addDivision(id, name, organization),
    );
  }

  Division _addDivision(String id, String name, Organization organization) {
    Division division = Division(id: id, name: name, parent: organization);
    divisions.add(division);
    return division;
  }

  void addToMyDay({required String email, required String message}) {
    //TODO: Create "AddToMyDay" method
  }
}
