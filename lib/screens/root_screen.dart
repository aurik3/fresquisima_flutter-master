import 'package:flutter/material.dart';
import 'package:fresquisima/routes/AppRouter.dart';
import 'package:fresquisima/screens/splash_screen.dart';


import 'package:fresquisima/values/data.dart';
import 'package:fresquisima/values/values.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import 'cart_screen.dart';
import 'home_screen.dart';
import 'account_screen.dart';

class RootScreen extends StatefulWidget {
  RootScreen({this.currentScreen});

  final CurrentScreen currentScreen;

  @override
  _RootScreenState createState() => _RootScreenState();
}
class _RootScreenState extends State<RootScreen>
    with SingleTickerProviderStateMixin {


  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen;
  int currentTab;
  AnimationController _controller;
  bool _loggedIn=false;

//  final double pi = math.pi;
  final double tilt90Degrees = 90;
  double angle = math.pi;

  bool get _isPanelVisible {
    return angle == tilt90Degrees ? true : false;
  }


  bool _isDataLoaded=false;
  bool _iSOrderData=false;

  @override
  initState() {

    super.initState();
    print("init runs");
    currentScreen = widget.currentScreen?.currentScreen ?? HomeScreen();
    currentTab = widget.currentScreen?.tab_no ?? 0;
    loadProducts();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
//      value: 1,
      vsync: this,
    );
  }


  void loadOrders() async
  {

    await getOrders();
    setState(() {
      _iSOrderData=true;
    });
  }

  void loadProducts() async
  {

    await getProducts();
    setState(() {
      _isDataLoaded=true;
    });
  }

  changeScreen({
    @required Widget currentScreen,
    @required int currentTab,
  }) {
    setState(() {
      this.currentScreen = currentScreen;
      this.currentTab = currentTab;
    });
  }

  void changeAngle() {
    if (angle == math.pi) {
      setState(() {
        angle = tilt90Degrees;
      });
    } else {
      setState(() {
        angle = math.pi;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    //set statusBarColor color to secondary color
    //This is done to make the statusBarColor consistent
    // because there are screens inside the app that AppBar is not being used
//    SystemChrome.setSystemUIOverlayStyle(
//      SystemUiOverlayStyle.dark.copyWith(
//        // statusBarColor is used to set Status bar color in Android devices.
//          statusBarColor: AppColors.secondaryColor,
//          // To make Status bar icons color white in Android devices.
//          statusBarIconBrightness: Brightness.light,
//          // statusBarBrightness is used to set Status bar icon color in iOS.
//          statusBarBrightness: Brightness.light
//        // Here light means dark color Status bar icons.
//      ),
//    );

    SharedPreferences.getInstance().then((value) => {
      prefs=value,
      if(value.getBool("loggedIn")==null)
        {
          setState(() {
            _loggedIn = false;
          })
        }
      else
        {
          setState(() {
            _loggedIn = value.getBool("loggedIn");
            if(!_iSOrderData) {
              loadOrders();
            }
          })
        }
    });

    if(_isDataLoaded)
    {
      return SafeArea(child: Scaffold(
        body: PageStorage(
          child: currentScreen,
          bucket: bucket,
        ),
        floatingActionButton: FloatingActionButton(
          child: AnimatedBuilder(
            animation: _controller,
            child: Icon(
              Icons.shopping_cart,
              size: 36,
              color: AppColors.primaryColor,
            ),
            builder: (context, child) => Transform.rotate(
              angle: 0,
              child: child,
            ),
          ),
          backgroundColor: AppColors.secondaryColor,
          elevation: 8.0,
          onPressed: () {
            changeAngle();
            _isPanelVisible ? _controller.forward() : _controller.reverse();
            _isPanelVisible
                ? changeScreen(
              currentScreen: CartScreen(),
              currentTab: CartScreen.TAB_NO,
            )
                : changeScreen(
              currentScreen: HomeScreen(),
              currentTab: HomeScreen.TAB_NO,
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: AppColors.primaryColor,
          elevation: 8.0,
          shape: AutomaticNotchedShape(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(currentTab==2?0:20),
                topLeft: Radius.circular(currentTab==2?0:20),
              ),
            ),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.0),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //Left Tab bar icons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    bottomNavigationIcon(
                      destination: HomeScreen(),
                      currentTab: HomeScreen.TAB_NO,
                      activeIcon: ImagePath.activeHomeIcon2,
                      nonActiveIcon: ImagePath.homeIcon,
                    ),
                  ],
                ),

                SizedBox(width: 30,),
                // Right Tab bar icons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    bottomNavigationIcon(
                      destination: _loggedIn? AccountScreen():SplashScreen(),
                      currentTab: AccountScreen.TAB_NO,
                      activeIcon: ImagePath.activePersonIcon,
                      nonActiveIcon: ImagePath.personGreyIcon,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ))
        ;
    }
    else
    {
      return Container(color: AppColors.primaryColor,child: Center(child: CircularProgressIndicator(),),);

    }


  }

  Widget bottomNavigationIcon({
    @required Widget destination,
    @required int currentTab,
    @required String activeIcon,
    @required String nonActiveIcon,
  }) {
    return InkWell(
      onTap: () {
        if(angle == tilt90Degrees) {
          setState(() {
            angle = math.pi;
          });
        }
        changeScreen(currentScreen: destination, currentTab: currentTab);
      }
      ,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          (this.currentTab == currentTab) ? activeIcon : nonActiveIcon,
        ),
      ),
    );
  }
}

