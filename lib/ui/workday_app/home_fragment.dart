import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/model/division/division.dart';
import 'package:workday/model/organization/organization.dart';
import '../../model/organization/organization_widget.dart';

class HomeFragment extends StatelessWidget {
  final Function(Division div) onDivSelected;

  const HomeFragment({
    super.key,
    required this.onDivSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
      builder: (context, value, child) => Builder(builder: (context) {
        if (MediaQuery.of(context).size.width > 800) {
          return Center(
            child: SizedBox(
              width: 700,
              child: buildHomeListview(value, context),
            ),
          );
        }
        return buildHomeListview(value, context);
      }),
    );
  }

  ListView buildHomeListview(AppData value, BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons
              .nights_stay_outlined), //TODO: Localize this and also make it time-sensitive
          title: Text(
            "Good evening, ${value.me?.firstName}!",
            textScaler: const TextScaler.linear(2),
          ),
          subtitle: Text(DateFormat(
                  "EEEE, dd", Localizations.localeOf(context).toLanguageTag())
              .format(DateTime.now())),
        ),
        for (Organization org in value.organizations)
          OrganizationWidget(org: org, onDivSelected: onDivSelected),
      ],
    );
  }
}
