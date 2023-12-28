import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/data/login.dart';
import 'package:workday/api.dart';
import 'package:workday/ui/workday_app/workday_app.dart';
import 'package:workday/ui/login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: backendUrl, anonKey: backendKey);

  Login login = Login();

  AppData appData;
  bool loginResult = await login.fetch();
  if (loginResult) {
    appData = AppData(me: login.user);
    await appData.fetchData();
  } else {
    appData = AppData();
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => appData),
    ChangeNotifierProvider(create: (context) => login)
  ], child: MainApp(loggedIn: loginResult)));
}

class MainApp extends StatelessWidget {
  final bool loggedIn;

  const MainApp({super.key, this.loggedIn = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: appTheme,
      darkTheme: appTheme,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      home: loggedIn ? const WorkdayApp() : const LoginPage(),
    );
  }
}

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme:
      const ColorScheme.dark(primary: Colors.teal, onPrimary: Colors.white),
);
