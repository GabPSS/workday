import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/login.dart';
import 'package:workday/ui/app_page.dart';
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
        : ElevatedButton(
            onPressed: () async {
              if (email.trim() != "" && password.trim() != "") {
                attemptLogin(email, password);
              }
            },
            child: Text(AppLocalizations.of(context)!.loginFunction));
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)!.welcomeGreeting),
          TextField(
            onChanged: (value) => email = value,
            decoration:
                InputDecoration(labelText: AppLocalizations.of(context)!.email),
          ),
          TextField(
            onChanged: (value) => password = value,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.password),
          ),
          loginButton,
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
        context, MaterialPageRoute(builder: (context) => const AppPage()));
  }
}
