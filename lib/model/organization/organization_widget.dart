import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/model/division/division.dart';
import 'package:workday/model/organization/organization.dart';

import '../division/division_widget.dart';

class OrganizationWidget extends StatelessWidget {
  const OrganizationWidget({
    super.key,
    required this.org,
    required this.onDivSelected,
  });

  final Organization org;
  final Function(Division div) onDivSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.domain_outlined),
            title: Text(org.name),
          ),
          const Divider(),
          for (var div in org.getDivisions(Provider.of<AppData>(context)))
            DivisionWidget(
              div: div,
              onSelected: () => onDivSelected(div),
            )
        ],
      ),
    );
  }
}
