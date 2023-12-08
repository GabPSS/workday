import 'package:flutter/material.dart';
import 'package:workday/model/dayinfo/dayinfo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuickInfoField extends StatefulWidget {
  final DayInfo dayInfo;

  const QuickInfoField({super.key, required this.dayInfo});

  @override
  State<QuickInfoField> createState() => _QuickInfoFieldState();
}

class _QuickInfoFieldState extends State<QuickInfoField> {
  bool editing = false;
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.dayInfo.message ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        controller: controller,
        onSubmitted: (value) {
          String trim = value.trim();
          widget.dayInfo.message = trim == "" ? null : trim;
          widget.dayInfo.update();
          editing = false;
        },
        onChanged: (value) {
          setState(() {});
          editing = true;
        },
        decoration: InputDecoration(
            helperText:
                editing ? AppLocalizations.of(context)!.enterToSubmit : null),
      ),
      leading: IconButton(
          onPressed: () {
            widget.dayInfo.destroy();
          },
          icon: const Icon(Icons.clear)),
    );
  }
}
