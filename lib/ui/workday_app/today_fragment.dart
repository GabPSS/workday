import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/model/dayinfo/dayinfo_list.dart';
import 'package:workday/model/division/division.dart';

class TodayFragment extends StatelessWidget {
  final Division div;

  const TodayFragment({super.key, required this.div});

  @override
  Widget build(BuildContext context) {
    if (!div.loaded) {
      return FutureBuilder(
          future: div.load(Provider.of<AppData>(context)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return DayInfoList(dayInfos: div.dayinfos!);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    }
    return DayInfoList(dayInfos: div.dayinfos!);
  }
}
