import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return Scaffold(
        body: MediaQuery.of(context).size.width < 700
            ? buildLoginContent(context)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary,
                          spreadRadius: 0,
                          blurRadius: 250,
                        ),
                      ]),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.8),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: 500,
                            child: buildLoginContent(context),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ));
  }

  Column buildLoginContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            AppLocalizations.of(context)!.welcomeGreeting,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) => email = value,
            decoration:
                InputDecoration(labelText: AppLocalizations.of(context)!.email),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (attemptingLogin)
                CircularProgressIndicator()
              else
                Expanded(
                  child: ElevatedButton.icon(
                      style: const ButtonStyle(
                        maximumSize: MaterialStatePropertyAll(Size(200, 80)),
                      ),
                      icon: const Icon(Icons.login),
                      onPressed: () async {
                        if (email.trim() != "" && password.trim() != "") {
                          attemptLogin(email, password);
                        }
                      },
                      label: Text(AppLocalizations.of(context)!.loginFunction)),
                ),
            ],
          ),
        ),
        if (!attemptingLogin)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                      onPressed: () => showWorkdayAboutDialog(context),
                      icon: const Icon(Icons.help_outline),
                      label: Text(
                          AppLocalizations.of(context)!.aboutAppMenuLabel)),
                ),
              ],
            ),
          )
      ],
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
