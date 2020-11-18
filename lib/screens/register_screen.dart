import 'package:flutter/material.dart';
import 'package:fresquisima/routes/router.gr.dart';
import 'package:fresquisima/values/data.dart';
import 'package:fresquisima/values/values.dart';

class RegisterScreen extends StatefulWidget{
  TextEditingController usernameController =TextEditingController();
  TextEditingController mailController =TextEditingController();
  TextEditingController passwordController =TextEditingController();
  bool submittedOnce=false;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

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
                  child: Column(
                    children: [
                      TextFormField(decoration: InputDecoration(
                          icon:Icon(Icons.mail),
                          hintText: "Nombre de usuario",
                          labelText: "Nombre de usuario *"
                      ),
                        controller: widget.usernameController,
                        validator: (String value){
                          return value.length>=5?
                          null:"Bombre demaciado corto, minimo 5 caracteres";
                        },
                      ),
                      TextFormField(decoration: InputDecoration(
                          icon:Icon(Icons.lock),
                          hintText: "Correo Electronico",
                          labelText: "Correo *"
                      ),
                        controller: widget.mailController,
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
                        controller: widget.passwordController,
                        validator: (String value){
                          return value.length>=8?
                          null:"La contraseña debe contener como minimo 8 caracteres";
                        },
                      ),
                      SizedBox(height: 50,),
                      OutlineButton(
                        borderSide: BorderSide(color: AppColors.primaryColor,width: 2),
                        child: Text("REGISTRARME"),
                        onPressed: ()=>{

                          if(_formKey.currentState.validate())
                            {
                              handleRegister(widget.usernameController.text,widget.mailController.text, widget.passwordController.text).then((value) => {
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
                      SizedBox(height: 20,),
                      OutlineButton(
                        borderSide: BorderSide(color: AppColors.primaryColor,width: 2),
                        child: Text("Iniciar Sesíon"),
                        onPressed: ()=>{
                          Router.navigator.pushNamed(Router.loginScreen)
                        },

                      ),
                    ],
                  ),
                )

              ),
              Container(
              )
            ],
          ),
        )
    );
  }
}