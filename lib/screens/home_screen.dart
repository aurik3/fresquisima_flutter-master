import 'package:flutter/material.dart';
import 'package:fresquisima/routes/AppRouter.dart';
import 'package:fresquisima/routes/AppRouter.gr.dart';
import 'package:fresquisima/screens/category_screen.dart';
import 'package:fresquisima/values/data.dart';
import 'package:fresquisima/values/values.dart';

class HomeScreen extends StatelessWidget{

  static const int TAB_NO = 0;

  Widget build(BuildContext context) {
    return Scaffold(

      body:
      Column(
        children: [
          Stack(
            children: [
              Image.asset(ImagePath.vegetable_banner),
              Center(
                child: Image.asset(ImagePath.fresquisima_logo,width: 120,),
              )
            ],
          ),
          Stack(
            children: [
              Image.asset(ImagePath.vegetables_gb,fit: BoxFit.fitWidth,color: AppColors.primaryShadow,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 30,top: 19),
                child: SingleChildScrollView(
                  child:  Column (
                    children: [
                      GestureDetector(
                        onTap: ()=>{
                          selectedCategory="VERDURAS",
                          AppRouter.navigator.pushNamed(
                              AppRouter.rootScreen,arguments:CurrentScreen(
                              currentScreen: CategoryScreen(),
                              tab_no: 0
                          )
                          )
                        },
                        child: Image.asset(ImagePath.verduras,fit: BoxFit.fitWidth),
                      ),
                      SizedBox(height: 20,),
                      GestureDetector(
                        onTap: ()=>{
                          selectedCategory="FRUTAS",
                          AppRouter.navigator.pushNamed(
                              AppRouter.rootScreen,arguments:CurrentScreen(
                              currentScreen: CategoryScreen(),
                              tab_no: 0
                          )
                          )
                        },
                        child: Image.asset(ImagePath.frutas,fit: BoxFit.fitWidth),
                      ),
                      SizedBox(height: 20,),
                      GestureDetector(
                        onTap: ()=>{
                          selectedCategory="PANADERIA",
                          AppRouter.navigator.pushNamed(
                              AppRouter.rootScreen,arguments:CurrentScreen(
                              currentScreen: CategoryScreen(),
                              tab_no: 0
                          )
                          )
                        },
                        child: Image.asset(ImagePath.panaderia,fit: BoxFit.fitWidth),
                      )
                    ],
                  ),
                )
              ),


            ],
          )
        ],
      ),
      );
  }

}