import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:workday/data/login.dart';
import 'package:workday/ui/about_dialog.dart';
import 'package:workday/ui/workday_app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";
  bool attemptingLogin = false;

  @override
  Widget build(BuildContext context) {
    var loginButton = attemptingLogin
        ? const CircularProgressIndicator()
        : ElevatedButton.icon(
            style: ButtonStyle(
              maximumSize: MaterialStatePropertyAll(Size(200, 80)),
            ),
            icon: Icon(Icons.login),
            onPressed: () async {
              if (email.trim() != "" && password.trim() != "") {
                attemptLogin(email, password);
              }
            },
            label: Text(AppLocalizations.of(context)!.loginFunction));
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.welcomeGreeting,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => email = value,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.email),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              obscureText: true,
              onChanged: (value) => password = value,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.password),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(child: loginButton),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                      onPressed: () => showWorkdayAboutDialog(context),
                      icon: Icon(Icons.help_outline),
                      label: Text(
                          AppLocalizations.of(context)!.aboutAppMenuLabel)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> attemptLogin(String email, String password) async {
    setState(() {
      attemptingLogin = true;
    });
    var result = await Provider.of<Login>(context, listen: false)
        .trySignIn(email, password);

    if (result == false) {
      setState(() => attemptingLogin = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.loginFailedMessage)));
      return;
    }

    if (!mounted) return;

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const WorkdayApp()));
  }
}
