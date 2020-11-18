import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter/material.dart';
import 'package:fresquisima/screens/login_screen.dart';
import 'package:fresquisima/screens/register_screen.dart';
import 'package:fresquisima/screens/splash_screen.dart';
import 'package:meta/meta.dart';


@CupertinoAutoRouter()
class $Router {

  @initial
  @CustomAutoRouter(transitionsBuilder: TransitionsBuilders.slideRight, durationInMilliseconds: 2000)
  LoginScreen loginScreen;

  @CustomAutoRouter(transitionsBuilder: TransitionsBuilders.slideRight, durationInMilliseconds: 2000)
  SplashScreen splashScreen;

  @MaterialRoute()
  RegisterScreen registerScreen;


}

class CurrentScreen{
  final Widget currentScreen;
  final int tab_no;

  CurrentScreen({
    @required this.tab_no,
    @required this.currentScreen,
  });
}
