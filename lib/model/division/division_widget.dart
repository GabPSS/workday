import 'package:flutter/material.dart';
import 'package:workday/model/division/division.dart';

class DivisionWidget extends StatelessWidget {
  const DivisionWidget({
    super.key,
    required this.div,
    required this.onSelected,
  });

  final Division div;
  final Function() onSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.work_outline)),
      title: Text(div.name),
      onTap: onSelected,
    );
  }
}
