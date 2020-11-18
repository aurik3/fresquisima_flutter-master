import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fresquisima/routes/router.gr.dart';
import 'package:fresquisima/values/data.dart';
import 'package:fresquisima/values/values.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget{
  TextEditingController mailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  bool submittedOnce=false;




  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();


  Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(ImagePath.vegetables_gb,fit: BoxFit.fitWidth),
                Center(heightFactor: 1.5,
                  child: Image.asset(ImagePath.fresquisima_logo,height: 150,),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 50,left: 50),
              child: Form(
                key: _formKey,
                child:  Column(
                  children: [
                    TextFormField(decoration: InputDecoration(
                        icon:Icon(Icons.mail),
                        hintText: "Correo electronico",
                        labelText: "Correo *"
                    ),
                      style: TextStyle(color: Colors.black),
                      controller: widget.mailController,
                      autovalidate: widget.submittedOnce,
                      validator: (String value){
                        return RegExp(  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value)?
                        null:"Ingrese un correo valido";
                      },
                    ),
                    TextFormField(decoration: InputDecoration(
                        icon:Icon(Icons.lock),
                        hintText: "Contraseña",
                        labelText: "Contraseña *"
                    ),
                      style: TextStyle(color: Colors.black),
                      obscureText: true,
                      autocorrect: false,
                      controller: widget.pwController,
                      autovalidate: widget.submittedOnce,
                      validator: (String value){
                        return value.length>=8?
                        null:"La contraseña contiene como minimo 8 caracteres";
                      },
                    ),
                    SizedBox(height: 50,),
                    OutlineButton(
                      borderSide: BorderSide(color: AppColors.primaryColor,width: 2),
                      child: Text("INGRESAR"),
                      onPressed: ()=>{

                        if(_formKey.currentState.validate())
                          {
                            handleSingIn(widget.mailController.text.trim(), widget.pwController.text).then((value) => {
                              if(value=="success"){
                                Router.navigator.pushNamedAndRemoveUntil(
                                  Router.rootScreen,
                                      (Route<dynamic> route) => false,
                                )
                              }
                              else{
                                showDialog(context: context,builder: (context)=> AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Los datos ingresados no son correctos"),
                                ))
                              }
                            })
                          }
                        else{
                          setState((){
                            widget.submittedOnce=true;
                          })

                        }

                      },
                    ),
                    SizedBox(height: 50,),
                    RaisedButton(
                      color: Color.fromARGB(255, 59, 89, 152),
                      child: Text("INGRESAR CON FB"),
                      onPressed: ()=>{_loginWithFB()},
                    ),
                    SizedBox(height: 20,),

                  ],
                ),
              )
            ),
            Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlineButton(
                    borderSide: BorderSide(color: AppColors.primaryColor,width: 2),
                    child: Text("Crear Cuenta",style: TextStyle(fontSize: 12)),
                    onPressed: ()=>{
                      Router.navigator.pushNamed(Router.registerScreen)
                    },
                  ),
                  SizedBox(width: 20,),
                  OutlineButton(
                    borderSide: BorderSide(color: AppColors.primaryColor,width: 2),
                    child: Text("¿Olvidaste tu contraseña?",style: TextStyle(fontSize: 12)),
                    onPressed: ()=>{},
                  ),
                ],
              ),
            )
          ],
        ),
      )
  );
  }

  final facebookLogin = FacebookLogin();

  _loginWithFB() async{

    bool _isLoggedIn = false;
    Map userProfile;
    final facebookLogin = FacebookLogin();

    FacebookLoginBehavior _loginBehavior = FacebookLoginBehavior.nativeWithFallback;


    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token');
        final profile =jsonDecode(graphResponse.body);

        print(profile);
        name=profile["name"];
        mail=profile["email"];
        profileurl=profile["picture"]["data"]["url"];

        await prefs.setString("name", name);
        await prefs.setBool("loggedIn", true);
        await prefs.setString("mail", mail);
        await prefs.setString("profileurl", profileurl);

        setState(() {
          userProfile = profile;
          _isLoggedIn = true;
        });
        Router.navigator.pushNamedAndRemoveUntil(
          Router.rootScreen,
              (Route<dynamic> route) => false,
        );
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false );
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false );
        break;
    }

  }

}
