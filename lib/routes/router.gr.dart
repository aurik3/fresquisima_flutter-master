import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fresquisima/routes/router.dart';
import 'package:fresquisima/screens/category_screen.dart';
import 'package:fresquisima/screens/login_screen.dart';
import 'package:fresquisima/screens/payment_screen.dart';
import 'package:fresquisima/screens/register_screen.dart';
import 'package:fresquisima/screens/root_screen.dart';
import 'package:fresquisima/screens/splash_screen.dart';

class Router{
  static const loginScreen = '/';
  static const splashScreen = '/splash-screen';
  static const paymentScreen = '/payment-screen';
  static const registerScreen = '/register-screen';
  static const homeScreen = '/home-screen';
  static const rootScreen = '/root-screen';
  static const categoryScreen='/category-screen';

  static final navigator = ExtendedNavigator();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Router.loginScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => LoginScreen(),
          settings: settings,
        );
      case Router.splashScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => SplashScreen(),
          settings: settings,
        );
      case Router.registerScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => RegisterScreen(),
          settings: settings,
        );
      case Router.rootScreen:
        if (hasInvalidArgs<CurrentScreen>(args)) {
          return misTypedArgsRoute<CurrentScreen>(args);
        }
        final typedArgs = args as CurrentScreen;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => RootScreen(currentScreen: typedArgs),
          settings: settings,
        );
      case Router.categoryScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => CategoryScreen(),
          settings: settings,
        );
      case Router.paymentScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => PaymentScreen(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);

    }
  }


}
