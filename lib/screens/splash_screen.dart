import 'package:flutter/material.dart';
import 'package:fresquisima/routes/router.gr.dart';
import 'package:fresquisima/theme.dart';
import 'package:fresquisima/values/data.dart';
import 'package:fresquisima/values/values.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget{


  LoginScreen()
  {
    setPreferences();
  }
  setPreferences() async
  {
    prefs= await SharedPreferences.getInstance();
  }




  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:AppColors.primaryColor,
        body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: Image.asset(ImagePath.vegetables_gb,fit: BoxFit.fitHeight,),
              ),
              Center(
                child: Image.asset(ImagePath.fresquisima_logo,width: 100,),
              )
            ],
          ),
        bottomNavigationBar:
        Container(
          margin: EdgeInsets.only(bottom: 30),
          child:    Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                color: white,
                onPressed: ()=>{
                  Router.navigator.pushNamed(Router.loginScreen)
                },
                child: Text("Ingresar",style: TextStyle(color: AppColors.primaryColor),),
              ),
              SizedBox(width: 20,)
              ,
              RaisedButton(
                color: white,
                onPressed: ()=>{
                  Router.navigator.pushNamed(Router.registerScreen)
                },
                child: Text("Registrarse",style: TextStyle(color: AppColors.primaryColor),),
              )
            ],
          ),
        ),
     );
  }

}