import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/login.dart';
import 'package:workday/ui/app_page.dart';

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
            child: const Text('Log in'));
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Welcome!'),
          TextField(
            onChanged: (value) => email = value,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            onChanged: (value) => password = value,
            decoration: const InputDecoration(labelText: 'Password'),
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
      return;
    }

    if (!mounted) return;

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AppPage()));
  }
}
