import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:workday/data/app_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShareDialog extends StatefulWidget {
  const ShareDialog({super.key});

  @override
  State<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  late String text;

  @override
  void didChangeDependencies() {
    text = Provider.of<AppData>(context, listen: false).getJobsList(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.shareFunction),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: AppLocalizations.of(context)!.jobStringPreview),
              controller: TextEditingController(text: text),
              maxLines: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
                onPressed: () {
                  Share.share(text);
                },
                icon: const Icon(Icons.share),
                label: Text(AppLocalizations.of(context)!.shareFunction)),
          )
        ],
      ),
    );
  }
}
