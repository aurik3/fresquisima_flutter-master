import 'package:flutter/material.dart';
import 'package:fresquisima/routes/router.gr.dart';
import 'package:fresquisima/theme.dart';
import 'package:fresquisima/values/data.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  bool loggedIn=false;
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  if(prefs.getBool("loggedIn")==null)
    {
      loggedIn = false;
    }
  else
    {
      loggedIn = prefs.getBool("loggedIn");
    }

  runApp(App(loggedIn));
}

class App extends StatelessWidget {

  static String _pkg = "order_fold";
  bool _loggedIn;

  App(this._loggedIn);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(context),
      initialRoute: _loggedIn ? Router.rootScreen :Router.splashScreen,
      onGenerateRoute: Router.onGenerateRoute,
      navigatorKey: Router.navigator.key,
    );
  }

  Future<SharedPreferences> setPreferences() async
  {
    return SharedPreferences.getInstance();
  }


}
