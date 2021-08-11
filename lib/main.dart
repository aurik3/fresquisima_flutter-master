import 'package:flutter/material.dart';
import 'package:fresquisima/routes/AppRouter.gr.dart';
import 'package:fresquisima/theme.dart';
import 'package:fresquisima/values/data.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(App());
}

class App extends StatelessWidget {

  static String _pkg = "order_fold";

  App();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(context),
      initialRoute: AppRouter.rootScreen,
      onGenerateRoute: AppRouter.onGenerateRoute,
      navigatorKey: AppRouter.navigator.key,
    );
  }

  Future<SharedPreferences> setPreferences() async
  {
    return SharedPreferences.getInstance();
  }


}
