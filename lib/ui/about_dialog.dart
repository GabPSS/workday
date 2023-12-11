import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showWorkdayAboutDialog(BuildContext context) => showAboutDialog(
        context: context,
        applicationVersion: AppLocalizations.of(context)!.appVersion,
        children: [
          Text(AppLocalizations.of(context)!.appDescription),
          Text(AppLocalizations.of(context)!.appAuthor),
          TextButton(
              onPressed: () =>
                  launchUrlString(AppLocalizations.of(context)!.appSourceRepo),
              child: Text(AppLocalizations.of(context)!.viewSourceButtonLabel)),
        ]);
