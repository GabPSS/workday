import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/model/division/division.dart';
import 'package:workday/model/organization/organization.dart';

class HomeFragment extends StatelessWidget {
  final Function(Division div) onDivSelected;

  const HomeFragment({
    super.key,
    required this.onDivSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
      builder: (context, value, child) => ListView(
        children: [
          Text(
              "${value.me?.name} -- ${value.me?.email}"), //TODO: Change to a greeting message
          for (Organization e in value.organizations)
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.domain_outlined),
                    title: Text(e.name),
                  ),
                  const Divider(),
                  for (var div in e.getDivisions(value))
                    ListTile(
                      leading:
                          const CircleAvatar(child: Icon(Icons.work_outline)),
                      title: Text(div.name),
                      onTap: () => onDivSelected(div),
                    )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
